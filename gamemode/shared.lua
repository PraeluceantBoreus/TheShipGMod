GM.Name = "The Ship"
GM.Author = "Richard Stöckl"
GM.Email = "richard.stoeckl@aon.at"
GM.Website = "N/A"

CONF = {}

CONF.RoundTime = 350
CONF.PrepareTime = 20

CONF.MinPlayers = 2

function GM:Initialize()
end

local function roundFinish()
    timer.Stop("Round")
    timer.Start("Prepare")
    if SERVER then
        net.Start("RoundState")
        net.WriteInt(4,3)
        net.Broadcast()
    end
end

local function prepareFinish()
    if #player.GetAll() >= CONF.MinPlayers then
        timer.Stop("Prepare")
        timer.Start("Round")
    else
        timer.Start("Prepare")
    end
end

timer.Create("Round", CONF.RoundTime, 0, roundFinish)
timer.Create("Prepare", CONF.PrepareTime, 0, prepareFinish)

timer.Start("Prepare")