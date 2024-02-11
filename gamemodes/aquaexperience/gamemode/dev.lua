
-- Dev shit

local function spawn( self )
	net.Start("AEDEV_Spawn")
		net.WriteString( self.ID )
	net.SendToServer()
	return
end

if SERVER then
	util.AddNetworkString("AEDEV_Spawn")
	net.Receive("AEDEV_Spawn", function( len, ply )
		local ET = ply:GetEyeTrace()
		local HP = ET.HitPos + ET.HitNormal * 8

		local ID = net.ReadString()
		ID = "aei_" .. ID
		print( "Making " .. ID )
		local ent = ents.Create( ID )
		ent:SetPos( HP )
		ent:Spawn()

	end)
end

function GM:OnSpawnMenuOpen()
	if IsValid( DEV_Spawnmenu ) then DEV_Spawnmenu:Remove() end

	DEV_Spawnmenu = vgui.Create("DFrame")
	DEV_Spawnmenu:SetSize( s(140), ScrH() - s(16) )
	DEV_Spawnmenu:SetX( s(8) )
	DEV_Spawnmenu:SetY( s(8) )
	DEV_Spawnmenu:MakePopup()
	DEV_Spawnmenu:SetKeyboardInputEnabled( false )

	local Scroll = DEV_Spawnmenu:Add("DScrollPanel")
	Scroll:Dock( FILL )

	--for i=1, 10 do
		local Category = Scroll:Add("DCollapsibleCategory")
		Category:Dock( TOP )
		Category:SetLabel( "Items" )

		local Panel = Scroll:Add("DIconLayout")
		Category:SetContents( Panel )
		Panel:SetTall( s(140) )
		Panel:SetStretchWidth( true )
		Panel:SetSpaceX( s(1) )
		Panel:SetSpaceY( s(1) )

		for itemname, itemdef in pairs(ITEMS) do
			local Butt = Panel:Add("DButton")
			Butt:SetSize( s(40), s(16) )
			Butt:SetText( itemdef.PrintName )
			Butt.ID = itemname

			Butt.DoClick = spawn
		end
	--end
end

function GM:OnSpawnMenuClose()
	if IsValid( DEV_Spawnmenu ) then DEV_Spawnmenu:Remove() end
end