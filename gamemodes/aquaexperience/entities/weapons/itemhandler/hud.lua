
local rad = 16
local MAT_CORNER = Material("ae/hud/select.png", "smooth")
local tracedef = {
}

function SWEP:DrawHUD()
	local w, h = ScrW()/2, ScrH()/2
	local p = LocalPlayer()

	--surface.DrawCircle( w, h, radi, 255, 255, 255, 30 )
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
		draw.SimpleText( cunt:ItemClass().PrintName, "AE_HUD_10", w + s(40+10), h + s(18), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
end