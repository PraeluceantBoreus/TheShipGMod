AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("lang/at.lua")
AddCSLuaFile("lang/de.lua")
AddCSLuaFile("lang/en.lua")

AddCSLuaFile("gui/gui.lua")
AddCSLuaFile("gui/cs_progressbar.lua")
AddCSLuaFile("gui/healthco.lua")
AddCSLuaFile("gui/messages.lua")
AddCSLuaFile("gui/playerinfo.lua")

AddCSLuaFile("data/identities.lua")


include("shared.lua")
include("utils/arrays.lua")

include("data/identities.lua")
include("gamemanager/killmode.lua")
include("gamemanager/timer.lua")
include("gamemanager/msg_events.lua")
include("gamemanager/money.lua")

--RoundStates:
--1 Hunting
--2 Killed from Hunter
--3 Hunting finished
--4 Preparing
--5 Join Round



function GM:PlayerInitialSpawn(ply)
    
    Killmode.newIdentity(ply)
    local rstate = R_STATE.PREPARING
    local curr_time = timer.TimeLeft("Prepare")
    if Timer.isRound() then 
        rstate = R_STATE.JOINED
        curr_time = timer.TimeLeft("Round")
    end
    net.Start("Timer")
        local isround = 0
        if Timer.isRound() then
            isround = 1
        end
        net.WriteUInt(0,2)
        net.WriteUInt(curr_time,16)
    net.Send(ply)
    Killmode.identities(ply)
    Killmode.roundState(ply,rstate)
    Killmode.roundStates(ply)
    Money.playerInit(ply)
end

function GM:PlayerLoadout(ply)
    
    ply:Give("weapon_shotgun")
    ply:Give("weapon_ar2")
    ply:Give("weapon_physgun")
    
end

util.AddNetworkString("Identity")
util.AddNetworkString("RoundState")
util.AddNetworkString("Timer")
util.AddNetworkString("Victim")
util.AddNetworkString("Message")

util.AddNetworkString("money_cash")
util.AddNetworkString("money_bank")
util.AddNetworkString("money_init")
util.AddNetworkString("money_weapon")