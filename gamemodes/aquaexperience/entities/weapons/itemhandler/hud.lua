
local rad = 16
local MAT_CORNER = Material("ae/hud/select.png", "mips smooth")
local MAT_ACTIVE = Material("ae/hud/attack.png", "mips smooth")
local MAT_DOT = Material("ae/hud/dot.png", "mips smooth")
local tracedef = {
}

function SWEP:DrawHUD()
	local w, h = ScrW()/2, ScrH()/2
	local p = LocalPlayer()

	--surface.DrawCircle( w, h, radi, 255, 255, 255, 30 )
	local item = self:ItemR()
	if item then

		local dispersion = math.rad( 1 )
		cam.Start3D()
			local lool = ( EyePos() + ( EyeAngles():Forward()*8192 ) + ( dispersion * EyeAngles():Up()*8192 ) ) :ToScreen()
		cam.End3D()
		local calc = ( (ScrH()/2) - lool.y )

		local Stupid = math.Remap( math.max( item:GetAccuracy_Reset() - CurTime(), 0 ), 0, 0.2, 0, 1 )
		Stupid = math.Clamp( Stupid, 0, 1 )
		Stupid = Lerp( Stupid, 63, 4 )
		surface.SetDrawColor( 255, 255, 255, Stupid )
		surface.SetMaterial( MAT_ACTIVE )
		local ra = s(4)
		local di = ra*2
		local Stupid = math.max( item:GetAccuracy_Reset() - CurTime(), 0 )
		Stupid = math.ease.OutExpo( Stupid )
		Stupid = math.Clamp( Stupid, 0, 1 )
		local gap = s( 4 + Stupid*16 )--s(4)
		surface.DrawTexturedRectRotated( w - gap, h - gap, di, di, 0 )
		surface.DrawTexturedRectRotated( w + gap, h - gap, di, di, 270 )
		surface.DrawTexturedRectRotated( w - gap, h + gap, di, di, 90 )
		surface.DrawTexturedRectRotated( w + gap, h + gap, di, di, 180 )
		--surface.DrawTexturedRectRotated( w, h - gap, di, di, 0 )
		--surface.DrawTexturedRectRotated( w + gap, h, di, di, 0 )
		--surface.DrawTexturedRectRotated( w - gap, h, di, di, 0 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( MAT_DOT )
		local ra = s(2)
		local di = ra*2
		local amt = self:ItemR("GetAccuracy")
		local gap = calc*amt
		surface.DrawTexturedRect( w - ra, h - ra + gap, di, di )
		surface.DrawTexturedRect( w - ra, h - ra - gap, di, di )
		surface.DrawTexturedRect( w - ra + gap, h - ra, di, di )
		surface.DrawTexturedRect( w - ra - gap, h - ra, di, di )
	else
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( MAT_CORNER )
		
		local cunt = false
		do
			local trace = self:ItemCheckTrace()
			if trace.Entity and trace.Entity:IsValid() and trace.Entity != Entity(0) then cunt = trace.Entity end
		end

		for mew=0, 360-(90), (90) do
			local i = mew + (90/2)
			local radi = rad
			if cunt then
				i = i - (CurTime()%1) * 90
				radi = radi + (math.sin(CurTime()*math.pi/0.25) * 2)
			end

			surface.DrawTexturedRectRotated( w - s( radi * math.cos(math.rad(i)) ), h + s( radi * math.sin(math.rad(i)) ), s(8), s(8), i+45 )
		end

		if cunt then
			draw.SimpleText( "M1)", "AE_HUD_10", w + s(40), h, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "PICK UP RIGHT HAND", "AE_HUD_8", w + s(40+10), h + s(10), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( cunt.Class.PrintName, "AE_HUD_10", w + s(40+10), h + s(18), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end
end