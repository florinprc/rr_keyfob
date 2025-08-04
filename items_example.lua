-- ========================================
-- QB-CORE ITEMS FOR QB-VEHICLEKEYS
-- ========================================
-- Adaugă aceste items în qb-core/shared/items.lua
-- ========================================

-- Vehicle Key Item
['vehicle_key'] = {
    ['name'] = 'vehicle_key',
    ['label'] = 'Cheie Mașină',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'vehicle_key.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'O cheie pentru o mașină specifică'
},

-- Key Fob Item
['keyfob'] = {
    ['name'] = 'keyfob',
    ['label'] = 'Key Fob',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'keyfob.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Un key fob pentru controlul mașinii'
},

-- ========================================
-- EXEMPLE DE ITEMS CU METADATA
-- ========================================
-- Acestea sunt exemple de cum să creezi items cu metadata
-- pentru chei specifice unor mașini

-- Cheie pentru o mașină specifică (exemplu)
['vehicle_key_ABC123'] = {
    ['name'] = 'vehicle_key_ABC123',
    ['label'] = 'Cheie Mașină ABC123',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'vehicle_key.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Cheie pentru mașina cu plăcuța ABC123',
    ['info'] = {
        ['plate'] = 'ABC123',
        ['vehicle'] = 'adder',
        ['owner'] = 'citizenid_example'
    }
},

-- ========================================
-- FUNCȚIE PENTRU CREAREA CHEILOR
-- ========================================
-- Adaugă această funcție în qb-core/server/items.lua
-- sau într-un script separat

-- Funcție pentru a crea o cheie pentru o mașină
function CreateVehicleKey(plate, vehicle, owner)
    local keyName = 'vehicle_key_' .. plate:gsub('%s+', '')
    local keyInfo = {
        plate = plate,
        vehicle = vehicle,
        owner = owner,
        created = os.time()
    }
    
    return {
        name = keyName,
        amount = 1,
        info = keyInfo,
        type = 'item',
        slot = nil
    }
end

-- Funcție pentru a crea un key fob pentru o mașină
function CreateKeyFob(plate, vehicle, owner)
    local fobName = 'keyfob_' .. plate:gsub('%s+', '')
    local fobInfo = {
        plate = plate,
        vehicle = vehicle,
        owner = owner,
        created = os.time(),
        battery = 100
    }
    
    return {
        name = fobName,
        amount = 1,
        info = fobInfo,
        type = 'item',
        slot = nil
    }
end

-- ========================================
-- EXEMPLE DE UTILIZARE
-- ========================================

-- Exemplu de cum să dai o cheie unui jucător
-- În server.lua sau într-un script de job

--[[
-- Pentru un job de taxi
RegisterNetEvent('taxi:giveVehicleKey', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player.PlayerData.job.name == 'taxi' then
        local keyItem = CreateVehicleKey(plate, 'taxi', Player.PlayerData.citizenid)
        Player.Functions.AddItem(keyItem.name, 1, false, keyItem.info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[keyItem.name], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'Ai primit cheile mașinii de taxi', 'success')
    end
end)

-- Pentru un job de poliție
RegisterNetEvent('police:giveVehicleKey', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player.PlayerData.job.name == 'police' then
        local keyItem = CreateVehicleKey(plate, 'police_car', Player.PlayerData.citizenid)
        Player.Functions.AddItem(keyItem.name, 1, false, keyItem.info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[keyItem.name], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'Ai primit cheile mașinii de poliție', 'success')
    end
end)

-- Pentru un job de mecanic
RegisterNetEvent('mechanic:giveVehicleKey', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player.PlayerData.job.name == 'mechanic' then
        local keyItem = CreateVehicleKey(plate, 'mechanic_truck', Player.PlayerData.citizenid)
        Player.Functions.AddItem(keyItem.name, 1, false, keyItem.info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[keyItem.name], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'Ai primit cheile camionului de mecanic', 'success')
    end
end)
--]]

-- ========================================
-- COMENZI ADMIN PENTRU TESTARE
-- ========================================

-- Comandă pentru a crea o cheie de test
QBCore.Commands.Add('createkey', 'Creează o cheie pentru o mașină (Admin Only)', {{name = 'plate', help = 'Plăcuța mașinii'}}, true, function(source, args)
    local src = source
    local plate = args[1]
    
    if not plate then
        TriggerClientEvent('QBCore:Notify', src, 'Sintaxă: /createkey [plate]', 'error')
        return
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    local keyItem = CreateVehicleKey(plate, 'test_vehicle', Player.PlayerData.citizenid)
    
    Player.Functions.AddItem(keyItem.name, 1, false, keyItem.info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[keyItem.name], 'add')
    TriggerClientEvent('QBCore:Notify', src, 'Ai creat o cheie pentru mașina cu plăcuța ' .. plate, 'success')
end, 'admin')

-- Comandă pentru a crea un key fob de test
QBCore.Commands.Add('createfob', 'Creează un key fob pentru o mașină (Admin Only)', {{name = 'plate', help = 'Plăcuța mașinii'}}, true, function(source, args)
    local src = source
    local plate = args[1]
    
    if not plate then
        TriggerClientEvent('QBCore:Notify', src, 'Sintaxă: /createfob [plate]', 'error')
        return
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    local fobItem = CreateKeyFob(plate, 'test_vehicle', Player.PlayerData.citizenid)
    
    Player.Functions.AddItem(fobItem.name, 1, false, fobItem.info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[fobItem.name], 'add')
    TriggerClientEvent('QBCore:Notify', src, 'Ai creat un key fob pentru mașina cu plăcuța ' .. plate, 'success')
end, 'admin')

-- ========================================
-- NOTIFICĂRI
-- ========================================
-- Asigură-te că ai imaginile pentru items în qb-inventory/html/images/
-- vehicle_key.png și keyfob.png

-- ========================================
-- IMPORTANT
-- ========================================
-- 1. Adaugă items-urile în qb-core/shared/items.lua
-- 2. Adaugă imaginile în qb-inventory/html/images/
-- 3. Repornește serverul
-- 4. Testează cu comenzile admin
-- 5. Integrează cu job-urile tale