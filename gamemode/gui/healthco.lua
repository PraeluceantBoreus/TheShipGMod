include("cs_progressbar.lua")
include("playerinfo.lua")
--make message table

local client = LocalPlayer()
local height = 200
local width = 300
local padding = 10
local rounding = 15

local cross_width = 50
local cross_strength = 1

local rs_color = {}
rs_color[R_STATE.HUNTING] = Color(0,0,127,255)
rs_color[R_STATE.KILLED] = Color(127,0,0,255)
rs_color[R_STATE.FINISHED] = Color(0,127,0,255)
rs_color[R_STATE.PREPARING] = Color(127,127,127,255)
rs_color[R_STATE.JOINED] = Color(127,127,127,255)

IDENTITIES = {}
ROUND_STATES = {}
VICTIM_NAME = ""
INITED = false

local function getRoundState()
    --local color = ROUND_STATES[LocalPlayer():GetName()]
    --if color == nil then color = rs_color[R_STATE.PREPARING] end
    return ROUND_STATES[LocalPlayer():GetName()]
end

local function getName()
    return IDENTITIES[LocalPlayer():GetName()]
end

local function getColor()
    local ret = rs_color[getRoundState()]
	if ret == nil then ret = rs_color[R_STATE.PREPARING] end
	return ret
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

function calcHealth(hp,fhp)
	local ret = LANG.HEALTH_FULL
	local color = Color(0,255,0,255)
	local pro = hp / fhp
	if pro < 1 then ret = LANG.HEALTH_HIT color = Color(63,195,0,255) end
	if pro < 0.8 then ret = LANG.HEALTH_DAMAGED color = Color(127,127,0,255) end
	if pro < 0.5 then ret = LANG.HEALTH_HURT color = Color(195,63,0,255) end
	if pro < 0.25 then ret = LANG.HEALTH_CRITICAL color = Color(255,0,0,255) end
	return ret, color
end

function drawPlayerInfo(ply)
	local rname = ply:GetName()
	local name = IDENTITIES[rname]
	local hp_text, hp_color = calcHealth(ply:Health(),ply:GetMaxHealth())
	local state = ROUND_STATES[rname]
	local state_text = LANG.STATE_HUNTING
	if state == R_STATE.KILLED then state_text = LANG.STATE_KILLED end
	if state == R_STATE.FINISHED then state_text = LANG.STATE_FINISHED end
	if state == R_STATE.PREPARING then state_text = LANG.STATE_PREPARING end
	if state == R_STATE.JOINED then state_text = LANG.STATE_JOINED end
	local state_color = rs_color[state]
	Playerinfo.drawInfo(1,name,Color(255,255,255,255))
	Playerinfo.drawInfo(2,hp_text, hp_color)
	
	Playerinfo.drawInfo(3,state_text,state_color)
end

function drawHealth()
    
    client = LocalPlayer()
    local padd_top = ScrH()-(height+padding)
    draw.RoundedBox(rounding,padding,padd_top,width,height, Color(0,0,0,128))
    
    local margin = padding
    local width = width - 2 * padding
    
    ProgBar.drawBar(1,1,margin,padd_top,width,-1,-1,getColor(),getName())
    
    margin = 2*padding
    padd_top = padd_top + padding + ProgBar.def_height
    ProgBar.drawBar(client:GetMaxHealth(),client:Health(),margin,padd_top,width,-1,-1,Color(96,0,0,255),LANG.HEALTH.." "..client:Health())
    
    padd_top = padd_top + ProgBar.def_height + padding
    if IsValid(weapon()) and maxClip() > 0 then
    ProgBar.drawBar(maxClip(),clipAmmo(),margin,padd_top,width,-1,-1,Color(196,127,0,255),LANG.AMMO.." "..clipAmmo().." + "..currAmmo())
    end
    
    padd_top = padd_top + ProgBar.def_height + padding
    local vname = LANG.ROUND_WAIT
    if getRoundState() == R_STATE.HUNTING then vname = VICTIM_NAME end
    if getRoundState() == R_STATE.KILLED then vname = LANG.ROUND_KILLED_FROM_HUNTER end
    if getRoundState() == R_STATE.FINISHED then vname = LANG.ROUND_KILLED_VICTIM end
    if getRoundState() == R_STATE.JOINED then vname = LANG.ROUND_JOINED end
    
    
    
    local totalTime = CONF.RoundTime
    local timeLeft = timer.TimeLeft("RoundTimer")
    
    
    
    if getRoundState() == R_STATE.PREPARING then
        totalTime = CONF.PrepareTime
    end
    
    
    if timeLeft == nil then timeLeft = totalTime end
    
    ProgBar.drawBar(totalTime,timeLeft,margin,padd_top,width,-1,-1,getColor(),vname)
end

function drawCross()
    
    draw.RoundedBox(0,ScrW()/2-cross_width/2,ScrH()/2-cross_strength/2,cross_width,cross_strength, getColor())
    --draw.RoundedBox(0,ScrW()/2-cross_width/2,cross_strength,cross_width, getColor())
    
end

function GM:HUDDrawTargetID()
    local tr = util.GetPlayerTrace(client)
    local trace = util.TraceLine(tr)
    if(!trace.Hit) then return end
    if(!trace.HitNonWorld) then return end
    local ent = trace.Entity
    if ent:IsPlayer() then
        drawPlayerInfo(ent)
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
end)

net.Receive("Victim", function()
    VICTIM_NAME = net.ReadString()
end)


hook.Add("HUDPaint","Health", drawHealth)
hook.Add("HUDPaint", "Cross", drawCross)
hook.Add("HUDShouldDraw", "Hide Stuff", proofHide)
