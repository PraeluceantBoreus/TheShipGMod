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
IDENTITIES = {}
ROUND_STATE = R_STATE.JOINED
ROUND_STATES = {}
VICTIM_NAME = ""
INITED = false

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

function GM:HUDDrawTargetID()
    local tr = util.GetPlayerTrace(client)
    local trace = util.TraceLine(tr)
    if(!trace.Hit) then return end
    if(!trace.HitNonWorld) then return end
    local ent = trace.Entity
    if ent:IsPlayer() then
        local st_id = ent:SteamID64()
        print(st_id)
        print(ent:GetName())
        draw.SimpleText(IDENTITIES[st_id], "ProgBar", ScrW()/2,ScrH()/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
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
    local isTable = net.ReadUInt(1)
    if isTable == 1 then
        IDENTITIES = net.ReadTable()
    end
    if isTable == 0 then
        local st_id = net.ReadString()
        local name = net.ReadString()
        IDENTITIES[st_id] = name
    end
    if INITED then
        IDENTITY_NAME = IDENTITIES[LocalPlayer():SteamID64()]
    end
end)

net.Receive("RoundState", function()
    local isTable = net.ReadUInt(1)
    if isTable == 1 then
        ROUND_STATES = net.ReadTable()
    end
    if isTable == 0 then
        local st_id = net.ReadString()
        local state = net.ReadInt(4)
        ROUND_STATES[st_id] = state
    end
    if INITED then
        ROUND_STATE = ROUND_STATES[LocalPlayer():SteamID64()]
    end
end)

net.Receive("Victim", function()
    VICTIM_NAME = net.ReadString()
end)


hook.Add("HUDPaint","Health", drawHealth)
hook.Add("HUDPaint", "Cross", drawCross)
hook.Add("HUDShouldDraw", "Hide Stuff", proofHide)
hook.Add("InitPostEntity", "afterfirstspawn", function()
    INITED = true
    IDENTITY_NAME = IDENTITIES[LocalPlayer():SteamID64()]
    ROUND_STATE = ROUND_STATES[LocalPlayer():SteamID64()]
end)
