-- Download rr_notify here: https://github.com/RoleplayRevisited/rr_notify

Config = {}

-- Framework Configuration
Config.Framework = "qbcore" -- "qbcore" or "esx" or "standalone"
Config.QBCore = exports['qb-core']:GetCoreObject()

-- Vehicle Control Settings
Config.preventDefaultEngineStart = true -- Stop vehicle engines from starting by default
Config.keepEngineRunning = true -- if a player exits the vehicle should the engine stay running
Config.keepVehicleDoorOpen = true -- if a player exits the vehicle should the door stay open

-- Key System Settings
Config.useKeySystem = true -- Enable key system for vehicles
Config.requireKeyForStart = true -- Require key to start vehicle
Config.requireKeyForLock = true -- Require key to lock/unlock vehicle
Config.requireKeyForTrunk = true -- Require key to open trunk

-- Item Configuration
Config.KeyItem = "vehicle_key" -- Item name for vehicle keys
Config.KeyfobItem = "keyfob" -- Item name for keyfob

-- UI Settings
Config.UISettings = {
    defaultKey = "I", -- Default key to open keyfob UI
    showFuel = true, -- Show fuel level in UI
    showSpeed = true, -- Show current speed in UI
    showEngine = true, -- Show engine status in UI
    showDoors = true, -- Show door status in UI
    showWindows = true, -- Show window status in UI
    showTrunk = true, -- Show trunk status in UI
    showHood = true, -- Show hood status in UI
}

-- Sound Settings
Config.Sounds = {
    lock = "lock.ogg",
    unlock = "unlock.ogg",
    start = "start.ogg",
    stop = "stop.ogg",
    trunk = "trunk.ogg",
    window = "window.ogg",
    alarm = "alarm.ogg"
}

-- Animation Settings
Config.Animations = {
    useKeyfob = true, -- Play animation when using keyfob
    keyfobAnim = "WORLD_HUMAN_CLIPBOARD", -- Animation for keyfob usage
    keyfobDict = "amb@world_human_clipboard@male@base",
    keyfobAnimName = "base"
}

-- Database Settings
Config.Database = {
    table = "player_vehicles", -- QBCore vehicles table
    plateColumn = "plate", -- Column name for license plate
    ownerColumn = "citizenid" -- Column name for owner
}

-- Locale Settings
Config.Locales = {
    ["grabbed_keys"] = "Ai luat cheile mașinii",
    ["no_key"] = "Nu ai cheile acestei mașini",
    ["vehicle_locked"] = "Mașina a fost încuiată",
    ["vehicle_unlocked"] = "Mașina a fost descuiată",
    ["engine_started"] = "Motorul a pornit",
    ["engine_stopped"] = "Motorul s-a oprit",
    ["trunk_opened"] = "Portbagajul s-a deschis",
    ["trunk_closed"] = "Portbagajul s-a închis",
    ["hood_opened"] = "Capota s-a deschis",
    ["hood_closed"] = "Capota s-a închis",
    ["window_opened"] = "Fereastra s-a deschis",
    ["window_closed"] = "Fereastra s-a închis",
    ["alarm_triggered"] = "Alarma s-a declanșat",
    ["key_given"] = "Ai primit cheile mașinii",
    ["key_removed"] = "Cheile mașinii au fost confiscate",
    ["not_in_vehicle"] = "Nu ești într-o mașină",
    ["vehicle_too_far"] = "Mașina este prea departe",
    ["keyfob_used"] = "Ai folosit keyfob-ul",
    ["no_keyfob"] = "Nu ai un keyfob",
    ["fuel_low"] = "Combustibil scăzut",
    ["speed_limit"] = "Viteză limită depășită"
}

-- Vehicle Classes that can use keyfob
Config.AllowedVehicleClasses = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
}

-- Blacklisted vehicles (cannot use keyfob)
Config.BlacklistedVehicles = {
    "rhino",
    "khanjali",
    "scarab",
    "scarab2",
    "scarab3"
}
