local currentStress = 0 -- On garde la variable ici pour ne pas la perdre

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.CheckTime)

        local playerped = PlayerPedId()

        -- On vérifie si le joueur est dans un véhicule
        if IsPedInAnyVehicle(playerped, false) then
            local vehicle = GetVehiclePedIsIn(playerped, false)
            local speed = GetEntitySpeed(vehicle) * 3.6

            -- Debug : On utilise la variable 'speed' qu'on vient de créer
            if Config.Debug then 
                print("Ma vitesse est de : " .. speed .. " km/h")
            end

            -- Si la vitesse dépasse la limite du config
            if speed > Config.LimitSpeed then 
                currentStress = currentStress + Config.StressAdd
                print("DEBUG: Stress Ajouté ! Stress Actuel: " .. currentStress)
            end
        end 
    end -- Fin du while
end) -- Fin du Thread
