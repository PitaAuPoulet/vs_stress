local currentStress = 0

Citizen.CreateThread(function()
    while true do
        -- On attend le temps défini dans le config (optimisation des performances)
        Citizen.Wait(Config.CheckTime)
        
        local playerPed = PlayerPedId()

        -- CONDITION PRINCIPALE : LE JOUEUR EST EN VOITURE
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6

            -- BLOC A : CALCUL DU STRESS (MONTÉE ET DESCENTE)
            if speed > Config.LimitSpeed then 
                currentStress = currentStress + Config.StressAdd
                
                -- On limite le maximum
                if currentStress > Config.MaxStress then 
                    currentStress = Config.MaxStress 
                end

            elseif speed < 20 and currentStress > 0 then
                -- On décompresse si on roule doucement ou à l'arrêt
                currentStress = currentStress - 1
                if currentStress < 0 then currentStress = 0 end
            end

            -- BLOC B : GESTION DES EFFETS VISUELS
            
            -- 1. Le tremblement (Shake)
            if currentStress > 10 then
                if not IsGameplayCamShaking() then
                    ShakeGameplayCam('ROAD_VIBRATION_SHAKE', 1.0)
                end
            else
                StopGameplayCamShaking(true)
            end

            -- 2. Le flou de panique (FocusOut)
            if currentStress > Config.HighStressLevel then
                if not AnimpostfxIsRunning('FocusOut') then
                    AnimpostfxPlay('FocusOut', 0, true)
                end
            else
                if AnimpostfxIsRunning('FocusOut') then
                    AnimpostfxStop('FocusOut')
                end
            end

            -- DEBUG CONSOLE (F8)
            if Config.Debug then
                print("Vitesse: " .. math.floor(speed) .. " km/h | Stress Actuel: " .. currentStress)
            end

        else
            -- SI LE JOUEUR SORT DU VÉHICULE
            -- Le stress descend lentement à pied pour l'immersion
            if currentStress > 0 then
                currentStress = currentStress - 0.5
            end
            
            -- On coupe les effets visuels immédiatement par sécurité
            if IsGameplayCamShaking() then
                StopGameplayCamShaking(true)
            end
            if AnimpostfxIsRunning('FocusOut') then
                AnimpostfxStop('FocusOut')
            end
        end 
    end
end)
