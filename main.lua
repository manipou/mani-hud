local Config = lib.load('config')

local Hud = {
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
    CrossingRoad = "",
    PlayerCount = 0,
    PlayerData = {
        Job = "",
        Grade = "",
        Money = 0,
        BlackMoney = 0,
        Bank = 0
    }
}

local function getCrossroads(Ped)
    local pos = GetEntityCoords(Ped)
    local street1 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)) or ""

    return GetStreetNameFromHashKey(street1), zone
end

function Hud:Toggle()
    self.Showing = not self.Showing
    SendNUIMessage({
        action = 'setVisible',
        data = self.Showing
    })

    if self.Showing then self:Interval() end
end

function Hud:Update()
    local Ped = cache.ped

    self.Health = math.max(0, GetEntityHealth(Ped) - 100)
    self.Armor = GetPedArmour(Ped)

    self.Heading = math.floor(360.0 - ((GetGameplayCamRot(0).z + 360.0) % 360.0))
    local StreetName, CrossingRoad = getCrossroads(Ped)

    if StreetName ~= '' then self.StreetName = StreetName end
    if CrossingRoad ~= '' then self.CrossingRoad = CrossingRoad end
    
    if self.HasWeapon then
        local Weapon = cache.weapon
        self.Weapon = Config.Weapons[Weapon] or 'Unknown Weapon'
        self.Ammo = GetAmmoInPedWeapon(Ped, Weapon)
        self.MaxAmmo = GetWeaponClipSize(Weapon)    
    end

    if self.InVehicle then
        local Vehicle = cache.vehicle
        self.Speed = GetEntitySpeed(Vehicle) * Config.SpeedMultipler
        self.Fuel = self:GetFuel()
    end

    SendNUIMessage({
        action = 'updateHud',
        data = {
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
            AlwaysCompass = self.AlwaysCompass,
            StreetName = self.StreetName,
            CrossingRoad = self.CrossingRoad
        }
    })
end

function Hud:Interval()
    CreateThread(function()
        while self.Showing do
            Wait(self.IntervalMS)   

            self:Update()
        end
    end)
end

CreateThread(function()
    SetInterval(function()
        if not Hud.Showing then return end
        Hud:UpdatePlayerData()
        SendNUIMessage({
            action = 'updateHud',
            data = {
                PlayerData = Hud.PlayerData,
                PlayerCount = GlobalState.PlayerCount
            }
        })
    end, Config.Intervals['LowPrio'])
end)

function Hud:Initiate()
    local Ped = cache.ped

    self.Showing = true
    self.Health = GetEntityHealth(Ped) - 100
    self.Armor = GetPedArmour(Ped)

    SendNUIMessage({
        action = 'updateHud',
        data = {
            Force = true,
            Health = self.Health,
            Armor = self.Armor,
            Hunger = self.Hunger,
            Thirst = self.Thirst,
            SpeedUnit = Config.SpeedUnit,
            ServerLogo = Config.ServerLogo
        }
    })

    self:Interval()
end

lib.onCache('weapon', function(Equipped, Unequipped)
    if Equipped then
        Hud.HasWeapon = true
    else
        Hud.HasWeapon = false
        Hud.Weapon = nil
        Hud.Ammo = nil
        Hud.MaxAmmo = nil
    end
end)

lib.onCache('vehicle', function(vehicle, oldVehicle)
    if vehicle then
        Hud.InVehicle = true
        Hud.IntervalMS = Config.Intervals['InVehicle']
    else
        Hud.InVehicle = false
        Hud.IntervalMS = Config.Intervals['Prio']
    end
end)

RegisterNUICallback('hideUI', function(_, cb)
    cb({})
    Hud.Showing = false
end)

RegisterCommand(Config.Commands['toggle'], function()
    Hud:Toggle()
end)

if Config.Debug then Wait(1000) Hud:Initiate() end

return Hud