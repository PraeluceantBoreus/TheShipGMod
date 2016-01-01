Timer = {}
CURR_ROUND = false

local function isRound()
    return CURR_ROUND
end

local function prepPrepTimer()
    net.Start("Timer")
    net.WriteUInt(1,2)
    net.WriteUInt(CONF.PrepareTime,16)
    net.Broadcast()
end

local function prepRouTimer()
    net.Start("Timer")
    net.WriteUInt(0,2)
    net.WriteUInt(CONF.RoundTime,16)
    net.Broadcast()
end

local function roundFinish()
    timer.Stop("Round")
    prepPrepTimer()
    timer.Start("Prepare")
    CURR_ROUND = false
    net.Start("RoundState")
    net.WriteInt(4,4)
    net.Broadcast()
end

local function prepareFinish()
    if #player.GetAll() >= CONF.MinPlayers then
        timer.Stop("Prepare")
        prepRouTimer()
        timer.Start("Round")
        CURR_ROUND = true
        Killmode.newVictims()
        net.Start("RoundState")
        net.WriteInt(1,4)
        net.Broadcast()
    else
        prepPrepTimer()
        timer.Start("Prepare")
    end
    
    
end

timer.Create("Round", CONF.RoundTime, 0, roundFinish)
timer.Create("Prepare", CONF.PrepareTime, 0, prepareFinish)

timer.Start("Prepare")

Timer.isRound = isRound