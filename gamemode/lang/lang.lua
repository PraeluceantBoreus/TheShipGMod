LANG_MGR = {}

local lang_code = "de"

local tableDat = {lang_code}


local function setLang(ply,cmd,args)
    PrintTable(args)
    include(args[1]..".lua")
    PrintTable(LANG)
end

setLang(nil,nil,tableDat)
print("lan")
PrintTable(LANG)

LANG_MGR.setLang = setLang
concommand.Add("setLang", setLang)