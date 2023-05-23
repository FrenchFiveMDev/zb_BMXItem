ESX = nil
QBCore = nil

Citizen.CreateThread(function()
    while ESX == nil and QBCore == nil do
        Citizen.Wait(100)
        if Config.Framework == "esx" then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        elseif Config.Framework == "qbcore" then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        else
            print('Veuillez définir un framework valide ou contacter le développeur')
        end
    end
end)

local CheckIfSpawn = {}
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
                CheckIfSpawn[PlayerPedId()] = true
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
                CheckIfSpawn[PlayerPedId()] = true
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
    else
        print('Veuillez définir un framework valide ou contacter le développeur')
    end
end)

local isInItem = false
local ItemName = Config.Item or "bmx"
local Check = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerSpeed = GetEntitySpeed(playerPed) 
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if Config.TakeAll then
            Check = true
        else
            Check = CheckIfSpawn[PlayerPedId()] or false
        end

        if vehicle ~= 0 and GetEntityModel(vehicle) == GetHashKey(ItemName) and Check then
            isInItem = true

            if playerSpeed == 0 then
                if IsControlJustReleased(0, Config.pickupKey or 38) then
                    DeleteVehicle(vehicle)
                    if Config.Framework == "esx" then
                        TriggerServerEvent('zb_ItemSpawn:giveItem')
                        if Config.notificationLibrary == "okok" then
                            -- utiliser la notification de la bibliothèque okok
                            exports['okokNotify']:Alert("Vehicle Item", "Vous avez récupéré le "..tostring(ItemName)..".", 5000, 'success')
                        elseif Config.notificationLibrary == "vNotif" then
                            -- utiliser la notification de la bibliothèque vNotif
                            exports['VCore-Noti']:Noti("info", "Vehicle Item", "Vous avez récupéré le "..tostring(ItemName)..".", 5000, "right")
                        elseif Config.notificationLibrary == "esxnotifi" then
                            -- utiliser la notification de la bibliothèque esxnotif
                            ESX.ShowNotification("Vous avez récupéré le "..tostring(ItemName)..".")
                        end
                        -- ESX.ShowNotification("Vous avez récupéré le "..tostring(ItemName)..".")
                        CheckIfSpawn[PlayerPedId()] = nil
                    elseif Config.Framework == "qbcore" then
                        TriggerServerEvent('zb_ItemSpawn:giveItem')
                        if Config.notificationLibrary == "okok" then
                            -- utiliser la notification de la bibliothèque okok
                            exports['okokNotify']:Alert("Vehicle Item", "Vous avez récupéré le "..tostring(ItemName)..".", 5000, 'success')
                        elseif Config.notificationLibrary == "vNotif" then
                            -- utiliser la notification de la bibliothèque vNotif
                            exports['VCore-Noti']:Noti("info", "Vehicle Item", "Vous avez récupéré le "..tostring(ItemName)..".", 5000, "right")
                        elseif Config.notificationLibrary == "qbnotify" then
                            -- utiliser la notification de la bibliothèque esxnotif
                            QBCore.Functions.Notify("Vous avez récupéré le "..tostring(ItemName)..".")
                        end
                        -- QBCore.Functions.Notify("Vous avez récupéré le "..tostring(ItemName)..".")
                        CheckIfSpawn[PlayerPedId()] = nil
                    else
                        print('Veuillez définir un framework valide ou contacter le développeur')
                    end
                else
                    if Config.Framework == "esx" then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer le "..tostring(ItemName)..".")
                    elseif Config.Framework == "qbcore" then
                        QBCore.Functions.Notify("Appuyez sur ~INPUT_CONTEXT~ pour récupérer le "..tostring(ItemName)..".")
                    else
                        print('Veuillez définir un framework valide ou contacter le développeur')
                    end
                end
            end
        else
            isInItem = false
        end
    end
end)
print("Made by ZeBee#0433")