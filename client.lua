--[[
    DiscordScreen - Client Script
    ----------------------------
    Listens for screenshot requests from the server, gathers player info,
    and uploads a screenshot to the Discord webhook.
    Author: Anton
    License: MIT
]]

-- Listen for screenshot requests from the server
RegisterNetEvent("DiscordScreen:take")
AddEventHandler("DiscordScreen:take", function(requesterName, requesterId, reason)
    -- Gather player info
    local playerName = GetPlayerName(PlayerId()) or "Unknown"
    local playerId = GetPlayerServerId(PlayerId())
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local health = GetEntityHealth(ped)
    local armor = GetPedArmour(ped)

    -- Vehicle info
    local veh = GetVehiclePedIsIn(ped, false)
    local vehInfo = "Not in vehicle"
    if veh and veh ~= 0 then
        local model = GetEntityModel(veh)
        local name = GetDisplayNameFromVehicleModel(model)
        local plate = GetVehicleNumberPlateText(veh)
        local seat = -1
        for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
            if GetPedInVehicleSeat(veh, i) == ped then seat = i break end
        end
        vehInfo = string.format("%s | Plate: %s | Seat: %s", name, plate, seat)
    end


    -- Take screenshot and upload to Discord webhook
    exports['screenshot-basic']:requestScreenshotUpload(
        Config.DISCORD_WEBHOOK, -- Webhook URL from config.lua
        'files[]',
        function(data)
            -- Notify server to send embed with player info
            TriggerServerEvent("DiscordScreen:sendEmbed",
                playerName, playerId, requesterName, requesterId,
                coords.x, coords.y, coords.z, health, armor, vehInfo, discordTag, reason
            )
        end
    )
end)
