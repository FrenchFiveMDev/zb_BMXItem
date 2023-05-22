fx_version 'adamant'
game 'gta5'
lua54 "yes"

author 'ZeBee#0433'

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