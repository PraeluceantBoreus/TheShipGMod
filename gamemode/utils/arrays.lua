Arrays = {}



local function length(arr)
    local ret = 0
    for _ in pairs(arr) do
        ret = ret + 1
    end
    return ret
end

local function shuffle(arr)
    local steamplys = {}
    for plynr, ply in pairs(arr) do
        table.insert(steamplys, ply)
    end
    local count = length(steamplys)
    for plynr, ply in pairs(steamplys) do
        local randnr = math.random(count)
        local oldply = steamplys[randnr]
        steamplys[randnr] = ply
        steamplys[plynr] = oldply
    end
    return steamplys
end

local function toSteam(arr)
    local ret = {}
    for key, val in pairs(arr) do
        table.insert(ret, val:SteamID64())
    end
    return ret
end

Arrays.shuffle = shuffle
Arrays.length = length
Arrays.toSteam = toSteam

PrintTable(Arrays)