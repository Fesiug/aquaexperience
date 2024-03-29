
AddCSLuaFile()

SWEP.Base						= "weapon_base"
SWEP.AEItemHandler				= true

SWEP.ViewModel					= "models/weapons/c_arms.mdl"
SWEP.ViewModelFOV				= 74
SWEP.ViewModelFlip				= false
SWEP.UseHands					= true
SWEP.WorldModel					= "models/weapons/w_pistol.mdl"
SWEP.DrawWorldModel				= true


SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= 0
SWEP.Primary.Ammo				= "none"
SWEP.Primary.Automatic			= true

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= 0
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= true

function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "ActiveR" )
	self:NetworkVar( "Entity", 1, "ActiveL" )
end

function SWEP:ItemR( run )
	local active = self:GetActiveR()
	if run and active:IsValid() then
		return active.Class[run]( active.Class, active, self )
	else
		return active:IsValid() and active or false
	end
end

function SWEP:ItemL( run )
	local active = self:GetActiveL()
	if run and active:IsValid() then
		active.Class[run]( active.Class, active, self )
	else
		return active:IsValid() and active or false
	end
end

function SWEP:Initialize()
end

local size = 8/2
local tracedef = {
	mins = Vector( -size, -size, -size ),
	maxs = Vector( size, size, size ),
}
function SWEP:ItemCheckTrace()
	local p = self:GetOwner()
	p:LagCompensation( true )
		tracedef.filter = p
		tracedef.start = p:EyePos()
		tracedef.endpos = p:EyePos() + (p:GetAimVector() * 72)
		local trace = util.TraceHull(tracedef)
	p:LagCompensation( false )
	return trace
end

function SWEP:EquipItem( ent )
	local p = self:GetOwner()
	if IsValid(ent) and ent.AEItem then
		if ent:GetOwner() != NULL then
			print( ent, "belongs to", ent:GetOwner(), "!! Not equipping." )
			return
		end
		--if !p:GetInventory()[ent] then
		--	print( ent, "is not in", p, "'s inventory!" )
		--	return
		if p:GetInventory()[ent] then
			print( ent, "is in", p, "'s inventory!" )
			return
		end
		--print("Pick up", ent)

		ent:SetParent( p )
		ent:SetOwner( p )
		ent:SetPos( vector_origin )
		ent:SetAngles( Angle( 0, p:EyeAngles().y, 0 ) )
		ent:SetAcquisition( CurTime() )

		--self:SetActive( ent )
		if SERVER then
			local inv = p:GetInventory()
			inv[ent] = true
			inv:Sync()
		else
			ent:SetPredictable( true )
		end
	end
end

function SWEP:SetActive( ent )
	local p = self:GetOwner()
	if ent:GetOwner() != p then return false end
	local vm = p:GetViewModel( 0 )
	if self:GetActiveR():IsValid() then self:Deactive() end
	self:SetActiveR( ent )
	vm:SetWeaponModel( ent.Class.VModel, self )
	self:ItemR( "Deploy" )
	--vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_DRAW ) )
	--vm:SetPlaybackRate( 1 )
	return true
end

function SWEP:Deactive()
	local p = self:GetOwner()
	local vm = p:GetViewModel( 0 )
	self:SetActiveR( NULL )
	vm:SetWeaponModel( "models/weapons/c_arms.mdl", self )
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "seq_admire" ) )
	vm:SetPlaybackRate( 2 )
end

function SWEP:PrimaryAttack()
	local p = self:GetOwner()
	if self:ItemR() then
		self:ItemR("Attack")
	else
		local trace = self:ItemCheckTrace()
		self:EquipItem( trace.Entity )
	end
end

function SWEP:Reload()
	if self:ItemR() then
		self:ItemR("Reload")
	end
end

function SWEP:VM()
	local p = self:GetOwner()
	return p:GetViewModel( 0 )
end

function SWEP:VMAnim( seq, rate )
	local p = self:GetOwner()
	local vm = p:GetViewModel( 0 )
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( rate or 1 )
end

function SWEP:VMAnimE( seq, rate )
	self:VMAnim( vm:LookupSequence( seq ), rate )
end

function SWEP:SecondaryAttack()
	local p = self:GetOwner()
	if p:KeyPressed(IN_ATTACK2) then
		self:DropItem()
	end
end

function SWEP:DropItem()
	local p = self:GetOwner()
	local ent = self:GetActiveR()
	if SERVER and ent:IsValid() then
		ent:SetParent( NULL )
		ent:SetOwner( NULL )

		local ep = ent:GetPhysicsObject()
		ent:SetPos( p:EyePos() + p:GetAimVector() * 0 )
		ent:SetAngles( p:EyeAngles() + Angle( 0, 180, 0 ) )
		ep:SetVelocity( p:GetAimVector() * 700 )
		ep:SetAngleVelocity( Vector( 0, -360*4, 0 ) )
		ep:Wake()

		self:Deactive()
		if SERVER then
			local inv = p:GetInventory()
			inv[ent] = nil
			inv:Sync()
		else
			ent:SetPredictable( false )
		end
	end
end

function SWEP:Think()
	local p = self:GetOwner()

	if p:IsValid() then
		if self:ItemR() then
			self:ItemR("Think")
		end
	else
		print( self, "Thinking without an owner." )
	end
end

function SWEP:Deploy()
end

function SWEP:Holster()
end

function SWEP:CalcViewModelView( vm, opos, oang, pos )
	local pos, ang = Vector( 1, -4, -1 ), Angle()

	opos = opos + pos.x * oang:Right()
	opos = opos + pos.y * oang:Forward()
	opos = opos + pos.z * oang:Up()

	return opos, oang
end

AddCSLuaFile("hud.lua")
include("hud.lua")
