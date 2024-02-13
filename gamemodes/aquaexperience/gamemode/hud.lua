
local hide = {
	["CHudHealth"]			= true,
	["CHudBattery"]			= true,
	["CHudAmmo"]			= true,
	["CHudSecondaryAmmo"]	= true,
	["CHudDamageIndicator"]	= true,
	--["CHudCloseCaption"]	= true,
	["CHudCrosshair"]		= true,
	["CHudSuitPower"]		= true,
	["CHUDQuickInfo"]		= true,
	["CHudZoom"]			= true,
}

function GM:HUDShouldDraw( name )
	if hide[ name ] then
		return false
	else
		return true
	end
end

CONV_HUDSCALE = CreateClientConVar("ae_hud_scale", 2, true, false )


function s( scale )
	return math.ceil( scale * CONV_HUDSCALE:GetFloat() )
end

local sizes = {
	8, 10, 12, 16, 20
}

local function regenfonts()
	for index, scale in ipairs( sizes ) do
		surface.CreateFont("AE_HUD_" .. scale, {
			font = "Arial Bold",
			size = s(scale),
			weight = 0,
			extended = false,
			italic = false,
			antialias = true,
		})
	end
end
regenfonts()
cvars.AddChangeCallback("ae_hud_scale", function(convar_name, value_old, value_new)
	regenfonts()
end)

local function xy( x, y )
	return {x, y}
end

local function hXY( x, y )
	local rx, ry = 0, 0
	for key, value in ipairs(stack) do
		rx = rx + value[1]
		ry = ry + value[2]
	end
	if x then rx = rx + x end
	if y then ry = ry + y end
	return rx, ry
end

local function S_Push( x, y )
	stack:Push( xy( x, y ) )
end

local function S_Pop( x, y )
	stack:Pop()
end

superblack = Color( 0, 0, 0, 200 )

local function hCol( r, g, b, a )
	if Shad then
		return surface.SetDrawColor( superblack.r, superblack.g, superblack.b, superblack.a )
	else
		return surface.SetDrawColor( r, g, b, a )
	end
end

local function hCoo( col )
	if Shad then
		return superblack
	else
		return col
	end
end

local function hRect( x, y, w, h )
	gx, gy = hXY()
	x = (x or 0) + gx
	y = (y or 0) + gy

	surface.DrawRect( x, y, w, h )
end

local function hORect( x, y, w, h, r )
	gx, gy = hXY()
	x = (x or 0) + gx
	y = (y or 0) + gy

	surface.DrawOutlinedRect( x, y, w, h, r )
end


function GM:HUDPaint()
	local p = LocalPlayer()
	local B1, B2 = s(4), s(8)
	local sw, sh = ScrW(), ScrH()
	local wep = p:HandlerCheck()

	stack = util.Stack()
	if false then--for i=1, 2 do
		Shad = i==1
		if Shad then
			S_Push( s(1), s(1) )
		end
		S_Push( B2, sh - B2 ) -- Push Corner
		
			local H_W, H_H = s(128), s(12)
			S_Push( 0, -H_H ) -- Push Health
				--hCol( 200, 200, 200, 150 )
				--hRect( H_W, H_H )

				hCol( 255, 255, 255 )
				hRect( 0, H_H-s(1), H_W, s(1) )

				hCol( 255, 255, 255 )
				hRect( 0, 0, H_W, H_H-s(2) )

				local x, y = hXY( 0, -s(16) )
				draw.SimpleText( "HEALTH", "AE_HUD_16", x, y, hCoo(color_white) )

				local F_W, F_H = s(72), s(8)
				S_Push( 0, -F_H - s(20) ) -- Push Food
				
					hCol( 255, 255, 255 )
					hRect( 0, F_H-s(1), F_W, s(1) )

					hCol( 255, 255, 255 )
					hRect( 0, 0, F_W, F_H-s(2) )

					local x, y = hXY( 0, -s(12) )
					draw.SimpleText( "FOOD", "AE_HUD_12", x, y, hCoo(color_white) )

				S_Push( 0, -F_H - s(14) ) -- Push Water
				
					hCol( 255, 255, 255 )
					hRect( 0, F_H-s(1), F_W, s(1) )

					hCol( 255, 255, 255 )
					hRect( 0, 0, F_W, F_H-s(2) )

					local x, y = hXY( 0, -s(12) )
					draw.SimpleText( "WATER", "AE_HUD_12", x, y, hCoo(color_white) )
					
				S_Pop() -- Pop Water
				S_Pop() -- Pop Food

			S_Pop() -- Pop Health
		
		S_Pop() -- Pop Corner
		if Shad then
			S_Pop()
		end
	end

	for i=1, 2 do
		Shad = i==1
		if Shad then
			S_Push( s(1), s(1) )
		end
		S_Push( sw - B2, sh - B2 ) -- Push Corner
			local H_W, H_H = s(128), s(18)

			--for rr=1, 2 do
			--	local left = (rr == 1)
			--	if left then
			--		S_Push( -H_W - s(4), 0 )
			--	end
			if wep and p:GetActiveWeapon():ItemR() then
				local active = wep:ItemR()
				S_Push( -H_W, -H_H ) -- Push Ammo
					--hCol( 200, 200, 200, 150 )
					--hRect( 0, 0, H_W, H_H )
					
					hCol( 255, 255, 255 )
					hRect( 0, H_H-s(1), H_W, s(1) )

					hCol( 255, 255, 255 )
					hORect( 0, 0, H_W, H_H-s(2), s(1) )
					
					--local x, y = hXY( 0, -s(16) )
					--draw.SimpleText( left and "LEFT" or "RIGHT", "AE_HUD_16", x, y, hCoo(color_white) )
					
					local x, y = hXY( s(4), s(3) )
					draw.SimpleText( active.Class.PrintName, "AE_HUD_12", x, y, hCoo(color_white) )
					local x, y = hXY( H_W - s(4), s(3) )

					local fmname = "SEMI"
					local fm = active.Class.BurstCount
					if fm == math.huge then
						fmname = "AUTO"
					elseif fm > 1 then
						fmname = fm.."RND"
					end
					draw.SimpleText( fmname, "AE_HUD_10", x, y, hCoo(color_white), TEXT_ALIGN_RIGHT )

					S_Push( H_W, s(-2) )
						for i=1, active.Class.ClipSize do
							if i <= active:GetClip() then
								hCol( 255, 255, 255 )
							else
								hCol( 0, 0, 0, 127 )
								--hORect( s(-4 - ((i-1) * 3)), -s(8), s(2), s(8) )
							end
							hRect( s(-4 - ((i-1) * 3)), -s(8), s(2), s(8) )
						end
					S_Pop()
				S_Pop() -- Pop Ammo
			end
			--	if left then
			--		S_Pop()
			--	end
			--end

		S_Pop() -- Pop Corner
		if Shad then
			S_Pop()
		end
	end

	S_Push( B2, sh - B2 ) -- Push Top Right Corner
	local H_W, H_H = s(48), s(24)
		S_Push( 0, -H_H )

			local inv = p:GetInventory():GetWeighted()
			for i=1, 2 do
				Shad = i==1
				if Shad then S_Push( s(1), s(1) ) end
				for _, ent in ipairs( inv ) do
					if ent == 0 then continue end
					if !ent:IsValid() then continue end
					local active = wep:ItemR()
					active = active == ent
						hCol( 255, 255, 255 )
						if active then
							hRect( 0, 0, H_W, H_H, s(1) )
						else
							hORect( 0, 0, H_W, H_H, s(1) )
						end

						local x, y = hXY( H_W/2, H_H/2 )
						draw.SimpleText( ent.Class.PrintName, "AE_HUD_10", x, y, hCoo(active and color_black or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						local x, y = hXY( s(3), s(2) )
						draw.SimpleText( _, "AE_HUD_10", x, y, hCoo(active and color_black or color_white) )
					S_Push( H_W + s(4), 0 ) -- Push Icon
				end
				for _, ent in ipairs( inv ) do
					if ent == 0 then continue end
					if !ent:IsValid() then continue end
					S_Pop()
				end
				if Shad then S_Pop() end
			end

		S_Pop()
	S_Pop()

	if stack:Size() != 0 then print("Stack unfinished.") end
	return
end

--[[



	local H_H = s(10)
	S_Push( 0, -H_H ) -- Push for bar

	surface.SetDrawColor( 255, 255, 255 )
	S_Push( 0, s(10) )
	hRect( s(96*(p:Health()/p:GetMaxHealth())), s(1) )
	S_Pop()
	hRect( s(96*(p:Health()/p:GetMaxHealth())), s(8) )

	S_Push( 0, -s(8) )
	local x, y = hXY()
	draw.SimpleText( "HEALTH", "AE_HUD_8", x, y, color_white )
	S_Pop()

]]