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

-- Functions Module

FX.Functions = function()
    local this = {}

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