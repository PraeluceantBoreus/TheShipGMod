local function msg(msg, data)
    local prepared = LANG[msg]
    for nr,item in pairs(data) do
        prepared = string.Replace(prepared, "{"..nr.."}", item)
    end
    notification.AddLegacy(prepared,NOTIFY_HINT,10)
end

net.Receive("Message", function()
    msg(net.ReadString(), net.ReadTable())
end)