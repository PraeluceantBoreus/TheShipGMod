-- uses SteamID64

-- include("../utils/arrays.lua")

Killmode = {}
local TS_Hunter_Victim = {}

local function newVictims()
    local plys = Arrays.shuffle(player.GetAll())
    local count = Arrays.length(plys)
    print("Count: "..count)
    for key,val in pairs(plys) do
        TS_Hunter_Victim[val] = plys[(key%count)+1]
    end
end

Killmode.newVictims = newVictims
Killmode.TS_Hunter_Victim = TS_Hunter_Victim