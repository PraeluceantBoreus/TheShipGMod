ProgBar = {}

local def_width = 300
local def_height = 40
local def_round = 15
local def_color = Color(127,127,127,255)

local function backColor(color)
    return Color(color["r"]/2,color["g"]/2,color["b"]/2,255)
end

local function drawBar(maxVal, currVal, posx, posy, width, height, round, color, text)
    if width < 0 then width = def_width end
    if height < 0 then height = def_height end
    if round < 0 then round = def_round end
    if color == nil then color = def_color end
    
    local darkColor = backColor(color)
    local curr_width = ((currVal/maxVal)*width)
    
    draw.RoundedBox(round, posx, posy, width, height, darkColor)
    if curr_width > 0 then
        draw.RoundedBox(round, posx, posy, curr_width, height, color)
    end
    
    if text ~= nil then
        local text_table = {
            text = text,
            font = "ProgBar",
            pos = {posx+width/2,posy+height/2},
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
        }
--         draw.SimpleText(text,"ProgBar",posx+width/2,posy+height/2,Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.TextShadow(text_table, 2, 255)
        draw.Text(text_table)
    end
end

ProgBar.drawBar = drawBar