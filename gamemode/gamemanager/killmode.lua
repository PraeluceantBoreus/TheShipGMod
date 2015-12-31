-- uses SteamID64

-- include("../utils/arrays.lua")

Killmode = {}
local TS_Hunter_Victim = {}
local TS_Identities = {}

local function newVictims()
    local plys = Arrays.toSteam(Arrays.shuffle(player.GetAll()))
    local count = Arrays.length(plys)
    print("Count: "..count)
    for key,val in pairs(plys) do
        TS_Hunter_Victim[val] = plys[(key%count)+1]
    end
end

local function newIdentity(ply)
--     create second table for names, remove name, when in use, add name, when nobody has it, shuffle names
    local oldname = TS_Identities[ply:SteamID64()]
    TS_Identities = table.remove(TMP_NAMES, 1)
    if oldname ~= nil then
        table.insert(TMP_NAMES, oldname)
        TMP_NAMES = Arrays.shuffle(TMP_NAMES)
    end
end

Killmode.newVictims = newVictims
Killmode.TS_Hunter_Victim = TS_Hunter_Victim