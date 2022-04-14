RegisterServerEvent('VehicleController:LockVehicleServer')
AddEventHandler('VehicleController:LockVehicleServer', function(vehicle)
    TriggerClientEvent('VehicleController:LockVehicleClient', -1, vehicle)
end)

RegisterServerEvent('VehicleController:UnlockVehicleServer')
AddEventHandler('VehicleController:UnlockVehicleServer', function(vehicle)
    TriggerClientEvent('VehicleController:UnlockVehicleClient', -1, vehicle)
end)