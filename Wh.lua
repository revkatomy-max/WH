local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- // CONFIGURATION //
local WEBHOOK_URL = "https://discord.com/api/webhooks/1480390802940366879/pnPF_v2-y0H421DLjQ63eVXnFS1ZKf5NPZTG4CGFsklV_AUh60zSHNGVOOWLMzUg6iK9"
local SCRIPT_ACTIVE = true

-- // Apakah mau log SEMUA catch atau hanya secret fish? //
-- true  = hanya secret fish yang dikirim ke webhook
-- false = semua catch dikirim ke webhook
local SECRET_ONLY = true

-- Database Ikan Secret
local SecretFishData = {
    ["Crystal Crab"] = 18335072046, ["Orca"] = 18335061483, ["Zombie Shark"] = 18335056722,
    ["Zombie Megalodon"] = 18335056551, ["Dead Zombie Shark"] = 18335056722, ["Blob Shark"] = 18335068212,
    ["Ghost Shark"] = 18335059639, ["Skeleton Narwhal"] = 18335057177, ["Ghost Worm Fish"] = 18335059511,
    ["Worm Fish"] = 18335057406, ["Megalodon"] = 18335063073, ["1x1x1x1 Comet Shark"] = 18335068832,
    ["Bloodmoon Whale"] = 18335067980, ["Lochness Monster"] = 18335063708, ["Monster Shark"] = 18335062145,
    ["Eerie Shark"] = 18335060416, ["Great Whale"] = 18335058867, ["Frostborn Shark"] = 18335059957,
    ["Armored Shark"] = 18335068417, ["Scare"] = 18335058097, ["Queen Crab"] = 18335058252,
    ["King Crab"] = 18335064431, ["Cryoshade Glider"] = 18335066928, ["Panther Eel"] = 18335060799,
    ["Giant Squid"] = 18335059345, ["Depthseeker Ray"] = 18335066551, ["Robot Kraken"] = 18335058448,
    ["Mosasaur Shark"] = 18335061981, ["King Jelly"] = 18335064243, ["Bone Whale"] = 18335067645,
    ["Elshark Gran Maja"] = 18335060241, ["Elpirate Gran Maja"] = 18335060241, ["Ancient Whale"] = 18335068612,
    ["Gladiator Shark"] = 18335059068, ["Ancient Lochness Monster"] = 18335063708, ["Talon Serpent"] = 18335057777,
    ["Hacker Shark"] = 18335059223, ["ElRetro Gran Maja"] = 18335060241, ["Strawberry Choc Megalodon"] = 18335063073,
    ["Krampus Shark"] = 18335062145, ["Emerald Winter Whale"] = 18335058867, ["Winter Frost Shark"] = 18335059957,
    ["Icebreaker Whale"] = 18335067645, ["Leviathan"] = 18335063983, ["Pirate Megalodon"] = 18335063073,
    ["Viridis Lurker"] = 18335060799, ["Cursed Kraken"] = 18335058448, ["Ancient Magma Whale"] = 18335068612,
    ["Rainbow Comet Shark"] = 18335118712, ["Love Nessie"] = 18335063708, ["Broken Heart Nessie"] = 18335063708
}

-- // WEBHOOK SENDER //
local function SendWebhook(title, description, color, fields, imageUrl, thumbUrl)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end

    local embed = {
        ["title"] = title,
        ["description"] = description,
        ["color"] = color,
        ["fields"] = fields,
        ["footer"] = {["text"] = "FishIt Monitor | " .. os.date("%X")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    if imageUrl then embed["image"] = {["url"] = imageUrl} end
    if thumbUrl then embed["thumbnail"] = {["url"] = thumbUrl} end

    task.spawn(function()
        pcall(function()
            requestFunc({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({["embeds"] = {embed}})
            })
        end)
    end)
end

-- // PARSE & HOOK CHAT SERVER //
-- Format: [Server]: PlayerName obtained a FishName (181.7kg) with a 1 in 5K chance!
local function OnNewMessage(messageObject)
    if not SCRIPT_ACTIVE then return end

    local msg = messageObject.MessageType == Enum.ChatMessageType.System and messageObject.Message or nil
    if not msg then return end

    -- Tangkap format: "[Server]: NAME obtained a FISH (WEIGHTkg) with a 1 in CHANCE chance!"
    local playerName, fishName, weight, chance = msg:match("%[Server%]:%s*(.-)%s+obtained a%s+(.-)%s+%(([%d%.]+)kg%)%s+with a 1 in%s+(.-)%s+chance!")

    if not playerName or not fishName then return end

    local isSecret = SecretFishData[fishName] ~= nil

    -- Filter berdasarkan config SECRET_ONLY
    if SECRET_ONLY and not isSecret then return end

    -- Ambil avatar player yang catch
    local targetPlayer = Players:FindFirstChild(playerName)
    local userId = targetPlayer and targetPlayer.UserId or nil
    local avatarUrl = userId and ("https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png") or nil

    -- Ambil image ikan kalau secret
    local fishImg = nil
    if isSecret and SecretFishData[fishName] then
        fishImg = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(SecretFishData[fishName]) .. "&width=420&height=420&format=png"
    end

    local title = isSecret and "🚨 SECRET FISH CAUGHT!" or "🐟 Fish Caught"
    local color = isSecret and 16776960 or 3447003 -- kuning untuk secret, biru untuk biasa

    SendWebhook(title, nil, color, {
        {["name"] = "👤 Player",  ["value"] = "**" .. playerName .. "**", ["inline"] = true},
        {["name"] = "🐠 Fish",    ["value"] = "**" .. fishName .. "**",   ["inline"] = true},
        {["name"] = "⚖️ Weight",  ["value"] = weight .. " kg",            ["inline"] = true},
        {["name"] = "🎲 Chance",  ["value"] = "1 in " .. chance,          ["inline"] = true},
        {["name"] = "🔥 Secret",  ["value"] = isSecret and "✅ YES" or "❌ No", ["inline"] = true},
    }, fishImg, avatarUrl)
end

-- // HOOK KE CHAT SERVICE //
local function HookChat()
    local success, ChatService = pcall(function()
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Chat", 10)
    end)

    -- Gunakan TextChatService (Roblox terbaru) atau ChatService lama
    local TextChatService = pcall(function() return game:GetService("TextChatService") end) and game:GetService("TextChatService") or nil

    if TextChatService and TextChatService.MessageReceived then
        -- Modern Roblox chat (TextChatService)
        TextChatService.MessageReceived:Connect(function(msg)
            if msg.TextSource == nil then -- pesan sistem tidak punya TextSource
                OnNewMessage({
                    Message = msg.Text,
                    MessageType = Enum.ChatMessageType.System
                })
            end
        end)
    else
        -- Fallback: hook lewat LocalPlayer chat events
        local localPlayer = Players.LocalPlayer
        localPlayer:WaitForChild("PlayerGui")

        -- Listen semua pesan chat yang masuk ke client
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 10)
        local events = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if events then
            local onMessageDoneFiltering = events:FindFirstChild("OnMessageDoneFiltering")
            if onMessageDoneFiltering then
                onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
                    if messageData and messageData.MessageType == "System" then
                        OnNewMessage({
                            Message = messageData.Message,
                            MessageType = Enum.ChatMessageType.System
                        })
                    end
                end)
            end
        end
    end
end

-- // PLAYER LEAVE //
Players.PlayerRemoving:Connect(function(player)
    if not SCRIPT_ACTIVE then return end
    local pName = player.Name
    local pId = player.UserId
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(pId) .. "&width=420&height=420&format=png"
    SendWebhook("👋 PLAYER LEFT", "A player has left the server.", 16711680, {
        {["name"] = "Username", ["value"] = "**" .. pName .. "**", ["inline"] = true}
    }, nil, avatarUrl)
end)

-- // PLAYER JOIN //
Players.PlayerAdded:Connect(function(player)
    if not SCRIPT_ACTIVE then return end
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(player.UserId) .. "&width=420&height=420&format=png"
    SendWebhook("✅ PLAYER JOINED", "A new player joined the server.", 65280, {
        {["name"] = "Username", ["value"] = "**" .. player.Name .. "**", ["inline"] = true}
    }, nil, avatarUrl)
end)

-- // STARTUP //
local function Startup()
    local allPlayers = Players:GetPlayers()
    local names = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    SendWebhook("🚀 WEBHOOK STARTED", nil, 65280, {
        {["name"] = "Host",         ["value"] = "👤 " .. Players.LocalPlayer.Name, ["inline"] = true},
        {["name"] = "Total Player", ["value"] = "👥 " .. tostring(#allPlayers),    ["inline"] = true},
        {["name"] = "Mode",         ["value"] = SECRET_ONLY and "🔒 Secret Fish Only" or "📡 All Fish", ["inline"] = true},
        {["name"] = "Daftar Player", ["value"] = "```\n" .. table.concat(names, ", ") .. "```", ["inline"] = false}
    })

    StarterGui:SetCore("SendNotification", {
        Title = "Blox Gank Weebhook Active",
        Text = "Monitoring FishIt server chat...",
        Duration = 5
    })
end

-- // INITIALIZE //
Startup()
HookChat()
