
-- Shared

local ACS, INC = AddCSLuaFile, include

GM.Name = "Aqua Experience"
GM.Author = "Fesiug"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:Initialize()
	-- Do stuff
end

function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_aquaexperience" )
end

function GM:PlayerSpawn( ply )
	ply:Give("itemhandler")
	ply:UnSpectate()
	ply:SetModel("models/player/police.mdl")
	ply:SetupHands()
end

ACS("playerclass.lua")
INC("playerclass.lua")

ACS("player.lua")
INC("player.lua")

ACS("items.lua")
INC("items.lua")

ACS("dev.lua")
INC("dev.lua")

ACS("hud.lua")
if CLIENT then
INC("hud.lua")
end

hook.Add( "CanPlayerSuicide", "AllowOwnerSuicide", function( ply )
	return false
end )

hook.Add( "PlayerNoClip", "isInNoClip", function( ply, desiredNoClipState )
	return true
end )

hook.Add( "EntityTakeDamage", "EntityDamageExample", function( target, dmginfo )
	return true
end )