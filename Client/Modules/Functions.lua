-- Notification Functions

FX.Notification = function(text, type, length, style, cb)
    if text then
        SendNUIMessage({
            text = text,
            type = type,
        })

        if cb then
            return cb(true)
        else
            return true
        end
    else
        if cb then
            return cb(false)
        else
            return false
        end
    end
end

-- Callbacks Functions

FX.UseCallback = function(name, cb, ...)
    FX.Callbacks[name] = cb

    TriggerServerEvent('fx:callback:useServer', name, ...)
end

-- Data Functions

FX.GetData = function()
    return FX.Data
end

-- Functions Module

FX.Functions = function()
    local this = {}

    -- Entity Functions
    this.Entity = function()
        local entity = {}

        entity.teleport = function(entity, coords, cb)
            if DoesEntityExist(entity) then
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                local timeout = 0
        
                -- we can get stuck here if any of the axies are "invalid"
                while not HasCollisionLoadedAroundEntity(entity) and timeout < 2000 do
                    Citizen.Wait(0)
                    timeout = timeout + 1
                end
        
                SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        
                if type(coords) == 'table' and coords.heading then
                    SetEntityHeading(entity, coords.heading)
                end
            end
        
            if cb then
                cb()
            end
        end

        return entity
    end

    -- Pvp Functions
    this.Pvp = function()
        local pvp = {}

        pvp.active = function()
            SetCanAttackFriendly(PlayerPedId(), true, false)
	        NetworkSetFriendlyFireOption(true)
        end

        return pvp
    end

    -- Wanted Functions
    this.Wanted = function()
        local wanted = {}

        wanted.desactive = function()
            ClearPlayerWantedLevel(PlayerId())
	        SetMaxWantedLevel(0)
        end

        return wanted
    end

    -- Render Functions
    this.Render = function()
        local render = {}
        
        render.drawMarker = function(type, coords, r, g, b)
            DrawMarker(type, coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, r, g, b, 100, false, true, 2, true, false, false, false)
        end

        render.drawText = function(text)
            if text then
                SetTextFont(0)
                SetTextProportional(0)
                SetTextScale(0.32, 0.32)
                SetTextColour(0, 255, 255, 255)
                SetTextDropShadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(1)
                SetTextEntry("STRING")
                AddTextComponentString(text or 'No hay texto brow')
                DrawText(0.5, 0.93)
            end
        end

        return render
    end

    -- Vehicle Functions
    this.Vehicle = function()
        local vehicle = {}

        -- Function from es_extended (ESX.Game.SpawnVehicle)
        vehicle.create = function(modelName, coords, heading, cb)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        
            Citizen.CreateThread(function()
                RequestModel(model)

                while not HasModelLoaded(model) do
                    Citizen.Wait(1)
                end
        
                local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
                local networkId = NetworkGetNetworkIdFromEntity(vehicle)
                local timeout = 0
        
                SetNetworkIdCanMigrate(networkId, true)
                SetEntityAsMissionEntity(vehicle, true, false)
                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                SetVehicleNeedsToBeHotwired(vehicle, false)
                SetVehRadioStation(vehicle, 'OFF')
                SetModelAsNoLongerNeeded(model)
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)

                while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
                    Citizen.Wait(0)
                    timeout = timeout + 1
                end
        
                if cb then
                    cb(vehicle)
                end
            end)
        end

        return vehicle
    end

    return this
end