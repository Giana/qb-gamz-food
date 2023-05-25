local QBCore = exports['qb-core']:GetCoreObject()

-- Events --

RegisterNetEvent('qb-gamz-food:server:addHunger', function(amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then
        return
    end
    player.Functions.SetMetaData('hunger', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', src, amount, player.PlayerData.metadata.thirst)
end)

RegisterNetEvent('qb-gamz-food:server:addThirst', function(amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then
        return
    end
    player.Functions.SetMetaData('thirst', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', src, player.PlayerData.metadata.hunger, amount)
end)

-- Callbacks --

QBCore.Functions.CreateCallback('qb-gamz-food:removeMoney', function(source, cb, amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if player.Functions.RemoveMoney('cash', amount) then
        cb(true)
    else
        cb(false)
    end
end)