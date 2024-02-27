fx_version "cerulean"

description "Crafting Menu for New Reign Roleplay"
author "Mkeefeus & MrMark1127"
version '1.1.3'

lua54 'yes'
game 'gta5'

ui_page 'web/build/index.html'

client_scripts {
    "framework/client/*.lua", -- CHANGE THIS TO YOUR FRAMEWORK
    "client/client.lua",
    "client/utils.lua",
}

server_scripts {
    'framework/server/*.lua', -- CHANGE THIS TO YOUR FRAMEWORK
    "server/server.lua"
}

escrow_ignore {
    'framework/**/*',
    'config.lua',
    'fxmanifest.lua',
}

dependencies {
    'ox_lib',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

files {
    'web/build/index.html',
    'web/build/**/*'
}
