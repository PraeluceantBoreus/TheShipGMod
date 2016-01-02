include("cs_progressbar.lua")
--make message table

local client = LocalPlayer()
local height = 200
local width = 300
local padding = 10
local rounding = 15

local cross_width = 50
local cross_strength = 1

local rs_color = {}
rs_color[1] = Color(0,0,127,255)
rs_color[2] = Color(127,0,0,255)
rs_color[3] = Color(0,127,0,255)
rs_color[4] = Color(127,127,127,255)
rs_color[5] = Color(127,127,127,255)

IDENTITY_NAME = ""
ROUND_STATE = 5
VICTIM_NAME = ""

local function getColor()
    return rs_color[ROUND_STATE]
end

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
    
    client = LocalPlayer()
    local padd_top = ScrH()-(height+padding)
    draw.RoundedBox(rounding,padding,padd_top,width,height, Color(0,0,0,128))
    
    local margin = padding
    local width = width - 2 * padding
    
    ProgBar.drawBar(1,1,margin,padd_top,width,-1,-1,getColor(),IDENTITY_NAME)
    
    margin = 2*padding
    padd_top = padd_top + padding + ProgBar.def_height
    ProgBar.drawBar(100,client:Health(),margin,padd_top,width,-1,-1,Color(96,0,0,255),LANG.HEALTH.." "..client:Health())
    
    padd_top = padd_top + ProgBar.def_height + padding
    if IsValid(weapon()) and maxClip() > 0 then
    ProgBar.drawBar(maxClip(),clipAmmo(),margin,padd_top,width,-1,-1,Color(196,127,0,255),LANG.AMMO.." "..clipAmmo().." + "..currAmmo())
    end
    
    padd_top = padd_top + ProgBar.def_height + padding
    local vname = LANG.ROUND_WAIT
    if ROUND_STATE == R_STATE.HUNTING then vname = VICTIM_NAME end
    if ROUND_STATE == R_STATE.KILLED then vname = LANG.ROUND_KILLED_FROM_HUNTER end
    if ROUND_STATE == R_STATE.FINISHED then vname = LANG.ROUND_KILLED_VICTIM end
    if ROUND_STATE == R_STATE.JOINED then vname = LANG.ROUND_JOINED end
    
    
    
    local totalTime = CONF.RoundTime
    local timeLeft = timer.TimeLeft("RoundTimer")
    
    
    
    if ROUND_STATE == R_STATE.PREPARING then
        totalTime = CONF.PrepareTime
    end
    
    
    if timeLeft == nil then timeLeft = totalTime end
    
    ProgBar.drawBar(totalTime,timeLeft,margin,padd_top,width,-1,-1,getColor(),vname)
end

function drawCross()
    
    draw.RoundedBox(0,ScrW()/2-cross_width/2,ScrH()/2-cross_strength/2,cross_width,cross_strength, getColor())
    draw.RoundedBox(0,ScrW()/2-cross_strength/2,ScrH()/2-cross_width/2,cross_strength,cross_width, getColor())
    
end

local toHide = {
    ["CHudHealth"] = true,
    ["CHudAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudSecondaryAmmo"] = true
}

local function proofHide(name)
    if (toHide[name]) then
        return false
    end
end

net.Receive("Identity", function()
    IDENTITY_NAME = net.ReadString()
end)

net.Receive("RoundState", function()
    ROUND_STATE = net.ReadInt(4)
end)

net.Receive("Victim", function()
    VICTIM_NAME = net.ReadString()
end)


hook.Add("HUDPaint","Health", drawHealth)
hook.Add("HUDPaint", "Cross", drawCross)
hook.Add("HUDShouldDraw", "Hide Stuff", proofHide)
