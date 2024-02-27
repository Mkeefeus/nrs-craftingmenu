Config = {}

Config.Debug = true -- Shows Zone debug and other debug related items

Config.ImagePath = 'qb-inventory/html/images/'

Config.DefaultEmote = 'mechanic'

Config.Styles = {}

Config.CraftingLocations = {
    ['example'] = {
        labels = {
            header = "Crafting Bench",
            costs = "Required Materials",
            crafting = "Items Made",
            submit = "Craft",
        },
        coords = vector3(-33.38, -1114.97, 26.0),
        emote = 'mechanic',
        -- OR
        -- scenario = 'WORLD_HUMAN_WELDING',
        -- OR
        -- animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        -- anim = "machinic_loop_mechandplayer",
        -- animFlag = 16,
        -- job = 'mechanic', -- Can also use table like { ['mechanic'] = 0}
        -- gang = 'vagos', -- Can also use table like { ['vagos'] = 0}
        items = {
            {
                name = 'armor',
                label = 'Armor',
                image = 'armor.png',
                craftedAmount = 2,
                requiredItems = {
                    {
                        name = 'plastic',
                        label = 'Plastic',
                        image = 'plastic.png',
                        amount = 3
                    },
                    {
                        name = 'rubber',
                        label = 'Rubber',
                        image = 'rubber.png',
                        amount = 2
                    },
                    {
                        name = 'steel',
                        label = 'Steel',
                        image = 'steel.png',
                        amount = 1
                    }
                },
            }
        }
    }
}

Config.Logs = {
    onOpen = false,
    onCraft = false,
    onCraftFail = false,
    onCraftCancel = false,
    onClose = false,
    onExploits = true
}