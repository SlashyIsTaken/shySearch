fx_version 'cerulean'
game 'gta5'

author 'shy // Slashy'
description 'Criminal Actions'

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_script 'client.lua'