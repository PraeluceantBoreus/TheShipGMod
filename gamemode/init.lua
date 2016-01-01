AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("lang/at.lua")
AddCSLuaFile("lang/de.lua")
AddCSLuaFile("lang/en.lua")

AddCSLuaFile("gui/gui.lua")
AddCSLuaFile("gui/cs_progressbar.lua")
AddCSLuaFile("gui/healthco.lua")

AddCSLuaFile("data/identities.lua")


include("shared.lua")
include("utils/arrays.lua")

include("data/identities.lua")
include("gamemanager/killmode.lua")
include("gamemanager/timer.lua")

PrintTable(Arrays)

--RoundStates:
--1 Hunting
--2 Killed from Hunter
--3 Hunting finished
--4 Preparing
--5 Join Round

function GM:PlayerInitialSpawn(ply)
    Killmode.newIdentity(ply)
    local rstate = 4
    local curr_time = timer.TimeLeft("Prepare")
    if Timer.isRound() then 
        rstate = 5
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
    net.Start("RoundState")
        net.WriteInt(rstate,4)
        net.WriteString("")
        net.WriteInt(curr_time+1,32)
    net.Send(ply)
end

function GM:PlayerLoadout(ply)
    ply:Give("weapon_shotgun")
    ply:Give("weapon_ar2")
    ply:Give("weapon_physgun")
end

function printpls()
    PrintTable(player.GetAll())
    PrintTable(Arrays.shuffle(player.GetAll()))
    for nr, ply in pairs(player.GetAll()) do
        print(ply:Nick().." "..ply:UserID())
    end
end

function baum()
    for nr, ply in pairs(player.GetAll()) do
        print(ply:EntIndex())
    end
end

util.AddNetworkString("Identity")
util.AddNetworkString("RoundState")
util.AddNetworkString("Timer")

concommand.Add("pllist", printpls)