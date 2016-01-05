Money = {} 

local TS_CASH = {}
local TS_BANK = {}

local function getCash(ply)
    return TS_CASH[ply:GetName()]
end

local function getBank(ply)
    return TS_BANK[ply:GetName()]
end

local function setCash(ply, amount)
    TS_CASH[ply:GetName()] = amount
end

local function setBank(ply, amount)
    TS_BANK[ply:GetName()] = amount
end

local function addCash(ply, amount)
    TS_CASH[ply:GetName()] = getCash(ply) + amount
end

local function addBank(ply, amount)
    TS_BANK[ply:GetName()] = getBank(ply) + amount
end

local function transferBC(ply, amount)
    if amount < 0 and getCash(ply) < (amount * -1) then return false end
    if amount > 0 and getBank(ply) < amount then return false end
    addBank(ply, amount*-1)
    addCash(amount)
    return true
end

Money.TS_CASH = TS_CASH
Money.TS_BANK = TS_BANK
Money.getCash = getCash
Money.getBank = getBank
Money.setCash = setCash
Money.setBank = setBank
Money.addCash = addCash
Money.addBank = addBank
Money.transferBC = transferBC