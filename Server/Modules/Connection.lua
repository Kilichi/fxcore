-- Connection Module

RegisterNetEvent('playerJoining', function(source)
    local src = source
    local fx = FX.Functions(src)

    fx:Identifier().getSteam(function(steam)
        if steam and string.sub(steam, 1, string.len("steam:")) == "steam:" then
            fx:Connection().checkPlayer(steam, function(exists)
                if not exists then
                    fx:Connection().createPlayer(function(done)
                        if done then
                            fx:Connection().addPlayer()
                        end
                    end)
                else
                    fx:Connection().addPlayer()
                end
            end)
        else
            DropPlayer(src, 'Your steam identifier was not found, try restarting FiveM or start Steam')
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

RegisterCommand('test', function(source)
    local src = source
    local fx = FX.Functions(src)

    fx:Identifier().getSteam(function(steam)
        if steam and string.sub(steam, 1, string.len("steam:")) == "steam:" then
            fx:Connection().checkPlayer(steam, function(exists)
                if not exists then
                    fx:Connection().createPlayer(function(done)
                        if done then
                            fx:Connection().addPlayer()
                        end
                    end)
                else
                    fx:Connection().addPlayer()
                end
            end)
        else
            DropPlayer(src, 'Your steam identifier was not found, try restarting FiveM or start Steam')
        end
    end)
end)