if GetResourceState('es_extended') ~= 'started' then return end
---@diagnostic disable: duplicate-set-field
local ESX = exports['es_extended']:getSharedObject()
Framework = {
    target = {}
}

-- function Framework.PlayEmote(emote)
    -- If your server has an emote system, replace this with your own code
    -- emote is a string of either the specified emote for this location, or the default emote
-- end

-- function Framework.CancelEmote()
    -- If your server has an emote system, replace this with your own code
-- end

RegisterNetEvent('esx:playerLoaded', function()
    CreateCraftingZones()
end)

CreateThread(function ()
    if not ESX.GetPlayerData()?.identifier then return end
    CreateCraftingZones()
end)

if GetResourceState('ox_target') == 'started' then
    Framework.target.sphere = function(data)
        for _, optionData in ipairs(data.options) do
            if optionData.job or optionData.gang then
                local groups = {}
                if type(optionData.job) == 'string' then
                    groups[#groups + 1] = optionData.job
                elseif type(optionData.job) == 'table' then
                    for job, grade in pairs(optionData.job) do
                        groups[job] = grade
                    end
                end
                if type(optionData.gang) == 'string' then
                    groups[#groups + 1] = optionData.gang
                elseif type(optionData.gang) == 'table' then
                    for gang, rank in pairs(optionData.gang) do
                        groups[gang] = rank
                    end
                end
                optionData.groups = groups
                optionData.job = nil
                optionData.gang = nil
            end
        end
        return exports['ox_target']:addSphereZone(data)
    end

    Framework.target.remove = function(zoneId)
        return exports['ox_target']:removeZone(zoneId)
    end
end
