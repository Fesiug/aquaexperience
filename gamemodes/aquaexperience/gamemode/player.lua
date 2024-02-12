
local PT = FindMetaTable("Player")

function PT:GetItems()
	return
end

function PT:HandlerCheck()
	return self:GetActiveWeapon().AEItemHandler and self:GetActiveWeapon()
end

InventoryMeta = {}

function InventoryMeta:Destroy()
	local p = self[0].Owner
	p.Inventory = nil
	p:GetInventory()
end

function InventoryMeta:BugCheck()
	for i, v in pairs(self) do
		if i != 0 and !i:IsValid() then
			self[i] = nil
		end
	end
end

function InventoryMeta:GetWeighted()
	local itemlist = {}

	for i, v in pairs(self) do
		if i == 0 then continue end
		table.insert( itemlist, i )
	end

	table.sort( itemlist, function( a, b ) 
		return a:GetAcquisition() < b:GetAcquisition()
	end)

	return itemlist
end

function InventoryMeta:Sync()
	if SERVER then
		net.Start("AEINV_InvSync")
			local count = table.Count( self )-1 -- The header is included
			net.WriteUInt( count, 8 )
			for key, _ in pairs( self ) do
				if key == 0 then continue end
				net.WriteEntity( key )
			end
		net.Send( self[0].Owner )
	end
end

InventoryMeta.__index = InventoryMeta
--function InventoryMeta.__index( self, key )
--	if INVMETAHELP[key] then return INVMETAHELP[key] end
--end

if SERVER then
	util.AddNetworkString("AEINV_InvSync")
else
	net.Receive("AEINV_InvSync", function()
		print("Destroyed old inventory")
		local p = LocalPlayer()
		p.Inventory = nil
		local inv = p:GetInventory()
		local count = net.ReadUInt(8)
		for i=1, count do
			local key = net.ReadEntity()
			print( "Added", key)
			inv[key] = true
		end
	end)
end

function PT:GetInventory()
	if !self.Inventory then
		print("Creating new inventory for", self)
		self.Inventory = {}
		self.Inventory[0] = { Owner = self }
		setmetatable( self.Inventory, InventoryMeta )

		if SERVER then
			for i, v in pairs( self:GetChildren() ) do
				if v.AEItem then
					print( "Regen, adding", v, "to inventory")
					self.Inventory[v] = true
				end
			end
			self.Inventory:Sync()
		end
	end

	self.Inventory:BugCheck()

	return self.Inventory
end


gameevent.Listen( "OnRequestFullUpdate" )
hook.Add( "OnRequestFullUpdate", "OnRequestFullUpdate_example", function( data )
	local name = data.name			// Same as Player:Nick()
	local steamid = data.networkid	// Same as Player:SteamID()
	local id = data.userid			// Same as Player:UserID()
	local index = data.index   		// Same as Entity:EntIndex() minus one

	if SERVER then
		Player(id):GetInventory():Sync()
	end
end )


do
	local qt = {
		["slot1"] = true,
		["slot2"] = true,
		["slot3"] = true,
		["slot4"] = true,
		["slot5"] = true,
		["slot6"] = true,
		["slot7"] = true,
		["slot8"] = true,
		["slot9"] = true,
		["slot0"] = true,
	}

	hook.Add( "PlayerBindPress", "Benny_PlayerBindPress_Original", function( ply, bind, pressed, code )
		if qt[bind] and pressed then
			return true
		end
	end)
end


local dads = {
	[KEY_1] = 1,
	[KEY_2] = 2,
	[KEY_3] = 3,
	[KEY_4] = 4,
	[KEY_5] = 5,
	[KEY_6] = 6,
	[KEY_7] = 7,
	[KEY_8] = 8,
	[KEY_9] = 9,
	[KEY_0] = 0,
}

local function beatup( ply, num )
	local inv = ply:GetInventory():GetWeighted()
	local wep = ply:HandlerCheck()

	local ent = inv[num]
	if ent then
		if ent == wep:GetActiveR() then
			wep:Deactive()
		else
			wep:SetActive(ent)
		end
	end
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_Inv", function( ply, button )
	local wep = ply:HandlerCheck()

	if dads[button] then
		beatup( ply, dads[button] )
	end
end)
