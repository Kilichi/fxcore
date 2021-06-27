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

-- Teleport Events
RegisterNetEvent('fx:teleport:waypoint', function()
    if DoesBlipExist(GetFirstBlipInfoId(8)) then
        local wc = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), wc.x, wc.y, height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(wc.x, wc.y, height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), wc.x, wc.y, height + 0.0)

                break
            end

            Citizen.Wait(5)
        end

        FX.Notification('Te has teletransportado', 'success')
    else
        FX.Notification('No tienes ningún waypoint marcado en el mapa', 'error')
    end
end)

-- Weapons Events
RegisterNetEvent('fx:weapon:add', function(weapon, ammo)
	local ply = PlayerPedId()
	local hash = GetHashKey(weapon)

    GiveWeaponToPed(ply, hash, ammo, false, false)
    FX.Notification('¡Se te ha agregado un arma al inventario! ('..weapon..')', 'success')
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