local this = FX.Functions()

-- Events Module

-- Notification Event
RegisterNetEvent('fx:notification', function(text, type)
    FX.Notification(text, type)
end)

-- Callbacks Event
RegisterNetEvent('fx:callback:useClient', function(name, ...)
    if FX.Callbacks[name] then
        FX.Callbacks[name](...)
        FX.Callbacks[name] = nil
    end
end)

-- Vehicles Events
RegisterNetEvent('fx:vehicle:create', function(vehicle)
    local model = GetHashKey(vehicle)

    local ply = PlayerPedId()
    local plyc, plyh = GetEntityCoords(ply), GetEntityHeading(ply)

    if ply and plyc then
        this:Vehicle().create(model, plyc, plyh, function(veh)
            TaskWarpPedIntoVehicle(ply, veh, -1)

            FX.Notification('¡Has spawneado un '..vehicle..'!', 'success')
        end)
    end
end)

RegisterNetEvent('fx:vehicle:delete', function()
    local ply = PlayerPedId()
    local vehicle = nil

    if IsPedInAnyVehicle(ply, true) then
        vehicle = GetVehiclePedIsIn(ply, false)

        if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
            DeleteEntity(vehicle)

            FX.Notification('¡Vehículo eliminado!', 'error')
        end
    else
        FX.Notification('¡Necesitas estar montado en un vehículo!', 'error')
    end
end)