ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

--Searching
RegisterServerEvent('shyCA:request')
AddEventHandler('shyCA:request', function(targetid)
    if targetid ~= nil then
        TriggerClientEvent('shyCA:displayrequest', targetid, source, targetid)
    end
end)

RegisterServerEvent('shyCA:denied')
AddEventHandler('shyCA:denied', function(invoker)
    if invoker ~= nil then
        TriggerClientEvent('okokNotify:Alert', invoker, Config.Translations.notifytitle, Config.Translations.denied, 5000, 'error')
    end
end)

RegisterServerEvent('shyCA:display')
AddEventHandler('shyCA:display', function(invoker, target)
    if invoker ~= nil then
        TriggerClientEvent('shyCA:openmenu', invoker, target)
    end
end)

ESX.RegisterServerCallback('shyCA:getOtherPlayerData', function(source, cb, target)
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

-- Cuffing