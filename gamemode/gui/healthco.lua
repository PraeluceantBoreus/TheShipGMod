include("cs_progressbar.lua")

local client = LocalPlayer()
local height = 200
local width = 300
local padding = 20
local rounding = 15

local bar_height = 40

local cross_width = 50
local cross_strength = 1

function drawHealth()
    
    local padd_top = ScrH()-(height+padding)
    draw.RoundedBox(rounding,padding,padd_top,width,height, Color(0,0,0,128))
--     draw.RoundedBox(rounding,padding,padd_top,width,bar_height, Color(128,0,0,256))
    ProgBar.drawBar(100,client:Health(),padding,padd_top,width,-1,-1,Color(96,0,0,255),"Helath "..client:Health())
end

function drawCross()
    
    draw.RoundedBox(0,ScrW()/2-cross_width/2,ScrH()/2-cross_strength/2,cross_width,cross_strength, Color(0,0,0,255))
    draw.RoundedBox(0,ScrW()/2-cross_strength/2,ScrH()/2-cross_width/2,cross_strength,cross_width, Color(0,0,0,255))
end

local toHide = {
    ["CHudHealth"] = true
}

local function proofHide(name)
    if (toHide[name]) then
        return false
    end
end

hook.Add("HUDPaint","Health", drawHealth)
hook.Add("HUDPaint", "Cross", drawCross)
hook.Add("HUDShouldDraw", "Hide Stuff", proofHide)
