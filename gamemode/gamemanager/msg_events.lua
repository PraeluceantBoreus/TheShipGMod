function GM:PlayerDeath(ply, weapon, killer)
    --PrintTable(ply)
    print(killer:SteamID64())
    local st_v = ply:SteamID64()
    local st_k = killer:SteamID64()
    local msg = "DEATH_UNFOUNDED"
    if st_k == nil then msg = "DEATH_SUICIDE" end
    print("Victim: "..st_v)
    print("Hunter: "..st_k)
    --hunter success
    if Killmode.isHunter(st_k, st_v) then 
        msg = "DEATH_VICTIM"
        Killmode.roundState(ply, R_STATE.KILLED)
        Killmode.roundState(killer, R_STATE.FINISHED)
    end
    if Killmode.isHunter(st_v, st_k) then 
        msg = "DEATH_HUNTER"
    end
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