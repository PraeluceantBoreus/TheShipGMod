include("cs_progressbar.lua")


local client = LocalPlayer()
local height = 200
local width = 300
local padding = 10
local rounding = 15

local cross_width = 50
local cross_strength = 1

local function weapon()
    return client:GetActiveWeapon()
end

local function currAmmo()
    return client:GetAmmoCount(weapon():GetPrimaryAmmoType())
end

local function clipAmmo()
    return weapon():Clip1()
end

local function maxClip()
    return weapon():GetMaxClip1()
end

function drawHealth()
    
    
    local padd_top = ScrH()-(height+padding)
    draw.RoundedBox(rounding,padding,padd_top,width,height, Color(0,0,0,128))
    local width = width - 2 * padding
    local margin = 2 * padding
    padd_top = padd_top + padding
    ProgBar.drawBar(100,client:Health(),margin,padd_top,width,-1,-1,Color(96,0,0,255),LANG.HEALTH.." "..client:Health())
     padd_top = padd_top + ProgBar.def_height + padding
    if IsValid(weapon()) and maxClip() > 0 then
    ProgBar.drawBar(maxClip(),clipAmmo(),margin,padd_top,width,-1,-1,Color(196,127,0,255),clipAmmo().." + "..currAmmo())
    end
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
