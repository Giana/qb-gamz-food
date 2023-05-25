if Config.UseTarget then
    for k, v in pairs(Config.Locations) do
        exports['qb-target']:AddBoxZone(k, v['coords'], 2.5, 2.5, {
            name = k,
            heading = 0,
            debugPoly = false,
            minZ = v['coords'].z - 1,
            maxZ = v['coords'].z + 1,
        }, {
            options = {
                {
                    type = 'client',
                    action = function()
                        foodStand(k)
                    end,
                    icon = 'fas fa-hotdog',
                    label = k,
                },
            },
            distance = 2
        })
    end
end