
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

function s( scale )
	return scale * 3
end

local sizes = {
	8
}

for index, scale in ipairs( sizes ) do
	surface.CreateFont("AE_HUD_" .. scale, {
		font = "Arial",
		size = s(scale),
		weight = 0,
		extended = false,
		italic = true,
	})
end

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

local superblack = Color( 0, 0, 0, 100 )

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

local function SRectOLD( w, h )
	x, y = hXY()

	surface.DrawRect( x, y, w, h )
end

local function hRect( x, y, w, h )
	gx, gy = hXY()
	x = (x or 0) + gx
	y = (y or 0) + gy

	surface.DrawRect( x, y, w, h )
end


function GM:HUDPaint()
	local p = LocalPlayer()
	local B1, B2 = s(4), s(8)
	local sw, sh = ScrW(), ScrH()

	stack = util.Stack()
	for i=1, 2 do
		Shad = i==1
		if Shad then
			S_Push( s(1), s(1) )
		end
		S_Push( B2, sh - B2 ) -- Push Corner
		
			local H_W, H_H = s(72), s(8)
			S_Push( 0, -H_H ) -- Push Health
				--hCol( 200, 200, 200, 150 )
				--hRect( H_W, H_H )

				hCol( 255, 255, 255 )
				hRect( 0, H_H-s(1), H_W, s(1) )

				hCol( 255, 255, 255 )
				hRect( 0, 0, H_W, H_H-s(2) )

				local x, y = hXY( 0, -s(8) )
				draw.SimpleText( "HEALTH", "AE_HUD_8", x, y, hCoo(color_white) )

				local F_W, F_H = s(48), s(6)
				S_Push( 0, -F_H - s(12) ) -- Push Food
				
					hCol( 255, 255, 255 )
					hRect( 0, F_H-s(1), F_W, s(1) )

					hCol( 255, 255, 255 )
					hRect( 0, 0, F_W, F_H-s(2) )

					local x, y = hXY( 0, -s(8) )
					draw.SimpleText( "FOOD", "AE_HUD_8", x, y, hCoo(color_white) )
					
				S_Pop() -- Pop Food

			S_Pop() -- Pop Health
		
		S_Pop() -- Pop Corner
		if Shad then
			S_Pop()
		end
	end

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