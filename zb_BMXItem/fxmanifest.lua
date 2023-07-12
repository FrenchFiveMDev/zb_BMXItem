fx_version 'adamant'
game 'gta5'
lua54 "yes"

version '1.0.5'

author 'ZeBee#0433'
Contributions 'JLDimitri74#2484'

shared_scripts {
    "config.lua",
}

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua"
}

escrow_ignore {
    'client/*.lua',
    'server/*.lua',
    'config.lua'
}