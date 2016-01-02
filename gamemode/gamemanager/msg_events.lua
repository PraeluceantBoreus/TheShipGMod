function GM:PlayerDeath(ply, weapon, killer)
    local st_v = ply:SteamID64()
    local st_k = killer:SteamID64()
    local msg = "DEATH_UNFOUNDED"
    if st_v == st_k then msg = "DEATH_SUICIDE" end
    if Killmode.isHunter(st_h, st_v) then msg = "DEATH_VICTIM" end
    if Killmode.isHunter(st_h, st_v) then msg = "DEATH_HUNTER" end
    local v_name = Killmode.name(ply)
    local k_name = Killmode.name(killer)
    local data = {}
    data["1"] = v_name
    data["2"] = k_name
    net.Start("Message")
        net.WriteString(msg)
        net.WriteTable(data)
    net.Broadcast()
end