local QBCore = exports['qb-core']:GetCoreObject()

-- Functions --

function foodStand(place)
    local menu = {
        {
            header = place,
            isMenuHeader = true
        },
        {
            header = 'Food',
            params = {
                event = 'qb-gamz-food:client:openFoodTypeMenu',
                args = {
                    place = place,
                    type = 'food'
                }
            }
        },
        {
            header = 'Drink',
            params = {
                event = 'qb-gamz-food:client:openFoodTypeMenu',
                args = {
                    place = place,
                    type = 'drink'
                }
            }
        },
        {
            header = '✖ Exit',
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end

function foodMenu(place, type)
    local menuHeader = ''
    if type == 'food' then
        menuHeader = 'Food'
    else
        menuHeader = 'Drink'
    end
    local menu = {
        {
            header = menuHeader,
            isMenuHeader = true
        }
    }
    for k, v in pairs(Config.Locations[place][type]) do
        menu[#menu + 1] = {
            header = k,
            txt = '$' .. tostring(v['price']),
            params = {
                event = 'qb-gamz-food:client:buy',
                args = {
                    name = k,
                    type = type,
                    prop = v['prop'],
                    price = v['price']
                }
            }
        }
    end
    menu[#menu + 1] = {
        header = '← Return',
        params = {
            event = 'qb-gamz-food:client:openFoodStandMenu',
            args = {
                place = place
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end

function loadModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
    return model
end

function consume(prop, type)
    local ped = PlayerPedId()
    local model = loadModel(prop)
    local prop = CreateObject(model, GetEntityCoords(ped), true, false, false)
    if type == 'food' then
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
        QBCore.Functions.Progressbar('eat_something', 'Eating...', 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            -- Animation
            animDict = 'mp_player_inteat@burger',
            anim = 'mp_player_int_eat_burger_fp',
            flags = 0,
        }, {}, {}, function()
            -- Done
            ClearPedSecondaryTask(PlayerPedId())
            DeleteObject(prop)
            local currentHunger = QBCore.Functions.GetPlayerData().metadata['hunger']
            local hungerIncrease = math.random(35, 55)
            local newHunger = currentHunger + hungerIncrease
            if newHunger > 100 then
                newHunger = 100
            end
            TriggerServerEvent('qb-gamz-food:server:addHunger', newHunger)
        end)
    else
        AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.15, 0.025, 0.010, 270.0, 175.0, 0.0, true, true, false, true, 1, true)
        QBCore.Functions.Progressbar('drink_something', 'Drinking...', 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            -- Animation
            animDict = 'mp_player_intdrink',
            anim = 'loop_bottle',
            flags = 0,
        }, {}, {}, function()
            -- Done
            ClearPedSecondaryTask(PlayerPedId())
            DeleteObject(prop)
            local currentThirst = QBCore.Functions.GetPlayerData().metadata['thirst']
            local thirstIncrease = math.random(35, 55)
            local newThirst = currentThirst + thirstIncrease
            if newThirst > 100 then
                newThirst = 100
            end
            TriggerServerEvent('qb-gamz-food:server:addThirst', newThirst)
        end)
    end
end

-- Events --

RegisterNetEvent('qb-gamz-food:client:openFoodStandMenu', function(data)
    foodStand(data.place)
end)

RegisterNetEvent('qb-gamz-food:client:openFoodTypeMenu', function(data)
    foodMenu(data.place, data.type)
end)

RegisterNetEvent('qb-gamz-food:client:buy', function(data)
    QBCore.Functions.TriggerCallback('qb-gamz-food:removeMoney', function(wasRemoved)
        if wasRemoved then
            QBCore.Functions.Notify('You bought a ' .. data.name)
            consume(data.prop, data.type)
        else
            QBCore.Functions.Notify('You do not have enough cash!')
        end
    end, data.price)
end)

-- Threads --

Citizen.CreateThread(function()
    for place, value in pairs(Config.Locations) do
        local blip = AddBlipForCoord(value['coords'].x, value['coords'].y)
        SetBlipSprite(blip, 238)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipColour(blip, 69)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(place)
        EndTextCommandSetBlipName(blip)
    end
    while true do
        local sleepTime = 500
        local coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Locations) do
            local dst = #(coords - v['coords'])
            local text = k
            if dst <= 7.5 then
                sleepTime = 5
                if not Config.UseTarget then
                    if dst <= 1.25 then
                        text = '[~r~E~w~] ' .. k
                        if IsControlJustReleased(0, 38) then
                            foodStand(k)
                        end
                    end
                end
                Marker(text, v['coords'].x, v['coords'].y, v['coords'].z - 0.98)
            end
        end
        Citizen.Wait(sleepTime)
    end
end)