ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand('fouilleer', function()
    if IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 1) then
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
            local target = GetPlayerServerId(closestPlayer)
            TriggerEvent("client:newStress", 500)
            TriggerServerEvent('karners:request', target)
            exports['okokNotify']:Alert("Fouilleren", "Wacht nu totdat "..target.." het fouilleer verzoek goedkeurt.", 5000, 'info')
        else
            exports['okokNotify']:Alert("Fouilleren", "Helaas. Niemand in de buurt om te fouilleren", 5000, 'error')
        end
    else
        exports['okokNotify']:Alert("Fouilleren", "Helaas. Je vormt geen bedreiging", 5000, 'error')
    end
end)

RegisterNetEvent('karners:displayrequest')
AddEventHandler('karners:displayrequest', function(boef, so)
    exports['okokNotify']:Alert("Fouilleer Verzoek", "<br><b>ID: "..boef.."</b> wilt je fouilleren.<br><br>Druk op <b>Z</b> om te accepteren<br><i>of</i><br>Druk op <b>G</b> om te weigeren", 10000, 'info')
    waitingforpress(boef, so)
end)

RegisterNetEvent('karners:openmenu')
AddEventHandler('karners:openmenu', function(so)
    if so ~= nil then
        OpenBodySearchMenu(so)
    end
end)

function waitingforpress(boef, so)
    local timer = 1500
    while timer >= 1 do
        Citizen.Wait(1)
        if IsControlJustPressed(1, 48) then
            geaccepteerd(boef, so)
            break
        end
        if IsControlJustPressed(1, 47) then
            geweigerd(boef)
            break
        end
        timer = timer - 1
        if timer == 1 then
            geweigerd(boef)
            break
        end
    end
end

function geaccepteerd(boef, so)
    TriggerServerEvent('karners:displaybuit', boef, so)
    exports['okokNotify']:Alert("Fouilleren", "Je wordt nu gefouilleerd...", 5000, 'info')
end

function geweigerd(boef)
    TriggerServerEvent('karners:deniedbitch', boef)
    exports['okokNotify']:Alert("Fouilleren", "Je wees het fouilleer verzoek af.", 5000, 'info')
end

function OpenBodySearchMenu(player)
    ESX.TriggerServerCallback('karners:getOtherPlayerData', function(data)

        local elements = {}

        table.insert(elements, {
            label = '<b>GELD</b>',
            value = nil
        })

        for i = 1, #data.accounts, 1 do

            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then

                table.insert(elements, {
                    label = 'Zwart Geld: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'black_money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })

            end
            if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
                table.insert(elements, {
                    label = 'Cash Geld: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })
            end
        end

        table.insert(elements, {
            label = '<b>WAPENS</b>',
            value = nil
        })

        for i = 1, #data.weapons, 1 do
            table.insert(elements, {
                label = ESX.GetWeaponLabel(data.weapons[i].name).." met "..data.weapons[i].ammo.." kogels",
                value = data.weapons[i].name,
                itemType = 'item_weapon',
                amount = data.weapons[i].ammo
            })
        end

        table.insert(elements, {
            label = '<b>ITEMS</b>',
            value = nil
        })

        for i = 1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(elements, {
                    label = data.inventory[i].count.."x "..data.inventory[i].label,
                    value = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount = data.inventory[i].count
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
            title = 'Fouilleer Menu',
            align = 'top-right',
            elements = elements
        }, function(data, menu)

            local itemType = data.current.itemType
            local itemName = data.current.value
            local amount = data.current.amount

            if data.current.value ~= nil then
                exports['okokNotify']:Alert("Fouilleren", "Nee nee, je mag niks afpakken...<br><br>Gewoon lief vragen aan de persoon in kwestie of hij het vrijwillig afgeeft.", 5000, 'info')
                OpenBodySearchMenu(player)
            end

        end, function(data, menu)
            menu.close()
        end)

    end, player)
end

TriggerEvent('chat:addSuggestion', '/fouilleer', 'Fouilleer de dichtsbijzijnde speler')