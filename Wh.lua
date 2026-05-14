-- ============================================================
--  BLOX Gank Server Monitor  |  Discord: @bloxgank
-- ============================================================

local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local TextChatService   = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local TweenService      = game:GetService("TweenService")

-- ============================================================
--  CONFIGURATION  (diisi lewat UI — jangan hardcode di sini)
-- ============================================================

local WEBHOOK_URL       = ""
local WEBHOOK_STATS     = "https://discord.com/api/webhooks/1488003996026273893/4v2Z-a838D17SL7qn03o8s2PKX3oN2quVIui1g4GmYjrIkgnONbtQUlOGqxkLQLD5eIm"
local WEBHOOK_FISH      = "https://discord.com/api/webhooks/1491726016291405884/HIyVphEsp02A-h_Ry1M2YhivK51YZPngEkb2oOgdXZVD-hcArpBjh19yG7HiHmIz7f2a"
local WEBHOOK_CHAT      = "https://discord.com/api/webhooks/1498573795118678176/oxD9a1iqw2Id7GPY5Qk077bhcN0awn_LWeblphJYUtu6UV7SeH1T_7zP_fhN3yjqCgh2"
local WEBHOOK_GALATAMA  = "https://discord.com/api/webhooks/1487995039912038481/BqBd5GD0D6lLvE6y5rlGblGNXMl3ScQ8C40fCVXYiTy8YmbVYbbsi8yQOjvuIUNgtz2q"
local DISCORD_ROLE_ID   = "1489557585764810802"
local WEBHOOK_AVATAR    = ""
local PROXY             = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE     = false

-- Persist Galatama via Discord bot (diisi lewat UI)
local BOT_TOKEN         = ""
local SAVE_CHANNEL_ID   = ""
local SAVE_STATE_TAG    = "GALATAMA_SAVESTATE_V1"

local LEADERBOARD_INTERVAL = 1800

-- ============================================================
--  MEMBER LIST
-- ============================================================

local MemberList = {
    { username = "zupzupzuppasup",   display = "RISKAMAUFORGOTTEN", id = "766292778501275678"  },
    { username = "natadecxco",       display = "nata",              id = "638355599574171668"  },
    { username = "NNOON412",         display = "412",               id = "1125668364489080933" },
    { username = "kdryvka",          display = "YIYA",              id = "1312729486067761162" },
    { username = "Deff69699",        display = "DEF",               id = "1407731878756221040" },
    { username = "fzallzall",        display = "Ziell",             id = "462346945441038337"  },
    { username = "x_ibo21",          display = "wowo",              id = "954296542406246400"  },
    { username = "evosudin",         display = "Bluuism",           id = "875656564931956766"  },
    { username = "minxing_kim",      display = "minxing",           id = "484295718765461515"  },
    { username = "w4terhyacinth",    display = "ReVWater",          id = "1309945598409048076" },
    { username = "sedotanpink",      display = "sedotanpink",       id = "1406804062825091274" },
    { username = "dekadekadekk",     display = "dekadee",           id = "692735562817470494"  },
    { username = "ceriseciscake",    display = "ciscake",           id = "786950836034994216"  },
    { username = "cobadulumogaseru", display = "lah",               id = "1451975194397638676" },
    { username = "BEJOD06",          display = "masw",              id = "1222390041951600640" },
    { username = "flucidious",       display = "fluc",              id = "279691238494699530"  },
    { username = "hawaish01",        display = "ilywaa",            id = "1392909983678595244" },
    { username = "ocheanyx",         display = "Michiko",           id = "1299617626309263381" },
    { username = "Reverned99",       display = "Reverned99",        id = "870201488218157107"  },
    { username = "Leale716",         display = "leaa",              id = "1408658812424028182" },
}

-- ============================================================
--  FISH DATABASE
-- ============================================================

local SecretFishList = {
    "Crystal Crab","Orca","Zombie Shark","Zombie Megalodon","Dead Zombie Shark",
    "Blob Shark","Ghost Shark","Skeleton Narwhal","Ghost Worm Fish","Worm Fish",
    "Megalodon","1x1x1x1 Comet Shark","Bloodmoon Whale","Lochness Monster",
    "Monster Shark","Eerie Shark","Great Whale","Frostborn Shark","Thin Armor Shark",
    "Scare","Queen Crab","King Crab","Cryoshade Glider","Panther Eel",
    "Giant Squid","Depthseeker Ray","Robot Kraken","Mosasaur Shark","King Jelly",
    "Bone Whale","Elshark Gran Maja","Elpirate Gran Maja","Ancient Whale",
    "Gladiator Shark","Ancient Lochness Monster","Talon Serpent","Hacker Shark",
    "ElRetro Gran Maja","Strawberry Choc Megalodon","Krampus Shark",
    "Emerald Winter Whale","Winter Frost Shark","Icebreaker Whale","Leviathan",
    "Pirate Megalodon","Viridis Lurker","Cursed Kraken","Ancient Magma Whale",
    "Rainbow Comet Shark","Love Nessie","Broken Heart Nessie",
    "Mutant Runic Koi","Ketupat Whale","Cosmic Mutant Shark","Strawberry Orca",
    "Bonemaw Tyrant","Deepsea Monster Axolotl","Blocky Lochness Monster","Aurelion",
    "Runic Enchant Stone","Frogalloon",
    "Sea Eater","Thunderzilla","Iridesca","Frostbite Leviathan",
}

local ForgottenList = {
    "Sea Eater","Thunderzilla","Iridesca","Frostbite Leviathan",
}

local MutasiList = {
    "Noob","Fairy Dust","Holographic","Gemstone","Fire","Color Burn","Fozen",
    "Galaxy","Midnight","BloodMoon","Binary","Lightning","Disco","Festive","Radioactive",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon","Star Snail","Cute Dumbo","Blossom Jelly","Bioluminescent Octopus",
}

-- ============================================================
--  GALATAMA EVENT
-- ============================================================

local GalatamaFishList = {
    "Cryoshade Glider","Panther Eel","Giant Squid","Depthseeker Ray","Robot Kraken",
}

local GalatamaPoin = {
    ["Cryoshade Glider"] = 45,
    ["Panther Eel"]      = 75,
    ["Giant Squid"]      = 80,
    ["Depthseeker Ray"]  = 120,
    ["Robot Kraken"]     = 350,
}

local GalatamaRarity = {
    ["Cryoshade Glider"] = "1 in 450K",
    ["Panther Eel"]      = "1 in 750K",
    ["Giant Squid"]      = "1 in 800K",
    ["Depthseeker Ray"]  = "1 in 1.2M",
    ["Robot Kraken"]     = "1 in 3.5M",
}

-- ============================================================
--  FISH CHANCE & IMAGE
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
    ["Frogalloon"]               = "1 in 1.50M",
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

local MentionCache   = {}
local FishImageCache = {}
local AvatarCache    = {}
local LeaveTimers    = {}
local PlayerStats    = {}   -- [uid] = { name, catchCount, secretList, joinTime, lastFishTime }
local PlayerNameToId = {}   -- [lowercase name] = uid
local GalatamaStats  = {}   -- [uid] = { name, totalPoin, catches }
local NameStats      = {}   -- [lowercase name] = { name, secretList, totalPoin, catches } (fallback)

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
    return (str:gsub("<[^>]+>", ""))
end

local function Trim(s)
    return s:match("^%s*(.-)%s*$") or s
end

local function UptimeString(seconds)
    return math.floor(seconds / 3600) .. "h " .. math.floor((seconds % 3600) / 60) .. "m"
end

local function FindPlayer(name)
    local lower = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == lower or p.DisplayName:lower() == lower then
            return p
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(lower, 1, true) or lower:find(p.Name:lower(), 1, true) then
            return p
        end
    end
    return nil
end

-- ============================================================
--  MENTION HELPERS
-- ============================================================

local function BuildMentionCache(rbxName, rbxDisplay)
    local nl = rbxName:lower()
    local dl = rbxDisplay:lower()
    for _, m in ipairs(MemberList) do
        local ul = m.username:lower()
        local ml = m.display:lower()
        if nl == ul or dl == ml or nl == ml or dl == ul then
            MentionCache[nl] = m.id
            MentionCache[dl] = m.id
        end
    end
end

local function GetMention(robloxName)
    if not robloxName then return "" end
    local lower = robloxName:lower()
    if MentionCache[lower] then return "<@" .. MentionCache[lower] .. ">" end
    for _, m in ipairs(MemberList) do
        if m.username:lower() == lower or m.display:lower() == lower then
            return "<@" .. m.id .. ">"
        end
    end
    return ""
end

-- ============================================================
--  FISH DETECTION
-- ============================================================

local function FindSecretFish(fishName)
    local lower = fishName:lower()
    for _, base in ipairs(SecretFishList) do
        if lower == base:lower() then return base, nil end
    end
    local bestBase, bestLen, bestMutasi = nil, 0, nil
    for _, base in ipairs(SecretFishList) do
        local s = lower:find(base:lower(), 1, true)
        if s and #base > bestLen then
            bestLen = #base
            bestBase = base
            bestMutasi = (s > 1) and Trim(fishName:sub(1, s - 1)) or nil
            if bestMutasi == "" then bestMutasi = nil end
        end
    end
    return bestBase, bestMutasi
end

local function FindGalatamaFish(fishName)
    local lower = fishName:lower()
    for _, base in ipairs(GalatamaFishList) do
        if lower == base:lower() then return base end
    end
    local bestBase, bestLen = nil, 0
    for _, base in ipairs(GalatamaFishList) do
        if lower:find(base:lower(), 1, true) and #base > bestLen then
            bestLen  = #base
            bestBase = base
        end
    end
    return bestBase
end

local function FindMutasi(fishName)
    local lower = fishName:lower()
    for _, mutasi in ipairs(MutasiList) do
        local ml = mutasi:lower()
        local s  = lower:find(ml, 1, true)
        if s then
            local before = s == 1 and " " or lower:sub(s - 1, s - 1)
            local after  = lower:sub(s + #ml, s + #ml)
            if (before == " " or s == 1) and (after == " " or after == "") then
                return mutasi
            end
        end
    end
    return nil
end

local function FindRuby(fishName)
    local lower = fishName:lower()
    if lower:find("ruby") and lower:find("gemstone") then return "Ruby" end
    return nil
end

local function FindLegendaryCrystal(fishName)
    local lower = fishName:lower()
    if not lower:find("crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if lower:find(name:lower(), 1, true) then return name end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh") then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture") then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

-- ============================================================
--  WEBHOOK HELPERS
-- ============================================================

local function BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, footerTag)
    local embed = {
        title       = title,
        description = description,
        color       = color,
        fields      = fields or {},
        footer      = { text = (footerTag or "BLOX Gank") .. " | " .. os.date("%X") },
    }
    if imageUrl then embed.image     = { url = imageUrl } end
    if thumbUrl then embed.thumbnail = { url = thumbUrl } end
    return embed
end

local function PostWebhook(url, body)
    if not url or url == "" then return end
    local req = GetRequestFunc()
    if not req then return end
    task.spawn(function()
        pcall(function()
            req({
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
    if captionType == "secret" or captionType == "forgotten" then return "Ingfokan spot pliss " .. m
    elseif captionType == "leave"   then return "ke disconect ya? " .. m
    elseif captionType == "join"    then return "alhamdulilah kembali " .. m
    elseif captionType == "notback" then return "lah kok ngilang " .. m
    end
    return m
end

local function SendWebhook(title, desc, color, fields, imgUrl, thumbUrl, mention, captionType)
    PostWebhook(WEBHOOK_URL, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        content    = BuildContent(mention, captionType),
        embeds     = { BuildEmbed(title, desc, color, fields, imgUrl, thumbUrl) },
    })
end

local function SendFishWebhook(title, desc, color, fields, imgUrl, thumbUrl, mention, captionType)
    local url = WEBHOOK_FISH ~= "" and WEBHOOK_FISH or WEBHOOK_URL
    PostWebhook(url, {
        content = BuildContent(mention, captionType),
        embeds  = { BuildEmbed(title, desc, color, fields, imgUrl, thumbUrl) },
    })
end

local function SendStatsWebhook(title, desc, color, fields)
    PostWebhook(WEBHOOK_STATS, {
        embeds = { BuildEmbed(title, desc, color, fields, nil, nil, "BLOX Gank Stats") }
    })
end

-- ============================================================
--  GALATAMA PERSIST (save & restore via Discord)
-- ============================================================

local function SaveGalatamaState()
    local req = GetRequestFunc()
    if not req or BOT_TOKEN == "" or SAVE_CHANNEL_ID == "" then return end

    local saveData = {}
    -- Kumpulkan dari GalatamaStats (uid-based)
    for _, gs in pairs(GalatamaStats) do
        if gs.totalPoin > 0 then
            saveData[gs.name] = { totalPoin = gs.totalPoin, catches = gs.catches }
        end
    end
    -- Merge NameStats (fallback)
    for _, ns in pairs(NameStats) do
        if (ns.totalPoin or 0) > 0 and not saveData[ns.name] then
            saveData[ns.name] = { totalPoin = ns.totalPoin, catches = ns.catches }
        end
    end

    if next(saveData) == nil then return end

    local ok, jsonStr = pcall(function() return HttpService:JSONEncode(saveData) end)
    if not ok then return end

    pcall(function()
        req({
            Url     = "https://discord.com/api/v10/channels/" .. SAVE_CHANNEL_ID .. "/messages",
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. BOT_TOKEN },
            Body    = HttpService:JSONEncode({ content = SAVE_STATE_TAG .. "\n```json\n" .. jsonStr .. "\n```" }),
        })
    end)
end

local function RestoreGalatamaState()
    local req = GetRequestFunc()
    if not req or BOT_TOKEN == "" or SAVE_CHANNEL_ID == "" then return end

    local ok, response = pcall(function()
        return req({
            Url     = "https://discord.com/api/v10/channels/" .. SAVE_CHANNEL_ID .. "/messages?limit=50",
            Method  = "GET",
            Headers = { ["Authorization"] = "Bot " .. BOT_TOKEN },
        })
    end)
    if not ok or not response or not response.Body then return end

    local okParse, messages = pcall(function() return HttpService:JSONDecode(response.Body) end)
    if not okParse or type(messages) ~= "table" then return end

    for _, msg in ipairs(messages) do
        local content = msg.content or ""
        if content:find(SAVE_STATE_TAG, 1, true) then
            local jsonStr = content:match("```json\n(.+)\n```")
            if not jsonStr then break end

            local okJson, saveData = pcall(function() return HttpService:JSONDecode(jsonStr) end)
            if not okJson or type(saveData) ~= "table" then break end

            local restoredCount = 0
            for playerName, data in pairs(saveData) do
                local lname = playerName:lower()
                -- Restore ke NameStats (selalu, tidak perlu uid)
                if not NameStats[lname] then
                    NameStats[lname] = { name = playerName, secretList = {}, totalPoin = 0, catches = {} }
                end
                if (data.totalPoin or 0) > (NameStats[lname].totalPoin or 0) then
                    NameStats[lname].totalPoin = data.totalPoin or 0
                    NameStats[lname].catches   = data.catches   or {}
                    restoredCount = restoredCount + 1
                end
                -- Juga restore ke GalatamaStats kalau uid ketemu
                local uid = PlayerNameToId[lname]
                if uid then
                    if not GalatamaStats[uid] then
                        GalatamaStats[uid] = { name = playerName, totalPoin = 0, catches = {} }
                    end
                    if (data.totalPoin or 0) > GalatamaStats[uid].totalPoin then
                        GalatamaStats[uid].totalPoin = data.totalPoin or 0
                        GalatamaStats[uid].catches   = data.catches   or {}
                    end
                end
            end

            if restoredCount > 0 then
                local url = WEBHOOK_GALATAMA ~= "" and WEBHOOK_GALATAMA or WEBHOOK_URL
                PostWebhook(url, {
                    embeds = { BuildEmbed(
                        "♻️ DATA GALATAMA DIPULIHKAN",
                        "Point **" .. restoredCount .. "** pemain berhasil di-restore dari sesi sebelumnya.",
                        3066993, {}, nil, nil, "BLOX Gank Galatama"
                    )}
                })
            end
            break
        end
    end
end

-- ============================================================
--  LEADERBOARD
-- ============================================================

local function SendLeaderboard(isFinal)
    -- Gabungkan PlayerStats + NameStats
    local merged = {}
    for _, stats in pairs(PlayerStats) do
        local key = stats.name:lower()
        if not merged[key] then merged[key] = { name = stats.name, total = 0, fishList = {} } end
        for fishName, count in pairs(stats.secretList) do
            merged[key].total = merged[key].total + count
            table.insert(merged[key].fishList, fishName .. " x" .. count)
        end
    end
    for lname, ns in pairs(NameStats) do
        if not merged[lname] then merged[lname] = { name = ns.name, total = 0, fishList = {} } end
        for fishName, count in pairs(ns.secretList) do
            local found = false
            for _, entry in ipairs(merged[lname].fishList) do
                if entry:find(fishName, 1, true) then found = true; break end
            end
            if not found then
                merged[lname].total = merged[lname].total + count
                table.insert(merged[lname].fishList, fishName .. " x" .. count)
            end
        end
    end

    local leaderData = {}
    for _, entry in pairs(merged) do
        if entry.total > 0 then
            table.insert(leaderData, entry)
        end
    end
    if #leaderData == 0 then return end
    table.sort(leaderData, function(a, b) return a.total > b.total end)

    local medals    = { "🥇", "🥈", "🥉" }
    local uptime    = os.time() - ServerStats.startTime
    local roleMent  = DISCORD_ROLE_ID ~= "" and ("<@&" .. DISCORD_ROLE_ID .. ">") or ""
    local title     = isFinal and "🏆 LEADERBOARD FINAL — EVENT GALATAMA" or "🏆 LEADERBOARD SECRET FISH — EVENT GALATAMA"
    local contentMsg = isFinal
        and (roleMent ~= "" and roleMent .. " 📢 **Leaderboard Final!** Monitor disconnect." or nil)
        or  (roleMent ~= "" and roleMent .. " 📊 **Update Leaderboard Galatama!**" or nil)

    local fields = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("#" .. i)
        table.insert(fields, {
            name   = medal .. " " .. entry.name .. " — " .. entry.total .. " secret",
            value  = table.concat(entry.fishList, ", "),
            inline = false,
        })
    end
    table.insert(fields, { name = "🎪 Event",           value = "**Galatama**",                                                inline = true })
    table.insert(fields, { name = "⏱️ Uptime",          value = UptimeString(uptime),                                          inline = true })
    table.insert(fields, { name = "🦕 Total Secret",    value = "**" .. ServerStats.totalSecret .. "** ekor",                  inline = true })
    table.insert(fields, { name = "⚜️ Total Forgotten", value = "**" .. ServerStats.totalForgotten .. "** ekor",               inline = true })

    local statsUrl = WEBHOOK_STATS ~= "" and WEBHOOK_STATS or WEBHOOK_URL
    PostWebhook(statsUrl, {
        content = contentMsg,
        embeds  = { BuildEmbed(title, nil, 3066993, fields, nil, nil, "BLOX Gank Stats") },
    })
end

local function SendGalatamaLeaderboard(isFinal)
    -- Gabungkan GalatamaStats + NameStats
    local merged = {}
    for _, gs in pairs(GalatamaStats) do
        if gs.totalPoin > 0 then
            local key = gs.name:lower()
            if not merged[key] or gs.totalPoin > merged[key].totalPoin then
                merged[key] = { name = gs.name, totalPoin = gs.totalPoin, catches = gs.catches }
            end
        end
    end
    for lname, ns in pairs(NameStats) do
        if (ns.totalPoin or 0) > 0 then
            if not merged[lname] then
                merged[lname] = { name = ns.name, totalPoin = ns.totalPoin or 0, catches = ns.catches }
            elseif (ns.totalPoin or 0) > merged[lname].totalPoin then
                merged[lname] = { name = ns.name, totalPoin = ns.totalPoin or 0, catches = ns.catches }
            end
        end
    end

    local leaderData = {}
    for _, gs in pairs(merged) do
        local catchLines = {}
        for fishName, count in pairs(gs.catches) do
            local pts = (GalatamaPoin[fishName] or 0) * count
            table.insert(catchLines, fishName .. " x" .. count .. " (+" .. pts .. "pts)")
        end
        table.insert(leaderData, {
            name      = gs.name,
            totalPoin = gs.totalPoin,
            catchStr  = #catchLines > 0 and table.concat(catchLines, "\n") or "-",
        })
    end
    if #leaderData == 0 then return end
    table.sort(leaderData, function(a, b) return a.totalPoin > b.totalPoin end)

    local medals    = { "🥇", "🥈", "🥉" }
    local uptime    = os.time() - ServerStats.startTime
    local roleMent  = DISCORD_ROLE_ID ~= "" and ("<@&" .. DISCORD_ROLE_ID .. ">") or ""
    local title     = isFinal and "🏆 LEADERBOARD FINAL GALATAMA" or "🏆 LEADERBOARD GALATAMA — UPDATE"
    local contentMsg = isFinal
        and (roleMent ~= "" and roleMent .. " 📢 **Hasil Akhir Galatama!** Monitor disconnect." or nil)
        or  (roleMent ~= "" and roleMent .. " 📊 **Update Leaderboard Galatama!**" or nil)

    local fields = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("#" .. i)
        table.insert(fields, {
            name   = medal .. " " .. entry.name .. " — 🏅 " .. entry.totalPoin .. " pts",
            value  = entry.catchStr,
            inline = false,
        })
    end
    table.insert(fields, { name = "🎪 Event",          value = "**Galatama**",                       inline = true })
    table.insert(fields, { name = "⏱️ Uptime",         value = UptimeString(uptime),                  inline = true })
    table.insert(fields, { name = "🦕 Total Secret",   value = "**" .. ServerStats.totalSecret .. "** ekor", inline = true })

    PostWebhook(WEBHOOK_GALATAMA, {
        content = contentMsg,
        embeds  = { BuildEmbed(title,
            "```\nCryoshade Glider=45 | Panther Eel=75 | Giant Squid=80 | Depthseeker Ray=120 | Robot Kraken=350\n```",
            16766720, fields, nil, nil, "BLOX Gank Galatama") },
    })
end

local function SendFinalLeaderboard()
    SaveGalatamaState()
    SendLeaderboard(true)
    SendGalatamaLeaderboard(true)
end

-- ============================================================
--  CHAT PARSING
-- ============================================================

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg):gsub("^%[Server%]:%s*", "")
    local playerName, fishFull, weight = msg:match("^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = msg:match("^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end
    playerName = Trim(playerName:match("%[%a+%]:%s*(.+)") or playerName)
    weight     = Trim(weight or "N/A")
    fishFull   = Trim((fishFull:match("^(.-)%s+with a 1 in") or fishFull):match("^(.-)%s*[!%.]?$") or fishFull)
    return { player = playerName, fish = fishFull, weight = weight }
end

local function GetAvatarUrl(player)
    if not player then return nil end
    return PROXY .. "/avatar/" .. tostring(player.UserId) .. "?t=" .. tostring(os.time())
end

-- ============================================================
--  MAIN DETECTION
-- ============================================================

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not rawMsg:lower():find("obtained") then return end

    local data = ParseChat(rawMsg)
    if not data then return end

    local targetPlayer = FindPlayer(data.player)
    local avatarUrl    = GetAvatarUrl(targetPlayer)
    local uid          = targetPlayer and targetPlayer.UserId or PlayerNameToId[data.player:lower()]
    local lname        = data.player:lower()

    -- Init PlayerStats
    if uid and not PlayerStats[uid] then
        PlayerStats[uid] = { name = data.player, catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil }
    end
    if uid then
        PlayerStats[uid].catchCount   = PlayerStats[uid].catchCount + 1
        PlayerStats[uid].lastFishTime = os.time()
    end

    -- Init GalatamaStats
    if uid and not GalatamaStats[uid] then
        GalatamaStats[uid] = { name = data.player, totalPoin = 0, catches = {} }
    end

    -- Init NameStats (selalu, sebagai fallback)
    if not NameStats[lname] then
        NameStats[lname] = { name = data.player, secretList = {}, totalPoin = 0, catches = {} }
    end

    -- 1. Crystalized Legendary
    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imgUrl = FishImageURL[legendaryBase] or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook("☄️ CRYSTALIZED LEGENDARY!", nil, 3407871, {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = "✨ Crystalized",             inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
        }, imgUrl, avatarUrl, GetMention(data.player), "secret")
        return
    end

    -- 2. Ruby Gemstone
    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imgUrl = FishImageURL[rubyBase] or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook("💎 RUBY GEMSTONE!", nil, 16753920, {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
        }, imgUrl, avatarUrl, GetMention(data.player), "secret")
        return
    end

    -- 3. Secret Fish
    local baseName, mutasi = FindSecretFish(data.fish)
    if baseName then
        local imgUrl = FishImageURL[baseName] or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))

        local isForgotten = false
        for _, name in ipairs(ForgottenList) do
            if baseName:lower() == name:lower() then isForgotten = true; break end
        end

        -- Update secretList (uid + name fallback)
        if uid and PlayerStats[uid] then
            PlayerStats[uid].secretList[baseName] = (PlayerStats[uid].secretList[baseName] or 0) + 1
        end
        NameStats[lname].secretList[baseName] = (NameStats[lname].secretList[baseName] or 0) + 1

        -- Cek Galatama point
        local galBase  = FindGalatamaFish(data.fish)
        local galPoint = galBase and (GalatamaPoin[galBase] or 0) or 0
        if galBase and galPoint > 0 then
            if uid and GalatamaStats[uid] then
                GalatamaStats[uid].catches[galBase] = (GalatamaStats[uid].catches[galBase] or 0) + 1
                GalatamaStats[uid].totalPoin        = GalatamaStats[uid].totalPoin + galPoint
            end
            NameStats[lname].catches[galBase] = (NameStats[lname].catches[galBase] or 0) + 1
            NameStats[lname].totalPoin        = (NameStats[lname].totalPoin or 0) + galPoint
        end

        local chanceInfo  = FishChanceData[baseName] or "Unknown"
        local mutasiField = mutasi and ("*" .. mutasi .. "*") or "-"
        local totalPoinNow = 0
        if uid and GalatamaStats[uid] then totalPoinNow = GalatamaStats[uid].totalPoin
        elseif NameStats[lname] then totalPoinNow = NameStats[lname].totalPoin or 0 end

        local fields = {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = mutasiField,                  inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
            { name = "Chance", value = "🎲 " .. chanceInfo,          inline = true },
        }
        if galBase and galPoint > 0 then
            table.insert(fields, {
                name   = "🏅 Galatama",
                value  = "**+" .. galPoint .. " pts** (total: " .. totalPoinNow .. " pts)",
                inline = true,
            })
        end

        if isForgotten then
            ServerStats.totalForgotten = ServerStats.totalForgotten + 1
            table.insert(ServerStats.forgottenLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook("⚜️ FORGOTTEN TIER DETECTED!", nil, 16777215, fields, imgUrl, avatarUrl, GetMention(data.player), "forgotten")
        else
            ServerStats.totalSecret = ServerStats.totalSecret + 1
            table.insert(ServerStats.secretLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook("🦕 SECRET FISH DETECTED!", nil, 1752220, fields, imgUrl, avatarUrl, GetMention(data.player), "secret")
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
        local base = FindSecretFish(item.Name)
        if base and not FishImageURL[base] and not FishImageCache[base] then
            local id = GetFishImageId(item)
            if id then FishImageCache[base] = id end
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
    local url = WEBHOOK_CHAT ~= "" and WEBHOOK_CHAT or WEBHOOK_URL
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
                local sender = msg.TextSource and msg.TextSource.Name or "Unknown"
                SendChatLog(sender, text)
            end
        end)
    end

    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if not (d and d.Message) then return end
                local lowerMsg = d.Message:lower()
                if lowerMsg:find("%[server%]") or lowerMsg:find("obtained") then
                    CheckAndSend(d.Message)
                else
                    SendChatLog(d.FromSpeaker or d.SpeakerName or "Unknown", d.Message)
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
    local names = {}
    for _, p in ipairs(allPlayers) do
        table.insert(names, p.Name)
        AvatarCache[p.UserId]                       = GetAvatarUrl(p)
        PlayerStats[p.UserId]                       = { name = p.Name, catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil }
        GalatamaStats[p.UserId]                     = { name = p.Name, totalPoin = 0, catches = {} }
        NameStats[p.Name:lower()]                   = { name = p.Name, secretList = {}, totalPoin = 0, catches = {} }
        PlayerNameToId[p.Name:lower()]              = p.UserId
        PlayerNameToId[p.DisplayName:lower()]       = p.UserId
        BuildMentionCache(p.Name, p.DisplayName)
        WatchForFish(p)
    end

    SendWebhook("🎣 WEBHOOK STARTED — EVENT GALATAMA", nil, 65280, {
        { name = "Host",             value = "👤 " .. Players.LocalPlayer.Name,            inline = true  },
        { name = "Total Player",     value = "👥 " .. tostring(#allPlayers),                inline = true  },
        { name = "Daftar Player",    value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
        { name = "🏅 Ikan Galatama", value = "Cryoshade Glider→**45pts** | Panther Eel→**75pts** | Giant Squid→**80pts** | Depthseeker Ray→**120pts** | Robot Kraken→**350pts**", inline = false },
    })

    HookChat()

    -- Restore point setelah 3 detik (tunggu player list ready)
    task.spawn(function()
        task.wait(3)
        if SCRIPT_ACTIVE then RestoreGalatamaState() end
    end)

    -- Leaderboard tiap 30 menit
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(LEADERBOARD_INTERVAL)
            if SCRIPT_ACTIVE then
                SendLeaderboard(false)
                SendGalatamaLeaderboard(false)
            end
        end
    end)

    -- Server stats tiap 20 menit
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(1200)
            if not SCRIPT_ACTIVE then break end
            local uptime = os.time() - ServerStats.startTime
            local recentS, recentF = {}, {}
            for i = math.max(1, #ServerStats.secretLog - 4), #ServerStats.secretLog do
                local e = ServerStats.secretLog[i]
                table.insert(recentS, e.fish .. " (" .. e.player .. ")")
            end
            for i = math.max(1, #ServerStats.forgottenLog - 4), #ServerStats.forgottenLog do
                local e = ServerStats.forgottenLog[i]
                table.insert(recentF, e.fish .. " (" .. e.player .. ")")
            end
            SendStatsWebhook("🌐 SERVER STATS", nil, 3447003, {
                { name = "⏱️ Uptime",          value = UptimeString(uptime),                                             inline = true  },
                { name = "🦕 Total Secret",     value = "**" .. ServerStats.totalSecret .. "** ekor",                    inline = true  },
                { name = "⚜️ Total Forgotten",  value = "**" .. ServerStats.totalForgotten .. "** ekor",                 inline = true  },
                { name = "🕐 Secret Terakhir",  value = #recentS > 0 and table.concat(recentS, "\n") or "-",            inline = false },
                { name = "👑 Forgotten Terakhir",value = #recentF > 0 and table.concat(recentF, "\n") or "-",           inline = false },
            })
        end
    end)

    -- Player join
    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        LeaveTimers[player.UserId]                      = nil
        PlayerStats[player.UserId]                      = { name = player.Name, catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil }
        GalatamaStats[player.UserId]                    = { name = player.Name, totalPoin = 0, catches = {} }
        NameStats[player.Name:lower()]                  = NameStats[player.Name:lower()] or { name = player.Name, secretList = {}, totalPoin = 0, catches = {} }
        PlayerNameToId[player.Name:lower()]             = player.UserId
        PlayerNameToId[player.DisplayName:lower()]      = player.UserId
        BuildMentionCache(player.Name, player.DisplayName)
        task.spawn(function()
            task.wait(1)
            AvatarCache[player.UserId] = GetAvatarUrl(player)
            SendWebhook("✅ PLAYER JOINED", nil, 65280, {
                { name = "Username", value = "**" .. player.Name .. "**",              inline = true },
                { name = "Total",    value = "👥 " .. tostring(#Players:GetPlayers()), inline = true },
            }, nil, AvatarCache[player.UserId], GetMention(player.Name), "join")
        end)
        WatchForFish(player)
    end)

    -- Player leave
    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local pName      = player.Name
        local pId        = player.UserId
        local avatarUrl  = AvatarCache[pId] or GetAvatarUrl(player)
        local totalNow   = #Players:GetPlayers() - 1
        local mentionStr = GetMention(pName)

        AvatarCache[pId]                    = nil
        PlayerNameToId[pName:lower()]       = nil
        PlayerNameToId[player.DisplayName:lower()] = nil
        MentionCache[pName:lower()]         = nil
        -- Sengaja tidak hapus PlayerStats/GalatamaStats/NameStats agar data tetap ada di leaderboard

        SendWebhook("👋 PLAYER LEFT", nil, 16729344, {
            { name = "Username", value = "**" .. pName .. "**",        inline = true },
            { name = "Total",    value = "👥 " .. tostring(totalNow),  inline = true },
        }, nil, avatarUrl, mentionStr, "leave")

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                PostWebhook(WEBHOOK_URL, {
                    username = "BLOX Gank",
                    content  = BuildContent(mentionStr, "notback"),
                    embeds   = { BuildEmbed("⏰ PLAYER TIDAK KEMBALI", nil, 16711680, {
                        { name = "Username", value = "**" .. pName .. "**",               inline = true },
                        { name = "Info",     value = "Tidak kembali selama **10 menit**", inline = true },
                    }) },
                })
            end
        end)
    end)

    -- Kirim leaderboard final saat disconnect
    local finalSent = false
    local function TrySendFinal()
        if finalSent or not SCRIPT_ACTIVE then return end
        finalSent = true
        SendFinalLeaderboard()
    end

    Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
        if parent == nil then TrySendFinal() end
    end)

    Players.LocalPlayer.CharacterRemoving:Connect(function()
        task.spawn(function()
            task.wait(2)
            if not Players.LocalPlayer.Parent then TrySendFinal() end
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
    frame.Size             = UDim2.new(0, 300, 0, 310)
    frame.Position         = UDim2.new(0.5, -150, 0.5, -155)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel  = 0
    frame.Parent           = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Parent    = frame

    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Size             = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel  = 0
    topBar.Parent           = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

    local topFix = Instance.new("Frame")
    topFix.Size             = UDim2.new(1, 0, 0, 8)
    topFix.Position         = UDim2.new(0, 0, 1, -8)
    topFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topFix.BorderSizePixel  = 0
    topFix.Parent           = topBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text                 = "🎣 BLOX Gank — Galatama"
    titleLbl.Size                 = UDim2.new(1, -80, 1, 0)
    titleLbl.Position             = UDim2.new(0, 10, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    titleLbl.Font                 = Enum.Font.GothamBold
    titleLbl.TextSize             = 13
    titleLbl.TextXAlignment       = Enum.TextXAlignment.Left
    titleLbl.Parent               = topBar

    local function MakeWinBtn(text, xOff, bg)
        local btn = Instance.new("TextButton")
        btn.Text             = text
        btn.Size             = UDim2.new(0, 28, 0, 22)
        btn.Position         = UDim2.new(1, xOff, 0.5, -11)
        btn.BackgroundColor3 = bg
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

    local isMin    = false
    local fullSize = UDim2.new(0, 300, 0, 310)
    local miniSize = UDim2.new(0, 300, 0, 36)

    local function HoverTween(btn, hover, base)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hover }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = base  }):Play() end)
    end
    HoverTween(minBtn,   Color3.fromRGB(80, 80, 80),   Color3.fromRGB(60, 60, 60))
    HoverTween(closeBtn, Color3.fromRGB(230, 70, 70),  Color3.fromRGB(200, 50, 50))

    minBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        TweenService:Create(frame, TweenInfo.new(0.2), { Size = isMin and miniSize or fullSize }):Play()
        minBtn.Text = isMin and "□" or "—"
    end)
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { Size = UDim2.new(0, 300, 0, 0), BackgroundTransparency = 1 }):Play()
        task.wait(0.2)
        gui:Destroy()
    end)

    -- Drag
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
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- Status
    local statusDot = Instance.new("Frame")
    statusDot.Size             = UDim2.new(0, 8, 0, 8)
    statusDot.Position         = UDim2.new(0, 16, 0, 46)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    statusDot.BorderSizePixel  = 0
    statusDot.Parent           = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Text                 = "Tidak Aktif"
    statusLbl.Size                 = UDim2.new(1, -40, 0, 20)
    statusLbl.Position             = UDim2.new(0, 30, 0, 38)
    statusLbl.BackgroundTransparency = 1
    statusLbl.TextColor3           = Color3.fromRGB(180, 180, 180)
    statusLbl.Font                 = Enum.Font.Gotham
    statusLbl.TextSize             = 11
    statusLbl.TextXAlignment       = Enum.TextXAlignment.Left
    statusLbl.Parent               = frame

    local function MakeLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Text                 = text
        lbl.Size                 = UDim2.new(1, -24, 0, 14)
        lbl.Position             = UDim2.new(0, 12, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3           = Color3.fromRGB(130, 130, 130)
        lbl.Font                 = Enum.Font.Gotham
        lbl.TextSize             = 10
        lbl.TextXAlignment       = Enum.TextXAlignment.Left
        lbl.Parent               = frame
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
    local inputJoin    = MakeInput("Paste webhook join/leave...", 72)
    MakeLabel("🤖 Bot Token (untuk restore point)", 110)
    local inputToken   = MakeInput("Paste Bot Token...", 124)
    MakeLabel("📌 Channel ID Galatama", 162)
    local inputChannel = MakeInput("Paste Channel ID...", 176)

    local allInputs = { inputJoin, inputToken, inputChannel }

    -- START button
    local startBtn = Instance.new("TextButton")
    startBtn.Text             = "START MONITORING"
    startBtn.Size             = UDim2.new(1, -24, 0, 32)
    startBtn.Position         = UDim2.new(0, 12, 0, 222)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    startBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    startBtn.Font             = Enum.Font.GothamBold
    startBtn.TextSize         = 12
    startBtn.BorderSizePixel  = 0
    startBtn.Parent           = frame
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)
    HoverTween(startBtn, Color3.fromRGB(0, 210, 120), Color3.fromRGB(0, 180, 100))

    -- Edit Webhook button
    local editBtn = Instance.new("TextButton")
    editBtn.Text             = "✏️ UBAH WEBHOOK"
    editBtn.Size             = UDim2.new(0.48, -12, 0, 32)
    editBtn.Position         = UDim2.new(0, 12, 0, 266)
    editBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    editBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    editBtn.Font             = Enum.Font.GothamBold
    editBtn.TextSize         = 10
    editBtn.BorderSizePixel  = 0
    editBtn.Visible          = false
    editBtn.Parent           = frame
    Instance.new("UICorner", editBtn).CornerRadius = UDim.new(0, 6)
    HoverTween(editBtn, Color3.fromRGB(80, 130, 210), Color3.fromRGB(60, 100, 180))

    -- Galatama LB button
    local galaBtn = Instance.new("TextButton")
    galaBtn.Text             = "🏅 LB GALATAMA"
    galaBtn.Size             = UDim2.new(0.48, -12, 0, 32)
    galaBtn.Position         = UDim2.new(0.52, 0, 0, 266)
    galaBtn.BackgroundColor3 = Color3.fromRGB(160, 100, 0)
    galaBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    galaBtn.Font             = Enum.Font.GothamBold
    galaBtn.TextSize         = 10
    galaBtn.BorderSizePixel  = 0
    galaBtn.Visible          = false
    galaBtn.Parent           = frame
    Instance.new("UICorner", galaBtn).CornerRadius = UDim.new(0, 6)
    HoverTween(galaBtn, Color3.fromRGB(200, 130, 0), Color3.fromRGB(160, 100, 0))

    galaBtn.MouseButton1Click:Connect(function()
        if not SCRIPT_ACTIVE then return end
        galaBtn.Text = "⏳ Mengirim..."
        SendGalatamaLeaderboard(false)
        task.wait(2)
        galaBtn.Text = "🏅 LB GALATAMA"
    end)

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
            if inputJoin.Text:find("discord.com/api/webhooks") then WEBHOOK_URL = inputJoin.Text end
            if inputToken.Text   ~= "" then BOT_TOKEN       = inputToken.Text   end
            if inputChannel.Text ~= "" then SAVE_CHANNEL_ID = inputChannel.Text end
            for _, box in ipairs(allInputs) do
                box.TextEditable     = false
                box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            editBtn.Text             = "✏️ UBAH WEBHOOK"
            editBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
            PostWebhook(WEBHOOK_URL ~= "" and WEBHOOK_URL or WEBHOOK_STATS, {
                username = "BLOX Gank",
                embeds   = { BuildEmbed("⚙️ KONFIGURASI DIPERBARUI", nil, 16776960, {
                    { name = "Info", value = "Webhook & token berhasil diubah.", inline = false },
                }) }
            })
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then return end
        if not inputJoin.Text:find("discord.com/api/webhooks") then
            startBtn.Text             = "❌ WEBHOOK INVALID!"
            startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(2)
            startBtn.Text             = "START MONITORING"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            return
        end

        WEBHOOK_URL = inputJoin.Text
        if inputToken.Text   ~= "" then BOT_TOKEN       = inputToken.Text   end
        if inputChannel.Text ~= "" then SAVE_CHANNEL_ID = inputChannel.Text end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        statusLbl.Text             = "Aktif — Monitoring Galatama..."
        statusLbl.TextColor3       = Color3.fromRGB(0, 220, 100)
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
