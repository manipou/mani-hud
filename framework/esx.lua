local Config = lib.load('config')
if Config.Framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()
local Hud = lib.load('main')

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    CreateThread(function()
        while not DoesEntityExist(PlayerPedId()) do Wait(100) end
        Hud:Initiate()
    end)
end)

AddEventHandler("esx_status:onTick", function(data)
	for i = 1, #data do
		if data[i].name == "hunger" then
			Hud.Hunger = math.floor(data[i].percent)
        elseif data[i].name == "thirst" then
			Hud.Thirst = math.floor(data[i].percent)
        end
	end
end)

local function GetAccounts(accounts)
    local Accounts = {}
    for i = 1, #accounts do
        Accounts[accounts[i].name] = accounts[i].money
    end
    return Accounts
end

function Hud:GetFuel()
    if not cache.vehicle then return 0 end
    return Entity(cache.vehicle).state.fuel
end

function Hud:UpdatePlayerData()
    local PlayerData = ESX.GetPlayerData()
    local Job = PlayerData.job
    local Accounts = GetAccounts(PlayerData.accounts)

    self.PlayerData = {
        Job = Job.label,
        Grade = Job.grade_label,
        Money = math.floor(Accounts.money),
        BlackMoney = math.floor(Accounts.black_money),
        Bank = math.floor(Accounts.bank)
    }
end