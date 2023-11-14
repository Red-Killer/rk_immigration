fx_version 'cerulean'
games { 'gta5' }
author 'Red Killer <github.com/Red-Killer>'
description 'Adds a immigration system to your server'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}