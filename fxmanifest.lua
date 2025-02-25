fx_version 'cerulean'
games { 'gta5' }

author 'KFDevelopment - discord.gg/kfdev | Kekko_, Fonlogen'
description 'Pause Menu'

version '1.2.0'

lua54 'yes'

client_scripts {
  'client/*.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/*.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

files {
  'ui/index.html',
  'ui/css/*.css',
  'ui/js/*.js',
  'ui/images/*.png',
  'ui/images/*.jpg',
  'ui/images/*.gif',
}

ui_page 'ui/index.html'