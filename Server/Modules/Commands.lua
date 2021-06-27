local this = FX.Functions()

-- Commands Module

-- Rank Commands

this:Commands().Register('rank', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Global().triggerEvent('fx:notification', src, 'Tu rango es: '..ply.rank, 'inform')
end)

this:Commands().Register('addrank', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('developer', function(result)
        if result then
            local osrc = tonumber(args[1])
            local oply = FX.GetPlayerById(osrc)
            
            if osrc then
                if osrc ~= src then
                    oply:Rank().set(args[2], function(done)
                        if done then
                            oply:Global().triggerEvent('fx:notification', src, '¡El administrador '..ply:Player().getName()..' te ha puesto el rango '..args[2]..'!', 'inform')
                            ply:Global().triggerEvent('fx:notification', src, '¡Le has puesto a '..oply:Player().getName()..' el rango '..args[2]..'!', 'inform')
                        else
                            ply:Global().triggerEvent('fx:notification', src, '¡Ha ocurrido un error, contacta con un programador!', 'error')
                        end
                    end)
                else
                    ply:Global().triggerEvent('fx:notification', src, '¡No puedes cambiar tu rango!', 'error')
                end
            else
                ply:Global().triggerEvent('fx:notification', src, '¡Este jugador no está en el servidor!', 'error')
            end
        else
            ply:Global().triggerEvent('fx:notification', src, '¡No tienes permisos para utilizar este comando!', 'error')
        end
    end)
end)

this:Commands().Register('removerank', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('developer', function(result)
        if result then
            local osrc = tonumber(args[1])
            local oply = FX.GetPlayerById(osrc)
            
            if osrc then
                if osrc ~= src then
                    oply:Rank().remove(function(done)
                        if done then
                            oply:Global().triggerEvent('fx:notification', src, '¡El administrador '..ply:Player().getName()..' te ha quitado tu rango!', 'inform')
                            ply:Global().triggerEvent('fx:notification', src, '¡Le has quitado el rango a '..oply:Player().getName(), 'inform')
                        else
                            ply:Global().triggerEvent('fx:notification', src, '¡Ha ocurrido un error, contacta con un programador!', 'error')
                        end
                    end)
                else
                    ply:Global().triggerEvent('fx:notification', src, '¡No puedes cambiar tu rango!', 'error')
                end
            else
                ply:Global().triggerEvent('fx:notification', src, '¡Este jugador no está en el servidor!', 'error')
            end
        else
            ply:Global().triggerEvent('fx:notification', src, '¡No tienes permisos para utilizar este comando!', 'error')
        end
    end)
end)

-- Weapon Commands (TEST)

this:Commands().Register('giveweapon', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('admin', function(result)
        if result then
            ply:Global().triggerEvent('fx:weapon:add', src, tostring(args[1]), tonumber(args[2]))
        else
            ply:Global().triggerEvent('fx:notification', src, 'No tienes permisos para utilizar este comando', 'error')
        end
    end)
end)

this:Commands().Register('giveammo', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('admin', function(result)
        if result then
            ply:Global().triggerEvent('fx:weapon:addAmmo', src, tonumber(args[1]))
        else
            ply:Global().triggerEvent('fx:notification', src, 'No tienes permisos para utilizar este comando', 'error')
        end
    end)
end)

-- Teleport Commands

this:Commands().Register('tpm', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('mod', function(result)
        if result then
            ply:Global().triggerEvent('fx:teleport:waypoint', src)
        else
            ply:Global().triggerEvent('fx:notification', src, 'No tienes permisos para utilizar este comando', 'error')
        end
    end)
end)

-- Vehicle Commands

this:Commands().Register('car', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('mod', function(result)
        if result then
            if args[1] ~= nil then
                ply:Global().triggerEvent('fx:vehicle:create', src, args[1])
            else
                ply:Global().triggerEvent('fx:vehicle:create', src, 't20')
            end
        else
            ply:Global().triggerEvent('fx:notification', src, 'No tienes permisos para utilizar este comando', 'error')
        end
    end)
end)

this:Commands().Register('dv', function(source, args)
    local src = source
    local ply = FX.GetPlayerById(src)

    ply:Rank().check('mod', function(result)
        if result then
            ply:Global().triggerEvent('fx:vehicle:delete', src)
        else
            ply:Global().triggerEvent('fx:notification', src, 'No tienes permisos para utilizar este comando', 'error')
        end
    end)
end)

