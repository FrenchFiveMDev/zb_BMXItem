ESX = nil
QBCore = nil

Citizen.CreateThread(function()
    while ESX == nil and QBCore == nil do
        Citizen.Wait(100)
        if Config.Framework == "esx" then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        elseif Config.Framework == "qbcore" then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        end
    end
end)

-- Événement pour faire apparaître l'item en tant que véhicule
RegisterNetEvent('zb_ItemSpawn:bmx')
AddEventHandler('zb_ItemSpawn:bmx', function()
    local playerPed = PlayerPedId()
    local coords, heading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)
    local forwardOffset = 2.0
    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, forwardOffset, 0.0)
    local model = GetHashKey(Config.Item)

    if Config.Framework == "esx" then
        ESX.Streaming.RequestModel(model, function()
            ESX.Game.SpawnVehicle(model, spawnCoords, heading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
        end)
    elseif Config.Framework == "qbcore" then
        QBCore.Functions.Progressbar("spawn_Item", "Spawn " ..model.."...", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            QBCore.Functions.SpawnVehicle(model, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end, {
                x = spawnCoords.x,
                y = spawnCoords.y,
                z = spawnCoords.z,
                heading = heading,
                isNetworked = true,
                isLocked = true,
                engineHealth = 1000,
                bodyHealth = 1000,
            })
        end)
    end
end)

local pickupKey = 38 -- Touche E
local isInItem = false
local ItemModel = GetHashKey(Config.Item)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and GetEntityModel(vehicle) == ItemModel then
            isInItem = true

            if IsControlJustReleased(0, pickupKey) then
                local netID = NetworkGetNetworkIdFromEntity(vehicle)
                if Config.Framework == "esx" then
                    ESX.TriggerServerCallback('zb_ItemSpawn:pickupItem', function() end, netID)
                elseif Config.Framework == "qbcore" then
                    QBCore.Functions.TriggerCallback('zb_ItemSpawn:pickupItem', function() end, netID)
                end
                DeleteVehicle(vehicle)
                if Config.Framework == "esx" then
                    local itemName = Config.Item
                    local amount = 1
                    TriggerServerEvent('zb_ItemSpawn:giveItem', itemName, amount)
                    ESX.ShowNotification("Vous avez récupéré le "..Config.Item..".")
                elseif Config.Framework == "qbcore" then
                    local itemName = Config.Item
                    local amount = 1
                    TriggerServerEvent('zb_ItemSpawn:giveItem', itemName, amount)
                    QBCore.Functions.Notify("Vous avez récupéré le "..Config.Item..".")
                end
            else
                if Config.Framework == "esx" then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer le "..Config.Item..".")
                elseif Config.Framework == "qbcore" then
                    QBCore.Functions.Notify("Appuyez sur ~INPUT_CONTEXT~ pour récupérer le "..Config.Item..".")
                end
            end
        else
            isInItem = false
        end
    end
end)
print("Made by ZeBee#0433")