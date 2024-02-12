
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AEItem = true

function ENT:Initialize()
	self:SetModel( self.Class.WModel or "models/weapons/w_357.mdl" )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:GetPhysicsObject():Wake()
	end

	self.Class:Initialize( self )
end

local function recurse( modify, includer )
	local basevars = ITEMS[includer].BaseClass
	if ITEMS[includer].BaseClass then
		recurse( modify, ITEMS[includer].Base )
	end

	local localvars = ITEMS[includer]:GetRaw("Vars")
	if localvars then
		for i, v in pairs( localvars ) do
			if !modify[i] then modify[i] = {} end
			table.Add( modify[i], v )
		end
	end
end

function ENT:SetupDataTables()
	local NWVars = {}
	recurse( NWVars, self.ID )
	for varname, varlist in pairs(NWVars) do
		local numba = 0
		for keyind, keyname in ipairs(varlist) do
			self:NetworkVar( varname, numba, keyname )
			numba = numba + 1
		end
	end
end

if SERVER then
	function ENT:PhysicsCollide( data, collider )
		if ( data.DeltaTime > 0.1 ) then
			local str = "ae/impact/hit_"

			if ( data.Speed > 400 ) then
				str = str .. "hard" .. math.random( 1, 3 )
			elseif ( data.Speed > 150 ) then
				str = str .. "med"
			else
				str = str .. "soft"
			end
			str = str .. ".wav"
			self:EmitSound( str, 70, 100, 1, CHAN_STATIC )
		end
		return
	end
end
