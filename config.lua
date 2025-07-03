local Config = {}

Config.Debug = true

Config.Framework = 'esx'

Config.ServerLogo = 'https://files.fivemerr.com/images/ddc95af9-16d5-43c8-a264-64c500035cbb.png'

Config.SpeedUnit = 'km/t'

Config.SpeedMultipler = 3.6 -- For MPH use: 2.236936

Config.Weapons = {
    [GetHashKey('WEAPON_PISTOL')] = '9mm Pistol',
    [GetHashKey('WEAPON_PISTOL50')] = 'Pistol .50',
    [GetHashKey('WEAPON_CERAMICPISTOL')] = 'Ceramic Pistol',
}

Config.Commands = {
    ['toggle'] = 'ToggleHud'
}

Config.Intervals = {
    ['Prio'] = 800,
    ['InVehicle'] = 300,
    ['LowPrio'] = 2000
}

return Config