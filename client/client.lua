local playingEmote = false
local currentShop = nil
local uiReady = false

local function OpenNUI(shopData)
    SetNuiFocus(true, true)
    SendReactMessage('setShopData', {
        shop = shopData,
        plyInventory = lib.callback.await('nr-craftingmenu:server:getPlayerInventory')
    })
    SendReactMessage('setVisible', true)
    if Config.Debug or Config.Logs?.onOpen then
        debugPrint('Open NUI frame')
        TriggerServerEvent('nr-craftingmenu:server:log', 'open', {location = currentShop})
    end
end

local function CloseNUI()
    SetNuiFocus(false, false)
    SendReactMessage('setVisible', false)
    local shop = currentShop
    currentShop = nil
    if Config.Debug or Config.Logs?.onClose then
        debugPrint('Close NUI frame')
        TriggerServerEvent('nr-craftingmenu:server:log', 'close', {location = shop})
    end
end

function CreateCraftingZones()
    for shopName, shopData in pairs(Config.CraftingLocations) do
        if shopData.zoneId then goto continue end
        shopData.zoneId = Framework.target.sphere({
            coords = shopData.coords,
            radius = shopData.raduis or 1.0,
            debug = Config.Debug,
            name = "nr-crafting_" .. shopName,
            options = {
                {
                    icon = 'fa-solid fa-ruler',
                    label = "Craft",
                    job = shopData.job,
                    gang = shopData.gang,
                    onSelect = function()
                        currentShop = shopName
                        TriggerEvent('nr-craftingmenu:client:openCrafting', shopName)
                    end,
                    canInteract = function()
                        return uiReady
                    end
                }
            }
        })
        ::continue::
    end
end

lib.callback.register('nr-craftingmenu:client:progressbar', function(itemData, shop)
    if not playingEmote then
        local tableData = Config.CraftingLocations[shop]
        if tableData.emote and Framework.PlayEmote then
            Framework.PlayEmote(tableData.emote)
            playingEmote = true
        elseif tableData.scenario then
            TaskStartScenarioInPlace(PlayerPedId(), tableData.scenario, 0, true)
            playingEmote = true
        elseif tableData.anim and tableData.animDict then
            lib.requestAnimDict(tableData.animDict)
            TaskPlayAnim(PlayerPedId(), tableData.animDict, tableData.anim, 8.0, 8.0, -1, tableData.animFlag or 1, 0, false,
                false, false)
        else
            if not Config.DefaultEmote or not Framework.PlayEmote then return end
            Framework.PlayEmote(Config.DefaultEmote)
            playingEmote = true
        end
    end
    return lib.progressBar({
        duration = itemData.time,
        label = ("Crafting %s..."):format(itemData.label),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        }
    })
end)

RegisterNetEvent('nr-craftingmenu:client:openCrafting', function(tableName)
    local tableData = Config.CraftingLocations[tableName]
    OpenNUI({ items = tableData.items, labels = tableData.labels })
end)

RegisterNetEvent("nr-craftingmenu:client:updateCraftingLocations", function(name, data)
    if Config.CraftingLocations?[name]?.zoneId then
        Framework.target.remove(Config.CraftingLocations[name].zoneId)
    end
    Config.CraftingLocations[name] = data
    if not data then return end
    CreateCraftingZones()
end)

RegisterNetEvent('nr-craftingmenu:client:cancelEmote', function ()
    if not Framework.CancelEmote or not playingEmote then return end
    Framework.CancelEmote()
    playingEmote = false
end)

CreateThread(function () -- onResourceStart
    if LocalPlayer.state.isLoggedIn then
        CreateCraftingZones()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, data in pairs(Config.CraftingLocations) do
            if data.zoneId then
                Framework.target.remove(data.zoneId)
            end
        end
    end
end)

RegisterNetEvent('nr-core:client:CloseNUI', CloseNUI)

RegisterNUICallback('closeCraftingMenu', function(_, cb)
    CloseNUI()
    cb({})
end)

RegisterNUICallback('craftItems', function(data, cb)
    TriggerServerEvent('nr-craftingmenu:server:craftItems', data, currentShop)
    cb({})
end)

RegisterNUICallback('uiLoaded', function(_, cb)
    uiReady = true
    cb({})
end)

RegisterNUICallback('getConfig', function(_, cb)
    cb({
        imagePath = "nui:/" .. Config.ImagePath,
        Styles = Config.Styles
    })
end)