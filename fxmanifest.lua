fx_version 'cerulean'
game 'gta5'

author 'Team Snaily (https://snai.ly/team)'
description 'Send screenshots to Discord with player info'
version '1.0.0'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_script 'config.lua'

dependency 'screenshot-basic'