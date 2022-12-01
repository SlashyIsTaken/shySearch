ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterServerEvent('karners:request')
AddEventHandler('karners:request', function(targetid)
    if targetid ~= nil then
        TriggerClientEvent('karners:displayrequest', targetid, source, targetid)
    end
end)

RegisterServerEvent('karners:deniedbitch')
AddEventHandler('karners:deniedbitch', function(boefid)
    if boefid ~= nil then
        TriggerClientEvent('okokNotify:Alert', boefid, "Fouilleren", "Je fouilleer verzoek is afgewezen.", 5000, 'error')
    end
end)

RegisterServerEvent('karners:displaybuit')
AddEventHandler('karners:displaybuit', function(boefid, slachtoffer)
    if boefid ~= nil then
        TriggerClientEvent('karners:openmenu', boefid, slachtoffer)
    end
end)

ESX.RegisterServerCallback('karners:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height, job FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	local firstname = result[1].firstname
	local lastname  = result[1].lastname
	local sex       = result[1].sex
	local dob       = result[1].dateofbirth
	local height    = result[1].height
    local job       = result[1].job
	local data = {
		name      = GetPlayerName(target),
		job       = xPlayer.job,
		inventory = xPlayer.inventory,
		accounts  = xPlayer.accounts,
		weapons   = xPlayer.loadout,
		firstname = firstname,
		lastname  = lastname,
		sex       = sex,
		dob       = dob,
		height    = height,
        job       = job
	}
	cb(data)
end)