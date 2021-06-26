FX = {}

FX.Players = {}
FX.Commands = {}

-- Server Events

RegisterNetEvent('fx:get', function(cb)
    if cb then
        return cb(FX)
    else
        return FX
    end
end)

RegisterNetEvent('fx:load', function()
    local src = source
    local this = FX.Functions(src)

    this:Connection().checkPlayer(steam, function(exists)
        if not exists then
            this:Connection().createPlayer(function(done)
                if done then
                    this:Connection().addPlayer()
                end
            end)
        else
            this:Connection().addPlayer()
        end
    end)
end)