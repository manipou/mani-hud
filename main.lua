local Config = lib.load('config')

Mani_Hud = {
    Showing = false,
    ShowCompass = true,
    IntervalMS = Config.Intervals['Prio'],
    Health = -1,
    Armor = -1,
    Hunger = 100,
    Thirst = 100,
    HasWeapon = false,
    Weapon = "",
    Ammo = 0,
    MaxAmmo = 0,
    InVehicle = false,
    Speed = 0,
    Fuel = 100,
    Heading = 0,
    StreetName = "",
    Zone = "",
    PlayerCount = 0,
    Talking = false,
    VoiceRange = 2,
    PlayerData = {
        Job = "",
        Grade = "",
        Money = 0,
        BlackMoney = 0,
        Bank = 0
    },
    HudSettings = Config.DefaultSettings
}

local function getCrossroads(Ped)
    local pos = GetEntityCoords(Ped)
    local street1 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)) or ""

    return GetStreetNameFromHashKey(street1), zone
end

local function getHeading(Ped)
    if Mani_Hud.HudSettings.CompassMode == 'Camera' then
        return math.floor(360.0 - ((GetGameplayCamRot(0).z + 360.0) % 360.0))
    elseif Mani_Hud.HudSettings.CompassMode == 'Character' then
        return math.floor(360.0 - ((GetEntityHeading(Ped) + 360.0) % 360.0))
    end
end

function Mani_Hud:Toggle()
    self.Showing = not self.Showing
    SendNUIMessage({
        action = 'setVisible',
        data = self.Showing
    })

    if self.Showing then self:Interval() end
end

function Mani_Hud:Update()
    local Ped = cache.ped

    self.Health = math.max(0, GetEntityHealth(Ped) - 100)
    self.Armor = GetPedArmour(Ped)

    if self.HudSettings.CompassInterval == 'Low' then
        self.Heading = getHeading(Ped)
    end

    local StreetName, Zone = getCrossroads(Ped)

    if StreetName ~= '' then self.StreetName = StreetName end
    if Zone ~= '' then self.Zone = Zone end

    self.Talking = NetworkIsPlayerTalking(cache.playerId) == 1 and true or false

    if self.HasWeapon then
        local Weapon = cache.weapon
        self.Weapon = Config.Weapons[Weapon] or 'Unknown Weapon'
        Mani_Hud:UpdateAmmo(Ped, Weapon)
    end

    if self.InVehicle then
        local Vehicle = cache.vehicle
        self.Speed = GetEntitySpeed(Vehicle) * Config.SpeedMultipler
        self.Fuel = self:GetFuel()
    end

    SendNUIMessage({
        action = 'updateHud',
        data = {
            ShowCompass = self.ShowCompass,
            Health = self.Health,
            Armor = self.Armor,
            Hunger = self.Hunger,
            Thirst = self.Thirst,
            HasWeapon = self.HasWeapon,
            Weapon = self.Weapon,
            Ammo = self.Ammo,
            MaxAmmo = self.MaxAmmo,
            InVehicle = self.InVehicle,
            Speed = self.Speed,
            Fuel = self.Fuel,
            Heading = self.Heading,
            StreetName = self.StreetName,
            Zone = self.Zone,
            Talking = self.Talking,
            VoiceRange = self.VoiceRange
        }
    })
end

function Mani_Hud:Interval()
    CreateThread(function()
        while self.Showing do
            Wait(self.IntervalMS)
            
            self:Update()
        end
    end)
end

CreateThread(function()
    SetInterval(function()
        if not Mani_Hud.Showing then return end
        Mani_Hud:UpdatePlayerData()
        SendNUIMessage({
            action = 'updateHud',
            data = {
                PlayerData = Mani_Hud.PlayerData,
                PlayerCount = GlobalState.PlayerCount,
                AspectRatio = GetAspectRatio(false)
            }
        })
    end, Config.Intervals['LowPrio'])
end)

function Mani_Hud:HighCompassInterval()
    CreateThread(function()
        while self.HudSettings.CompassInterval == 'High' do
            if self.Showing and self.ShowCompass then
                local LastHeading = self.Heading
                local Ped = cache.ped

                self.Heading = getHeading(Ped)

                if LastHeading ~= self.Heading then
                    SendNUIMessage({
                        action = 'updateHud',
                        data = {
                            Heading = self.Heading
                        }
                    }) 
                end
            end

            Wait(Config.Intervals['HighCompass'])
        end
    end)
end

function Mani_Hud:Initiate()
    local Ped = cache.ped

    self.Showing = true
    self.Health = GetEntityHealth(Ped) - 100
    self.Armor = GetPedArmour(Ped)

    local HudSettings = lib.callback.await('mani-hud:server:getSettings', false)
    if HudSettings then
        self.HudSettings = HudSettings
    end

    if self.HudSettings.ShowCompass == 'on' then
        self.ShowCompass = true
    elseif self.HudSettings.ShowCompass == 'off' or self.HudSettings.ShowCompass == 'vehicle' then
        self.ShowCompass = false
    end

    if self.HudSettings.CompassInterval == 'High' then
        self:HighCompassInterval()
    end

    Mani_Hud:UpdatePlayerData()

    SendNUIMessage({
        action = 'updateHud',
        data = {
            Force = true,
            Health = self.Health,
            Armor = self.Armor,
            Hunger = self.Hunger,
            Thirst = self.Thirst,
            SpeedUnit = Config.SpeedUnit,
            ServerLogo = Config.ServerLogo,
            Id = cache.serverId,
            Currency = Config.Currency,
            AspectRatio = GetAspectRatio(false),
            HudSettings = self.HudSettings,
            PlayerData = Mani_Hud.PlayerData,
            PlayerCount = GlobalState.PlayerCount
        }
    })

    self:Interval()
end

lib.onCache('weapon', function(Equipped, Unequipped)
    if Equipped and Config.Weapons[Equipped] then
        Mani_Hud.HasWeapon = true
    else
        Mani_Hud.HasWeapon = false
        Mani_Hud.Weapon = nil
        Mani_Hud.Ammo = nil
        Mani_Hud.MaxAmmo = nil
    end
end)

lib.onCache('vehicle', function(vehicle, oldVehicle)
    if vehicle then
        Mani_Hud.InVehicle = true
        Mani_Hud.IntervalMS = Config.Intervals['InVehicle']

        if Mani_Hud.HudSettings.ShowCompass == 'vehicle' then
            Mani_Hud.ShowCompass = true
        end
    else
        Mani_Hud.InVehicle = false
        Mani_Hud.IntervalMS = Config.Intervals['Prio']

        if Mani_Hud.HudSettings.ShowCompass == 'vehicle' then
            Mani_Hud.ShowCompass = false
        end
    end
end)

RegisterNUICallback('hideUI', function(_, cb)
    cb({})
    Mani_Hud.Showing = false
end)

RegisterNUICallback('HideSettings', function(_, cb)
    Mani_Hud.HudSettings.ShowMenu = false
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback('UpdateSettings', function(data, cb)
    Mani_Hud.HudSettings = data

    if Mani_Hud.HudSettings.ShowCompass == 'vehicle' then
        if not Mani_Hud.InVehicle then
            Mani_Hud.ShowCompass = false
        end
    elseif Mani_Hud.HudSettings.ShowCompass == 'off' then
        Mani_Hud.ShowCompass = false
    elseif Mani_Hud.HudSettings.ShowCompass == 'on' then
        Mani_Hud.ShowCompass = true
    end

    cb({})
end)

RegisterNUICallback('UpdateCompassInterval', function(Setting, cb)
    Mani_Hud.HudSettings.CompassInterval = Setting

    if Setting == 'High' then
        Mani_Hud:HighCompassInterval()
    end

    cb({})
end)

RegisterNUICallback('SaveSettings', function(_, cb)
    TriggerServerEvent('mani-hud:server:setSettings', Mani_Hud.HudSettings)
    cb({})
end)

RegisterCommand(Config.Commands['toggle'], function()
    Mani_Hud:Toggle()
end)

RegisterCommand(Config.Commands['settings'], function()
    Mani_Hud.HudSettings.ShowMenu = true
    SendNUIMessage({
        action = 'updateHud',
        data = {
            HudSettings = Mani_Hud.HudSettings
        }
    })
    SetNuiFocus(true, true)
end)

RegisterKeyMapping(Config.Commands['settings'], 'Open Hud Settings', 'keyboard', Config.Keybinds['settings'])

RegisterKeyMapping(Config.Commands['toggle'], 'Toggle Hud', 'keyboard', Config.Keybinds['toggle'])

if Config.Debug then SetNuiFocus(false, false) end