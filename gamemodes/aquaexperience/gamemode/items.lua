
ITEMS = {}

local itemmeta = {}

function itemmeta:__tostring()
	return "ItemDef [" .. self.ClassName .. "]"
end

local ITEMHELPER = {
	Get = function( self, key )
		return self.key
	end,
	GetRaw = function( self, key )
		return rawget( self, key )
	end,
}

function itemmeta.__index( self, key )
	if ITEMHELPER[key] then return ITEMHELPER[key] end
	if rawget(self, "BaseClass") then
		return rawget(self, "BaseClass")[key]
	end
end

function AddItem( itemname, item )
	if item then
		ITEMS[itemname] = item
		item.ClassName = itemname
		item.BaseClass = ITEMS[item.Base]
		setmetatable( item, itemmeta )
	else
		return ITEMS[itemname]
	end
end

AddItem( "base", {
	PrintName = "Base Item",

	Vars = {
		["Float"] = {
			"Acquisition",
		},
	},

	["Initialize"] = function( class, ent )
		print( class, "Initialized base initialization" )
	end,
})

AddItem( "base_firearm", {
	PrintName = "Base Firearm",
	Base = "base",

	Vars = {
		["Int"] = {
			"Clip",
			"BurstCount",
		},
		["Float"] = {
			"Delay",
			"RefillTime",
			"Accuracy_Reset",
			"Accuracy_Amount",
		},
	},

	ClipSize = 15,
	BurstCount = math.huge,

	["Initialize"] = function( class, ent )
		ITEMS["base"].Initialize( class, ent )

		ent:SetClip( class.ClipSize )

		print( class, "Initialized a firearm" )
	end,

	["GetAccuracy"] = function( class, ent, ih )
		return class.Accuracy + ent:GetAccuracy_Amount()
	end,

	["Deploy"] = function( class, ent, ih )
		ih:VMAnim( ih:VM():SelectWeightedSequence( ACT_VM_DRAW ) )
		ent:SetDelay( CurTime() + 0.75 )
	end,

	["Attack"] = function( class, ent, ih )
		if ent:GetDelay() > CurTime() then
			return
		end
		if ent:GetBurstCount() >= class.BurstCount then
			return
		end
		if ent:GetClip() <= 0 then
			ih:EmitSound( "weapons/clipempty_rifle.wav", 60, 100, 0.3, CHAN_STATIC )
			ent:SetDelay( CurTime() + 0.2 )
			return
		end
		ent:SetBurstCount( ent:GetBurstCount() + 1 )
		ent:SetDelay( CurTime() + class.Delay )
		ent:SetClip( ent:GetClip() - 1 )
		ih:VMAnim( ih:VM():SelectWeightedSequence( ACT_VM_PRIMARYATTACK ) )
		ih:EmitSound( class.FireSound, 70, 100, 0.4, CHAN_STATIC )

		ent:SetAccuracy_Reset( CurTime() + class.Accuracy_Reset )
		ent:SetAccuracy_Amount( ent:GetAccuracy_Amount() + class.Accuracy_Add )

		local acc = ih:ItemR("GetAccuracy")
		acc = math.rad( acc )
		ih:FireBullets( {
			Attacker = ih:GetOwner(),
			Damage = 1,
			Force = 1,
			Num = 1,
			Dir = ih:GetOwner():GetAimVector(),
			Src = ih:GetOwner():GetShootPos(),
			Spread = Vector( acc, acc, 0 ),
		} )
	end,

	["Think"] = function( class, ent, ih )
		if ent:GetRefillTime() > 0 and ent:GetRefillTime() <= CurTime() then
			ent:SetClip( class.ClipSize )
			ent:SetRefillTime( 0 )
		end
		if !ih:GetOwner():KeyDown( IN_ATTACK ) then
			ent:SetBurstCount( 0 )
		end
		if ent:GetAccuracy_Reset() <= CurTime() then
			ent:SetAccuracy_Amount( math.Approach( ent:GetAccuracy_Amount(), 0, FrameTime()*class.Accuracy_Decay ) )
		end
	end,

	["Reload"] = function( class, ent, ih )
		if ent:GetClip() < class.ClipSize and ent:GetDelay() <= CurTime() then
			ih:VMAnim( ih:VM():SelectWeightedSequence( ACT_VM_RELOAD ) )

			ent:SetRefillTime( CurTime() + 1.5 )
			ent:SetDelay( CurTime() + ih:VM():SequenceDuration() )
		end
	end,
})

AddItem( "glock", {
	PrintName = "G17",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_glock18.mdl",
	WModel = "models/weapons/w_pist_glock18.mdl",

	ClipSize = 20,
	Delay = (60/400),
	FireSound = "weapons/glock/glock18-1.wav",

	Accuracy = 1,
	BurstCount = 1,
	Accuracy_Add = 0.3,
	Accuracy_Reset = 0.4,
	Accuracy_Decay = 5,
})

AddItem( "usp", {
	PrintName = "KM-45T",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_usp.mdl",
	WModel = "models/weapons/w_pist_usp.mdl",

	ClipSize = 12,
	Delay = (60/300),
	FireSound = "weapons/usp/usp_unsil-1.wav",

	Accuracy = 0.7,
	BurstCount = 1,
	Accuracy_Add = 0.5,
	Accuracy_Reset = 0.4,
	Accuracy_Decay = 5,
})

AddItem( "p228", {
	PrintName = "P2-8",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_p228.mdl",
	WModel = "models/weapons/w_pist_p228.mdl",

	ClipSize = 13,
	Delay = (60/300),
	FireSound = "weapons/p228/p228-1.wav",

	Accuracy = 0.8,
	BurstCount = 1,
	Accuracy_Add = 0.4,
	Accuracy_Reset = 0.5,
	Accuracy_Decay = 6,
})

AddItem( "fiveseven", {
	PrintName = "FN5-7",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_fiveseven.mdl",
	WModel = "models/weapons/w_pist_fiveseven.mdl",

	ClipSize = 20,
	BurstCount = 1,
	Delay = (60/350),
	FireSound = "weapons/fiveseven/fiveseven-1.wav",

	Accuracy = 1,
	Accuracy_Add = 0.9,
	Accuracy_Reset = 0.3,
	Accuracy_Decay = 8,
})

AddItem( "deagle", {
	PrintName = "D.E.",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_deagle.mdl",
	WModel = "models/weapons/w_pist_deagle.mdl",

	ClipSize = 7,
	BurstCount = 1,
	Delay = (60/240),
	FireSound = "weapons/deagle/deagle-1.wav",

	Accuracy = 1.5,
	Accuracy_Add = 1,
	Accuracy_Reset = 0.7,
	Accuracy_Decay = 4,
})

AddItem( "m4a1", {
	PrintName = "M-16",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_rif_m4a1.mdl",
	WModel = "models/weapons/w_rif_m4a1.mdl",

	ClipSize = 20,
	Delay = (60/450),
	FireSound = "weapons/m4a1/m4a1_unsil-1.wav",

	Accuracy = 1,
	Accuracy_Add = 0.4,
	Accuracy_Reset = 0.4,
	Accuracy_Decay = 12,
})

AddItem( "famas", {
	PrintName = "FA-3",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_rif_famas.mdl",
	WModel = "models/weapons/w_rif_famas.mdl",

	ClipSize = 20,
	BurstCount = 3,
	Delay = (60/850),
	FireSound = "weapons/famas/famas-1.wav",

	Accuracy = 1,
	Accuracy_Add = 0.15,
	Accuracy_Reset = 0.2,
	Accuracy_Decay = 12,
})

for ID, Data in pairs(ITEMS) do
	local tent = {}
	tent.Base = "ae_item"
	tent.PrintName = Data.PrintName or ID
	tent.ID = ID
	tent.Class = ITEMS[ID]
	tent.Spawnable = true
	tent.AdminOnly = false
	tent.Category = "Other"

	-- print("aei_" .. ID)
	scripted_ents.Register( tent, "aei_" .. ID )
end


--[[ This looks stupid.
local sdir = "aquaexperience/gamemode/items/"
local fff, ffd = file.Find( sdir .. "*", "LUA" )

for index, filename in ipairs( fff ) do
	print( "Executing " .. filename )
	local yaya, yoyo = pcall(function() AddCSLuaFile(sdir..filename) include(sdir..filename) end)
	if !yaya then print( "Item file " .. filename .. " has errors" ) end
end
]]