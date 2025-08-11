--[[
    DiscordScreen - Server Script
    ----------------------------
    This script allows admins to request player screenshots and sends detailed info to a Discord webhook.
    Configuration is handled via config.lua.
    Author: Anton (Team Snaily)
    License: MIT
]]

-- Table to track screenshot counts per player
local screenshotCounts = {}
-- Table to track last screenshot time per player (for cooldown)
local lastScreenshotTime = {}

--[[
    /screen [playerId] [reason]
    Command to request a screenshot from a player.
    - If playerId is -1, requests from all players (with delay).
    - Only allows screenshots if cooldown has passed.
]]
RegisterCommand("screen", function(source, args)
    local target = tonumber(args[1])
    local reason = table.concat(args, " ", 2)
    local requesterName = source > 0 and GetPlayerName(source) or "Console"
    local requesterId = source > 0 and source or 0

    if not target then
        print("Invalid or missing player ID.")
        return
    end

    -- Cooldown check
    if lastScreenshotTime[target] and (os.time() - lastScreenshotTime[target]) < (Config.SCREENSHOT_COOLDOWN or 10) then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1Error", "Please wait before taking another screenshot of this player." } })
        return
    end
    lastScreenshotTime[target] = os.time()

    -- Request from all players if target is -1
    if target == -1 then
        Citizen.CreateThread(function()
            for _, playerId in ipairs(GetPlayers()) do
                local targetName = GetPlayerName(playerId)
                if targetName then
                    TriggerClientEvent("customScreenshot:take", tonumber(playerId), requesterName, requesterId, reason)
                    print(("Screenshot requested from %s (ID: %s) by %s (ID: %s)"):format(
                        targetName, playerId, requesterName, requesterId
                    ))
                    Citizen.Wait(3000) -- 3 seconds interval between targets, not recommended to change this value. (TO-DO, Send screenshots in same message as info embed)
                end
            end
        end)
        return
    end

    -- Request from a single player
    local targetName = GetPlayerName(target)
    if not targetName then
        print("Player ID does not exist or is not connected.")
        return
    end

    TriggerClientEvent("DiscordScreen:take", target, requesterName, requesterId, reason)
    print(("Screenshot requested from %s (ID: %s) by %s (ID: %s)"):format(
        targetName, target, requesterName, requesterId
    ))
end, true) -- Requires ace permission "command.screen"

--[[
    Event: DiscordScreen:sendEmbed
    Called by client after screenshot is taken.
    Sends an embed with player info to the Discord webhook.
]]
RegisterNetEvent("DiscordScreen:sendEmbed")
AddEventHandler("DiscordScreen:sendEmbed", function(playerName, playerId, requesterName, requesterId, x, y, z, health, armor, vehInfo, discordTag, reason)
    -- Increment screenshot count for this player
    screenshotCounts[playerId] = (screenshotCounts[playerId] or 0) + 1

    -- Gather player identifiers (excluding IP)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local id = GetPlayerIdentifier(playerId, i)
        if not id:find("^ip:") then
            table.insert(identifiers, id)
        end
    end
    local idString = table.concat(identifiers, "\n")
    if idString == "" then idString = "N/A" end

    local ping = GetPlayerPing(playerId) or "N/A"
    local embedColor = 65280 -- Green

    -- Build the Discord embed
    local embed = {
        {
            title = Config.EMBED_TITLE or "Player Screenshot",
            color = embedColor,
            -- thumbnail = { url = "your_logo_url" }, -- Optional: add your logo
            fields = {
                { name = "Player", value = string.format("```%s (ID: %s)```", playerName, playerId), inline = true },
                { name = "Requested By", value = string.format("```%s (ID: %s)```", requesterName, requesterId), inline = true },
                { name = "Ping", value = string.format("```%s```", tostring(ping)), inline = true },
                { name = "Identifiers", value = string.format("```%s```", idString), inline = false },
                { name = "Coords", value = string.format("```X: %.2f, Y: %.2f, Z: %.2f```", x or 0, y or 0, z or 0), inline = false },
                { name = "Health/Armor", value = string.format("```Health: %d, Armor: %d```", health or 0, armor or 0), inline = false },
                { name = "Vehicle", value = string.format("```%s```", vehInfo or "N/A"), inline = false },
                { name = "Screenshot Reason", value = string.format("```Reason for screenshot:%s```", reason or "N/A"), inline = false },
                { name = "Screenshot Count", value = string.format("```%s```", tostring(screenshotCounts[playerId])), inline = true }
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = { text = "System by Team Snaily" }
        }
    }

    -- Send the embed to Discord
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers)
        if err ~= 204 then
            print("Discord webhook error:", err, text)
        end
    end, 'POST', json.encode({
        content = "**^^INFO ABOUT SCREENSHOT ABOVE^^**",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end)
