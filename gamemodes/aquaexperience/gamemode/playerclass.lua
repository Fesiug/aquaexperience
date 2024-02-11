
local PLAYER = {}

PLAYER.DisplayName			= "Aqua Experience Player Class"

PLAYER.SlowWalkSpeed		= 200
PLAYER.WalkSpeed			= 400
PLAYER.RunSpeed				= 600
PLAYER.CrouchedWalkSpeed	= 0.3
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight		= false
PLAYER.MaxHealth			= 100
PLAYER.MaxArmor				= 100
PLAYER.StartHealth			= 100
PLAYER.StartArmor			= 0
PLAYER.DropWeaponOnDie		= false
PLAYER.TeammateNoCollide	= true
PLAYER.AvoidPlayers			= true
PLAYER.UseVMHands			= true

function PLAYER:SetupDataTables()
	self.Player:NetworkVar("Entity", 0, "DesireR")
	self.Player:NetworkVar("Entity", 1, "DesireL")
end

function PLAYER:Init()
end

function PLAYER:Spawn()
end

function PLAYER:Loadout()
end

function PLAYER:SetModel()
	local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	self.Player:SetModel( modelname )
end

function PLAYER:Death( inflictor, attacker )
end

function PLAYER:ViewModelChanged( vm, old, new )
end

function PLAYER:PreDrawViewModel( vm, weapon )
end

function PLAYER:PostDrawViewModel( vm, weapon )
end

-- Clientside only
function PLAYER:CalcView( view ) end		-- Setup the player's view
function PLAYER:CreateMove( cmd ) end		-- Creates the user command on the client
function PLAYER:ShouldDrawLocal() end		-- Return true if we should draw the local player

-- Shared
function PLAYER:StartMove( cmd, mv ) end	-- Copies from the user command to the move
function PLAYER:Move( mv ) end				-- Runs the move (can run multiple times for the same client)
function PLAYER:FinishMove( mv ) end		-- Copy the results of the move back to the Player

function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName( self.Player:GetModel() )
	return player_manager.TranslatePlayerHands( playermodel )

end

player_manager.RegisterClass( "player_aquaexperience", PLAYER, nil )
