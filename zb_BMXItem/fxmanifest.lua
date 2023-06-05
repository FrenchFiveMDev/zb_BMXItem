fx_version 'adamant'
game 'gta5'
lua54 "yes"

version '1.0.4'

author 'ZeBee#0433'
Contributors 'JLDimitri74#2484 , Malizniak#4796 , Sarish#0609'

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