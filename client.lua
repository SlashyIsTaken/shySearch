ESX = exports['es_extended']:getSharedObject()

RegisterCommand(Config.CommandName, function()
    if Config.OnlyAllowArmed then
        if IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 1) then
            local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
                local target = GetPlayerServerId(closestPlayer)
                if Config.UseStress then
                    TriggerEvent(Config.StressTrigger, Config.StressAmount)
                end
                TriggerServerEvent('shyCA:request', target)
                exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.waitforpass, 5000, 'info')
            else
                exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.nobodynear, 5000, 'error')
            end
        else
            exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.nothreat, 5000, 'error')
        end
    else
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
            local target = GetPlayerServerId(closestPlayer)
            if Config.UseStress then
                TriggerEvent(Config.StressTrigger, Config.StressAmount)
            end
            TriggerServerEvent('shyCA:request', target)
            exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.waitforpass, 5000, 'info')
        else
            exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.nobodynear, 5000, 'error')
        end
    end
end)

RegisterNetEvent('shyCA:displayrequest')
AddEventHandler('shyCA:displayrequest', function(player, so)
    exports['okokNotify']:Alert(Config.Translations.searchtitle, "<br><b>ID: "..player.."</b> "..Config.Translations.wantstosearch.."<br><br>"..Config.Translations.press, 10000, 'info')
    waitingforpress(player, so)
end)

RegisterNetEvent('shyCA:openmenu')
AddEventHandler('shyCA:openmenu', function(so)
    if so ~= nil then
        if Config.ox then
            exports.ox_inventory:openInventory('player', so)
        else
            OpenBodySearchMenu(so)
        end
    end
end)

function waitingforpress(player, so)
    local timer = 1500
    while timer >= 1 do
        Citizen.Wait(1)
        if IsControlJustPressed(1, 48) then
            accepted(player, so)
            break
        end
        if IsControlJustPressed(1, 47) then
            declined(player)
            break
        end
        timer = timer - 1
        if timer == 1 then
            declined(player)
            break
        end
    end
end

function accepted(player, so)
    TriggerServerEvent('shyCA:display', player, so)
    exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.beingsearched, 5000, 'info')
end

function declined(player)
    TriggerServerEvent('shyCA:denied', player)
    exports['okokNotify']:Alert(Config.Translations.notifytitle, Config.Translations.declined, 5000, 'info')
end

function OpenBodySearchMenu(player)
    ESX.TriggerServerCallback('shyCA:getOtherPlayerData', function(data)

        local elements = {}

        table.insert(elements, {
            label = '<b>MONEY</b>',
            value = nil
        })

        for i = 1, #data.accounts, 1 do

            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then

                table.insert(elements, {
                    label = 'Black Money: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'black_money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })

            end
            if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
                table.insert(elements, {
                    label = 'Cash: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })
            end
        end

        table.insert(elements, {
            label = '<b>WEAPONS</b>',
            value = nil
        })

        for i = 1, #data.weapons, 1 do
            table.insert(elements, {
                label = ESX.GetWeaponLabel(data.weapons[i].name).." with "..data.weapons[i].ammo.." bullets",
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
            title = 'shy CA',
            align = Config.Align,
            elements = elements
        }, function(data, menu)

            local itemType = data.current.itemType
            local itemName = data.current.value
            local amount = data.current.amount

            if data.current.value ~= nil then
                OpenBodySearchMenu(player)
            end

        end, function(data, menu)
            menu.close()
        end)

    end, player)
end

TriggerEvent('chat:addSuggestion', Config.CommandName, Config.CommandDesc)
