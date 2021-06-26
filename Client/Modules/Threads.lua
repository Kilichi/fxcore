-- Threads Module

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('fx:load')
            
            break
        end
    end
end)