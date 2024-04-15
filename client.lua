ESX = exports['es_extended']:getSharedObject() or function()
    local obj = nil
    while not obj do
        Wait(0)
        TriggerEvent('esx:getSharedObject', function(esx)
            obj = esx
        end)
    end
    return obj
end

local ts = Config.Locale
local plrState = false
local menuRegistered = false
local inArea = false

local ped = PlayerPedId()

-- on player load
Citizen.CreateThread(function()
    while true do
        Wait(2000)
        ped = PlayerPedId()
    end
end)

local function addMarker(coords, type, scale, color)
    DrawMarker(type, coords, 0.0, 0.0, 0.0, 0.0, 0.0, Config.NPC.heading - 180.0, scale.x, scale.y,
        scale.z, color.r, color.g, color.b, color.a, false, false, 2, false, nil, nil, false)
end

CreateThread(function()
    if Config.NPC.enabled then
        --spawn npc on location
        local model = GetHashKey(Config.NPC.ped)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local npc = CreatePed(4, model, Config.NPC.coords, Config.NPC.heading, false, false)
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetModelAsNoLongerNeeded(model)
    end

    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(ped)
        local distance = #(playerCoords - Config.NPC.coords)
        if Config.NPC.marker.enabled then
            if distance < Config.NPC.marker.distance then
                addMarker(Config.NPC.coords, Config.NPC.marker.type, Config.NPC.marker.scale,
                    Config.NPC.marker.color)
            end
        end
        if distance < Config.NPC.interactionDistance and not inArea then
            inArea = true
            lib.showTextUI('[E] - ' .. ts.interact_npc)
        elseif distance > Config.NPC.interactionDistance and inArea then
            inArea = false
            lib.hideTextUI()
        end

        if IsControlJustPressed(0, Config.NPC.interactKey) and inArea then
            TriggerServerEvent('rk_immigration:server:callAdmin')
        end
    end
end)


if not Config.Immigration.combat then
    CreateThread(function()
        while true do
            Wait(0)
            local playerCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - Config.NPC.coords)

            if distance < Config.Immigration.radius then
                DisablePlayerFiring(ped, false)
                DisableControlAction(0, 45, false)
                DisableControlAction(0, 140, false)
                DisableControlAction(0, 141, false)
                DisableControlAction(0, 142, false)
            else
                Wait(1000)
            end
        end
    end)
end

-- 


local function openPermitMenu()
    local options = {
        { label = ts.menu.permit_menu.give,   value = 'give' },
        { label = ts.menu.permit_menu.remove, value = 'remove' },
    }

    local input = lib.inputDialog(ts.menu.permit_menu.title, {
        { type = 'select', label = ts.menu.permit_menu.select_action, options = options, required = true, icon = 'fas fa-cog' },
        { type = 'number', label = ts.menu.permit_menu.enter_id,      required = true,   icon = 'hashtag' },
    })
    if not input then return end
    TriggerServerEvent('rk_immigration:server:permitAction', input[1], input[2])
end

RegisterNetEvent('rk_immigration:client:openMenu', function()
    if not menuRegistered then
        lib.registerMenu({
            id = 'rk_immigration_menu',
            title = ts.menu.title,
            position = 'top-right',
            options = {
                { label = ts.menu.duty,   icon = 'fas fa-door-open' },
                { label = ts.menu.permit, icon = 'fas fa-passport' }
            }
        }, function(selected, scrollIndex, args)
            if selected == 1 then
                plrState = not plrState
                if plrState then
                    local outfit = GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') and
                        Config.Outfits.female or Config.Outfits.male
                    TriggerEvent('skinchanger:loadSkin', outfit)
                else
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        if skin == nil then return end
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                end
                TriggerServerEvent('rk_immigration:server:changeState', plrState)
            elseif selected == 2 then
                openPermitMenu()
            end
        end)
        menuRegistered = true
    end

    lib.showMenu('rk_immigration_menu')
end)
