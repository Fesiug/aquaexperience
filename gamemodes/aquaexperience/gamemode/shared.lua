
-- Shared

local ACS, INC = AddCSLuaFile, include

GM.Name = "Aqua Experience"
GM.Author = "Fesiug"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:Initialize()
	-- Do stuff
end

ACS("dev.lua")
INC("dev.lua")

ACS("hud.lua")
if CLIENT then
INC("hud.lua")
end