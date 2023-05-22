ESX = nil
QBCore = nil

if Config.Framework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.Framework == "qbcore" then
    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
else
    print('Veuillez définir un framework valide ou contacter le développeur') 
end


local CheckSpawnByPlayer = {}
if Config.Framework == "esx" then
    ESX.RegisterUsableItem(Config.Item, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.Item, 1)
        TriggerClientEvent('zb_ItemSpawn:bmx', source)
        CheckSpawnByPlayer[source] = true
    end)
elseif Config.Framework == "qbcore" then
    QBCore.Functions.CreateUseableItem(Config.Item, function(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveItem(Config.Item, 1)
        TriggerClientEvent('zb_ItemSpawn:bmx', source)
        CheckSpawnByPlayer[source] = true
    end)
else
    print('Veuillez définir un framework valide ou contacter le développeur')
end

RegisterServerEvent('zb_ItemSpawn:giveItem')
AddEventHandler('zb_ItemSpawn:giveItem', function()
    local src = source

    if Config.TakeAll then 
        Check = true
    else
        Check = CheckSpawnByPlayer[src] or false
    end

    if Check then
        if Config.Framework == "esx" then
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.addInventoryItem(Config.Item, 1)
        elseif Config.Framework == "qbcore" then
            local player = QBCore.Functions.GetPlayer(src)
            player.Functions.AddItem(Config.Item, 1)
        else
            print('Veuillez définir un framework valide ou contacter le développeur')
        end
    end
end)
