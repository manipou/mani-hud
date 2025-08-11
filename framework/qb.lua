local Config = lib.load('config')
if Config.Framework ~= 'qb' then return end

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(function()
        while not DoesEntityExist(PlayerPedId()) do Wait(100) end
        Mani_Hud:Initiate()
    end)
end)

CreateThread(function()
    local PlayerData = QBCore.Functions.GetPlayerData()

    if next(PlayerData) then
        Wait(250)
        Mani_Hud:Initiate()
    end
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    Mani_Hud.Hunger = newHunger
    Mani_Hud.Thirst = newThirst
end)

local function GetBlackMoney(Inventory) -- Yes this is weird, yes qbcore is ass
    local BlackMoney = 0

    for i = 1, #Inventory do
        local Item = Inventory[i]
        if Item and Item.name == 'markedbills' then
            BlackMoney = Item.info.worth * Item.amount
        end
    end

    return BlackMoney
end

function Mani_Hud:GetFuel()
    if not cache.vehicle then return 0 end
    return Entity(cache.vehicle).state.fuel
end

function Mani_Hud:UpdatePlayerData()
    local PlayerData = QBCore.Functions.GetPlayerData()

    local Job = PlayerData.job
    local Accounts = PlayerData.money

    self.PlayerData = {
        Job = Job.label,
        Grade = Job.grade.name,
        Money = math.floor(Accounts.cash),
        BlackMoney = math.floor(GetBlackMoney(PlayerData.items)),
        Bank = math.floor(Accounts.bank)
    }
end

function Mani_Hud:UpdateAmmo(Ped, Weapon)
    local _, ammo = GetAmmoInClip(Ped, Weapon)
    self.Ammo = ammo
    self.MaxAmmo = GetAmmoInPedWeapon(Ped, Weapon) - ammo
end

RegisterNetEvent('pma-voice:setTalkingMode', function(range)
    Mani_Hud.VoiceRange = range
end)