include("shared.lua")
LANGS = {}
include("lang/at.lua")
include("lang/de.lua")
include("lang/en.lua")


surface.CreateFont("ProgBar", {
    font = "Arial",
    size = 26,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("PlyInfo", {
    font = "Arial",
    size = 18,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

local function setLang(ply, cmd, args)
    LANG = LANGS[args[1]]
end

LANG = LANGS["en"]
concommand.Add("setLang", setLang)
timer.Create("RoundTimer",100,0,function() end)

include("gui/gui.lua")
include("gui/messages.lua")

net.Receive("Timer", function()
    local tim = net.ReadUInt(2)
    local time_left = net.ReadUInt(16)
    timer.Stop("RoundTimer")
    timer.Adjust("RoundTimer", time_left, 0, function() end)
    timer.Start("RoundTimer")
end)