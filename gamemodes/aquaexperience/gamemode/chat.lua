
if SERVER then
	-- hook.Add( "PlayerSay", "CoinFlip", function( ply, text )
	-- end)
end

gameevent.Listen( "player_say" )
hook.Add( "player_say", "player_say_example", function( data ) 
	local priority = SERVER and data.Priority or 1 	// Priority ??
	local id = data.userid				// Same as Player:UserID() for the speaker
	local text = data.text				// The written text.

	if CLIENT then
		
	end
end )


local function hex2rgb(hex)
	hex = hex:gsub("#","")
	return Color( tonumber( "0x" .. hex:sub(1, 2) ), tonumber( "0x" .. hex:sub(3, 4) ), tonumber( "0x" .. hex:sub(5, 6) ) )
end

local CHANNELS = {
	["Common"] = {
		Name = "Common",
		Icon = "icon16/comment.png",
		Color = hex2rgb("408010"),
	},
	["Security"] = {
		Name = "Security",
		Icon = "icon16/user_red.png",
		Color = hex2rgb("A30000"),
	},
	["Medical"] = {
		Name = "Medical",
		Icon = "icon16/add.png",
		Color = hex2rgb("009190"),
	},
	["Supply"] = {
		Name = "Supply",
		Icon = "icon16/box.png",
		Color = hex2rgb("7F6539"),
	},
	["Service"] = {
		Name = "Service",
		Icon = "icon16/drink.png",
		Color = hex2rgb("80A000"),
	},
	["Science"] = {
		Name = "Science",
		Icon = "icon16/shape_align_bottom.png",
		Color = hex2rgb("993399"),
	},
	["Command"] = {
		Name = "Command",
		Icon = "icon16/user_suit.png",
		Color = hex2rgb("204090"),
	},
	["Central Command"] = {
		Name = "Central Command",
		Icon = "icon16/user_gray.png",
		Color = hex2rgb("5C5C7C"),
	},
	["Syndicate"] = {
		Name = "Syndicate",
		Icon = "icon16/bomb.png",
		Color = hex2rgb("6D3F40"),
	},
}

if CLIENT then

	local qt = {
		["messagemode"] = true,
		["messagemode2"] = true,
	}


	local RADIOSELECT = {
		{
			Name = "Local",
			Icon = "icon16/user_red.png",
		},
		{
			Name = "Left Hand",
			Icon = "icon16/arrow_left.png",
		},
		{
			Name = "Right Hand",
			Icon = "icon16/arrow_right.png",
		},
		true,
		CHANNELS[ "Common" ],
		CHANNELS[ "Security" ],
		CHANNELS[ "Medical" ],
		CHANNELS[ "Supply" ],
		CHANNELS[ "Service" ],
		CHANNELS[ "Science" ],
		CHANNELS[ "Command" ],
		CHANNELS[ "Central Command" ],
		CHANNELS[ "Syndicate" ],
	}

	concommand.Add("radio_say", function( ply, cmd, args )
		net.Start("AC_ClientChat")
			net.WriteString( args[1] )
			net.WriteString( args[2] )
		net.SendToServer()
	end)

	function OpenChatBox()
		if IsValid(ChatBox) then ChatBox:Remove() end

		ChatBox = vgui.Create("DFrame")
		ChatBox:SetSize( s(140), 20 + s(30) )
		ChatBox:Center()
		ChatBox:MakePopup()
		ChatBox:SetIcon( "icon16/comment.png" )
		ChatBox:SetTitle( "Chat" )

		local TextE = ChatBox:Add("DTextEntry")
		TextE:SetWide( ChatBox:GetWide() - s(8) )
		TextE:SetTall( s(10) )
		TextE:SetPos( s(4), 20 + s(4) )
		TextE:RequestFocus()

		-- OnKeyCodeTyped below

		local Button_NO = ChatBox:Add("DButton")
		Button_NO:SetText("Cancel")
		Button_NO:SetSize( s(30), s(10) )
		Button_NO:SetPos( ChatBox:GetWide() - s(4+30+2+30), 20 + s(4) + TextE:GetTall() + s(2) )
		function Button_NO:DoClick()
			ChatBox:Remove()
		end

		local Button_OK = ChatBox:Add("DButton")
		Button_OK:SetText("OK")
		Button_OK:SetSize( s(30), s(10) )
		Button_OK:SetPos( ChatBox:GetWide() - s(4+30), 20 + s(4) + TextE:GetTall() + s(2) )

		-- DoClick below

		local Channel = ChatBox:Add("DComboBox")
		Channel:SetSize( ChatBox:GetWide() - s(4+30+2+30+4+2), s(10) )
		Channel:SetPos( s(4), 20 + s(4) + TextE:GetTall() + s(2) )
		Channel:SetSortItems( false )

		for i, v in ipairs( RADIOSELECT ) do
			if v == true then
				Channel:AddSpacer()
			else
				Channel:AddChoice( v.Name, nil, v.Name == "Common", v.Icon )
			end
		end

		function Channel:OnSelect()
			timer.Simple( 0, function()
				TextE:RequestFocus()
			end)
		end

		-- DoClick
		function Button_OK:DoClick()
			RunConsoleCommand("radio_say", TextE:GetValue(), Channel:GetValue())
			ChatBox:Remove()
		end
		
		-- OnKeyCodeTyped
		function TextE:OnKeyCodeTyped( key )
			if key == KEY_TAB then
				Channel:DoClick()
				Channel:RequestFocus()
			elseif key == KEY_ENTER then
				Button_OK:DoClick()
			end
		end

	end

	local fi = {}

	fi.size = s(7)
	fi.font = "Verdana"
	fi.italic = false
	surface.CreateFont("AC_8", fi )
	fi.font = "Calibri"
	surface.CreateFont("AC_8b", fi )

	fi.size = s(8)
	fi.font = "Trebuchet MS"
	fi.italic = false
	surface.CreateFont("AC_10", fi )
	fi.font = "Calibri Bold"
	surface.CreateFont("AC_10b", fi )

	local MESSAGES = {} or {
		{
			Name = "Jack Ingoff",
			Role = "Head of Security",
			Channel = "Security",
			Message = "I'm going to mog you."
		},
		{
			Name = "Finland Mercer",
			Role = "Security Officer",
			Channel = "Security",
			Message = "No!!"
		},
		{
			Name = "Fesiug",
			Role = "Assistant",
			Channel = "Common",
			Message = "Really really really fucking long string. I think. I guess if you're a fucking moron, it makes sense, no?"
		},
		{
			Name = "Dead Space",
			Role = "Chief Medical Officer",
			Channel = "Medical",
			Message = "We're ALL gonna DIE!!!"
		},
		{
			Name = "David Keyes",
			Role = "Captain",
			Channel = "Command",
			Message = "Will someone tell them to shut the fuck up?!"
		},
		{
			Name = "Mr. Payaso",
			Role = "Chef",
			Channel = "Service",
			Message = "I cooka da pizza."
		},
		{
			Name = "Duke Chookem",
			Role = "Bartender",
			Channel = "Service",
			Message = "Fuck you."
		},
		{
			Name = "Dickweed",
			Role = "Syndicate Officer",
			Channel = "Syndicate",
			Message = "Hee-hee-hee-haw!"
		},
		{
			Name = "Big Heavy Crate Man",
			Role = "Cargo Technician",
			Channel = "Supply",
			Message = "I packagea da package!"
		},
		{
			Name = "Sr. James Jadamn",
			Role = "Central Command",
			Channel = "Central Command",
			Message = "Die! Die! Die! Die! Die! Die! Die! Die!"
		},
		{
			Name = "Gordon Freeman",
			Role = "Scientist",
			Channel = "Science",
			Message = "Beep boop!"
		},
	}

	local ec = Color( 255, 150, 150 )
	local errors = {
		[0] = "Empty message",
		[1] = "Blacklisted message",
		[2] = "Nonexistant channel",
		[3] = "Sending messages too fast",
	}
	net.Receive("AC_ClientChat", function( len, ply )
		local str = net.ReadUInt( 3 )
		chat.AddText( ec, "FAIL! " .. errors[str] )
	end)

	net.Receive("AC_BroadcastChat", function( len, ply )
		local str = net.ReadString()
		local str2 = net.ReadString()
		--chat.AddText( color_white, str )
		surface.PlaySound("buttons/blip1.wav")
		table.insert( MESSAGES, { Name = "Fesiug", Role = "Assistant", Channel = str2, Message = str } )
		OpenGrinder()

		local text = str
		local ply = LocalPlayer()
		local time = 0
		for i=0, #text do
			local letter = text[i]
			if i == 0 then
				ply:EmitSound("ac/r_on.wav", 80, 100, 0.7, CHAN_STATIC )
				time = time + 0.15
			elseif string.find( letter, "%u" ) then
				timer.Simple( time, function() 
					ply:EmitSound("ac/test-0" .. math.random( 1, 5 ) .. ".ogg", 80, 190 + math.random( -10, 10 ), 0.7, CHAN_STATIC )
				end)
				time = time + 0.06
			elseif string.find( letter, "%l" ) then
				timer.Simple( time, function() 
					ply:EmitSound("ac/test-0" .. math.random( 1, 5 ) .. ".ogg", 70, 140 + math.random( -10, 10 ), 0.5, CHAN_STATIC )
				end)
				time = time + 0.08
			elseif string.find( letter, "%p" ) then
				timer.Simple( time, function() 
					ply:EmitSound("ac/period.ogg", 70, 190, 0.1, CHAN_STATIC )
				end)
				time = time + 0.1
			elseif string.find( letter, "%s" ) then
				time = time + 0.1
			end

			if i == #text then
				time = time + 0.05
				timer.Simple( time, function() 
					ply:EmitSound("ac/r_off.wav", 80, 100, 0.7, CHAN_STATIC )
				end)
			end
		end
	end)

	function OpenGrinder()
		if IsValid(Grinder) then Grinder:Remove() end

		Grinder = vgui.Create("DFrame")
		Grinder:SetSize( s(200), 20 + s(180) )
		Grinder:SetPos( ScrW() - Grinder:GetWide() - s(4), ScrH() - Grinder:GetTall() - s(120) )
		--Grinder:MakePopup()
		--Grinder:SetIcon( "icon16/comment.png" )
		Grinder:SetTitle( "" or "Chat" )

		function Grinder:Paint()
			return true
		end

		local Scroll = Grinder:Add("DScrollPanel")
		Scroll:Dock( FILL )
		Scroll.VBar:SetWide(0)

		for i, v in ipairs( MESSAGES ) do
			local Test = Scroll:Add("DPanel")
			Test:SetTall( s(15) )
			Test:Dock(TOP)

			function Test:Paint( w, h )
				local col = CHANNELS[v.Channel].Color

				if false then
					surface.SetDrawColor( color_white )
					surface.DrawRect( 0, 0, w, h, 1 )
					local col = CHANNELS[v.Channel].Color
					local ch, cs, cv = ColorToHSV( col )
					cv = 1
					cs = cs/2
					col = HSVToColor( ch, cs, cv )
					col.a = 30
					surface.SetDrawColor( col )
					surface.DrawRect( 0, 0, w, h, 1 )
				end

				Scroll:ScrollToChild( Test )

				local ch, cs, cv = ColorToHSV( col )
				
				for i=2, 3 do
					if i==2 then i = 1 end
					local col = col
					local es = 0
					if i==1 or i==2 then
						cs = 0
						cv = 0
						col = HSVToColor( ch, cs, cv )
						col.a = 255
						es = i==1 and 1 or i==2 and -1
					end
					draw.SimpleText(
						v.Name,
						"AC_10b",
						s(1) + es,
						s(-1) + es,
						col,
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_TOP
					)
					draw.SimpleText(
						" · " .. v.Role,
						"AC_8b",
						s(1) + surface.GetTextSize(v.Name) + es,
						s(-0.5) + es,
						col,
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_TOP
					)
					draw.SimpleText(
						"[" .. v.Channel .. "]",
						"AC_8b",
						w-s(1) + es,
						s(-0.5) + es,
						col,
						TEXT_ALIGN_RIGHT,
						TEXT_ALIGN_TOP
					)
					draw.SimpleText(
						"\"" .. v.Message .. "\"",
						"AC_8",
						s(1) + es,
						s(7) + es,
						col,
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_TOP
					)
				end
			end
		end

		--[[
		local tick = 1
		timer.Create( "SuperDuper", 0.2, 30, function()
			local Test = Scroll:Add("DPanel")
			Test:SetTall( s(12) )
			Test:Dock(TOP)

			local supertick = tick

			function Test:Paint( w, h )
				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawOutlinedRect( 0, 0, w, h, 1 )

				draw.SimpleText( "#" .. supertick .. " [Common] [Assistant] Fesiug says, \"FUCK FUCK FUCK FUCK FUCK I guess if you're a fucking moron, it makes sense, no?\"", "AE_HUD_8", s(2), s(2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end

			timer.Simple( 0, function()
				Scroll:InvalidateLayout( true )
				local x, y = Scroll.pnlCanvas:GetChildPosition( Test )
				local w, h = Test:GetSize()

				y = y + h * 0.5
				y = y - Scroll:GetTall() * 0.5

				--Scroll:ScrollToChild( Test )
				Scroll.VBar:SetScroll( y )
			end)

			tick = tick + 1
		end)]]
	end

	hook.Add( "PlayerBindPress", "AC_PlayerBindPress", function( ply, bind, pressed, code )
		if qt[bind] and pressed then
			if bind == "messagemode2" then
				OpenGrinder()
			else
				OpenChatBox()
			end
			return true
		end
	end)
else
	util.AddNetworkString("AC_ClientChat")
	util.AddNetworkString("AC_BroadcastChat")
	net.Receive("AC_ClientChat", function( len, ply )
		if (ply.LastChat or 0) > CurTime() then
			ply.LastChat = CurTime() + 1
			net.Start("AC_ClientChat")
				net.WriteUInt( 3, 3 )
			net.Send(ply)
			return
		end
		ply.LastChat = CurTime() + 0.5
		local str = net.ReadString()
		local str2 = net.ReadString()

		local unacceptable = false
		if str == "" then
			unacceptable = 0
		end
		if str2 == "" or !CHANNELS[str2] then
			unacceptable = 2
		end

		if unacceptable then
			net.Start("AC_ClientChat")
				net.WriteUInt( unacceptable, 3 )
			net.Send(ply)
			return
		end
		
		-- Trim the beginning and end
		str = str:Trim()
		
		-- Grab any length whitespace and convert it into one normal space.
		str = str:gsub("%s+", " ")
		
		-- If there isn't any punctuation at the end, add it.
		if !string.find( str:Right(1), "%p" ) then
			str = str .. "."
		end
		
		-- Capitalize the first letter.
		str = str:SetChar( 1, string.upper(str[1]) )

		--str = string.format( "[Common] [Assistant] %s says, %q", ply:Nick(), str )

		net.Start("AC_BroadcastChat")
			net.WriteString(str)
			net.WriteString(str2)
		net.Broadcast()
	end)
end