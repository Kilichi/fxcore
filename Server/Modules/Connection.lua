-- Connection Module

RegisterNetEvent('playerConnecting', function(name, setCallback, deferrals)
    deferrals.defer()

    local src = source
    local fx = FX.Functions(src)

    fx:Identifier().getSteam(function(steam)
        if steam and string.sub(steam, 1, string.len("steam:")) == "steam:" then
            deferrals.done()
        else
            deferrals.done('Your steam identifier was not found, try restarting FiveM or start Steam')
        end
    end)
end)

RegisterNetEvent('playerDropped', function(source)
    local src = source
    local ply = FX.GetPlayerById(src)

    if ply then
        ply:Data().save(function(done)
            FX.Players[src] = nil
        end)
    end
end)