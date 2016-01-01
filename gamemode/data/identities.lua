NAMES = {
"Richard Stoeckl",
"Dennis Toth",
"Luca Sanda",
"Stephan Schloegl",
"Guido Schreier",
"Markus Reichl",
"Manuel Zatschkowitsch",
}

TEMP_NAMES = {}

local function fillTemp()
    for nr, str in pairs(NAMES) do
        table.insert(TEMP_NAMES, str)
    end
    TEMP_NAMES = Arrays.shuffle(TEMP_NAMES)
end

fillTemp()
