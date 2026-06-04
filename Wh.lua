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
local WEBHOOK_STATS     = ""
local WEBHOOK_FISH      = ""
local WEBHOOK_AVATAR    = ""
local PROXY             = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE     = false

local LEADERBOARD_INTERVAL = 1800  -- 30 menit (detik)

-- ============================================================
--  MEMBER LIST
--  Format: { username = "RobloxUsername", display = "DisplayName", id = "DiscordID" }
-- ============================================================

local MemberList = {
    -- ── Existing members (updated) ───────────────────────────────────────────────
    { username = "zupzupzuppasup",   display = "KEPALASPPGDKIJAKARTA", id = "766292778501275678" }, -- updated display
    { username = "natadecxco",       display = "natarebus",            id = "638355599574171668" }, -- updated display
    { username = "pyciieegirls",     display = "pyciiiii",             id = "1182254978904109138" },
    { username = "kdryvka",          display = "YIYA",                 id = "1312729486067761162" },
    { username = "1nhanss",          display = "han",                  id = "1438046472179548190" }, -- ID dipertahankan (data baru konflik dgn pyciieegirls)
    { username = "cjmin131",         display = "Karaadino",            id = "1406639996127154246" },
    { username = "x_ibo21",          display = "wowo",                 id = "954296542406246400" },
    { username = "evosudin",         display = "Bluuism",              id = "875656564931956766" },
    { username = "minxing_kim",      display = "Minxing",              id = "484295718765461515" }, -- updated display
    { username = "w4terhyacinth",    display = "waterrr",              id = "1309945598409048076" }, -- updated display
    { username = "rexlepwz",         display = "Reeamore",             id = "1205780304753725492" }, -- updated display
    { username = "dekadekadekk",     display = "dekadee",              id = "692735562817470494" },
    { username = "ceriseciscake",    display = "ciscake",              id = "786950836034994216" },
    { username = "mnikndy",          display = "prettyv",              id = "1478607686345035880" },
    { username = "BEJOD06",          display = "MasW",                 id = "1222390041951600640" }, -- updated display
    { username = "flucidious",       display = "fluc",                 id = "279691238494699530" },
    { username = "hawaish01",        display = "ilywaa",               id = "1392909983678595244" },
    { username = "AcidReign07",      display = "kiixlau",              id = "1393120438594437161" },
    { username = "minyaktalon9990",  display = "Revv2",                id = "870201488218157107" },
    { username = "alleThetwin",      display = "LikeAvillain",         id = "870201488218157107" }, -- sama ID dgn Revv2
    { username = "fzallzall",        display = "Ziell",                id = "462346945441038337" },
    { username = "cecillionz1",      display = "ceceyy",               id = "1404117087303110877" },
    { username = "Klerra_Asu",       display = "MomKlerra",            id = "1171410071092215888" }, -- updated display & ID
    { username = "theromantasy",     display = "star",                 id = "1461593359318650880" },
    { username = "choalyn_2",        display = "Alyn_ikaa",            id = "1467390946357416060" },
    { username = "Alyn_ikaa",        display = "Choalyn_2",            id = "1467390946357416060" }, -- akun alt choalyn
    { username = "zyr_xi",           display = "fii",                  id = "1181609363236999289" },
    { username = "Matchafav17",      display = "Macaaa",               id = "1478634976990859304" },
    { username = "0_Aurorain",       display = "Aurorain",             id = "574581489912643603" },
    { username = "cobadulumogaseru", display = "lah",                  id = "1451975194397638676" },
    { username = "Avochildoo",       display = "Avo",                  id = "1203622473955024896" },
    { username = "renjunundip",      display = "aleale",               id = "1428266616763977811" },
    { username = "iloafieus",        display = "mavis",                id = "1440589079086628998" },
    { username = "aaireell",         display = "ellyaaa",              id = "" },
    { username = "trianayaa23",      display = "tiarkive",             id = "1425223281686085713" },
    { username = "longisimusdorsii", display = "strawberry",           id = "638355599574171668" }, -- updated ID (data baru)
    { username = "Thismeann",        display = "Oceann",               id = "1463858926394015838" },
    { username = "hynad27",          display = "jisoo",                id = "1217043654909366323" },
    { username = "Bintanggg_1111",   display = "niss",                 id = "574581489912643603" },
    -- ── New members ──────────────────────────────────────────────────────────────
    { username = "Baeforlife",       display = "Jaemin_choa",          id = "1467390946357416060" }, -- akun alt Alyn_ikaa
    { username = "OomKlerra2",       display = "OomKlerra2",           id = "1171410071092215888" }, -- akun alt Klerra_Asu
    { username = "kathzeu",          display = "katzu",                id = "669806652375040022" }, -- username tanpa @ (tidak valid di Roblox)
    { username = "tantecungkring",   display = "Lavvy",                id = "757111417919766648" },
    { username = "prada2296",        display = "Prada",                id = "757111417919766648" }, -- sama ID dgn tantecungkring
}

-- ============================================================
--  DATABASE
-- ============================================================

local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armor Shark",
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
    "Runic Enchant Stone", "Frogalloon", "Coral Whale", "Flame Tyrant", "Withering Core",
    -- Forgotten Tier
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane", "Cerulean Dragon",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane", "Cerulean Dragon",
}

local MutasiList = {
    "Noob", "Fairy Dust", "Holographic", "Gemstone", "Fire", "Color Burn", "Frozen",
    "Galaxy", "BloodMoon", "Binary", "Lightning", "Disco", "Festive", "Radioactive", "Moon Fragment",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo",
    "Blossom Jelly", "Bioluminescent Octopus",
}

local RubyList = { "Ruby" }

local FishChanceData = {
    ["Crystal Crab"]              = "1 in 750K",
    ["Orca"]                      = "1 in 1.5M",
    ["Zombie Shark"]              = "1 in 250K",
    ["Zombie Megalodon"]          = "1 in 4M",
    ["Dead Zombie Shark"]         = "1 in 500K",
    ["Blob Shark"]                = "1 in 250K",
    ["Ghost Shark"]               = "1 in 500K",
    ["Skeleton Narwhal"]          = "1 in 600K",
    ["Ghost Worm Fish"]           = "1 in 1M",
    ["Worm Fish"]                 = "1 in 3M",
    ["Megalodon"]                 = "1 in 4M",
    ["1x1x1x1 Comet Shark"]       = "1 in 4M",
    ["Bloodmoon Whale"]           = "1 in 5M",
    ["Lochness Monster"]          = "1 in 3M",
    ["Monster Shark"]             = "1 in 2.5M",
    ["Eerie Shark"]               = "1 in 250K",
    ["Great Whale"]               = "1 in 900K",
    ["Frostborn Shark"]           = "1 in 500K",
    ["Thin Armor Shark"]          = "1 in 300K",  -- FIX: was "Thin Armored Shark" (tidak cocok key SecretFishList)
    ["Scare"]                     = "1 in 3M",
    ["Queen Crab"]                = "1 in 800K",
    ["King Crab"]                 = "1 in 1.2M",
    ["Cryoshade Glider"]          = "1 in 450K",
    ["Panther Eel"]               = "1 in 750K",
    ["Giant Squid"]               = "1 in 800K",
    ["Depthseeker Ray"]           = "1 in 1.2M",
    ["Robot Kraken"]              = "1 in 3.5M",
    ["Mosasaur Shark"]            = "1 in 800K",
    ["King Jelly"]                = "1 in 1.5M",
    ["Bone Whale"]                = "1 in 2M",
    ["Elshark Gran Maja"]         = "1 in 4M",
    ["Elpirate Gran Maja"]        = "1 in 4M",
    ["ElRetro Gran Maja"]         = "1 in 4M",
    ["Ancient Whale"]             = "1 in 2.75M",
    ["Gladiator Shark"]           = "1 in 1M",
    ["Ancient Lochness Monster"]  = "1 in 3M",
    ["Talon Serpent"]             = "1 in 3M",
    ["Hacker Shark"]              = "1 in 2M",
    ["Strawberry Choc Megalodon"] = "1 in 4M",
    ["Krampus Shark"]             = "1 in 1M",
    ["Emerald Winter Whale"]      = "1 in 1.5M",
    ["Winter Frost Shark"]        = "1 in 3M",
    ["Icebreaker Whale"]          = "1 in 4M",
    ["Cursed Kraken"]             = "1 in 3M",
    ["Pirate Megalodon"]          = "1 in 4M",
    ["Leviathan"]                 = "1 in 5M",
    ["Viridis Lurker"]            = "1 in 1.4M",
    ["Ancient Magma Whale"]       = "1 in 5M",
    ["Mutant Runic Koi"]          = "1 in ??",
    ["Cosmic Mutant Shark"]       = "1 in 2M",
    ["Strawberry Orca"]           = "1 in 3M",
    ["Bonemaw Tyrant"]            = "1 in 2.5M",
    ["Rainbow Comet Shark"]       = "1 in ??",   -- FIX: ditambahkan (ada di SecretFishList tapi tidak ada di ChanceData)
    ["Love Nessie"]               = "1 in ??",   -- FIX: ditambahkan
    ["Broken Heart Nessie"]       = "1 in ??",   -- FIX: ditambahkan
    ["Sea Eater"]                 = "1 in 25M",
    ["Thunderzilla"]              = "1 in 30M",
    ["Iridesca"]                  = "1 in 25M",
    ["Eggy Enchant Stone"]        = "1 in 100K",
    ["Deepsea Monster Axolotl"]   = "1 in 2M",
    ["Blocky Lochness Monster"]   = "1 in 3M",
    ["Frostbite Leviathan"]       = "1 in 12M",
    ["Aurelion"]                  = "1 in 3M",
    ["Runic Enchant Stone"]       = "1 in 1.5M",  -- FIX: was "1 in 1.50M" (konsistensi)
    ["Frogalloon"]                = "1 in 1.5M",  -- FIX: was "1 in 1,50M" (koma → titik)
    ["Fluorivane"]                = "1 in 15M",
    ["Coral Whale"]               = "1 in 2M",
    ["Flame Tyrant"]              = "1 in 5M",
    ["Cerulean Dragon"]           = "1 in 25M",
    ["Withering Core"]            = "1 in ??",
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
    ["Scare"]                    = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Scare.png",
    ["Viridis Lurker"]           = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Viridis%20Lurker.jpg",
    ["Fluorivane"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Fluorivane.png",
    ["Coral Whale"]              = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Coral%20Whale.png",
    ["Runic Enchant Stone"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Runic%20Enchant%20Stone.png",
    ["Flame Tyrant"]             = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Flame%20Tyrant.png",
    ["Cerulean Dragon"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cerulean%20Dragon.png",  -- FIX: typo "Curelean" → "Cerulean"
    ["Withering Core"]           = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Withering%20Core.png",
}

-- ============================================================
--  STATE / CACHE
-- ============================================================

local MentionCache    = {}
local FishImageCache  = {}
local AvatarCache     = {}
local LeaveTimers     = {}
local PlayerStats     = {}
local PlayerNameToId  = {}

local ServerStats = {
    totalSecret    = 0,
    totalForgotten = 0,
    secretLog      = {},
    forgottenLog   = {},
    startTime      = 0,
}

-- ============================================================
--  SAVE CONFIG (writefile / readfile)
-- ============================================================

local CONFIG_FILE = "bloxgank_config.json"

local function SaveConfig(joinUrl, fishUrl, statsUrl)
    if not writefile then return end
    local ok, err = pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            webhook_join  = joinUrl  or "",
            webhook_fish  = fishUrl  or "",
            webhook_stats = statsUrl or "",
        }))
    end)
    if not ok then warn("[BloxGank] Gagal simpan config: " .. tostring(err)) end
end

local function LoadConfig()
    if not readfile or not isfile then return nil end
    local ok, raw = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok or not raw or raw == "" then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and type(data) == "table" then return data end
    return nil
end

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
    if string.find(lower, "ruby") and string.find(lower, "gemstone") then
        return "Ruby"
    end
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
    local content = BuildContent(mention, captionType)
    PostWebhook(WEBHOOK_URL, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        content    = content,
        embeds     = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local url = (WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL
    if url == "" then return end
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    local content = BuildContent(mention, captionType)
    PostWebhook(url, {
        content = content,
        embeds  = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendStatsWebhook(title, description, color, fields, imageUrl, thumbUrl)
    PostWebhook(WEBHOOK_STATS, {
        embeds = { BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, "BLOX Gank Stats") }
    })
end

-- ============================================================
--  LEADERBOARD
-- ============================================================

local function SendLeaderboard()
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
    if #leaderData == 0 then return end

    local medals = { "🥇", "🥈", "🥉" }
    local lines  = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("**#" .. i .. "**")
        table.insert(lines, medal .. " **" .. entry.name .. "** — " .. entry.total .. " secret\n↳ " .. entry.fishStr)
    end

    local uptime = os.time() - ServerStats.startTime
    SendStatsWebhook("🏆 LEADERBOARD SECRET FISH", table.concat(lines, "\n\n"), 16766720, {
        { name = "⏱️ Uptime",          value = UptimeString(uptime),                                      inline = true },
        { name = "🦕 Total Secret",    value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",    inline = true },
        { name = "⚜️ Total Forgotten", value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor", inline = true },
    })
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

    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = data.player }
        end
        PlayerStats[uid].catchCount   = PlayerStats[uid].catchCount + 1
        PlayerStats[uid].lastFishTime = os.time()
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

    -- 3. Secret Fish (termasuk mutated)
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

        local chanceInfo  = FishChanceData[baseName] or "Unknown"
        local mutasiField = mutasi and ("*" .. mutasi .. "*") or "-"
        local fields = {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = mutasiField,                  inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
            { name = "Chance", value = "🎲 " .. chanceInfo,          inline = true },
        }

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

    -- 4. Mutasi non-secret (no mention)
    local mutasiDetected = FindMutasi(data.fish)
    if mutasiDetected then
        SendFishWebhook("✨ MUTASI DETECTED!", nil, 16776960, {
            { name = "Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = "Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = "Mutasi", value = "🌀 " .. mutasiDetected,     inline = true },
            { name = "Berat",  value = data.weight,                  inline = true },
        }, nil, avatarUrl, nil, nil)
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
--  HOOK CHAT
-- ============================================================

local function HookChat()
    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            local text = msg.Text or ""
            if msg.TextSource == nil then
                CheckAndSend(text)
            end
            -- Chat log dihapus sesuai permintaan
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
                end
                -- Chat log dihapus sesuai permintaan
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

    SendWebhook("🎣 WEBHOOK STARTED", nil, 65280, {
        { name = "Host",          value = "👤 " .. Players.LocalPlayer.Name,            inline = true  },
        { name = "Total Player",  value = "👥 " .. tostring(#allPlayers),                inline = true  },
        { name = "Daftar Player", value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
    })

    HookChat()

    -- Leaderboard setiap 30 menit
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(LEADERBOARD_INTERVAL)
            if SCRIPT_ACTIVE then SendLeaderboard() end
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
                { name = "🦕 Total Secret Fish",  value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",               inline = true  },
                { name = "⚜️ Total Forgotten",    value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor",            inline = true  },
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
        PlayerNameToId[string.lower(p.Name)]        = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
        BuildMentionCache(p.Name, p.DisplayName)
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        LeaveTimers[player.UserId] = nil
        PlayerStats[player.UserId] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = player.Name }
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

        local pName     = player.Name
        local pId       = player.UserId
        local avatarUrl = AvatarCache[pId] or GetAvatarUrl(player)
        local totalNow  = #Players:GetPlayers() - 1
        local mentionStr = GetMention(pName)

        AvatarCache[pId]                    = nil
        PlayerStats[pId]                    = nil
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
                local notBackContent = BuildContent(mentionStr, "notback")
                PostWebhook(WEBHOOK_URL, {
                    username   = "BLOX Gank",
                    avatar_url = WEBHOOK_AVATAR,
                    content    = notBackContent,
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

    -- Coba load config tersimpan
    local savedConfig = LoadConfig()

    -- Main frame (height dikurangi karena 2 input dihapus)
    local FRAME_H = 300
    local frame = Instance.new("Frame")
    frame.Name              = "Main"
    frame.Size              = UDim2.new(0, 300, 0, FRAME_H)
    frame.Position          = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3  = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel   = 0
    frame.Parent            = gui
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

    local topBarFix = Instance.new("Frame")
    topBarFix.Size             = UDim2.new(1, 0, 0, 8)
    topBarFix.Position         = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBarFix.BorderSizePixel  = 0
    topBarFix.Parent           = topBar

    local title = Instance.new("TextLabel")
    title.Text                   = "🎣 BLOX Gank Monitor"
    title.Size                   = UDim2.new(1, -80, 1, 0)
    title.Position               = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3             = Color3.fromRGB(255, 255, 255)
    title.Font                   = Enum.Font.GothamBold
    title.TextSize               = 13
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = topBar

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
    local fullSize    = UDim2.new(0, 300, 0, FRAME_H)
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
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hoverColor }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = baseColor  }):Play() end)
    end
    HoverTween(minBtn,   Color3.fromRGB(80, 80, 80),  Color3.fromRGB(60, 60, 60))
    HoverTween(closeBtn, Color3.fromRGB(230, 70, 70), Color3.fromRGB(200, 50, 50))

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
            local delta    = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Status dot + label
    local statusDot = Instance.new("Frame")
    statusDot.Size             = UDim2.new(0, 8, 0, 8)
    statusDot.Position         = UDim2.new(0, 16, 0, 46)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    statusDot.BorderSizePixel  = 0
    statusDot.Parent           = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text                   = "Tidak Aktif"
    statusLabel.Size                   = UDim2.new(1, -40, 0, 20)
    statusLabel.Position               = UDim2.new(0, 30, 0, 38)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3             = Color3.fromRGB(180, 180, 180)
    statusLabel.Font                   = Enum.Font.Gotham
    statusLabel.TextSize               = 11
    statusLabel.TextXAlignment         = Enum.TextXAlignment.Left
    statusLabel.Parent                 = frame

    local function MakeLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Text                   = text
        lbl.Size                   = UDim2.new(1, -24, 0, 14)
        lbl.Position               = UDim2.new(0, 12, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3             = Color3.fromRGB(130, 130, 130)
        lbl.Font                   = Enum.Font.Gotham
        lbl.TextSize               = 10
        lbl.TextXAlignment         = Enum.TextXAlignment.Left
        lbl.Parent                 = frame
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

    -- Input fields (3 webhook saja, tanpa Role dan Chat)
    MakeLabel("👋 Webhook Join / Leave", 58)
    local inputJoin  = MakeInput("Paste webhook join/leave...", 72)

    MakeLabel("🐋 Webhook Secret Fish", 110)
    local inputFish  = MakeInput("Paste webhook secret fish...", 124)

    MakeLabel("📊 Webhook Stats", 162)
    local inputStats = MakeInput("Paste webhook stats...", 176)

    -- ── Toggle Save Config ──────────────────────────────────
    local saveEnabled = false

    local toggleBg = Instance.new("Frame")
    toggleBg.Size             = UDim2.new(0, 36, 0, 18)
    toggleBg.Position         = UDim2.new(1, -48, 0, 215)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBg.BorderSizePixel  = 0
    toggleBg.Parent           = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size             = UDim2.new(0, 14, 0, 14)
    toggleKnob.Position         = UDim2.new(0, 2, 0.5, -7)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleKnob.BorderSizePixel  = 0
    toggleKnob.Parent           = toggleBg
    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text                   = "💾 Simpan Config"
    toggleLabel.Size                   = UDim2.new(1, -60, 0, 18)
    toggleLabel.Position               = UDim2.new(0, 12, 0, 213)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3             = Color3.fromRGB(130, 130, 130)
    toggleLabel.Font                   = Enum.Font.Gotham
    toggleLabel.TextSize               = 10
    toggleLabel.TextXAlignment         = Enum.TextXAlignment.Left
    toggleLabel.Parent                 = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size                   = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position               = UDim2.new(1, -48, 0, 215)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text                   = ""
    toggleBtn.BorderSizePixel        = 0
    toggleBtn.Parent                 = frame

    local function SetToggle(enabled)
        saveEnabled = enabled
        TweenService:Create(toggleKnob, TweenInfo.new(0.15), {
            Position         = enabled and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            BackgroundColor3 = enabled and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(200, 200, 200),
        }):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.15), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(60, 60, 60),
        }):Play()
        toggleLabel.TextColor3 = enabled and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(130, 130, 130)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        SetToggle(not saveEnabled)
    end)

    -- Auto-load saved config jika ada
    if savedConfig then
        if savedConfig.webhook_join  and savedConfig.webhook_join  ~= "" then inputJoin.Text  = savedConfig.webhook_join  end
        if savedConfig.webhook_fish  and savedConfig.webhook_fish  ~= "" then inputFish.Text  = savedConfig.webhook_fish  end
        if savedConfig.webhook_stats and savedConfig.webhook_stats ~= "" then inputStats.Text = savedConfig.webhook_stats end
        SetToggle(true)
    end

    -- ── Start Button ────────────────────────────────────────
    local startBtn = Instance.new("TextButton")
    startBtn.Text             = "START MONITORING"
    startBtn.Size             = UDim2.new(1, -24, 0, 34)
    startBtn.Position         = UDim2.new(0, 12, 0, 250)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    startBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    startBtn.Font             = Enum.Font.GothamBold
    startBtn.TextSize         = 12
    startBtn.BorderSizePixel  = 0
    startBtn.Parent           = frame
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)

    HoverTween(startBtn, Color3.fromRGB(0, 210, 120), Color3.fromRGB(0, 180, 100))

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

        -- Simpan config jika toggle aktif
        if saveEnabled then
            SaveConfig(WEBHOOK_URL, WEBHOOK_FISH, WEBHOOK_STATS)
        end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        statusLabel.Text           = "Aktif — Monitoring..."
        statusLabel.TextColor3     = Color3.fromRGB(0, 220, 100)
        startBtn.Text              = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3  = Color3.fromRGB(30, 30, 30)

        for _, box in ipairs({ inputJoin, inputFish, inputStats }) do
            box.TextEditable = false
        end
        toggleBtn.Active = false

        StartMonitoring()
    end)
end

-- ============================================================
--  INIT
-- ============================================================

CreateUI()
