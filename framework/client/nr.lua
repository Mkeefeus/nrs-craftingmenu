---@diagnostic disable: duplicate-set-field
Framework = {
    target = {}
}

function Framework.PlayEmote(emote)
    return exports.scully_emotemenu:PlayByCommand(emote)
end

function Framework.CancelEmote()
    return exports.scully_emotemenu:CancelAnimation()
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateCraftingZones()
end)

Framework.target.sphere = function (data)
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

Framework.target.remove = function (zoneId)
    return exports['ox_target']:removeZone(zoneId)
end
