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

include("gamemanager/killmode.lua")

PrintTable(Arrays)

function GM:PlayerInitialSpawn(ply)
end

function GM:PlayerLoadout(ply)
    ply:Give("weapon_shotgun")
    ply:Give("weapon_ar2")
    ply:Give("gmod_tool")
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

concommand.Add("pllist", printpls)