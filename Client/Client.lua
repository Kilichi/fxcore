FX = {}

-- Client Events

AddEventHandler('fx:get', function(cb)
    if cb then
        return cb(FX)
    else
        return FX
    end
end)