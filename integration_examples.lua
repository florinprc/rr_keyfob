-- ========================================
-- INTEGRARE CU ALTE RESURSE QB-CORE
-- ========================================
-- Exemple de integrare cu resurse populare
-- ========================================

-- ========================================
-- QB-GARAGES INTEGRATION
-- ========================================

-- Când o mașină este scoasă din garaj, dă cheile automat
RegisterNetEvent('qb-garages:server:VehicleSpawned', function(plate, vehicle, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        -- Dă cheile mașinii jucătorului
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile mașinii cu plăcuța ' .. plate, 'success')
    end
end)

-- Când o mașină este returnată în garaj, confiscă cheile
RegisterNetEvent('qb-garages:server:VehicleStored', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        -- Confiscă cheile mașinii
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Cheile mașinii cu plăcuța ' .. plate .. ' au fost confiscate', 'info')
    end
end)

-- ========================================
-- QB-VEHICLESHOP INTEGRATION
-- ========================================

-- Când o mașină este cumpărată, dă cheile automat
RegisterNetEvent('qb-vehicleshop:server:VehiclePurchased', function(plate, vehicle, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        -- Dă cheile mașinii noi
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Felicitări! Ai primit cheile mașinii tale noi', 'success')
        
        -- Creează și un key fob
        local fobItem = CreateKeyFob(plate, vehicle, Player.PlayerData.citizenid)
        Player.Functions.AddItem(fobItem.name, 1, false, fobItem.info)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[fobItem.name], 'add')
    end
end)

-- ========================================
-- QB-MECHANICJOB INTEGRATION
-- ========================================

-- Când un mecanic repară o mașină, poate să dea cheile
RegisterNetEvent('qb-mechanicjob:server:RepairVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == 'mechanic' then
        -- Dă cheile mașinii reparate
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile mașinii reparate', 'success')
    end
end)

-- ========================================
-- QB-POLICEJOB INTEGRATION
-- ========================================

-- Când poliția confiscă o mașină, confiscă și cheile
RegisterNetEvent('qb-policejob:server:ImpoundVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == 'police' then
        -- Confiscă cheile mașinii confiscate
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Cheile mașinii confiscate au fost confiscate', 'info')
    end
end)

-- Când poliția scoate o mașină din impound, dă cheile
RegisterNetEvent('qb-policejob:server:ReleaseVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == 'police' then
        -- Dă cheile mașinii eliberate
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile mașinii eliberate', 'success')
    end
end)

-- ========================================
-- QB-TAXIJOB INTEGRATION
-- ========================================

-- Când un taxi primește o mașină de serviciu
RegisterNetEvent('qb-taxijob:server:GiveServiceVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == 'taxi' then
        -- Dă cheile mașinii de serviciu
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile mașinii de taxi', 'success')
    end
end)

-- Când un taxi termină serviciul, confiscă cheile
RegisterNetEvent('qb-taxijob:server:ReturnServiceVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == 'taxi' then
        -- Confiscă cheile mașinii de serviciu
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Cheile mașinii de taxi au fost returnate', 'info')
    end
end)

-- ========================================
-- QB-AMBULANCEJOB INTEGRATION
-- ========================================

-- Când un paramedic primește o ambulanță
RegisterNetEvent('qb-ambulancejob:server:GiveAmbulance', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == 'ambulance' then
        -- Dă cheile ambulanței
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile ambulanței', 'success')
    end
end)

-- ========================================
-- QB-BANKING INTEGRATION
-- ========================================

-- Când o mașină este confiscată pentru datorii
RegisterNetEvent('qb-banking:server:RepossessVehicle', function(plate, source)
    -- Confiscă cheile de la toți jucătorii care le au
    local Players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(Players) do
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', Player.PlayerData.source, plate)
    end
end)

-- ========================================
-- QB-PHONE INTEGRATION
-- ========================================

-- Adaugă o aplicație în telefon pentru controlul mașinii
RegisterNetEvent('qb-phone:server:AddVehicleControlApp', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        -- Adaugă aplicația în telefon
        TriggerClientEvent('qb-phone:client:AddApp', source, 'vehiclecontrol', {
            name = 'Vehicle Control',
            icon = 'fas fa-car',
            color = '#3498db'
        })
    end
end)

-- ========================================
-- QB-INVENTORY INTEGRATION
-- ========================================

-- Când un jucător folosește o cheie din inventar
QBCore.Functions.CreateUseableItem('vehicle_key', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and item.info and item.info.plate then
        -- Dă cheile mașinii
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, item.info.plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai folosit cheile mașinii cu plăcuța ' .. item.info.plate, 'success')
        
        -- Șterge item-ul din inventar
        Player.Functions.RemoveItem(item.name, 1, item.slot)
    end
end)

-- Când un jucător folosește un key fob din inventar
QBCore.Functions.CreateUseableItem('keyfob', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and item.info and item.info.plate then
        -- Dă cheile mașinii
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, item.info.plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai folosit key fob-ul pentru mașina cu plăcuța ' .. item.info.plate, 'success')
        
        -- Deschide interfața keyfob
        TriggerClientEvent('qb-vehiclekeys:client:OpenKeyfob', source)
    end
end)

-- ========================================
-- QB-CORE EVENTS INTEGRATION
-- ========================================

-- Când un jucător se conectează, dă cheile pentru mașinile sale
RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
    local src = Player.PlayerData.source
    
    -- Verifică ce mașini deține jucătorul
    local ownedVehicles = MySQL.Sync.fetchAll("SELECT plate FROM player_vehicles WHERE citizenid = ?", {Player.PlayerData.citizenid})
    
    for _, vehicle in pairs(ownedVehicles) do
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, vehicle.plate)
    end
    
    TriggerClientEvent('QBCore:Notify', src, 'Cheile mașinilor tale au fost încărcate', 'success')
end)

-- Când un jucător se deconectează, salvează cheile
RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    -- Cheile sunt deja salvate în memorie, nu trebuie să faci nimic special
end)

-- ========================================
-- CUSTOM EVENTS FOR YOUR SERVER
-- ========================================

-- Event pentru a da cheile unei mașini de job
RegisterNetEvent('jobs:server:GiveJobVehicle', function(jobName, plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == jobName then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile mașinii de ' .. jobName, 'success')
    end
end)

-- Event pentru a confisca cheile unei mașini de job
RegisterNetEvent('jobs:server:RemoveJobVehicle', function(jobName, plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == jobName then
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Cheile mașinii de ' .. jobName .. ' au fost confiscate', 'info')
    end
end)

-- Event pentru a da cheile unei mașini închiriate
RegisterNetEvent('rental:server:GiveRentalVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Ai primit cheile mașinii închiriate', 'success')
    end
end)

-- Event pentru a confisca cheile unei mașini închiriate
RegisterNetEvent('rental:server:ReturnRentalVehicle', function(plate, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
        TriggerClientEvent('QBCore:Notify', source, 'Cheile mașinii închiriate au fost returnate', 'info')
    end
end)

-- ========================================
-- EXPORT FUNCTIONS FOR OTHER RESOURCES
-- ========================================

-- Funcție pentru a verifica dacă un jucător are cheile unei mașini
exports('PlayerHasVehicleKey', function(source, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    -- Verifică dacă jucătorul deține mașina
    local result = MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ?", {Player.PlayerData.citizenid, plate})
    return #result > 0
end)

-- Funcție pentru a da cheile unei mașini unui jucător
exports('GiveVehicleKeyToPlayer', function(source, plate)
    TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
end)

-- Funcție pentru a confisca cheile unei mașini de la un jucător
exports('RemoveVehicleKeyFromPlayer', function(source, plate)
    TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
end)

-- ========================================
-- CALLBACK FUNCTIONS FOR OTHER RESOURCES
-- ========================================

-- Callback pentru a verifica dacă un jucător are cheile unei mașini
QBCore.Functions.CreateCallback('qb-vehiclekeys:server:PlayerHasVehicleKey', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then 
        cb(false)
        return
    end
    
    local result = MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ?", {Player.PlayerData.citizenid, plate})
    cb(#result > 0)
end)

-- Callback pentru a obține toate mașinile unui jucător
QBCore.Functions.CreateCallback('qb-vehiclekeys:server:GetPlayerVehicles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then 
        cb({})
        return
    end
    
    local result = MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE citizenid = ?", {Player.PlayerData.citizenid})
    cb(result)
end)

-- ========================================
-- NOTIFICĂRI
-- ========================================
-- Toate aceste exemple presupun că ai QBCore configurat corect
-- și că resursele menționate sunt instalate pe serverul tău

-- ========================================
-- IMPORTANT
-- ========================================
-- 1. Adaptează aceste exemple la nevoile tale
-- 2. Testează fiecare integrare înainte de a o folosi în producție
-- 3. Asigură-te că toate resursele sunt compatibile
-- 4. Backup-ul datelor înainte de a face modificări
-- 5. Documentează toate modificările făcute