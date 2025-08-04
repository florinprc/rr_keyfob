local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local currentVehicle = nil
local keyfobOpen = false
local vehicleKeys = {}

-- Initialize player data
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Key management functions
local function HasVehicleKey(plate)
    if not Config.useKeySystem then return true end
    return vehicleKeys[plate] or false
end

local function AddVehicleKey(plate)
    vehicleKeys[plate] = true
end

local function RemoveVehicleKey(plate)
    vehicleKeys[plate] = nil
end

-- Vehicle control functions
local function GetVehicleInFront()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        return vehicle
    end
    
    local rayHandle = StartShapeTestRay(pos.x, pos.y, pos.z, pos.x + forward.x * 10.0, pos.y + forward.y * 10.0, pos.z + forward.z * 10.0, 10, ped, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    
    return vehicle
end

local function IsVehicleOwned(plate)
    if not Config.useKeySystem then return true end
    
    local result = QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:IsVehicleOwned', plate)
    return result
end

local function PlaySound(soundName)
    if Config.Sounds[soundName] then
        SendNUIMessage({
            type = "playSound",
            sound = Config.Sounds[soundName]
        })
    end
end

local function ShowNotification(message)
    QBCore.Functions.Notify(message, "primary", 3000)
end

-- Vehicle lock/unlock
local function LockVehicle(vehicle)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    if lockStatus == 1 then
        SetVehicleDoorsLocked(vehicle, 2)
        ShowNotification(Config.Locales["vehicle_locked"])
        PlaySound("lock")
    else
        SetVehicleDoorsLocked(vehicle, 1)
        ShowNotification(Config.Locales["vehicle_unlocked"])
        PlaySound("unlock")
    end
    
    return true
end

-- Engine control
local function ToggleEngine(vehicle)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if Config.requireKeyForStart and not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    local engineRunning = GetIsVehicleEngineRunning(vehicle)
    if engineRunning then
        SetVehicleEngineOn(vehicle, false, true, true)
        ShowNotification(Config.Locales["engine_stopped"])
        PlaySound("stop")
    else
        SetVehicleEngineOn(vehicle, true, false, true)
        ShowNotification(Config.Locales["engine_started"])
        PlaySound("start")
    end
    
    return true
end

-- Trunk control
local function ToggleTrunk(vehicle)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if Config.requireKeyForTrunk and not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    local trunkOpen = GetVehicleDoorAngleRatio(vehicle, 5) > 0.0
    if trunkOpen then
        SetVehicleDoorShut(vehicle, 5, false)
        ShowNotification(Config.Locales["trunk_closed"])
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
        ShowNotification(Config.Locales["trunk_opened"])
    end
    
    PlaySound("trunk")
    return true
end

-- Hood control
local function ToggleHood(vehicle)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    local hoodOpen = GetVehicleDoorAngleRatio(vehicle, 4) > 0.0
    if hoodOpen then
        SetVehicleDoorShut(vehicle, 4, false)
        ShowNotification(Config.Locales["hood_closed"])
    else
        SetVehicleDoorOpen(vehicle, 4, false, false)
        ShowNotification(Config.Locales["hood_opened"])
    end
    
    return true
end

-- Window control
local function ToggleWindow(vehicle, windowIndex)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    local windowOpen = IsVehicleWindowIntact(vehicle, windowIndex)
    if windowOpen then
        RollDownWindow(vehicle, windowIndex)
        ShowNotification(Config.Locales["window_opened"])
    else
        RollUpWindow(vehicle, windowIndex)
        ShowNotification(Config.Locales["window_closed"])
    end
    
    PlaySound("window")
    return true
end

-- Door control
local function ToggleDoor(vehicle, doorIndex)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    local doorOpen = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0.0
    if doorOpen then
        SetVehicleDoorShut(vehicle, doorIndex, false)
    else
        SetVehicleDoorOpen(vehicle, doorIndex, false, false)
    end
    
    return true
end

-- Alarm control
local function TriggerAlarm(vehicle)
    if not vehicle or vehicle == 0 then return end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not HasVehicleKey(plate) then
        ShowNotification(Config.Locales["no_key"])
        return false
    end
    
    SetVehicleAlarm(vehicle, true)
    StartVehicleAlarm(vehicle)
    ShowNotification(Config.Locales["alarm_triggered"])
    PlaySound("alarm")
    
    SetTimeout(5000, function()
        SetVehicleAlarm(vehicle, false)
    end)
    
    return true
end

-- Get vehicle information for UI
local function GetVehicleInfo(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    
    local plate = QBCore.Functions.GetPlate(vehicle)
    local fuel = GetVehicleFuelLevel(vehicle)
    local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h
    local engineRunning = GetIsVehicleEngineRunning(vehicle)
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    local trunkOpen = GetVehicleDoorAngleRatio(vehicle, 5) > 0.0
    local hoodOpen = GetVehicleDoorAngleRatio(vehicle, 4) > 0.0
    
    local doors = {}
    for i = 0, 5 do
        doors[i] = GetVehicleDoorAngleRatio(vehicle, i) > 0.0
    end
    
    local windows = {}
    for i = 0, 3 do
        windows[i] = not IsVehicleWindowIntact(vehicle, i)
    end
    
    return {
        plate = plate,
        fuel = fuel,
        speed = math.floor(speed),
        engineRunning = engineRunning,
        locked = lockStatus == 2,
        trunkOpen = trunkOpen,
        hoodOpen = hoodOpen,
        doors = doors,
        windows = windows,
        hasKey = HasVehicleKey(plate)
    }
end

-- Keyfob UI functions
local function OpenKeyfobUI()
    if keyfobOpen then return end
    
    local vehicle = GetVehicleInFront()
    if not vehicle or vehicle == 0 then
        ShowNotification(Config.Locales["not_in_vehicle"])
        return
    end
    
    local vehicleInfo = GetVehicleInfo(vehicle)
    if not vehicleInfo then return end
    
    keyfobOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "openKeyfob",
        vehicle = vehicleInfo,
        config = Config.UISettings
    })
    
    -- Play keyfob animation
    if Config.Animations.useKeyfob then
        local ped = PlayerPedId()
        RequestAnimDict(Config.Animations.keyfobDict)
        while not HasAnimDictLoaded(Config.Animations.keyfobDict) do
            Wait(0)
        end
        TaskPlayAnim(ped, Config.Animations.keyfobDict, Config.Animations.keyfobAnimName, 8.0, -8.0, -1, 49, 0, false, false, false)
    end
end

local function CloseKeyfobUI()
    if not keyfobOpen then return end
    
    keyfobOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = "closeKeyfob"
    })
    
    -- Stop animation
    if Config.Animations.useKeyfob then
        ClearPedTasks(PlayerPedId())
    end
end

-- NUI Callbacks
RegisterNUICallback('closeKeyfob', function(data, cb)
    CloseKeyfobUI()
    cb('ok')
end)

RegisterNUICallback('lockVehicle', function(data, cb)
    local vehicle = GetVehicleInFront()
    LockVehicle(vehicle)
    cb('ok')
end)

RegisterNUICallback('toggleEngine', function(data, cb)
    local vehicle = GetVehicleInFront()
    ToggleEngine(vehicle)
    cb('ok')
end)

RegisterNUICallback('toggleTrunk', function(data, cb)
    local vehicle = GetVehicleInFront()
    ToggleTrunk(vehicle)
    cb('ok')
end)

RegisterNUICallback('toggleHood', function(data, cb)
    local vehicle = GetVehicleInFront()
    ToggleHood(vehicle)
    cb('ok')
end)

RegisterNUICallback('toggleWindow', function(data, cb)
    local vehicle = GetVehicleInFront()
    local windowIndex = data.windowIndex
    ToggleWindow(vehicle, windowIndex)
    cb('ok')
end)

RegisterNUICallback('toggleDoor', function(data, cb)
    local vehicle = GetVehicleInFront()
    local doorIndex = data.doorIndex
    ToggleDoor(vehicle, doorIndex)
    cb('ok')
end)

RegisterNUICallback('triggerAlarm', function(data, cb)
    local vehicle = GetVehicleInFront()
    TriggerAlarm(vehicle)
    cb('ok')
end)

RegisterNUICallback('updateVehicleInfo', function(data, cb)
    local vehicle = GetVehicleInFront()
    local vehicleInfo = GetVehicleInfo(vehicle)
    cb(vehicleInfo)
end)

-- Key management events
RegisterNetEvent('qb-vehiclekeys:client:AddKeys', function(plate)
    AddVehicleKey(plate)
    ShowNotification(Config.Locales["key_given"])
end)

RegisterNetEvent('qb-vehiclekeys:client:RemoveKeys', function(plate)
    RemoveVehicleKey(plate)
    ShowNotification(Config.Locales["key_removed"])
end)

RegisterNetEvent('qb-vehiclekeys:client:SetKeys', function(plates)
    vehicleKeys = plates or {}
end)

-- Vehicle entry/exit events
RegisterNetEvent('baseevents:enteredVehicle', function(vehicle, seat, vehicleName)
    currentVehicle = vehicle
    local plate = QBCore.Functions.GetPlate(vehicle)
    
    if Config.useKeySystem and not HasVehicleKey(plate) then
        -- Check if player owns the vehicle
        QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:IsVehicleOwned', function(owned)
            if owned then
                AddVehicleKey(plate)
                ShowNotification(Config.Locales["grabbed_keys"])
            end
        end, plate)
    end
end)

RegisterNetEvent('baseevents:leftVehicle', function(vehicle, seat, vehicleName)
    currentVehicle = nil
end)

-- Prevent engine start without key
if Config.preventDefaultEngineStart then
    CreateThread(function()
        while true do
            Wait(0)
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local plate = QBCore.Functions.GetPlate(vehicle)
                
                if Config.requireKeyForStart and not HasVehicleKey(plate) then
                    SetVehicleEngineOn(vehicle, false, true, true)
                end
            end
        end
    end)
end

-- Key binding
RegisterCommand('openkeyfob', function()
    OpenKeyfobUI()
end, false)

RegisterKeyMapping('openkeyfob', 'Open Keyfob', 'keyboard', Config.UISettings.defaultKey)

-- Export functions for other resources
exports('HasVehicleKey', HasVehicleKey)
exports('AddVehicleKey', AddVehicleKey)
exports('RemoveVehicleKey', RemoveVehicleKey)
exports('LockVehicle', LockVehicle)
exports('ToggleEngine', ToggleEngine)
exports('ToggleTrunk', ToggleTrunk)
exports('ToggleHood', ToggleHood)
exports('ToggleWindow', ToggleWindow)
exports('ToggleDoor', ToggleDoor)
exports('TriggerAlarm', TriggerAlarm)
