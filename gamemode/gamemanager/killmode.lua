-- uses SteamID64
Killmode = {}
local TS_Hunter_Victim = {}
local TS_Identities = {}
local TS_Round_State = {}

local function isHunter(st_h, st_v)
    return TS_Hunter_Victim[st_h] == st_v
end

local function name(ply)
    return TS_Identities[ply:SteamID64()]
end

local function newVictim(hunter, victim)
    TS_Hunter_Victim[hunter:SteamID64()] = victim:SteamID64()
    Killmode.roundState(hunter, R_STATE.HUNTING)
    net.Start("Victim")
        net.WriteString(TS_Identities[victim:SteamID64()])
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
    local oldname = TS_Identities[ply:SteamID64()]
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
    TS_Identities[ply:SteamID64()] = table.remove(TEMP_NAMES, 1)
    
    net.Start("Identity")
        net.WriteUInt(0,1)
        net.WriteString(ply:SteamID64())
        net.WriteString(TS_Identities[ply:SteamID64()])
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
            TS_Round_State[val:SteamID64()] = state
        end
    else
        local st_id = ply:SteamID64()
        TS_Round_State[st_id] = state
    end
    net.Start("RoundState")
    --is table?
    net.WriteUInt(0,1)
    net.WriteString(st_id)
    net.WriteInt(state, 4)
    net.Broadcast()
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
    table.remove(TS_Identities, ply:SteamID64())
    for hunt,vic in pairs(TS_Hunter_Victim) do
        if vic == ply:SteamID64() then
            newVictim(hunt,player.GetBySteamID64(TS_Identities[ply:SteamID64()]))
        end
    end
    table.remove(TS_Hunter_Victim, ply:SteamID64())
    table.remove(TS_Round_State, ply:SteamID64())
end)



Killmode.newVictims = newVictims
Killmode.TS_Hunter_Victim = TS_Hunter_Victim
Killmode.TS_Identities = TS_Identities
Killmode.newIdentity = newIdentity
Killmode.isHunter = isHunter
Killmode.name = name
Killmode.roundState = roundState
Killmode.roundStates = roundStates
Killmode.identities = identities