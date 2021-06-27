FX = {}

FX.Players = {}

FX.Ranks = Config.Ranks
FX.Jobs = Config.Jobs

FX.Callbacks = {}
FX.Commands = {}
FX.Items = {}

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
    local steam = this:Identifier().getSteam()

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

-- MySQL Function

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(items)
        for b,c in pairs(items) do
            FX.Items[c.name] = c
        end
    end)
end)