-- Constantes para os nomes das Convars
-- Define os nomes das variáveis de configuração do servidor
local CONVAR_NAMES = {
    DEFAULT_LEVEL = "torque_DefaultLevel",
    TOGGLE_KEY = "torque_toggleKey",
    DRAW_DEBUG = "torque_DrawDebug",
    POWER = "torque_Power",
    TORQUE = "torque_Torque",
    ANGLE = "torque_Angle",
    SPEED = "torque_Speed"
}

local defaultLevel = 0
local drawDebug = false
local enableKey = true
local toggleKey = 166
local power_adj = 100.0
local torque_adj = 80.0
local angle_impact = 350.0
local speed_impact = 200.0


function GetConvars()
    -- Obtém os valores das configurações do servidor
    defaultLevel = GetConvarInt(CONVAR_NAMES.DEFAULT_LEVEL, 0)
    
    local toggleKeyValue = GetConvarInt(CONVAR_NAMES.TOGGLE_KEY, 166)
    enableKey = toggleKeyValue ~= 0
    toggleKey = enableKey and toggleKeyValue or 0
    
    drawDebug = GetConvar(CONVAR_NAMES.DRAW_DEBUG, "false") == "true"
    
    power_adj = GetConvarInt(CONVAR_NAMES.POWER, 100)    
    torque_adj = GetConvarInt(CONVAR_NAMES.TORQUE, 80)    
    angle_impact = GetConvarInt(CONVAR_NAMES.ANGLE, 350)
    speed_impact = GetConvarInt(CONVAR_NAMES.SPEED, 200)
end
	
Citizen.CreateThread(function()
    -- Cria um evento para enviar as configurações para o cliente
	RegisterServerEvent("torque:plsgibconfig")
	AddEventHandler("torque:plsgibconfig", function()
		GetConvars()
		local config = {defaultLevel=defaultLevel,drawDebug=drawDebug,enableKey=enableKey,toggleKey=toggleKey,power_adj=power_adj,torque_adj=torque_adj,angle_impact=angle_impact,speed_impact=speed_impact}
		TriggerClientEvent("torque:plsgibconfig", source, config)
	end)
end)