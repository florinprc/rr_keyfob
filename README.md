<div align='center'><h3><a href="https://discord.gg/RsWzxwtAY3">Discord</a></h3></div>

# qb-vehiclekeys

Un sistem avansat de gestionare a cheilor de mașini pentru QBCore FiveM cu interfață modernă și funcționalități complete.

## 🚗 Caracteristici

### Funcționalități Principale
- **Sistem de chei avansat** - Gestionare completă a cheilor de mașini
- **Interfață modernă** - UI frumos aranjat și prietenos
- **Control complet al mașinii** - Toate funcționalitățile într-un singur loc
- **Sistem de notificări** - Notificări în română
- **Animații și sunete** - Efecte vizuale și audio
- **Responsive design** - Funcționează pe toate rezoluțiile

### Controale Disponibile
- 🔒 **Încuietoare/Descuiere** - Control complet al încuietorilor
- 🔥 **Motor** - Pornire/oprire motor
- 📦 **Portbagaj** - Deschidere/închidere portbagaj
- 🚗 **Capotă** - Deschidere/închidere capotă
- 🪟 **Ferestre** - Control individual pentru fiecare fereastră
- 🚪 **Uși** - Control individual pentru fiecare ușă
- 🚨 **Alarmă** - Declanșare alarmă
- ⛽ **Combustibil** - Afișare nivel combustibil
- 🏃 **Viteză** - Afișare viteză curentă

## 📋 Cerințe

- **QBCore Framework** (cel mai recent)
- **oxmysql** pentru baza de date
- **FiveM Server** cu suport pentru Lua

## 🛠️ Instalare

1. **Descarcă resursa**
   ```bash
   git clone https://github.com/your-username/qb-vehiclekeys.git
   ```

2. **Mută în folderul resources**
   ```bash
   mv qb-vehiclekeys /path/to/your/server/resources/
   ```

3. **Adaugă în server.cfg**
   ```cfg
   ensure qb-vehiclekeys
   ```

4. **Configurează baza de date**
   - Asigură-te că ai `oxmysql` instalat și configurat
   - Resursa folosește tabelul `player_vehicles` din QBCore

5. **Configurează items (opțional)**
   - Adaugă item-urile `vehicle_key` și `keyfob` în `qb-core/shared/items.lua`

## ⚙️ Configurare

### Configurare de bază
Editează `config.lua` pentru a personaliza resursa:

```lua
Config = {}

-- Framework Configuration
Config.Framework = "qbcore"

-- Vehicle Control Settings
Config.preventDefaultEngineStart = true
Config.keepEngineRunning = true
Config.keepVehicleDoorOpen = true

-- Key System Settings
Config.useKeySystem = true
Config.requireKeyForStart = true
Config.requireKeyForLock = true
Config.requireKeyForTrunk = true

-- Item Configuration
Config.KeyItem = "vehicle_key"
Config.KeyfobItem = "keyfob"

-- UI Settings
Config.UISettings = {
    defaultKey = "I",
    showFuel = true,
    showSpeed = true,
    showEngine = true,
    showDoors = true,
    showWindows = true,
    showTrunk = true,
    showHood = true,
}
```

### Configurare Items (opțional)
Adaugă în `qb-core/shared/items.lua`:

```lua
['vehicle_key'] = {
    ['name'] = 'vehicle_key',
    ['label'] = 'Vehicle Key',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'vehicle_key.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A key for a specific vehicle'
},

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
    ['description'] = 'A key fob for vehicle control'
}
```

## 🎮 Utilizare

### Pentru Jucători
1. **Deschide keyfob-ul** - Apasă `I` (sau tasta configurată)
2. **Controlează mașina** - Folosește butoanele din interfață
3. **Vezi informații** - Monitorizează combustibil, viteză, status

### Pentru Admini
Comenzi disponibile:
- `/givekeys [id] [plate]` - Dă cheile unei mașini unui jucător
- `/removekeys [id] [plate]` - Confiscă cheile unei mașini
- `/checkkeys [id] [plate]` - Verifică dacă un jucător are cheile

### Pentru Dezvoltatori
Export-uri disponibile pentru alte resurse:

```lua
-- Client exports
exports['qb-vehiclekeys']:HasVehicleKey(plate)
exports['qb-vehiclekeys']:AddVehicleKey(plate)
exports['qb-vehiclekeys']:RemoveVehicleKey(plate)
exports['qb-vehiclekeys']:LockVehicle(vehicle)
exports['qb-vehiclekeys']:ToggleEngine(vehicle)
exports['qb-vehiclekeys']:ToggleTrunk(vehicle)
exports['qb-vehiclekeys']:ToggleHood(vehicle)
exports['qb-vehiclekeys']:ToggleWindow(vehicle, windowIndex)
exports['qb-vehiclekeys']:ToggleDoor(vehicle, doorIndex)
exports['qb-vehiclekeys']:TriggerAlarm(vehicle)

-- Server exports
exports['qb-vehiclekeys']:IsVehicleOwned(plate)
exports['qb-vehiclekeys']:GetVehicleOwner(plate)
exports['qb-vehiclekeys']:GiveVehicleKey(source, plate)
exports['qb-vehiclekeys']:RemoveVehicleKey(source, plate)
```

## 🎨 Personalizare

### Culori și Stil
Editează `html/main.css` pentru a personaliza aspectul:
- Culori pentru butoane
- Dimensiuni și spațiere
- Animații și efecte
- Responsive design

### Sunete
Înlocuiește fișierele din `html/sounds/`:
- `lock.ogg` - Sunet pentru încuietoare
- `unlock.ogg` - Sunet pentru descuiere
- `start.ogg` - Sunet pentru pornire motor
- `stop.ogg` - Sunet pentru oprire motor
- `trunk.ogg` - Sunet pentru portbagaj
- `window.ogg` - Sunet pentru ferestre
- `alarm.ogg` - Sunet pentru alarmă

### Locale
Editează `Config.Locales` în `config.lua` pentru a schimba mesajele:
```lua
Config.Locales = {
    ["grabbed_keys"] = "Ai luat cheile mașinii",
    ["no_key"] = "Nu ai cheile acestei mașini",
    -- ... mai multe mesaje
}
```

## 🔧 Troubleshooting

### Probleme Comune

**1. Keyfob-ul nu se deschide**
- Verifică dacă resursa este pornită în server.cfg
- Verifică dacă QBCore este instalat corect
- Verifică consola pentru erori

**2. Cheile nu funcționează**
- Verifică configurația bazei de date
- Asigură-te că tabelul `player_vehicles` există
- Verifică dacă `oxmysql` este instalat

**3. Interfața nu se afișează corect**
- Verifică dacă toate fișierele HTML/CSS/JS sunt prezente
- Verifică dacă Font Awesome se încarcă corect
- Verifică consola browser-ului pentru erori

**4. Sunetele nu funcționează**
- Verifică dacă fișierele .ogg sunt prezente în `html/sounds/`
- Verifică dacă browser-ul permite redarea audio
- Verifică dacă sunetele sunt în format corect

## 📝 Changelog

### v2.0.0
- ✨ Interfață complet nouă și modernă
- 🎨 Design responsive și prietenos
- 🔧 Sistem de chei avansat pentru QBCore
- 🎵 Sunete și animații
- 📱 Suport pentru mobile
- 🛠️ Export-uri pentru dezvoltatori
- 📊 Monitorizare combustibil și viteză
- 🚪 Control individual pentru uși și ferestre

### v1.2.2 (Original)
- Sistem de bază pentru chei
- Interfață simplă
- Suport pentru ESX și QBCore

## 🤝 Contribuții

Contribuțiile sunt binevenite! Pentru a contribui:

1. Fork repository-ul
2. Creează o branch pentru feature (`git checkout -b feature/AmazingFeature`)
3. Commit schimbările (`git commit -m 'Add some AmazingFeature'`)
4. Push la branch (`git push origin feature/AmazingFeature`)
5. Deschide un Pull Request

## 📄 Licență

Acest proiect este licențiat sub MIT License - vezi fișierul [LICENSE](LICENSE) pentru detalii.

## 🙏 Mulțumiri

- **QBCore Team** - Pentru framework-ul excelent
- **RoleplayRevisited** - Pentru versiunea originală
- **Font Awesome** - Pentru iconițele frumoase
- **Comunitatea FiveM** - Pentru suport și feedback

## 📞 Suport

Pentru suport și întrebări:
- 📧 Email: your-email@example.com
- 💬 Discord: [Link Discord]
- 🐛 Issues: [GitHub Issues](https://github.com/your-username/qb-vehiclekeys/issues)

---

**Notă:** Această resursă este optimizată pentru QBCore și poate necesita modificări pentru alte framework-uri.
