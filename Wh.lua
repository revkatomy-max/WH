-- ============================================================
--  BLOX Gank Server Monitor  |  Discord: @bloxgank
-- ============================================================

local HttpService        = game:GetService("HttpService")
local Players            = game:GetService("Players")
local TextChatService    = game:GetService("TextChatService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local CoreGui            = game:GetService("CoreGui")
local TweenService       = game:GetService("TweenService")

-- ============================================================
--  CONFIGURATION
-- ============================================================

local WEBHOOK_URL       = ""
local WEBHOOK_STATS     = "https://discord.com/api/webhooks/1488003996026273893/4v2Z-a838D17SL7qn03o8s2PKX3oN2quVIui1g4GmYjrIkgnONbtQUlOGqxkLQLD5eIm"
local WEBHOOK_FISH      = "https://discord.com/api/webhooks/1488485636024307784/s0tXIAmlnx2OosodZm6FiC3Ny9YT4PzcIDFqUeHXymdVvcKOyuIRVxLPcxE7lsK1IZgb"
local WEBHOOK_CHAT      = "https://discord.com/api/webhooks/1498573795118678176/oxD9a1iqw2Id7GPY5Qk077bhcN0awn_LWeblphJYUtu6UV7SeH1T_7zP_fhN3yjqCgh2"
local WEBHOOK_GALATAMA  = "https://discord.com/api/webhooks/1487995039912038481/BqBd5GD0D6lLvE6y5rlGblGNXMl3ScQ8C40fCVXYiTy8YmbVYbbsi8yQOjvuIUNgtz2q"
local DISCORD_ROLE_ID   = "1489557585764810802"
local WEBHOOK_AVATAR    = ""
local PROXY             = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE     = false

local LEADERBOARD_INTERVAL          = 1800  -- 30 menit
local LEADERBOARD_GALATAMA_INTERVAL = 1800  -- 30 menit (bisa dibedakan)

-- ============================================================
--  MEMBER LIST
-- ============================================================

local MemberList = {
    { username = "zupzupzuppasup",   display = "RISKAMAUFORGOTTEN", id = "766292778501275678" },
    { username = "natadecxco",       display = "nata",              id = "638355599574171668" },
    { username = "NNOON412",         display = "412",               id = "1125668364489080933" },
    { username = "kdryvka",          display = "YIYA",              id = "1312729486067761162" },
    { username = "Deff69699",        display = "DEF",               id = "1407731878756221040" },
    { username = "fzallzall",        display = "Ziell",             id = "462346945441038337" },
    { username = "x_ibo21",          display = "wowo",              id = "954296542406246400" },
    { username = "evosudin",         display = "Bluuism",           id = "875656564931956766" },
    { username = "minxing_kim",      display = "minxing",           id = "484295718765461515" },
    { username = "w4terhyacinth",    display = "ReVWater",          id = "1309945598409048076" },
    { username = "sedotanpink",      display = "sedotanpink",       id = "1406804062825091274" },
    { username = "dekadekadekk",     display = "dekadee",           id = "692735562817470494" },
    { username = "ceriseciscake",    display = "ciscake",           id = "786950836034994216" },
    { username = "cobadulumogaseru", display = "lah",               id = "1451975194397638676" },
    { username = "BEJOD06",          display = "masw",              id = "1222390041951600640" },
    { username = "flucidious",       display = "fluc",              id = "279691238494699530" },
    { username = "hawaish01",        display = "ilywaa",            id = "1392909983678595244" },
    { username = "ocheanyx",         display = "Michiko",           id = "1299617626309263381" },
    { username = "Reverned99",       display = "Reverned99",        id = "870201488218157107" },
    { username = "Leale716",         display = "leaa",              id = "1408658812424028182" },
}

-- ============================================================
--  DATABASE — SECRET FISH
-- ============================================================

local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armored Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale",
    "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark",
    "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark",
    "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan",
    "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale",
    "Rainbow Comet Shark", "Love Nessie", "Broken Heart Nessie",
    "Mutant Runic Koi", "Ketupat Whale", "Cosmic Mutant Shark", "Strawberry Orca",
    "Bonemaw Tyrant", "Deepsea Monster Axolotl", "Blocky Lochness Monster", "Aurelion",
    "Runic Enchant Stone", "Frogalloon",
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan",
}

local MutasiList = {
    "Noob", "Fairy Dust", "Holographic", "Gemstone", "Fire", "Color Burn", "Fozen",
    "Galaxy", "Midnight", "BloodMoon", "Binary", "Lightning", "Disco", "Festive", "Radioactive",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo",
    "Blossom Jelly", "Bioluminescent Octopus",
}

local RubyList = { "Ruby" }

-- ============================================================
--  GALATAMA EVENT — Ikan & Point
-- ============================================================

-- Hanya ikan berikut yang masuk sistem point Galatama
local GalatamaFishList = {
    "Cryoshade Glider",
    "Panther Eel",
    "Giant Squid",
    "Depthseeker Ray",
    "Robot Kraken",
}

-- Point per tangkapan
local GalatamaPoin = {
    ["Cryoshade Glider"] = 45,
    ["Panther Eel"]      = 75,
    ["Giant Squid"]      = 80,
    ["Depthseeker Ray"]  = 120,
    ["Robot Kraken"]     = 350,
}

-- Rarity display
local GalatamaRarity = {
    ["Cryoshade Glider"] = "1 in 450K",
    ["Panther Eel"]      = "1 in 750K",
    ["Giant Squid"]      = "1 in 800K",
    ["Depthseeker Ray"]  = "1 in 1.2M",
    ["Robot Kraken"]     = "1 in 3.5M",
}

-- ============================================================
--  DATABASE — CHANCE & IMAGE
-- ============================================================

local FishChanceData = {
    ["Crystal Crab"]             = "1 in 750K",
    ["Orca"]                     = "1 in 1.5M",
    ["Zombie Shark"]             = "1 in 250K",
    ["Zombie Megalodon"]         = "1 in 4M",
    ["Dead Zombie Shark"]        = "1 in 500K",
    ["Blob Shark"]               = "1 in 250K",
    ["Ghost Shark"]              = "1 in 500K",
    ["Skeleton Narwhal"]         = "1 in 600K",
    ["Ghost Worm Fish"]          = "1 in 1M",
    ["Worm Fish"]                = "1 in 3M",
    ["Megalodon"]                = "1 in 4M",
    ["1x1x1x1 Comet Shark"]      = "1 in 4M",
    ["Bloodmoon Whale"]          = "1 in 5M",
    ["Lochness Monster"]         = "1 in 3M",
    ["Monster Shark"]            = "1 in 2.5M",
    ["Eerie Shark"]              = "1 in 250K",
    ["Great Whale"]              = "1 in 900K",
    ["Frostborn Shark"]          = "1 in 500K",
    ["Thin Armored Shark"]       = "1 in 300K",
    ["Scare"]                    = "1 in 3M",
    ["Queen Crab"]               = "1 in 800K",
    ["King Crab"]                = "1 in 1.2M",
    ["Cryoshade Glider"]         = "1 in 450K",
    ["Panther Eel"]              = "1 in 750K",
    ["Giant Squid"]              = "1 in 800K",
    ["Depthseeker Ray"]          = "1 in 1.2M",
    ["Robot Kraken"]             = "1 in 3.5M",
    ["Mosasaur Shark"]           = "1 in 800K",
    ["King Jelly"]               = "1 in 1.5M",
    ["Bone Whale"]               = "1 in 2M",
    ["Elshark Gran Maja"]        = "1 in 4M",
    ["Elpirate Gran Maja"]       = "1 in 4M",
    ["ElRetro Gran Maja"]        = "1 in 4M",
    ["Ancient Whale"]            = "1 in 2.75M",
    ["Gladiator Shark"]          = "1 in 1M",
    ["Ancient Lochness Monster"] = "1 in 3M",
    ["Talon Serpent"]            = "1 in 3M",
    ["Hacker Shark"]             = "1 in 2M",
    ["Strawberry Choc Megalodon"]= "1 in 4M",
    ["Krampus Shark"]            = "1 in 1M",
    ["Emerald Winter Whale"]     = "1 in 1.5M",
    ["Winter Frost Shark"]       = "1 in 3M",
    ["Icebreaker Whale"]         = "1 in 4M",
    ["Cursed Kraken"]            = "1 in 3M",
    ["Pirate Megalodon"]         = "1 in 4M",
    ["Leviathan"]                = "1 in 5M",
    ["Viridis Lurker"]           = "1 in 1.4M",
    ["Ancient Magma Whale"]      = "1 in 5M",
    ["Mutant Runic Koi"]         = "1 in ??",
    ["Cosmic Mutant Shark"]      = "1 in 2M",
    ["Strawberry Orca"]          = "1 in 3M",
    ["Bonemaw Tyrant"]           = "1 in 2.5M",
    ["Sea Eater"]                = "1 in 25M",
    ["Thunderzilla"]             = "1 in 30M",
    ["Iridesca"]                 = "1 in 25M",
    ["Eggy Enchant Stone"]       = "1 in 100K",
    ["Deepsea Monster Axolotl"]  = "1 in 2M",
    ["Blocky Lochness Monster"]  = "1 in 3M",
    ["Frostbite Leviathan"]      = "1 in 12M",
    ["Aurelion"]                 = "1 in 3M",
    ["Runic Enchant Stone"]      = "1 in 1.50M",
    ["Frogalloon"]               = "1 in 1,50M",
}

local FishImageURL = {
    ["Monster Shark"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Monster%20Shark.png",
    ["Megalodon"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Megalodon.png",
    ["Ancient Lochness Monster"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Lochness%20Monster.png",
    ["Ancient Magma Whale"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Magma%20Whale.png",
    ["Ancient Whale"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Whale.png",
    ["Bloodmoon Whale"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bloodmoon%20Whale.png",
    ["Blob Shark"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Blob%20Shark.png",
    ["Bonemaw Tyrant"]           = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bonemaw%20Tyrant.png",
    ["Bone Whale"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bone%20Whale.png",
    ["Cosmic Mutant Shark"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cosmic%20Mutant%20Shark.png",
    ["Cryoshade Glider"]         = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cryoshade%20Glider.png",
    ["Crystal Crab"]             = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Crystal%20Crab.png",
    ["Cursed Kraken"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cursed%20Kraken.png",
    ["Depthseeker Ray"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Depthseeker%20Ray.png",
    ["Eerie Shark"]              = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Eerie%20Shark.png",
    ["Elpirate Gran Maja"]       = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Elpirate%20Gran%20Maja.png",
    ["Elshark Gran Maja"]        = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Elshark%20Gran%20Maja.png",
    ["Frostborn Shark"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Frostborn%20Shark.png",
    ["Ghost Shark"]              = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ghost%20Shark.png",
    ["Giant Squid"]              = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Giant%20Squid.png",
    ["Gladiator Shark"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Gladiator%20Shark.png",
    ["Great Whale"]              = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Great%20Whale.png",
    ["Ketupat Whale"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ketupat%20Whale.png",
    ["King Crab"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/King%20Crab.png",
    ["King Jelly"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/King%20Jelly.png",
    ["Leviathan"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Leviathan.png",
    ["Lochness Monster"]         = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Lochness%20Monster.png",
    ["Mosasaur Shark"]           = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Mosasaur%20Shark.png",
    ["Orca"]                     = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Orca.png",
    ["Panther Eel"]              = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Panther%20Eel.png",
    ["Pirate Megalodon"]         = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Pirate%20Megalodon.png",
    ["Queen Crab"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Queen%20Crab.png",
    ["Rainbow Comet Shark"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Rainbow%20Comet%20Shark.png",
    ["Robot Kraken"]             = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Robot%20Kraken.png",
    ["Ruby"]                     = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ruby%20Gemstone.png",
    ["Sea Eater"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Sea%20Eater.png",
    ["Skeleton Narwhal"]         = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Skeleton%20Narwhal.png",
    ["Thin Armor Shark"]         = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Thin%20Armor%20Shark.png",
    ["Thunderzilla"]             = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Thunderzilla.png",
    ["Strawberry Orca"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Strawberry%20Orca.png",
    ["Eggy Enchant Stone"]       = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Eggy%20Enchant%20Stone.png",
    ["Worm Fish"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Worm%20Fish.png",
    ["Iridesca"]                 = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Iridesca.png",
    ["Deepsea Monster Axolotl"]  = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Deepsea%20Monster%20Axolotl.jpeg",
    ["Blocky Lochness Monster"]  = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Blocky%20Lochness%20Monster.jpeg",
    ["Frostbite Leviathan"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Frostbite%20Leviathan.jpeg",
    ["Aurelion"]                 = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Aurelion.png",
    ["Frogalloon"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Frogallon.png",
    ["Scare"]                    = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Frogallon.png",
    ["Viridis Lurker"]           = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Viridis%20Lurker.jpg",
}

-- ============================================================
--  STATE / CACHE
-- ============================================================

local MentionCache    = {}
local FishImageCache  = {}
local AvatarCache     = {}
local LeaveTimers     = {}
local PlayerStats     = {}  -- userId → { catchCount, secretList, joinTime, lastFishTime, name }
local PlayerNameToId  = {}

-- Galatama: userId → { name, totalPoin, catches: { fishName → count } }
local GalatamaStats   = {}

local ServerStats = {
    totalSecret    = 0,
    totalForgotten = 0,
    secretLog      = {},
    forgottenLog   = {},
    startTime      = 0,
}

-- ============================================================
--  UTILITY
-- ============================================================

local function GetRequestFunc()
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or (fluxus and fluxus.request)
        or request
end

local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function Trim(s)
    return s:match("^%s*(.-)%s*$") or s
end

local function UptimeString(seconds)
    return math.floor(seconds / 3600) .. "h " .. math.floor((seconds % 3600) / 60) .. "m"
end

local function FindPlayer(name)
    local p = Players:FindFirstChild(name)
    if p then return p end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower then return player end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(player.Name), lower, 1, true)
        or string.find(lower, string.lower(player.Name), 1, true) then
            return player
        end
    end
    return nil
end

-- ============================================================
--  MENTION HELPERS
-- ============================================================

local function BuildMentionCache(rbxName, rbxDisplay)
    for _, member in ipairs(MemberList) do
        local uLower = string.lower(member.username)
        local dLower = string.lower(member.display)
        if string.lower(rbxName) == uLower    or string.lower(rbxDisplay) == dLower
        or string.lower(rbxName) == dLower    or string.lower(rbxDisplay) == uLower then
            MentionCache[string.lower(rbxName)]    = member.id
            MentionCache[string.lower(rbxDisplay)] = member.id
        end
    end
end

local function GetMention(robloxName)
    if not robloxName then return "" end
    local lower = string.lower(robloxName)
    if MentionCache[lower] then return "<@" .. MentionCache[lower] .. ">" end
    for _, member in ipairs(MemberList) do
        if string.lower(member.username) == lower or string.lower(member.display) == lower then
            return "<@" .. member.id .. ">"
        end
    end
    return ""
end

-- ============================================================
--  FISH DETECTION
-- ============================================================

local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    for _, baseName in ipairs(SecretFishList) do
        if lower == string.lower(baseName) then return baseName, nil end
    end
    local bestBase, bestLen, bestMutasi = nil, 0, nil
    for _, baseName in ipairs(SecretFishList) do
        local s = string.find(lower, string.lower(baseName), 1, true)
        if s then
            local mutasi = nil
            if s > 1 then
                mutasi = fishName:sub(1, s - 1):match("^%s*(.-)%s*$")
                if mutasi == "" then mutasi = nil end
            end
            if #baseName > bestLen then
                bestLen    = #baseName
                bestBase   = baseName
                bestMutasi = mutasi
            end
        end
    end
    return bestBase, bestMutasi
end

-- Deteksi ikan Galatama (exact + substring)
local function FindGalatamaFish(fishName)
    local lower = string.lower(fishName)
    -- Pass 1: exact
    for _, baseName in ipairs(GalatamaFishList) do
        if lower == string.lower(baseName) then return baseName end
    end
    -- Pass 2: substring (untuk mutasi prefix, e.g. "Galaxy Cryoshade Glider")
    local bestBase, bestLen = nil, 0
    for _, baseName in ipairs(GalatamaFishList) do
        if string.find(lower, string.lower(baseName), 1, true) and #baseName > bestLen then
            bestLen  = #baseName
            bestBase = baseName
        end
    end
    return bestBase
end

local function FindMutasi(fishName)
    local lower = string.lower(fishName)
    for _, mutasiName in ipairs(MutasiList) do
        local mutasiLower = string.lower(mutasiName)
        local s = string.find(lower, mutasiLower, 1, true)
        if s then
            local before = s == 1 and " " or lower:sub(s - 1, s - 1)
            local after  = lower:sub(s + #mutasiLower, s + #mutasiLower)
            if (before == " " and after == " ")
            or (s == 1 and after == " ") then
                return mutasiName
            end
        end
    end
    return nil
end

local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if string.find(lower, "ruby") and string.find(lower, "gemstone") then return "Ruby" end
    return nil
end

local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh")                               then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture")         then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
            return nil
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

-- ============================================================
--  WEBHOOK SENDERS
-- ============================================================

local function BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, footerTag)
    local embed = {
        title       = title,
        description = description,
        color       = color,
        fields      = fields,
        footer      = { text = (footerTag or "BLOX Gank Webhook") .. " | " .. os.date("%X") },
        timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    if imageUrl  then embed.image     = { url = imageUrl }  end
    if thumbUrl  then embed.thumbnail = { url = thumbUrl }  end
    return embed
end

local function PostWebhook(url, body)
    local requestFunc = GetRequestFunc()
    if not requestFunc or url == "" then return end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode(body),
            })
        end)
    end)
end

local function BuildContent(mention, captionType)
    if not mention or mention == "" then return nil end
    local m = Trim(mention)
    if captionType == "secret" or captionType == "forgotten" then
        return "Ingfokan spot pliss " .. m
    elseif captionType == "leave" then
        return "ke disconect ya? " .. m
    elseif captionType == "join" then
        return "alhamdulilah kembali " .. m
    elseif captionType == "notback" then
        return "lah kok ngilang " .. m
    end
    return m
end

local function SendWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    PostWebhook(WEBHOOK_URL, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        content    = BuildContent(mention, captionType),
        embeds     = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local url = (WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL
    if url == "" then return end
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    PostWebhook(url, {
        content = BuildContent(mention, captionType),
        embeds  = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendStatsWebhook(title, description, color, fields, imageUrl, thumbUrl)
    PostWebhook(WEBHOOK_STATS, {
        embeds = { BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, "BLOX Gank Stats") }
    })
end

-- ============================================================
--  GALATAMA LEADERBOARD
-- ============================================================

local function SendGalatamaLeaderboard(isFinal)
    -- Kumpulkan data dari GalatamaStats
    local leaderData = {}
    for uid, gs in pairs(GalatamaStats) do
        if gs.totalPoin > 0 then
            -- Susun daftar tangkapan: "Ikan x3 (x pts)"
            local catchLines = {}
            for fishName, count in pairs(gs.catches) do
                local poinPerEkor = GalatamaPoin[fishName] or 0
                local total       = poinPerEkor * count
                table.insert(catchLines, fishName .. " x" .. count .. " (+" .. total .. " pts)")
            end
            table.insert(leaderData, {
                name       = gs.name or "Unknown",
                totalPoin  = gs.totalPoin,
                catchStr   = #catchLines > 0 and table.concat(catchLines, "\n") or "-",
            })
        end
    end

    if #leaderData == 0 then return end

    table.sort(leaderData, function(a, b) return a.totalPoin > b.totalPoin end)

    local medals = { "🥇", "🥈", "🥉" }
    local lines  = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("**#" .. i .. "**")
        table.insert(lines,
            medal .. " **" .. entry.name .. "** — 🏅 **" .. entry.totalPoin .. " pts**\n"
            .. "↳ " .. entry.catchStr
        )
    end

    local uptime      = os.time() - ServerStats.startTime
    local roleMention = (DISCORD_ROLE_ID ~= "") and ("<@&" .. DISCORD_ROLE_ID .. ">") or ""
    local title       = isFinal
        and "🏆 LEADERBOARD FINAL GALATAMA"
        or  "🏆 LEADERBOARD GALATAMA — UPDATE"

    local contentMsg = isFinal
        and (roleMention ~= "" and roleMention .. " 📢 **Hasil Akhir Event Galatama!** Monitor disconnect." or nil)
        or  (roleMention ~= "" and roleMention .. " 📊 **Update Leaderboard Galatama!**" or nil)

    -- Tabel point referensi di footer description
    local pointRef = "```\nTabel Point Galatama:\n"
        .. "Cryoshade Glider  (1 in 450K) =  45 pts\n"
        .. "Panther Eel       (1 in 750K) =  75 pts\n"
        .. "Giant Squid       (1 in 800K) =  80 pts\n"
        .. "Depthseeker Ray   (1 in 1.2M) = 120 pts\n"
        .. "Robot Kraken      (1 in 3.5M) = 350 pts\n"
        .. "```"

    local desc = table.concat(lines, "\n\n") .. "\n\n" .. pointRef

    PostWebhook(WEBHOOK_GALATAMA, {
        content = contentMsg,
        embeds  = { BuildEmbed(title, desc, 16766720, {
            { name = "🎪 Event",           value = "**Galatama**",                                            inline = true },
            { name = "⏱️ Uptime",          value = UptimeString(uptime),                                      inline = true },
            { name = "🦕 Total Secret",    value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",    inline = true },
        }, nil, nil, "BLOX Gank Galatama") },
    })
end

-- ============================================================
--  LEADERBOARD SECRET (biasa)
-- ============================================================

local function BuildLeaderboardData()
    local leaderData = {}
    for uid, stats in pairs(PlayerStats) do
        local total, fishList = 0, {}
        for fishName, count in pairs(stats.secretList) do
            total = total + count
            table.insert(fishList, fishName .. " x" .. count)
        end
        if total > 0 then
            table.insert(leaderData, {
                name    = stats.name or "Unknown",
                total   = total,
                fishStr = #fishList > 0 and table.concat(fishList, ", ") or "-",
            })
        end
    end
    table.sort(leaderData, function(a, b) return a.total > b.total end)
    return leaderData
end

local function SendLeaderboard(isFinal)
    local leaderData = BuildLeaderboardData()
    if #leaderData == 0 then return end

    local medals = { "🥇", "🥈", "🥉" }
    local lines  = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("**#" .. i .. "**")
        table.insert(lines, medal .. " **" .. entry.name .. "** — " .. entry.total .. " secret\n↳ " .. entry.fishStr)
    end

    local uptime      = os.time() - ServerStats.startTime
    local roleMention = (DISCORD_ROLE_ID ~= "") and ("<@&" .. DISCORD_ROLE_ID .. ">") or ""
    local title       = isFinal
        and "🏆 LEADERBOARD FINAL — EVENT GALATAMA"
        or  "🏆 LEADERBOARD SECRET FISH — EVENT GALATAMA"
    local contentMsg  = isFinal
        and (roleMention ~= "" and roleMention .. " 📢 **Leaderboard Final Event Galatama!** Monitor disconnect." or nil)
        or  (roleMention ~= "" and roleMention .. " 📊 **Update Leaderboard Event Galatama!**" or nil)

    local statsUrl = (WEBHOOK_STATS ~= "") and WEBHOOK_STATS or WEBHOOK_URL
    if statsUrl == "" then return end

    PostWebhook(statsUrl, {
        content = contentMsg,
        embeds  = { BuildEmbed(title, table.concat(lines, "\n\n"), 3066993, {
            { name = "🎪 Event",           value = "**Galatama**",                                                    inline = true },
            { name = "⏱️ Uptime",          value = UptimeString(uptime),                                              inline = true },
            { name = "🦕 Total Secret",    value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",            inline = true },
            { name = "⚜️ Total Forgotten", value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor",         inline = true },
        }, nil, nil, "BLOX Gank Stats") },
    })
end

-- Kirim kedua leaderboard saat final/disconnect
local function SendFinalLeaderboard()
    SendLeaderboard(true)
    SendGalatamaLeaderboard(true)
end

-- ============================================================
--  CHAT PARSING & DETECTION
-- ============================================================

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg)
    msg = string.gsub(msg, "^%[Server%]:%s*", "")

    local playerName, fishFull, weight = string.match(msg, "^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = string.match(msg, "^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end

    playerName = playerName:match("%[%a+%]:%s*(.+)") or playerName
    playerName = Trim(playerName)
    weight     = weight and Trim(weight) or "N/A"
    fishFull   = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull   = fishFull:match("^(.-)%s*[!%.]?$")     or fishFull
    fishFull   = Trim(fishFull)

    return { player = playerName, fish = fishFull, weight = weight }
end

local function GetAvatarUrl(player)
    return player and (PROXY .. "/avatar/" .. tostring(player.UserId) .. "?t=" .. tostring(os.time())) or nil
end

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end

    local data = ParseChat(rawMsg)
    if not data then return end

    local targetPlayer = FindPlayer(data.player)
    local avatarUrl    = GetAvatarUrl(targetPlayer)
    local uid = targetPlayer and targetPlayer.UserId or PlayerNameToId[string.lower(data.player)]

    -- Update player stats
    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = data.player }
        end
        PlayerStats[uid].catchCount   = PlayerStats[uid].catchCount + 1
        PlayerStats[uid].lastFishTime = os.time()

        -- Init GalatamaStats jika belum ada
        if not GalatamaStats[uid] then
            GalatamaStats[uid] = { name = data.player, totalPoin = 0, catches = {} }
        end
    end

    -- 1. Crystalized Legendary
    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = FishImageURL[legendaryBase]
            or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook("☄️ CRYSTALIZED LEGENDARY!", nil, 3407871, {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = "✨ Crystalized",             inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
        }, imageUrl, avatarUrl, GetMention(data.player), "secret")
        return
    end

    -- 2. Ruby Gemstone
    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = FishImageURL[rubyBase]
            or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook("💎 RUBY GEMSTONE!", nil, 16753920, {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
        }, imageUrl, avatarUrl, GetMention(data.player), "secret")
        return
    end

    -- 3. Secret Fish (termasuk cek Galatama point)
    local baseName, mutasi = FindSecretFish(data.fish)
    if baseName then
        local imageUrl = FishImageURL[baseName]
            or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))

        local isForgotten = false
        for _, name in ipairs(ForgottenList) do
            if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
        end

        if uid and PlayerStats[uid] then
            PlayerStats[uid].secretList[baseName] = (PlayerStats[uid].secretList[baseName] or 0) + 1
        end

        -- Cek apakah ikan ini masuk Galatama & tambah point
        local galatamaBase = FindGalatamaFish(data.fish)
        local galaPoint    = galatamaBase and GalatamaPoin[galatamaBase] or 0
        if galatamaBase and galaPoint > 0 and uid and GalatamaStats[uid] then
            GalatamaStats[uid].catches[galatamaBase]  = (GalatamaStats[uid].catches[galatamaBase] or 0) + 1
            GalatamaStats[uid].totalPoin              = GalatamaStats[uid].totalPoin + galaPoint
            GalatamaStats[uid].name                   = data.player
        end

        local chanceInfo  = FishChanceData[baseName] or "Unknown"
        local mutasiField = mutasi and ("*" .. mutasi .. "*") or "-"

        -- Field point Galatama (ditampilkan jika ikan masuk event)
        local fields = {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = mutasiField,                  inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
            { name = "Chance", value = "🎲 " .. chanceInfo,          inline = true },
        }

        if galatamaBase and galaPoint > 0 then
            table.insert(fields, {
                name   = "🏅 Galatama",
                value  = "**+" .. galaPoint .. " pts** (total: " .. (GalatamaStats[uid] and GalatamaStats[uid].totalPoin or galaPoint) .. " pts)",
                inline = true
            })
        end

        if isForgotten then
            ServerStats.totalForgotten = ServerStats.totalForgotten + 1
            table.insert(ServerStats.forgottenLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook("⚜️ FORGOTTEN TIER DETECTED!", nil, 16777215, fields, imageUrl, avatarUrl, GetMention(data.player), "forgotten")
        else
            ServerStats.totalSecret = ServerStats.totalSecret + 1
            table.insert(ServerStats.secretLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook("🦕 SECRET FISH DETECTED!", nil, 1752220, fields, imageUrl, avatarUrl, GetMention(data.player), "secret")
        end
        return
    end

    -- 4. Mutasi non-secret
    local mutasiDetected = FindMutasi(data.fish)
    if mutasiDetected then
        SendFishWebhook("✨ MUTASI DETECTED!", nil, 16776960, {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = "🌀 " .. mutasiDetected,     inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
        }, nil, avatarUrl, GetMention(data.player), "secret")
    end
end

-- ============================================================
--  BACKPACK MONITOR
-- ============================================================

local function WatchBackpack(bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName = FindSecretFish(item.Name)
        if baseName and not FishImageURL[baseName] and not FishImageCache[baseName] then
            local imgId = GetFishImageId(item)
            if imgId then FishImageCache[baseName] = imgId end
        end
    end)
end

local function WatchForFish(player)
    local bp = player:FindFirstChild("Backpack")
    if bp then WatchBackpack(bp) end
    player.CharacterAdded:Connect(function()
        local newBp = player:WaitForChild("Backpack", 15)
        if newBp then WatchBackpack(newBp) end
    end)
end

-- ============================================================
--  CHAT LOG
-- ============================================================

local function SendChatLog(senderName, message)
    if not SCRIPT_ACTIVE or not message or message == "" then return end
    local url = (WEBHOOK_CHAT ~= "") and WEBHOOK_CHAT or WEBHOOK_URL
    if url == "" then return end
    local player   = FindPlayer(senderName)
    local thumbUrl = player and (AvatarCache[player.UserId] or GetAvatarUrl(player)) or nil
    PostWebhook(url, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        embeds = { BuildEmbed("💬 CHAT LOG", nil, 5793266, {
            { name = "👤 Pemain", value = "**" .. senderName .. "**", inline = true  },
            { name = "💬 Pesan",  value = message,                    inline = false },
        }, nil, thumbUrl, "BLOX Gank Chat Log") },
    })
end

-- ============================================================
--  HOOK CHAT
-- ============================================================

local function HookChat()
    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            local text = msg.Text or ""
            if msg.TextSource == nil then
                CheckAndSend(text)
            else
                local senderName = msg.TextSource and msg.TextSource.Name or "Unknown"
                SendChatLog(senderName, text)
            end
        end)
    end

    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if not (d and d.Message) then return end
                local lowerMsg = string.lower(d.Message)
                local isServer = string.find(lowerMsg, "%[server%]") or string.find(lowerMsg, "obtained")
                if isServer then
                    CheckAndSend(d.Message)
                else
                    local sender = d.FromSpeaker or d.SpeakerName or "Unknown"
                    SendChatLog(sender, d.Message)
                end
            end)
        end
    end
end

-- ============================================================
--  START MONITORING
-- ============================================================

local function StartMonitoring()
    ServerStats.startTime = os.time()

    local allPlayers = Players:GetPlayers()
    local names      = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    SendWebhook("🎣 WEBHOOK STARTED — EVENT GALATAMA", nil, 65280, {
        { name = "Host",          value = "👤 " .. Players.LocalPlayer.Name,            inline = true  },
        { name = "Total Player",  value = "👥 " .. tostring(#allPlayers),                inline = true  },
        { name = "Daftar Player", value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
        { name = "🏅 Ikan Galatama", value =
            "Cryoshade Glider → **45 pts**\n" ..
            "Panther Eel → **75 pts**\n" ..
            "Giant Squid → **80 pts**\n" ..
            "Depthseeker Ray → **120 pts**\n" ..
            "Robot Kraken → **350 pts**",
          inline = false },
    })

    HookChat()

    -- Kirim kedua leaderboard saat disconnect
    game:GetService("Players").LocalPlayer.AncestryChanged:Connect(function(_, parent)
        if parent == nil and SCRIPT_ACTIVE then
            SendFinalLeaderboard()
        end
    end)

    local localPlayer = Players.LocalPlayer
    localPlayer.CharacterRemoving:Connect(function()
        task.delay(2, function()
            if not localPlayer.Parent then
                SendFinalLeaderboard()
            end
        end)
    end)

    -- Leaderboard secret biasa setiap 30 menit
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(LEADERBOARD_INTERVAL)
            if SCRIPT_ACTIVE then SendLeaderboard(false) end
        end
    end)

    -- Leaderboard Galatama setiap 30 menit
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(LEADERBOARD_GALATAMA_INTERVAL)
            if SCRIPT_ACTIVE then SendGalatamaLeaderboard(false) end
        end
    end)

    -- Server stats setiap 20 menit
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(1200)
            if not SCRIPT_ACTIVE then break end

            local uptime = os.time() - ServerStats.startTime
            local recentSecret, recentForgotten = {}, {}
            for i = math.max(1, #ServerStats.secretLog - 4), #ServerStats.secretLog do
                local e = ServerStats.secretLog[i]
                table.insert(recentSecret, e.fish .. " (" .. e.player .. ")")
            end
            for i = math.max(1, #ServerStats.forgottenLog - 4), #ServerStats.forgottenLog do
                local e = ServerStats.forgottenLog[i]
                table.insert(recentForgotten, e.fish .. " (" .. e.player .. ")")
            end

            SendStatsWebhook("🌐 SERVER STATS", nil, 3447003, {
                { name = "⏱️ Uptime Monitor",    value = UptimeString(uptime),                                                  inline = true  },
                { name = "🦕 Total Secret Fish",  value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",              inline = true  },
                { name = "⚜️ Total Forgotten",    value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor",           inline = true  },
                { name = "🕐 Secret Terakhir",    value = #recentSecret   > 0 and table.concat(recentSecret,   "\n") or "-",   inline = false },
                { name = "👑 Forgotten Terakhir", value = #recentForgotten > 0 and table.concat(recentForgotten, "\n") or "-", inline = false },
            })
        end
    end)

    -- Init existing players
    for _, p in ipairs(allPlayers) do
        WatchForFish(p)
        AvatarCache[p.UserId]                       = GetAvatarUrl(p)
        PlayerStats[p.UserId]                       = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = p.Name }
        GalatamaStats[p.UserId]                     = { name = p.Name, totalPoin = 0, catches = {} }
        PlayerNameToId[string.lower(p.Name)]        = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
        BuildMentionCache(p.Name, p.DisplayName)
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        LeaveTimers[player.UserId] = nil
        PlayerStats[player.UserId]   = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = player.Name }
        GalatamaStats[player.UserId] = { name = player.Name, totalPoin = 0, catches = {} }
        PlayerNameToId[string.lower(player.Name)]        = player.UserId
        PlayerNameToId[string.lower(player.DisplayName)] = player.UserId
        BuildMentionCache(player.Name, player.DisplayName)

        task.spawn(function()
            task.wait(1)
            AvatarCache[player.UserId] = GetAvatarUrl(player)
            SendWebhook("✅ PLAYER JOINED SERVER", nil, 65280, {
                { name = "Username", value = "**" .. player.Name .. "**",              inline = true },
                { name = "Total",    value = "👥 " .. tostring(#Players:GetPlayers()), inline = true },
            }, nil, AvatarCache[player.UserId], GetMention(player.Name), "join")
        end)

        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end

        local pName      = player.Name
        local pId        = player.UserId
        local avatarUrl  = AvatarCache[pId] or GetAvatarUrl(player)
        local totalNow   = #Players:GetPlayers() - 1
        local mentionStr = GetMention(pName)

        AvatarCache[pId]                    = nil
        PlayerStats[pId]                    = nil
        GalatamaStats[pId]                  = nil
        PlayerNameToId[string.lower(pName)] = nil
        for k, v in pairs(PlayerNameToId) do if v == pId then PlayerNameToId[k] = nil end end
        MentionCache[string.lower(pName)]   = nil

        SendWebhook("👋 PLAYER LEFT SERVER", nil, 16729344, {
            { name = "Username", value = "**" .. pName .. "**",       inline = true },
            { name = "Total",    value = "👥 " .. tostring(totalNow), inline = true },
        }, nil, avatarUrl, mentionStr, "leave")

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                PostWebhook(WEBHOOK_URL, {
                    username   = "BLOX Gank",
                    avatar_url = WEBHOOK_AVATAR,
                    content    = BuildContent(mentionStr, "notback"),
                    embeds     = { BuildEmbed("⏰ PLAYER TIDAK KEMBALI", nil, 16711680, {
                        { name = "Username", value = "**" .. pName .. "**",               inline = true },
                        { name = "Info",     value = "Tidak kembali selama **10 menit**", inline = true },
                    }, nil, nil) },
                })
            end
        end)
    end)
end

-- ============================================================
--  UI
-- ============================================================

local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name         = "BloxGankUI"
    gui.ResetOnSpawn = false
    gui.Parent       = (gethui and gethui()) or CoreGui

    local frame = Instance.new("Frame")
    frame.Name             = "Main"
    frame.Size             = UDim2.new(0, 300, 0, 420)
    frame.Position         = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel  = 0
    frame.Parent           = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Parent    = frame

    local topBar = Instance.new("Frame")
    topBar.Size             = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel  = 0
    topBar.Parent           = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size             = UDim2.new(1, 0, 0, 8)
    topBarFix.Position         = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBarFix.BorderSizePixel  = 0
    topBarFix.Parent           = topBar

    local title = Instance.new("TextLabel")
    title.Text              = "🎣 BLOX Gank — Galatama"
    title.Size              = UDim2.new(1, -80, 1, 0)
    title.Position          = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3        = Color3.fromRGB(255, 255, 255)
    title.Font              = Enum.Font.GothamBold
    title.TextSize          = 13
    title.TextXAlignment    = Enum.TextXAlignment.Left
    title.Parent            = topBar

    local function MakeWinBtn(text, xOffset, bgColor)
        local btn = Instance.new("TextButton")
        btn.Text             = text
        btn.Size             = UDim2.new(0, 28, 0, 22)
        btn.Position         = UDim2.new(1, xOffset, 0.5, -11)
        btn.BackgroundColor3 = bgColor
        btn.TextColor3       = Color3.fromRGB(255, 255, 255)
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 12
        btn.BorderSizePixel  = 0
        btn.Parent           = topBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        return btn
    end

    local minBtn   = MakeWinBtn("—", -58, Color3.fromRGB(60, 60, 60))
    local closeBtn = MakeWinBtn("✕", -28, Color3.fromRGB(200, 50, 50))

    local isMinimized = false
    local fullSize    = UDim2.new(0, 300, 0, 420)
    local miniSize    = UDim2.new(0, 300, 0, 36)

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        TweenService:Create(frame, TweenInfo.new(0.2), {
            Size = isMinimized and miniSize or fullSize
        }):Play()
        minBtn.Text = isMinimized and "□" or "—"
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), {
            Size = UDim2.new(0, 300, 0, 0), BackgroundTransparency = 1
        }):Play()
        task.wait(0.2); gui:Destroy()
    end)

    local function HoverTween(btn, hoverColor, baseColor)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = baseColor}):Play()  end)
    end
    HoverTween(minBtn,   Color3.fromRGB(80, 80, 80),   Color3.fromRGB(60, 60, 60))
    HoverTween(closeBtn, Color3.fromRGB(230, 70, 70),  Color3.fromRGB(200, 50, 50))

    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta    = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local statusDot = Instance.new("Frame")
    statusDot.Size             = UDim2.new(0, 8, 0, 8)
    statusDot.Position         = UDim2.new(0, 16, 0, 46)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    statusDot.BorderSizePixel  = 0
    statusDot.Parent           = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text              = "Tidak Aktif"
    statusLabel.Size              = UDim2.new(1, -40, 0, 20)
    statusLabel.Position          = UDim2.new(0, 30, 0, 38)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3        = Color3.fromRGB(180, 180, 180)
    statusLabel.Font              = Enum.Font.Gotham
    statusLabel.TextSize          = 11
    statusLabel.TextXAlignment    = Enum.TextXAlignment.Left
    statusLabel.Parent            = frame

    local function MakeLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Text              = text
        lbl.Size              = UDim2.new(1, -24, 0, 14)
        lbl.Position          = UDim2.new(0, 12, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3        = Color3.fromRGB(130, 130, 130)
        lbl.Font              = Enum.Font.Gotham
        lbl.TextSize          = 10
        lbl.TextXAlignment    = Enum.TextXAlignment.Left
        lbl.Parent            = frame
        return lbl
    end

    local function MakeInput(placeholder, yPos)
        local box = Instance.new("TextBox")
        box.PlaceholderText   = placeholder
        box.Size              = UDim2.new(1, -24, 0, 30)
        box.Position          = UDim2.new(0, 12, 0, yPos)
        box.BackgroundColor3  = Color3.fromRGB(35, 35, 35)
        box.TextColor3        = Color3.fromRGB(220, 220, 220)
        box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        box.Font              = Enum.Font.Gotham
        box.TextSize          = 10
        box.ClearTextOnFocus  = false
        box.BorderSizePixel   = 0
        box.Text              = ""
        box.TextXAlignment    = Enum.TextXAlignment.Left
        box.ClipsDescendants  = true
        box.Parent            = frame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local pad = Instance.new("UIPadding", box)
        pad.PaddingLeft  = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        return box
    end

    MakeLabel("👋 Webhook Join / Leave", 58)
    local inputJoin  = MakeInput("Paste webhook join/leave...", 72)
    MakeLabel("🐋 Webhook Secret Fish", 110)
    local inputFish  = MakeInput("Paste webhook secret fish...", 124)
    MakeLabel("📊 Webhook Stats", 162)
    local inputStats = MakeInput("Paste webhook stats...", 176)
    MakeLabel("💬 Webhook Chat Log", 210)
    local inputChat  = MakeInput("Paste webhook chat log...", 224)
    MakeLabel("🔔 Discord Role ID (opsional)", 258)
    local inputRole  = MakeInput("Masukkan Role ID...", 272)

    local allInputs = { inputJoin, inputFish, inputStats, inputChat, inputRole }

    -- START button
    local startBtn = Instance.new("TextButton")
    startBtn.Text             = "START MONITORING"
    startBtn.Size             = UDim2.new(1, -24, 0, 32)
    startBtn.Position         = UDim2.new(0, 12, 0, 312)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    startBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    startBtn.Font             = Enum.Font.GothamBold
    startBtn.TextSize         = 12
    startBtn.BorderSizePixel  = 0
    startBtn.Parent           = frame
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)

    -- EDIT WEBHOOK button
    local editBtn = Instance.new("TextButton")
    editBtn.Text             = "✏️ UBAH WEBHOOK"
    editBtn.Size             = UDim2.new(0.48, -12, 0, 32)
    editBtn.Position         = UDim2.new(0, 12, 0, 352)
    editBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    editBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    editBtn.Font             = Enum.Font.GothamBold
    editBtn.TextSize         = 10
    editBtn.BorderSizePixel  = 0
    editBtn.Visible          = false
    editBtn.Parent           = frame
    Instance.new("UICorner", editBtn).CornerRadius = UDim.new(0, 6)

    -- SEND GALATAMA LB button (manual trigger)
    local galaBtn = Instance.new("TextButton")
    galaBtn.Text             = "🏅 LB GALATAMA"
    galaBtn.Size             = UDim2.new(0.48, -12, 0, 32)
    galaBtn.Position         = UDim2.new(0.52, 0, 0, 352)
    galaBtn.BackgroundColor3 = Color3.fromRGB(160, 100, 0)
    galaBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    galaBtn.Font             = Enum.Font.GothamBold
    galaBtn.TextSize         = 10
    galaBtn.BorderSizePixel  = 0
    galaBtn.Visible          = false
    galaBtn.Parent           = frame
    Instance.new("UICorner", galaBtn).CornerRadius = UDim.new(0, 6)

    HoverTween(startBtn, Color3.fromRGB(0, 210, 120),  Color3.fromRGB(0, 180, 100))
    HoverTween(editBtn,  Color3.fromRGB(80, 130, 210), Color3.fromRGB(60, 100, 180))
    HoverTween(galaBtn,  Color3.fromRGB(200, 130, 0),  Color3.fromRGB(160, 100, 0))

    -- Manual kirim leaderboard Galatama
    galaBtn.MouseButton1Click:Connect(function()
        if not SCRIPT_ACTIVE then return end
        galaBtn.Text = "⏳ Mengirim..."
        SendGalatamaLeaderboard(false)
        task.wait(2)
        galaBtn.Text = "🏅 LB GALATAMA"
    end)

    -- Edit webhook toggle
    local isEditing = false
    editBtn.MouseButton1Click:Connect(function()
        if not SCRIPT_ACTIVE then return end
        isEditing = not isEditing

        if isEditing then
            for _, box in ipairs(allInputs) do
                box.TextEditable     = true
                box.BackgroundColor3 = Color3.fromRGB(50, 50, 30)
            end
            editBtn.Text             = "💾 SIMPAN"
            editBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 0)
        else
            if inputJoin.Text:find("discord.com/api/webhooks")  then WEBHOOK_URL      = inputJoin.Text  end
            if inputFish.Text:find("discord.com/api/webhooks")  then WEBHOOK_FISH     = inputFish.Text  end
            if inputStats.Text:find("discord.com/api/webhooks") then WEBHOOK_STATS    = inputStats.Text end
            if inputChat.Text:find("discord.com/api/webhooks")  then WEBHOOK_CHAT     = inputChat.Text  end
            local roleText = Trim(inputRole.Text)
            if roleText ~= "" then DISCORD_ROLE_ID = roleText end

            for _, box in ipairs(allInputs) do
                box.TextEditable     = false
                box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            editBtn.Text             = "✏️ UBAH WEBHOOK"
            editBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)

            PostWebhook(WEBHOOK_URL ~= "" and WEBHOOK_URL or WEBHOOK_STATS, {
                username = "BLOX Gank",
                embeds   = { BuildEmbed("⚙️ WEBHOOK DIPERBARUI", nil, 16776960, {
                    { name = "Info", value = "Konfigurasi webhook berhasil diubah.", inline = false },
                }) }
            })
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then return end

        if not inputJoin.Text:find("discord.com/api/webhooks") then
            startBtn.Text             = "❌ WEBHOOK JOIN INVALID!"
            startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(2)
            startBtn.Text             = "START MONITORING"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            return
        end

        WEBHOOK_URL = inputJoin.Text
        if inputFish.Text:find("discord.com/api/webhooks")  then WEBHOOK_FISH  = inputFish.Text  end
        if inputStats.Text:find("discord.com/api/webhooks") then WEBHOOK_STATS = inputStats.Text end
        if inputChat.Text:find("discord.com/api/webhooks")  then WEBHOOK_CHAT  = inputChat.Text  end
        local roleText = Trim(inputRole.Text)
        if roleText ~= "" then DISCORD_ROLE_ID = roleText end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        statusLabel.Text           = "Aktif — Monitoring Galatama..."
        statusLabel.TextColor3     = Color3.fromRGB(0, 220, 100)
        startBtn.Text              = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3  = Color3.fromRGB(30, 30, 30)

        for _, box in ipairs(allInputs) do box.TextEditable = false end

        editBtn.Visible = true
        galaBtn.Visible = true

        StartMonitoring()
    end)
end

-- ============================================================
--  INIT
-- ============================================================

CreateUI()
