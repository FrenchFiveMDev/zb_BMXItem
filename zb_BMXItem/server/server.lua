while ESX == nil and QBCore == nil do
    if Config.Framework == "esx" then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    elseif Config.Framework == "qbcore" then
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
    end
end

if Config.Framework == "esx" then
    ESX.RegisterUsableItem(Config.Item, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.Item, 1)
        TriggerClientEvent('zb_ItemSpawn:bmx', source)
    end)
elseif Config.Framework == "qbcore" then
    QBCore.Functions.CreateUseableItem(Config.Item, function(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveItem(Config.Item, 1)
        TriggerClientEvent('zb_ItemSpawn:bmx', source)
    end)
end

RegisterServerEvent('zb_ItemSpawn:giveItem')
AddEventHandler('zb_ItemSpawn:giveItem', function(itemName, amount)
    local src = source
    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(itemName, amount)
    elseif Config.Framework == "qbcore" then
        local player = QBCore.Functions.GetPlayer(src)
        player.Functions.AddItem(itemName, amount)
    end
end)
