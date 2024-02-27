if GetResourceState('qb-core') ~= 'started' then return end
---@diagnostic disable: duplicate-set-field
Framework = {
    target = {}
}

function Framework.PlayEmote(emote)
    TriggerEvent('animations:client:EmoteCommandStart', { emote })
end

function Framework.CancelEmote()
    TriggerEvent('animations:client:EmoteCommandStart', { 'c' })
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
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
elseif GetResourceState('qb-target') == 'started' then
    Framework.target.sphere = function(data)
        local options = {}
        for _, optionData in ipairs(data.options) do
            options[#options + 1] = {
                icon = optionData.icon,
                label = optionData.label,
                action = optionData.onSelect,
                canInteract = optionData.canInteract,
                job = optionData.job,
                gang = optionData.gang,
            }
        end
        exports['qb-target']:AddCircleZone(data.name, data.coords, data.radius, {
            name = data.name,
            debugPoly = data.debug,
        }, { options = options })
        return data.name
    end

    Framework.target.remove = function(zoneId)
        return exports['qb-target']:RemoveZone(zoneId)
    end
end
