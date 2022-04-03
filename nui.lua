local display = false
local lightsOn = false
local EngineAlwaysOn = false

RegisterCommand("vehremote", function(source, args)
    SetDisplay(not display)
end)

RegisterCommand("eao", function()
	if EngineAlwaysOn then
		EngineAlwaysOn = false
	else
		EngineAlwaysOn = true
	end
end)

RegisterKeyMapping('vehremote', 'Vehicle Remote', 'keyboard', '[')

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if EngineAlwaysOn then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)
			SetVehicleEngineOn(vehicle, true, true, true)
		end
	end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("togglelock", function(data)
    ExecuteCommand("_carlock")
	SetDisplay(false)
end)

RegisterNUICallback("hotwire", function(data)
    ExecuteCommand("_hotwire")
	SetDisplay(false)
end)

RegisterNUICallback("givekeys", function(data)
    ExecuteCommand("_givekeys")
	SetDisplay(false)
end)

RegisterNUICallback("carsearch", function(data)
    ExecuteCommand("_carsearch")
	SetDisplay(false)
end)

RegisterNUICallback("carmenu", function(data)
    ExecuteCommand("_carmenu")
	SetDisplay(false)
end)

RegisterNUICallback("toggleengine", function(data)
    ExecuteCommand("eng")
	notify('Engine Toggled')
	SetDisplay(false)
end)

RegisterNUICallback("headlights", function(data)
    if lightsOn then
		lightsOn = false
		SetDisplay(false)
		notify('Lights turned ~r~off')
	else
		lightsOn = true
		SetDisplay(false)
		notify('Lights turned ~g~on')
	end
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if lightsOn then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)
			SetVehicleLightsMode(vehicle, 2)
			SetVehicleLights(vehicle, 2)
		else
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)
			SetVehicleLightsMode(vehicle, 0)
			SetVehicleLights(vehicle, 0)
		end
	end
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end