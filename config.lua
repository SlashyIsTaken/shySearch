Config = {}

Config.CommandName = "search" -- Command for searching others.
Config.CommandDesc = "Send a search request to the nearest person."

Config.OnlyAllowArmed = true -- True only allows armed players to use the commands, false lets everyone use it.

Config.UseStress = true -- Enable/disable use of adding stress to player if the command passes through succesfully. Requires external client-sided script.
Config.StressTrigger = "client:newStress"
Config.StressAmount = 500

Confix.ox = true -- Toggle use of ox_inventory. False will make use of esx_menu_default.
Config.Align = 'top-right' -- Where to align the menu.

Config.Translations = {
    notifytitle = "shy Criminal Actions",
    searchtitle = "Search Request",

    waitforpass = "Please wait until the player responds.",
    nobodynear = "No one nearby.",
    nothreat = "You don't form a threat to the person in question.",
    wantstosearch = "would like to search you.",
    press = "Press <b>Z</b> to accept<br><i>or</i><br>Press <b>G</b> to decline.",
    beingsearched = "You are now being searched.",
    declined = "You have declined the search request.",
    denied = "Your search request has been declined."
}