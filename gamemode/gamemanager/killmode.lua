-- uses GetName
Killmode = {}
local TS_Hunter_Victim = {}
local TS_Identities = {}
local TS_Round_State = {}

local function byName(name)
    for nr,ply in pairs(player.GetAll()) do
        if ply:GetName() == name then
            return ply
        end
    end
    return nil
end

local function isHunter(st_h, st_v)
    return TS_Hunter_Victim[st_h] == st_v
end

local function name(ply)
    return TS_Identities[ply:GetName()]
end

local function newVictim(hunter, victim)
    TS_Hunter_Victim[hunter:GetName()] = victim:GetName()
    Killmode.roundState(hunter, R_STATE.HUNTING)
    net.Start("Victim")
        net.WriteString(TS_Identities[victim:GetName()])
    net.Send(hunter)
end

local function newVictims()
    local plys = Arrays.shuffle(player.GetAll())
    local ply = nil
    local first = nil
    for key,val in pairs(plys) do
        if ply == nil then
            first = val
        else
            newVictim(val,ply)
        end
        ply = val
    end
    newVictim(first,ply)
end


local function giveBackName(ply)
    local oldname = TS_Identities[ply:GetName()]
    if oldname ~= nil then
        table.insert(TEMP_NAMES, oldname)
        TEMP_NAMES = Arrays.shuffle(TEMP_NAMES)
    end
end

local function identities(ply)
    net.Start("Identity")
    net.WriteUInt(1,1)
    net.WriteTable(TS_Identities)
    net.Send(ply)
end

local function newIdentity(ply)
--     create second table for names, remove name, when in use, add name, when nobody has it, shuffle names
    giveBackName(ply)
    TS_Identities[ply:GetName()] = table.remove(TEMP_NAMES, 1)
    
    net.Start("Identity")
        net.WriteUInt(0,1)
        net.WriteString(ply:GetName())
        net.WriteString(TS_Identities[ply:GetName()])
    net.Broadcast()
end

function newIds()
    for nr,ply in pairs(player.GetAll()) do
        newIdentity(ply)
    end
end

local function roundState(ply, state, all)
    if all ~= nil then
        for nr,val in pairs(player.GetAll()) do
            TS_Round_State[val:GetName()] = state
        end
        net.Start("RoundState")
        net.WriteUInt(1,1)
        net.WriteTable(TS_Round_State)
        net.Broadcast()
    else
        local st_id = ply:GetName()
        TS_Round_State[st_id] = state
        net.Start("RoundState")
        --is table?
        net.WriteUInt(0,1)
        net.WriteString(st_id)
        net.WriteInt(state, 4)
        net.Broadcast()
    end
end

local function roundStates(ply)
    net.Start("RoundState")
    --is table?
    net.WriteUInt(1,1)
    net.WriteTable(TS_Round_State)
    net.Send(ply)
end


local function roundEnd()
    for k,v in pairs(TS_Hunter_Victim) do
        TS_Hunter_Victim = nil
    end
end

hook.Add("PlayerDisconnected", "GiveBackName", function(ply)
    giveBackName(ply)
    TS_Identities[ply:GetName()] = nil
    for hunt,vic in pairs(TS_Hunter_Victim) do
        if vic == ply:GetName() then
            newVictim(hunt,byName(vic))
        end
    end
    TS_Hunter_Victim[ply:GetName()] = nil
    TS_Round_State[ply:GetName()] = nil
end)



Killmode.newVictims = newVictims
Killmode.TS_Hunter_Victim = TS_Hunter_Victim
Killmode.TS_Identities = TS_Identities
Killmode.TS_Round_State = TS_Round_State
Killmode.newIdentity = newIdentity
Killmode.isHunter = isHunter
Killmode.name = name
Killmode.roundState = roundState
Killmode.roundStates = roundStates
Killmode.identities = identities
Killmode.byName = byName