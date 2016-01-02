-- uses SteamID64

-- include("../utils/arrays.lua")

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
    net.Start("RoundState")
        net.WriteInt(1,4)
    net.Send(hunter)
    net.Start("Victim")
        net.WriteString(TS_Identities[victim:SteamID64()])
    net.Send(hunter)
end

local function newVictims()
    local plys = Arrays.shuffle(player.GetAll())
    local count = Arrays.length(plys)
    print("Count: "..count)
    for key,val in pairs(plys) do
        newVictim(val,plys[(key%count)+1])
    end
end


local function newIdentity(ply)
--     create second table for names, remove name, when in use, add name, when nobody has it, shuffle names
    
    TS_Identities[ply:SteamID64()] = table.remove(TEMP_NAMES, 1)
    
    net.Start("Identity")
        net.WriteString(TS_Identities[ply:SteamID64()])
    net.Send(ply)
end

function newIds()
    for nr,ply in pairs(player.GetAll()) do
        newIdentity(ply)
    end
end

local function roundState(ply, state)
    net.Start("RoundState")
    net.WriteInt(state, 4)
    net.Send(ply)
end

local function giveBackName(ply)
    local oldname = TS_Identities[ply:SteamID64()]
    if oldname ~= nil then
        table.insert(TEMP_NAMES, oldname)
        TEMP_NAMES = Arrays.shuffle(TEMP_NAMES)
    end
end

local function roundEnd()
    for nr,ply in pairs(player.GetAll()) do
        roundState(ply,R_STATE.PREPARING)
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
end)



Killmode.newVictims = newVictims
Killmode.TS_Hunter_Victim = TS_Hunter_Victim
Killmode.TS_Identities = TS_Identities
Killmode.newIdentity = newIdentity
Killmode.isHunter = isHunter
Killmode.name = name
Killmode.roundState = roundState