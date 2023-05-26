Config = {}

Config.UseTarget = false        -- true == use qb-target on location, false == press E on location

Config.Locations = {
    ['Chihuahua Hotdogs'] = {
        ['coords'] = vector3(43.775257110596, -997.98028564453, 29.336441040039),
        ['drink'] = {
            ['Coca Cola'] = {
                ['price'] = 5,
                ['prop'] = 'prop_ecola_can'
            },
            ['Sparkling Water'] = {
                ['price'] = 5,
                ['prop'] = 'prop_ld_flow_bottle'
            }
        },
        ['food'] = {
            ['Burger'] = {
                ['price'] = 5,
                ['prop'] = 'prop_cs_burger_01'
            },
            ['Hotdog'] = {
                ['price'] = 5,
                ['prop'] = 'prop_cs_hotdog_01'
            }
        }
    },
}