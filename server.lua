ESX = exports['es_extended']:getSharedObject() or function()
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

local permitMenu = Config.Command.permitMenu
local ts = Config.Locale
local zoneCoords = Config.Immigration.coords
local zoneRadius = Config.Immigration.radius
local staffCoords = Config.Immigration.staff_coords
local playerStatus = {}
local playerCooldowns = {}

local function getIdentifier(src, type)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:find(type) then return id end
    end
end

local function log(title, desc, ping)
    if not Config.Discord.enabled then return end

    local embed = {
        {
            ['color'] = 4437377,
            ['title'] = title,
            ['description'] = desc,
            ['footer'] = {
                ['text'] = "Made by Red Killer"
            },
            ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%S')
        }
    }

    local main = {
        content = ping and '@here' or nil,
        embeds = embed,
    }

    local webhook = ping and Config.Discord.webhook_ping or Config.Discord.webhook_log
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(main),
        { ['Content-Type'] = 'application/json' })
end

local function newPlayer(src)
    if not src or ESX.GetPlayerFromId(src) == nil then return end
    local id = ESX.GetPlayerFromId(src).getIdentifier()

    MySQL.Async.fetchScalar('SELECT newPlayer FROM users WHERE identifier = @id', {
        ['@id'] = id
    }, function(newPlayer)
        playerStatus[src] = newPlayer
        if newPlayer then
            SetPlayerRoutingBucket(src, 1)
        end
        return newPlayer
    end)
end

local function updatePlayer(src, status)
    local id = ESX.GetPlayerFromId(src).getIdentifier()
    MySQL.Async.execute('UPDATE users SET newPlayer = @status WHERE identifier = @id', {
        ['@id'] = id,
        ['@status'] = status
    }, function()
        playerStatus[src] = status
    end)
end

local function callAdmin(src)
    local players = GetPlayers()
    local xName = GetPlayerName(src) .. ' - ' .. src
    for i = 1, #players do
        local plr = players[i]
        local xPlayer = ESX.GetPlayerFromId(plr)
        if xPlayer == nil then return end
        local xGroup = xPlayer.getGroup()
        for j = 1, #Config.AdminGroups do
            if xGroup == Config.AdminGroups[j] then
                notifyPlayer(plr, string.format(ts.admin_call, xName), 'info')
            end
        end
    end
end

AddEventHandler('playerDropped', function()
    local src = tostring(source)
    if playerStatus[src] ~= nil then
        playerStatus[src] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local players = GetPlayers()
        for i = 1, #players do
            local plr = players[i]
            local newPlayer = playerStatus[plr] == nil and newPlayer(plr) or playerStatus[plr]

            if newPlayer then
                if #(GetEntityCoords(GetPlayerPed(plr)) - zoneCoords) > zoneRadius then
                    SetEntityCoords(GetPlayerPed(plr), zoneCoords.x, zoneCoords.y, zoneCoords.z, false, false, false,
                        false)
                    notifyPlayer(plr, ts.not_in_zone, 'error')
                    log(ts.discord.not_in_zone_title, string.format(ts.discord.not_in_zone_desc, GetPlayerName(plr), plr,
                        getIdentifier(plr, 'license'), '<@' .. getIdentifier(plr, 'discord'):gsub('discord:', '') .. '>'))
                end
            end
        end
    end
end)

RegisterNetEvent('rk_immigration:server:callAdmin', function()
    local src = source
    if not playerStatus[tostring(src)] then
        notifyPlayer(src, ts.interact_npc_old, 'info')
        return
    end

    if playerCooldowns[src] and playerCooldowns[src] > GetGameTimer() then
        local remainingTime = math.floor((playerCooldowns[src] - GetGameTimer()) / 1000)
        notifyPlayer(src, string.format(ts.interact_cooldown, remainingTime), 'error')
    else
        playerCooldowns[src] = GetGameTimer() + Config.NPC.cooldown * 1000
        notifyPlayer(src, ts.interact_npc_info, 'info')
        callAdmin(src)

        local xName = GetPlayerName(src)
        local id = getIdentifier(src, 'license')
        local dc_id = '<@' .. getIdentifier(src, 'discord'):gsub('discord:', '') .. '>'

        log(ts.discord.admin_call_title, string.format(ts.discord.admin_call_desc, xName, src, id, dc_id), true)
    end
end)

RegisterNetEvent('rk_immigration:server:permitAction', function(action, id)
    local src = source
    if not IsPlayerAceAllowed(src, 'command.' .. permitMenu.command) then return end

    if (action ~= 'give' and action ~= 'remove') or (not id or type(id) ~= 'number') then return end
    id = tostring(id)

    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget then
        if action == 'give' and not playerStatus[id] then
            notifyPlayer(src, ts.already_have_permit, 'error')
            return
        elseif action == 'remove' and playerStatus[id] then
            notifyPlayer(src, ts.already_have_not_permit, 'error')
            return
        end
        local xName = xTarget.getName()
        local status = nil
        if action == 'give' then
            status = false
        elseif action == 'remove' then
            status = true
        end

        updatePlayer(id, status)
        notifyPlayer(src, action == 'give' and string.format(ts.give_permit, xName) or string.format(ts.remove_permit,
            xName), 'info')
        notifyPlayer(id, action == 'give' and ts.give_permit_t or ts.remove_permit_t, 'info')
        local bucket = status and 1 or 0
        SetPlayerRoutingBucket(id, bucket)
        if Config.Immigration.finish_coords and not status then
            SetEntityCoords(GetPlayerPed(id), Config.Immigration.finish_coords, false, false, false,
                false)
        end

        local admin_name = GetPlayerName(src)
        local admin_id = getIdentifier(src, 'license')
        local admin_dc_id = '<@' .. getIdentifier(src, 'discord'):gsub('discord:', '') .. '>'

        local target_name = GetPlayerName(id)
        local target_id = getIdentifier(id, 'license')
        local target_dc_id = '<@' .. getIdentifier(id, 'discord'):gsub('discord:', '') .. '>'

        local title = action == 'give' and ts.discord.give_permit or ts.discord.remove_permit
        log(string.format(ts.discord.permit_title, title),
            string.format(ts.discord.permit_desc, admin_name, src, admin_id, admin_dc_id, target_name, id, target_id,
                target_dc_id))
    else
        notifyPlayer(source, ts.invalid_id, 'error')
    end
end)


local oldLocationStorage = {}
RegisterNetEvent('rk_immigration:server:changeState', function(state)
    if not IsPlayerAceAllowed(source, 'command.' .. permitMenu.command) then return end

    if state then
        oldLocationStorage[source] = GetEntityCoords(GetPlayerPed(source))
        SetEntityCoords(GetPlayerPed(source), staffCoords.x, staffCoords.y, staffCoords.z, false, false, false,
            false)
    else
        if oldLocationStorage[source] then
            SetEntityCoords(GetPlayerPed(source), oldLocationStorage[source].x, oldLocationStorage[source].y,
                oldLocationStorage[source].z, false, false, false, false)
            oldLocationStorage[source] = nil
        end
    end

    local bucket = state and 1 or 0
    SetPlayerRoutingBucket(source, bucket)
    notifyPlayer(source, state and ts.on_duty or ts.off_duty, 'info')

    local xName = GetPlayerName(source)
    local id = getIdentifier(source, 'license')
    local dc_id = '<@' .. getIdentifier(source, 'discord'):gsub('discord:', '') .. '>'
    local title = state and ts.discord.on_duty or ts.discord.off_duty
    log(string.format(ts.discord.admin_duty_title, title),
        string.format(ts.discord.admin_duty_desc, xName, source, id, dc_id))
end)


--Command stuff
RegisterCommand(permitMenu.command, function(src)
    if (src > 0) then
        TriggerClientEvent('rk_immigration:client:openMenu', src)
    else
        print(ts.on_console)
    end
end, true)

TriggerClientEvent('chat:addSuggestions', -1, {
    {
        name = '/' .. permitMenu.command,
        help = permitMenu.help
    },
})
