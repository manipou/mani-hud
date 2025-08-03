CreateThread(function()
    SetInterval(function()
        GlobalState.PlayerCount = #GetPlayers()
    end, 30000)
end)

lib.callback.register('mani-hud:server:getSettings', function(src)
    local HudSettings = exports['mani-bridge']:getMetaData(src, 'hud:settings', 'table')

    if next(HudSettings) then return HudSettings end
    return false
end)

RegisterNetEvent('mani-hud:server:setSettings', function(Settings)
    local src = source
    Settings.ShowMenu = false
    exports['mani-bridge']:setMetaData(src, 'hud:settings', Settings)
end)