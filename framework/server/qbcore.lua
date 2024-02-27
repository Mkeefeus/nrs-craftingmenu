if GetResourceState('qb-core') ~= 'started' then return end
---@diagnostic disable: duplicate-set-field
local QBCore = exports['qb-core']:GetCoreObject()
local oxInventory = GetResourceState('ox_inventory') == 'started' and exports.ox_inventory or nil

Framework = {}

function Framework.Notify(src, msg, type, duration)
    TriggerClientEvent('QBCore:Notify', src, msg, type, duration)
end

function Framework.GetPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

-- Inventory functions

function Framework.GetValidInv(src)
    if oxInventory then
        local inventory = {}
        for _, item in pairs(exports.ox_inventory:GetInventoryItems(src)) do
            inventory[item.name] = (inventory[item.name] or 0) + item.count
        end
        return inventory
    else
        local xPlayer = Framework.GetPlayer(src)
        if not xPlayer then return end
        local inventory = {}
        for _, item in pairs(xPlayer.PlayerData.items) do
            inventory[item.name] = (inventory[item.name] or 0) + item.amount
        end
        return inventory
    end
end

function Framework.AddItem(src, name, amount)
    if oxInventory then
        return oxInventory:AddItem(src, name, amount)
    else
        local xPlayer = Framework.GetPlayer(src)
        return xPlayer.Functions.AddItem(name, amount)
    end
end

function Framework.RemoveItem(src, name, amount)
    if oxInventory then
        return oxInventory:RemoveItem(src, name, amount)
    else
        local xPlayer = Framework.GetPlayer(src)
        return xPlayer.Functions.RemoveItem(name, amount)
    end
end

function Framework.Log(type, event, src, data)
    local msg = ''
    if event == 'open' then
        msg = ('[%s] Player %s opened crafting menu %s.'):format(type, src, data.location)
    elseif event == 'close' then
        msg = ('[%s] Player %s closed crafting menu %s.'):format(type, src, data.location)
    elseif event == 'failAddItem' then
        msg = ('[%s] Player %s failed to add item %s x %s.'):format(type, src, data.item, data.amount)
    elseif event == 'failRemoveItem' then
        msg = ('[%s] Player %s failed to remove item %s x %s.'):format(type, src, data.item, data.amount)
    elseif event == 'invalidLocation' then
        msg = ('[%s] Player %s tried to open invalid crafting location %s.'):format(type, src, data.location)
    elseif event == 'tooFar' then
        msg = ('[%s] Player %s tried to open crafting menu %s but was too far away.'):format(type, src, data.location)
    elseif event == 'missingMats' then
        msg = ('[%s] Player %s tried to craft %s but was missing materials.'):format(type, src, data.item)
    elseif event == 'canceled' then
        msg = ('[%s] Player %s canceled crafting %s.'):format(type, src, data.item)
    elseif event == 'craft' then
        msg = ('[%s] Player %s crafted %s.'):format(type, src, data.item)
    elseif event == 'unknown' then
        msg = ('[%s] Player %s attempted to inject data to the log event.'):format(type, src, data.event)
    end
    if msg == '' then return end
    if type == 'Exploit' then
        -- Make text red
        msg = '^1' .. msg .. '^0'
    end
    print(msg)
end
