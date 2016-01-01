-- uses SteamID64

-- include("../utils/arrays.lua")

Killmode = {}
local TS_Hunter_Victim = {}
local TS_Identities = {}

local function newVictim(hunter, victim)
    TS_Hunter_Victim[hunter] = victim
    net.Start("RoundState")
        net.WriteInt(1,4)
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
    local oldname = TS_Identities[ply:SteamID64()]
    TS_Identities[ply:SteamID64()] = table.remove(TEMP_NAMES, 1)
    if oldname ~= nil then
        table.insert(TEMP_NAMES, oldname)
        TEMP_NAMES = Arrays.shuffle(TEMP_NAMES)
    end
    
    net.Start("Identity")
        net.WriteString(TS_Identities[ply:SteamID64()])
    net.Send(ply)
end

function newIds()
    for nr,ply in pairs(player.GetAll()) do
        newIdentity(ply)
    end
end

local function roundEnd()
end


hook.Add("PlayerDisconnected", "GiveBackName", function(ply)
    local name = TS_Identities[ply:SteamID64()]
    if name ~= nil then table.insert(TEMP_NAMES, name) end
    table.remove(TS_Identities, ply:SteamID64())
    for hunt,vic in pairs(TS_Hunter_Victim) do
        if vic == ply:SteamID64() then
            newVictim(hunt,TS_Identities[ply:SteamID64()])
        end
    end
    table.remove(TS_Hunter_Victim, ply:SteamID64())
end)



Killmode.newVictims = newVictims
Killmode.TS_Hunter_Victim = TS_Hunter_Victim
Killmode.newIdentity = newIdentity