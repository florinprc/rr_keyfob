local QBCore = exports['qb-core']:GetCoreObject()

-- Database functions
local function IsVehicleOwned(plate)
    local result = MySQL.Sync.fetchAll("SELECT * FROM " .. Config.Database.table .. " WHERE " .. Config.Database.plateColumn .. " = ?", {plate})
    return #result > 0
end

local function GetVehicleOwner(plate)
    local result = MySQL.Sync.fetchAll("SELECT " .. Config.Database.ownerColumn .. " FROM " .. Config.Database.table .. " WHERE " .. Config.Database.plateColumn .. " = ?", {plate})
    if #result > 0 then
        return result[1][Config.Database.ownerColumn]
    end
    return nil
end

-- Key management functions
local function GiveVehicleKey(source, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    -- Check if player owns the vehicle
    local owner = GetVehicleOwner(plate)
    if owner and owner == Player.PlayerData.citizenid then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        return true
    end
    
    return false
end

local function RemoveVehicleKey(source, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
    return true
end

-- Server callbacks
QBCore.Functions.CreateCallback('qb-vehiclekeys:server:IsVehicleOwned', function(source, cb, plate)
    cb(IsVehicleOwned(plate))
end)

QBCore.Functions.CreateCallback('qb-vehiclekeys:server:GetVehicleOwner', function(source, cb, plate)
    cb(GetVehicleOwner(plate))
end)

QBCore.Functions.CreateCallback('qb-vehiclekeys:server:HasVehicleKey', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then 
        cb(false)
        return
    end
    
    -- Check if player owns the vehicle
    local owner = GetVehicleOwner(plate)
    if owner and owner == Player.PlayerData.citizenid then
        cb(true)
    else
        cb(false)
    end
end)

-- Events
RegisterNetEvent('qb-vehiclekeys:server:GiveKeys', function(plate)
    local source = source
    GiveVehicleKey(source, plate)
end)

RegisterNetEvent('qb-vehiclekeys:server:RemoveKeys', function(plate)
    local source = source
    RemoveVehicleKey(source, plate)
end)

RegisterNetEvent('qb-vehiclekeys:server:GiveKeysToPlayer', function(targetId, plate)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    
    if not Player or not TargetPlayer then return end
    
    -- Check if source player owns the vehicle
    local owner = GetVehicleOwner(plate)
    if owner and owner == Player.PlayerData.citizenid then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', targetId, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai dat cheile mașinii lui ' .. TargetPlayer.PlayerData.charinfo.firstname, 'success')
        TriggerClientEvent('QBCore:Notify', targetId, 'Ai primit cheile mașinii de la ' .. Player.PlayerData.charinfo.firstname, 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Nu deții această mașină', 'error')
    end
end)

-- Item usage events
QBCore.Functions.CreateUseableItem(Config.KeyItem, function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- This would be used when player has a physical key item
    -- The key item should have metadata with the plate
    if item.info and item.info.plate then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, item.info.plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai folosit cheile mașinii', 'success')
    end
end)

QBCore.Functions.CreateUseableItem(Config.KeyfobItem, function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- This would be used when player has a keyfob item
    -- The keyfob item should have metadata with the plate
    if item.info and item.info.plate then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, item.info.plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai folosit keyfob-ul', 'success')
    end
end)

-- Admin commands
QBCore.Commands.Add('givekeys', 'Give vehicle keys to a player (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'plate', help = 'Vehicle Plate'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local plate = args[2]
    
    if not targetId or not plate then
        TriggerClientEvent('QBCore:Notify', source, 'Sintaxă: /givekeys [id] [plate]', 'error')
        return
    end
    
    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        TriggerClientEvent('QBCore:Notify', source, 'Jucătorul nu a fost găsit', 'error')
        return
    end
    
    TriggerClientEvent('qb-vehiclekeys:client:AddKeys', targetId, plate)
    TriggerClientEvent('QBCore:Notify', source, 'Ai dat cheile mașinii cu plăcuța ' .. plate .. ' lui ' .. TargetPlayer.PlayerData.charinfo.firstname, 'success')
    TriggerClientEvent('QBCore:Notify', targetId, 'Ai primit cheile mașinii cu plăcuța ' .. plate, 'success')
end, 'admin')

QBCore.Commands.Add('removekeys', 'Remove vehicle keys from a player (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'plate', help = 'Vehicle Plate'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local plate = args[2]
    
    if not targetId or not plate then
        TriggerClientEvent('QBCore:Notify', source, 'Sintaxă: /removekeys [id] [plate]', 'error')
        return
    end
    
    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        TriggerClientEvent('QBCore:Notify', source, 'Jucătorul nu a fost găsit', 'error')
        return
    end
    
    TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', targetId, plate)
    TriggerClientEvent('QBCore:Notify', source, 'Ai confiscat cheile mașinii cu plăcuța ' .. plate .. ' de la ' .. TargetPlayer.PlayerData.charinfo.firstname, 'success')
    TriggerClientEvent('QBCore:Notify', targetId, 'Cheile mașinii cu plăcuța ' .. plate .. ' au fost confiscate', 'error')
end, 'admin')

QBCore.Commands.Add('checkkeys', 'Check if a player has keys for a vehicle (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'plate', help = 'Vehicle Plate'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local plate = args[2]
    
    if not targetId or not plate then
        TriggerClientEvent('QBCore:Notify', source, 'Sintaxă: /checkkeys [id] [plate]', 'error')
        return
    end
    
    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        TriggerClientEvent('QBCore:Notify', source, 'Jucătorul nu a fost găsit', 'error')
        return
    end
    
    QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:HasVehicleKey', targetId, function(hasKey)
        if hasKey then
            TriggerClientEvent('QBCore:Notify', source, TargetPlayer.PlayerData.charinfo.firstname .. ' are cheile mașinii cu plăcuța ' .. plate, 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, TargetPlayer.PlayerData.charinfo.firstname .. ' nu are cheile mașinii cu plăcuța ' .. plate, 'error')
        end
    end, plate)
end, 'admin')

-- Export functions for other resources
exports('IsVehicleOwned', IsVehicleOwned)
exports('GetVehicleOwner', GetVehicleOwner)
exports('GiveVehicleKey', GiveVehicleKey)
exports('RemoveVehicleKey', RemoveVehicleKey)

-- Vehicle spawn events (for job vehicles, etc.)
RegisterNetEvent('qb-vehiclekeys:server:GiveKeysForSpawnedVehicle', function(plate)
    local source = source
    -- This event can be triggered when a vehicle is spawned for a player
    -- Useful for job vehicles, rental cars, etc.
    TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
end)

-- Player loaded event
RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
    -- When player loads, you might want to give them keys for their owned vehicles
    -- This is optional and depends on your server's needs
end)

-- Player logout event
RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    -- Clean up any temporary key data if needed
end)
