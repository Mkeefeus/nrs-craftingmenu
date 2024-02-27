local function updateCraftingLocation(name, data)
    Config.CraftingLocations[name] = data
    TriggerClientEvent("nr-craftingmenu:client:updateCraftingLocations", -1, name, data)
end

exports('updateCraftingLocation', updateCraftingLocation)

local function CanCraft(src, item, amount)
    local materials = item.requiredItems
    if not materials then return false end
    for _, itemData in ipairs(materials) do
        local inv = Framework.GetValidInv(src)
        if not inv or not next(inv) then return false end
        if not inv[itemData.name] or (inv[itemData.name]) < (itemData.amount * amount) then
            Framework.Notify(src, "You do not have enough " .. itemData.label, "error")
            return false
        end
    end
    return true
end

local function GetItem(src, name, amount, itemData)
    if not Framework.AddItem(src, name, amount) then
        Framework.Notify(src, "You don't have enough space in your inventory", "error")
        TriggerClientEvent('nr-craftingmenu:client:cancelEmote', src)
        if Config.Debug or Config.Logs?.onCraftFail and Framework.Log then
            Framework.Log('Crafting', 'failAddItem', src, { item = name, amount = amount })
        end
        return
    end

    if Config.Debug or Config.Logs?.onCraft and Framework.Log then
        Framework.Log('Crafting', 'craft', src, { item = name, amount = amount })
    end

    for _, item in ipairs(itemData.requiredItems) do
        local amountToRemove = (item.amount * amount) / (itemData.craftedAmount or 1)
        if not Framework.RemoveItem(src, item.name, amountToRemove) then
            -- multiple stacks of the same item
            for _ = 0, amountToRemove do
                if not Framework.RemoveItem(src, item.name, 1) then
                    TriggerClientEvent('nr-craftingmenu:client:cancelEmote', src)
                    if Config.Debug or Config.Logs?.onCraftFail and Framework.Log then
                        Framework.Log('Crafting', 'failRemoveItem', src, { item = item.name, amount = amountToRemove })
                        return
                    end
                end
            end
        end
    end
end

RegisterNetEvent('nr-craftingmenu:server:craftItems', function(items, location)
    local src = source
    local xPlayer = Framework.GetPlayer(src)
    if not xPlayer then return end
    local locationData = Config.CraftingLocations[location]
    if not locationData then
        if Config.Debug or Config.Logs?.onExploit and Framework.Log then
            Framework.Log('Exploit', 'invalidLocation', src, { location = location })
        end
        return false
    end
    if #(GetEntityCoords(GetPlayerPed(src)) - locationData.coords) > 5.0 then
        if Config.Debug or Config.Logs?.onExploit and Framework.Log then
            Framework.Log('Exploit', 'tooFar', src, { location = location })
        end
        return false
    end
    for _, item in ipairs(items) do
        local crafted = 0
        local itemName = item.name
        local index = 0
        for i, _item in ipairs(locationData.items) do
            if _item.name == itemName then
                index = i
                break
            end
        end
        local itemData = locationData.items[index]
        if not CanCraft(src, itemData, item.amount) then
            if Config.Debug or Config.Logs?.onCraftFail and Framework.Log then
                Framework.Log('Info', 'missingMats', src, { item = itemName, location = location })
            end
            return
        end
        for _ = 1, item.amount do
            if not lib.callback.await('nr-craftingmenu:client:progressbar', src, {
                    label = itemData.label,
                    time = itemData.time or 5000
                }, location) then
                TriggerClientEvent('nr-craftingmenu:client:cancelEmote', src)
                if Config.Debug or Config.Logs?.onCraftCancel and Framework.Log then
                    Framework.Log('Info', 'canceled', src, { item = itemName, location = location })
                end
                if crafted > 0 then
                    GetItem(src, itemName, crafted, itemData)
                end
                return
            end
            crafted = crafted + (itemData.craftedAmount or 1)
        end
        GetItem(src, itemName, crafted, itemData)
    end
    TriggerClientEvent('nr-craftingmenu:client:cancelEmote', src)
end)

RegisterNetEvent('nr-craftingmenu:server:log', function (event, data)
    if not Config.Logs or not Framework.Log then return end
    local src = source
    if event == 'open' then
        Framework.Log('Info', 'open', src, data)
    elseif event == 'close' then
        Framework.Log('Info', 'close', src, data)
    else
        Framework.Log('Exploit', 'unknown', src, data)
    end
end)

lib.callback.register('nr-craftingmenu:server:getPlayerInventory', function()
    local src = source
    return Framework.GetValidInv(src)
end)

CreateThread(function()
    if not Framework then
        error("\n^1Framework not found^0")
    end
end)
