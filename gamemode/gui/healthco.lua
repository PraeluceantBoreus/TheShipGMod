function drawHealth()
    draw.RoundedBox(0,0,0,128,128, Color(0,0,0,128))
end

hook.Add("HUDPaint","HUDPaint_Health", drawHealth)
concommand.Add("drawh", drawHealth)