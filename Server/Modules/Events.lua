-- Events Module

-- Callbacks Events
RegisterNetEvent('fx:callback:useServer', function(name, ...)
    local src = source
    local ply = FX.GetPlayerById(src)

    FX.UseCallback(name, src, function(...)
        ply:Global().triggerEvent('fx:callback:useClient', src, name, ...)
    end, ...)
end)