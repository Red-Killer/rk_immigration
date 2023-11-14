Config = {}

Config.Immigration = {
    coords = vector3(0, 0, 0),
    radius = 5.0,
    finish_coords = vector3(0, 0, 0), -- nil or vector3(x, y, z)
    staff_coords = vector3(0, 0, 0),
    combat = false,
}

Config.Command = {
    permitMenu = {
        command = 'permit', -- add_ace group.staff command.permit allow
        help = 'Open the permit menu',
    }
}

Config.AdminGroups = { 'admin' }

Config.NPC = {
    enabled = true,
    cooldown = 300,
    interactKey = 38,
    coords = vector3(0, 0, 0),
    heading = 180.0,
    ped = 'a_m_m_business_01',
    interactionDistance = 1.5,
    marker = {
        enabled = true,
        type = 1,
        distance = 10.0,
        scale = {x = 1.0, y = 1.0, z = 1.0},
        color = {r = 255, g = 0, b = 0, a = 100},
    },
}

Config.Discord = {
    enabled = true,
    webhook_log = 'https://discord.com/api/webhooks/xxx/xxx',
    webhook_ping = 'https://discord.com/api/webhooks/xxx/xxx',
}

Config.Locale = {
    on_console = 'This command can only be executed by a player',
    not_in_zone = 'You cannot leave this area!',
    on_duty = 'You are now on duty',
    off_duty = 'You are now off duty',
    menu = {
        title = 'Immigration',
        duty = 'On/Off duty',
        permit = 'Permit Management',
        permit_menu = {
            title = 'Permit menu',
            enter_id = 'Player ID',
            give = 'Give',
            remove = 'Remove',
            select_action = 'Select action'
        }
    },
    invalid_id = 'Invalid Player ID',
    give_permit = 'You have given a permit to %s',
    give_permit_t = 'You successfully received a permit',
    remove_permit = 'You have removed the permit from %s',
    remove_permit_t = 'Your permit has been removed',
    already_have_permit = 'This player already has a permit',
    already_have_not_permit = 'This player does not have a permit',
    interact_npc = 'Call an Admin',
    interact_cooldown = 'You have to wait %s seconds to call an admin again',
    interact_npc_old = 'You are not a new player, you cannot call an admin',
    interact_npc_info = 'An admin has been called',
    admin_call = '%s called an admin to the Immigration Office',
    discord = {
        not_in_zone_title = 'Player tried to leave the area',
        not_in_zone_desc = [[
            **Player**
            Name: %s
            ID: %s
            License: %s
            Discord: %s
        ]],
        admin_call_title = 'Admin request',
        admin_call_desc = [[
            **Player**
            Name: %s
            ID: %s
            License: %s
            Discord: %s
        ]],
        permit_title = 'Permit %s',
        permit_desc = [[
            **Admin**
            Name: %s
            ID: %s
            License: %s
            Discord: %s

            **Target**
            Name: %s
            ID: %s
            License: %s
            Discord: %s
        ]],
        give_permit = 'Given',
        remove_permit = 'Removed',
        admin_duty_title = 'Admin %s',
        admin_duty_desc = [[
            Name: %s
            ID: %s
            License: %s
            Discord: %s
        ]],
        on_duty = 'On duty',
        off_duty = 'Off duty',
    }
}

local function calculateDuration(desc)
    local w, s = 0, 0
    desc:gsub('%S+', function() w = w + 1 end)
    desc:gsub('%.', function() s = s + 1 end)
    return (w + s) * 500
end

function notifyPlayer(src, desc, type)
    local data = {
        title = 'Immigration',
        description = desc,
        type = type,
        duration = calculateDuration(desc)
    }
    TriggerClientEvent('ox_lib:notify', src, data)
end

Config.Outfits = {
    male = {
        sex          = 0,
        face         = 0,
        skin         = 0,
        beard_1      = 0,
        beard_2      = 0,
        beard_3      = 0,
        beard_4      = 0,
        hair_1       = 0,
        hair_2       = 0,
        hair_color_1 = 0,
        hair_color_2 = 0,
        tshirt_1     = 0,
        tshirt_2     = 0,
        torso_1      = 0,
        torso_2      = 0,
        decals_1     = 0,
        decals_2     = 0,
        arms         = 0,
        pants_1      = 0,
        pants_2      = 0,
        shoes_1      = 0,
        shoes_2      = 0,
        mask_1       = 0,
        mask_2       = 0,
        bproof_1     = 0,
        bproof_2     = 0,
        chain_1      = 0,
        chain_2      = 0,
        helmet_1     = 5,
        helmet_2     = 0,
        glasses_1    = 0,
        glasses_2    = 0,
    },
    female = {
        sex          = 1,
        face         = 0,
        skin         = 0,
        beard_1      = 0,
        beard_2      = 0,
        beard_3      = 0,
        beard_4      = 0,
        hair_1       = 0,
        hair_2       = 0,
        hair_color_1 = 0,
        hair_color_2 = 0,
        tshirt_1     = 0,
        tshirt_2     = 0,
        torso_1      = 0,
        torso_2      = 0,
        decals_1     = 0,
        decals_2     = 0,
        arms         = 0,
        pants_1      = 0,
        pants_2      = 0,
        shoes_1      = 0,
        shoes_2      = 0,
        mask_1       = 0,
        mask_2       = 0,
        bproof_1     = 0,
        bproof_2     = 0,
        chain_1      = 0,
        chain_2      = 0,
        helmet_1     = 0,
        helmet_2     = 0,
        glasses_1    = 0,
        glasses_2    = 0,
    },
}