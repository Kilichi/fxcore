FX = {}

FX.Data = {}
FX.Callbacks = {}

-- Client Events

RegisterNetEvent('fx:get', function(cb)
    if cb then
        return cb(FX)
    else
        return FX
    end
end)

RegisterNetEvent('fx:spawned', function(data)
    local this = FX.Functions()
    local model = GetHashKey('a_m_m_golfer_01')

    this:Entity().teleport(PlayerPedId(), {
        x = data.position.x,
        y = data.position.y,
        z = data.position.z + 0.25,
        heading = data.position.heading
    }, function()
        FX.Data = data

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(10)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
    end)
end)