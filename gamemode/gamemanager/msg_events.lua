function GM:PlayerDeath(ply, weapon, killer)
    local st_v = ply:GetName()
    local st_k = killer:GetName()
    local msg = "DEATH_UNFOUNDED"
	local v_name = Killmode.name(ply)
    local k_name = Killmode.name(killer)
    if st_k == nil or st_v == st_k then msg = "DEATH_SUICIDE" else
    --killed hunter
    if Killmode.isHunter(st_v, st_k) then 
        msg = "DEATH_HUNTER"
    end
    --hunter success
    if Killmode.isHunter(st_k, st_v) then 
        msg = "DEATH_VICTIM"
        Killmode.roundState(ply, R_STATE.KILLED)
        Killmode.roundState(killer, R_STATE.FINISHED)
        Killmode.TS_Hunter_Victim[st_k] = nil
		Killmode.TS_Hunter_Victim[st_v] = nil
		Killmode.newIdentity(ply)
    end
    end
    
    local data = {}
    data["1"] = v_name
    data["2"] = k_name
    net.Start("Message")
        net.WriteString(msg)
        net.WriteTable(data)
    net.Broadcast()
end