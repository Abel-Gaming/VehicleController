local display = false
local lightsOn = false
local doorsLocked = false
local autoLock = false
local EngineAlwaysOn = false
local AutoLockvehicle

---------- COMMANDS ----------
RegisterCommand("vehremote", function(source, args)
    SetDisplay(not display)
end)

RegisterCommand('dv', function()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		DeleteVehicle(vehicle)
		notify('~g~[SUCCESS]~w~ Vehicle deleted!')
	else
		local vehicle = GetVehiclePedIsIn(playerPed, true)
		DeleteVehicle(vehicle)
		notify('~g~[SUCCESS]~w~ Vehicle deleted!')
	end
end, false)

RegisterCommand("eao", function()
	if EngineAlwaysOn then
		EngineAlwaysOn = false
	else
		EngineAlwaysOn = true
	end
end)

---------- KEY MAPPINGS ----------
RegisterKeyMapping('vehremote', 'Vehicle Remote', 'keyboard', '[')


---------- ENGINE ON THREAD ----------
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

---------- LIGHTS ON THREAD ----------
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

---------- NO CONTROL IS DISPLAY IS OPEN ----------
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(AutoLockvehicle)) >= 7.0 then
			if not doorsLocked and autoLock then
				notify('~y~[INFO]~w~ You vehicle doors have been locked')
				doorsLocked = true
				TriggerServerEvent('VehicleController:LockVehicleServer', AutoLockvehicle)
			end
		end
	end
end)

---------- NUI CALLBACKS ----------
RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("togglelock", function(data)
    local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, true)

	if doorsLocked then
		TriggerServerEvent('VehicleController:UnlockVehicleServer', vehicle)
		notify('~g~[SUCCESS]~w~ Doors have been unlocked')
		doorsLocked = false
		SetDisplay(false)
	else
		TriggerServerEvent('VehicleController:LockVehicleServer', vehicle)
		notify('~g~[SUCCESS]~w~ Doors have been locked')
		doorsLocked = true
		SetDisplay(false)
	end
end)

RegisterNUICallback("toggleautolock", function(data)
    local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		if autoLock then
			AutoLockvehicle = 0
			autoLock = false
			notify('~y~[INFO]~w~ Auto lock ~r~disabled')
			SetDisplay(false)
		else
			AutoLockvehicle = GetVehiclePedIsIn(playerPed, false)
			autoLock = true
			notify('~y~[INFO]~w~ Auto lock ~g~enabled')
			SetDisplay(false)
		end
	else
		notify('~r~[ERROR]~w~ You are not in a vehicle')
		SetDisplay(false)
	end
end)

RegisterNUICallback("toggleengine", function(data)
    ExecuteCommand("eng")
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

---------- FUNCTIONS ----------
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

---------- EVENTS ----------
RegisterNetEvent('VehicleController:LockVehicleClient')
AddEventHandler('VehicleController:LockVehicleClient', function(vehicle)
	SetVehicleDoorsLocked(vehicle, 2)
end)

RegisterNetEvent('VehicleController:UnlockVehicleClient')
AddEventHandler('VehicleController:UnlockVehicleClient', function(vehicle)
	SetVehicleDoorsLocked(vehicle, 1)
end)