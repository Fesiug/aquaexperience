
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

	["Initialize"] = function( self )
		print(self, "Initialized base initialization")
	end,
})

AddItem( "base_firearm", {
	PrintName = "Base Firearm",
	Base = "base",

	Vars = {
		["Int"] = {
			"BurstCount",
		},
		["Float"] = {
			"Delay",
		},
	},

	["Initialize"] = function( self )
		self.BaseClass.Initialize( self )

		print(self, "Initialized a firearm")
	end,
})

AddItem( "glock", {
	PrintName = "G17",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_glock18.mdl",
	WModel = "models/weapons/w_pist_glock18.mdl",
})

AddItem( "usp", {
	PrintName = "KM-45T",
	Base = "base_firearm",

	VModel = "models/weapons/cstrike/c_pist_usp.mdl",
	WModel = "models/weapons/w_pist_usp.mdl",
})

for ID, Data in pairs(ITEMS) do
	local tent = {}
	tent.Base = "ae_item"
	tent.PrintName = Data.PrintName or ID
	tent.ID = ID
	tent.Spawnable = true
	tent.AdminOnly = false
	tent.Category = "Other"

	print("aei_" .. ID)
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