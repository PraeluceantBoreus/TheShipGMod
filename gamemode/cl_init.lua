include("shared.lua")
LANGS = {}
include("lang/at.lua")
include("lang/de.lua")
include("lang/en.lua")
include("gui/gui.lua")

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

local function setLang(ply, cmd, args)
    LANG = LANGS[args[1]]
end

concommand.Add("setLang", setLang)