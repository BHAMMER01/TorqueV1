-- Constantes globais
-- Define o valor de PI para cálculos matemáticos
local PI = 3.14159265

-- Função para exibir texto de ajuda na tela
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Inicialização de variáveis
local speed = 0.0
local rel_vector = { 0.0, 0, 0.0, 0, 0.0, 0 }
local angle = 0.0

base = 35.0;
power_adj = 1.0;
torque_adj = 1.0;
angle_impact = 3.0;
speed_impact = 2.0;

speed_mult = 0.0;
power_mult = 1.0;
torque_mult = 1.0;

accelval = 127;
brakeval = 127;

disablep = 0;
disablet = 0;


power_adj = 100.0
torque_adj = 80.0
angle_impact = 350.0
speed_impact = 200.0
base = 35.0
deadzone = 25.0


-- Configurações dos modos
levels = {
    [0] = { 
        name="PADRAO 25", 
        deadzone = 25.0,  -- Ângulo mínimo para ativação
        power_factor = 1.0,  -- Multiplicador de potência
        torque_factor = 1.0  -- Multiplicador de torque
    },
    [1] = { 
        name="SENSIVEL 15", 
        deadzone = 15.0,
        power_factor = 1.2,
        torque_factor = 1.1
    },
    [2] = { 
        name="DRIFT 10", 
        deadzone = 10.0,
        power_factor = 1.4,
        torque_factor = 1.3
    },
    [3] = { 
        name="DESATIVADO 180", 
        deadzone = 180.0,
        power_factor = 0.0,
        torque_factor = 0.0
    }
}
curLevel = 0
maxLevel = #levels+1 -- one level aboth the last level
control = 166
enableKey = true

RegisterNetEvent("torque:SetLevel")


AddEventHandler("torque:SetLevel", function(level)
	curLevel = level
	deadzone = levels[level].deadzone
	name = levels[level].name
	DisplayHelpText("torque: "..levels[level].name)
end)



Citizen.CreateThread( function()
	Wait(10)
	RegisterNetEvent("torque:plsgibconfig")
	AddEventHandler("torque:plsgibconfig", function(config)
		curLevel = config.defaultLevel
		deadzone = levels[curLevel].deadzone
		name = levels[curLevel].name
		drawDebug = config.drawDebug
		enableKey = config.enableKey
		control = config.toggleKey
		power_adj = config.power_adj+.0
		torque_adj = config.torque_adj+.0
		angle_impact = config.angle_impact+.0
		speed_impact = config.speed_impact+.0
	end)
	TriggerServerEvent("torque:plsgibconfig")
	
	while true do
		ped = PlayerPedId()
		veh = GetVehiclePedIsUsing( ped )
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and DoesEntityExist(veh) and GetPedInVehicleSeat(veh, -1) == ped then
			if IsControlJustReleased(0, control) and enableKey then
				curLevel = curLevel+1
				if curLevel == maxLevel then
					curLevel = 0
				end
				deadzone = levels[curLevel].deadzone
				name = levels[curLevel].name
				DisplayHelpText("torque: "..name)
			end
		end
		Citizen.Wait( 0 )
	end
end )

Citizen.CreateThread(function()
	while true do
		player = PlayerId()
		playerPed = PlayerPedId()
		valid = true -- stupid workaround because my brain broke
		
		if not DoesEntityExist(playerPed) or not IsPlayerControlOn(player) then
			valid = false
		end
		
		if IsEntityDead(playerPed) then
			valid = false
		end
		
		if not GetVehiclePedIsUsing(playerPed) then
			valid = false
		end
		
		vehicle = GetVehiclePedIsUsing(playerPed)
		if not IsThisModelACar( GetEntityModel(vehicle)) then
			valid = false
		end
		Wait(100)
	end

end)

-- Otimização do cálculo de ângulo e multiplicadores
-- Constantes baseadas no handling do Nissan 350Z
local BASE_ANGLE = 35.0
local MAX_ANGLE = 80.0
local CONTROL_ACCEL = 71
local CONTROL_BRAKE = 72

-- Função para obter valores do handling do veículo
local function GetVehicleHandlingValues(vehicle)
    local handling = {
        mass = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fMass") or 3200.0,
        driveForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce") or 0.4,
        brakeForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce") or 0.7,
        tractionCurveLateral = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral") or 35.0,
        suspensionForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionForce") or 2.0
    }
    return handling
end

-- Ajustar função calculateMultipliers para usar valores do handling
-- Função para calcular os multiplicadores de potência e torque
local function calculateMultipliers()
    local handling = GetVehicleHandlingValues(vehicle)
    
    if speed < BASE_ANGLE then
        speed_mult = (BASE_ANGLE - speed) / BASE_ANGLE
    else 
        speed_mult = 0.0
    end
    
    -- Usar valores do handling como base
    local angle_factor = angle / 90
    local impact_factor = (angle_factor * angle_impact) + (angle_factor * speed_mult * speed_impact)
    
    -- Ajustar multiplicadores baseados no handling
    local mode_power = levels[curLevel].power_factor
    local mode_torque = levels[curLevel].torque_factor
    
    -- Cálculo progressivo do power_mult
    local base_power = (1.0 + power_adj * impact_factor) / handling.mass
    power_mult = base_power * (1.0 + (speed_mult * mode_power))
    
    -- Cálculo progressivo do torque_mult
    local base_torque = (1.0 + torque_adj * impact_factor) / handling.mass
    torque_mult = base_torque * (1.0 + (speed_mult * mode_torque))
    
    -- Limita os multiplicadores para evitar valores extremos
    power_mult = math.min(math.max(power_mult, 0.1), 5.0)
    torque_mult = math.min(math.max(torque_mult, 0.1), 5.0)
end

-- Adicionar função para ajustar valores de handling
local function AdjustVehicleHandling(vehicle, fieldName, value)
    local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    SetVehicleHandlingFloat(vehicle, "CHandlingData", fieldName, value)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        if valid then
            if base < 0.0 then base = BASE_ANGLE end
            
            speed = GetEntitySpeed(vehicle)
            rel_vector = GetEntitySpeedVector(vehicle, true)
            
            -- Cálculo de ângulo otimizado
            if speed > 0.0001 then
                angle = math.acos(rel_vector.y / speed) * 180 / PI
                if type(angle) ~= "number" or angle ~= angle then angle = 0.0 end
            else
                angle = 0.0
            end
            
            calculateMultipliers()
            
            -- Remover controle de direção durante derrapagem
            accelval = GetControlValue(0, CONTROL_ACCEL)
            brakeval = GetControlValue(0, CONTROL_BRAKE)
            local steeringLock = 35.0  -- Initialize with default value
            steeringLock = math.min(steeringLock, 70.0)  -- Novo limite máximo de steering lock
            -- Adicionar função DrawHudText no início do arquivo, após as constantes
            -- Adicionar função DrawHudText no início do arquivo, após as constantes
            function DrawHudText(text, color, x, y, scale, center)
                SetTextFont(4)
                SetTextProportional(0)
                SetTextScale(scale, scale)
                SetTextColour(color[1], color[2], color[3], color[4])
                SetTextDropShadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(center)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentSubstringPlayerName(text)
                EndTextCommandDisplayText(x, y)
            end
            
            -- Na parte onde mostra o debug, substitua o bloco if drawDebug então por:
            if drawDebug then
                local speed_kmh = speed * 3.6 -- Converter para km/h
                local mode_info = levels[curLevel].name
                
                DrawHudText(string.format(
                    "Modo: %s\n" ..
                    "Velocidade: %.1f km/h\n" ..
                    "Ângulo: %.1f°\n" ..
                    "Zona Morta: %.1f\n" ..
                    "Acelerador: %d%%\n" ..
                    "Freio: %d%%\n" ..
                    "Mult. Potência: %.2fx\n" ..
                    "Mult. Torque: %.2fx",
                    mode_info,
                    speed_kmh,
                    angle,
                    deadzone,
                    math.floor((accelval/255)*100),
                    math.floor((brakeval/255)*100),
                    power_mult,
                    torque_mult
                ), {255, 255, 255, 255}, 0.5, 0.15, 0.4, true)
            end
            
            if angle < MAX_ANGLE and angle > deadzone and brakeval < accelval + 12 then
                if disablet == 0 then SetVehicleEngineTorqueMultiplier(vehicle, torque_mult) end
                if disablep == 0 then SetVehicleEnginePowerMultiplier(vehicle, power_mult) end
            else
                SetVehicleEnginePowerMultiplier(vehicle, 1.0)
                SetVehicleEngineTorqueMultiplier(vehicle, 1.0)
            end
            
            -- Ajustar handling baseado no modo atual e ângulo
            local steeringLock = 35.0  -- Valor base
            if angle > deadzone then
                -- Aumentar o steering lock proporcionalmente ao ângulo
                steeringLock = steeringLock + (angle - deadzone) * 0.5
                steeringLock = math.min(steeringLock, 60.0)  -- Limite máximo
            end

            if curLevel == 1 then  -- Modo SENSIVEL
                AdjustVehicleHandling(vehicle, "fSteeringLock", steeringLock)
                AdjustVehicleHandling(vehicle, "fTractionCurveLateral", 30.0)
            elseif curLevel == 2 then  -- Modo Drift
                AdjustVehicleHandling(vehicle, "fSteeringLock", steeringLock)
                AdjustVehicleHandling(vehicle, "fTractionCurveLateral", 25.0)
            else  -- Modo PADRAO
                AdjustVehicleHandling(vehicle, "fSteeringLock", steeringLock)
                AdjustVehicleHandling(vehicle, "fTractionCurveLateral", 35.0)
            end
        end
    end
end)