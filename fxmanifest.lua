fx_version 'cerulean'
game 'gta5'

description 'Play timing for QBCore by @Cruso#5044'
version '0.0.1'

shared_scripts {
    'config.lua',
	
}

client_script {
    'client.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page "html/index.html"



files {
    "html/scripts/*.js",
   
    "html/*.html",
    "html/css/*.css",
    "html/img/*.png",

}
