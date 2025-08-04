fx_version 'cerulean'
game 'gta5'

name 'qb-vehiclekeys'
description 'Advanced Vehicle Key Management System for QBCore'
version '2.0.0'
url 'https://github.com/your-username/qb-vehiclekeys'
author 'Your Name'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/main.css',
	'html/sounds/*.ogg',
	'html/images/*.png'
}

dependencies {
	'qb-core',
	'oxmysql'
}

-- Attribution
--[[
  <a href="https://www.flaticon.com/free-icons/car-window" title="car window icons">Car window icons created by LAFS - Flaticon</a>
  Font Awesome Icons - https://fontawesome.com/
]]
