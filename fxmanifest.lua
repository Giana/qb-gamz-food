fx_version 'cerulean'

game 'gta5'

author 'Giana - github.com/Giana (Original author: github.com/gamziboi)'
description 'qb-gamz-food (Forked from github.com/gamziboi/gamz-food)'
version '1.0.1'

shared_scripts {
    'config.lua'
}

client_script {
    'client/main.lua',
    'client/utils.lua',
    'client/target.lua'
}

server_script {
    'server/main.lua'
}

lua54 'yes'
