-- ============================================================
--  nursultan v13.1 — FULL EDITION
--  🌈 Rainbow Logo | Killaura | Drop All | RGB Model
--  ФАН-ПРОЕКТ. Мы никак не относимся к реальному Nursultan.
-- ============================================================

local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local LOGO_ID     = "rbxassetid://139568612294283"

local function SafeParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local ok2, c = pcall(function() return CoreGui end)
    if ok2 and c then return c end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local Conn_list = {}
local function Conn(c) table.insert(Conn_list, c); return c end

-- ANIM
local ANIM = {
    Fast    = TweenInfo.new(0.15, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Normal  = TweenInfo.new(0.28, Enum.EasingStyle.Quint,   Enum.EasingDirection.Out),
    Smooth  = TweenInfo.new(0.4,  Enum.EasingStyle.Cubic,   Enum.EasingDirection.InOut),
    Bounce  = TweenInfo.new(0.45, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    FadeIn  = TweenInfo.new(0.3,  Enum.EasingStyle.Sine,    Enum.EasingDirection.Out),
    SlideIn = TweenInfo.new(0.35, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    SlideOut= TweenInfo.new(0.3,  Enum.EasingStyle.Quint,   Enum.EasingDirection.In),
}
local FAST = ANIM.Fast
local SLOW = ANIM.Normal

-- COLOR HELPERS
local function HSVtoRGB(h, s, v)
    h = h % 360
    local c = v * s
    local hh = (h / 60) % 6
    local x = c * (1 - math.abs(hh % 2 - 1))
    local r, g, b = 0, 0, 0
    if hh < 1 then r,g,b = c,x,0
    elseif hh < 2 then r,g,b = x,c,0
    elseif hh < 3 then r,g,b = 0,c,x
    elseif hh < 4 then r,g,b = 0,x,c
    elseif hh < 5 then r,g,b = x,0,c
    else r,g,b = c,0,x end
    local m = v - c
    return Color3.new(r+m, g+m, b+m)
end
local function RGBtoHSV(c)
    local r, g, b = c.R, c.G, c.B
    local max = math.max(r,g,b)
    local min = math.min(r,g,b)
    local v = max
    local d = max - min
    local s = (max == 0) and 0 or (d/max)
    local h = 0
    if d ~= 0 then
        if max == r then h = 60 * (((g-b)/d) % 6)
        elseif max == g then h = 60 * ((b-r)/d + 2)
        else h = 60 * ((r-g)/d + 4) end
    end
    return h, s, v
end

-- TRANSLATIONS
local LANG = "RU"
local STR = {
    RU = {
        Combat="Бой", Visuals="Визуалы", Dupe="Дюп", Binds="Бинды",
        Configs="Конфиги", Info="Инфо", Settings="Настройки",
        SearchPlaceholder="Поиск...",
        KillauraTitle="⚔️ Killaura", KillauraEnable="Включить Killaura (R)",
        KARange="Радиус атаки", KADelay="Задержка",
        IgnoreNaked="Игнорировать голых",
        TargetInfoTitle="👁️ Инфо о цели", TargetInfoEnable="Показывать при наведении",
        InfJumpEnable="Бесконечный прыжок",
        WalkSpeedEnable="Установить скорость",
        WalkSpeedValue="Скорость ходьбы",
        ESPTitle="🎨 ESP", ESPEnable="Включить ESP", ESPNameplate="Плашка с HP",
        ESPBoxes="Подсветка (Chams)", ESPTeam="Проверка команды",
        RGBTitle="🌈 RGB Модель", RGBModel="Включить RGB",
        HUDTitle="📊 HUD", HUDShow="Показать HUD",
        ShadersTitle="✨ Шейдеры", ShBloom="Bloom", ShCC="Color Correction",
        ShSunRays="Sun Rays", ShDoF="Depth of Field", ShBlur="Blur", ShSharpen="Sharpen",
        SkyTitle="🌌 Небо", SkyGalaxy="Космос", SkyNight="Ночь", SkyBlue="Голубое",
        SkyRed="Красное", SkyDefault="По умолчанию",
        OptimizeTitle="⚡ Оптимизация", FPSUnlock="Разблокировать FPS",
        FPSCleanup="Оптимизация мира", RemoveShadows="Убрать тени",
        DupeTitle="📦 Дюп и предметы", DupeSelected="Дюп выбранного", DupeChest1="Дюп 1 слота",
        DupeChestAll="Дюп сундука", DupeInf="Бесконечные предметы",
        DumpDupe="Dump + Dupe", AutoDupe="Авто-дюп",
        DropAll="🎒 Выбросить всё",
        BindsTitle="🎹 Активные бинды", BindsShow="Показать оверлей биндов",
        ConfigTitle="💾 Управление конфигами", CfgName="Имя конфига", CfgSave="Сохранить конфиг",
        CfgLoad="Загрузить конфиг", CfgDelete="Удалить конфиг", CfgList="Обновить список",
        CfgWhatSaves="ℹ️ Что сохраняется",
        ThemeTitle="🎨 Палитра", ThemePresets="Пресеты", ThemeCustom="Свой цвет",
        Hue="Оттенок", Saturation="Насыщенность", Value="Яркость",
        LangBtn="Сменить язык (RU/EN)", UnloadBtn="Выгрузить скрипт",
        Disclaimer="НУРСУЛТАН БУСТИТ ТИПА"
    },
    EN = {
        Combat="Combat", Visuals="Visuals", Dupe="Dupe", Binds="Binds",
        Configs="Configs", Info="Info", Settings="Settings",
        SearchPlaceholder="Search...",
        KillauraTitle="⚔️ Killaura", KillauraEnable="Enable Killaura (R)",
        KARange="Attack Range", KADelay="Delay",
        IgnoreNaked="Ignore Naked",
        TargetInfoTitle="👁️ Target Info", TargetInfoEnable="Show on hover",
        InfJumpEnable="Infinite Jump",
        WalkSpeedEnable="Set Walk Speed",
        WalkSpeedValue="Walk Speed",
        ESPTitle="🎨 ESP", ESPEnable="Enable ESP", ESPNameplate="Nameplate with HP",
        ESPBoxes="Highlight (Chams)", ESPTeam="Team Check",
        RGBTitle="🌈 RGB Model", RGBModel="Enable RGB",
        HUDTitle="📊 HUD", HUDShow="Show HUD",
        ShadersTitle="✨ Shaders", ShBloom="Bloom", ShCC="Color Correction",
        ShSunRays="Sun Rays", ShDoF="Depth of Field", ShBlur="Blur", ShSharpen="Sharpen",
        SkyTitle="🌌 Skybox", SkyGalaxy="Galaxy", SkyNight="Night", SkyBlue="Blue",
        SkyRed="Red", SkyDefault="Default",
        OptimizeTitle="⚡ Optimization", FPSUnlock="Unlock FPS",
        FPSCleanup="Optimize World", RemoveShadows="Remove Shadows",
        DupeTitle="📦 Dupe & Items", DupeSelected="Dupe Selected", DupeChest1="Dupe 1 Slot",
        DupeChestAll="Dupe Chest", DupeInf="Infinite Items",
        DumpDupe="Dump + Dupe", AutoDupe="Auto Dupe",
        DropAll="🎒 Drop All Items",
        BindsTitle="🎹 Active Binds", BindsShow="Show Binds Overlay",
        ConfigTitle="💾 Config Manager", CfgName="Config name", CfgSave="Save Config",
        CfgLoad="Load Config", CfgDelete="Delete Config", CfgList="Refresh List",
        CfgWhatSaves="ℹ️ What is saved",
        ThemeTitle="🎨 Palette", ThemePresets="Presets", ThemeCustom="Custom Color",
        Hue="Hue", Saturation="Saturation", Value="Value",
        LangBtn="Switch Language (RU/EN)", UnloadBtn="Unload Script",
        Disclaimer="⚠️ FAN PROJECT. We are not related to the real Nursultan."
    }
}
local function T(k) return STR[LANG][k] or k end

-- THEME
local PALETTES = {
    ["Blood Red"]      = {Color3.fromRGB(246,92,82),  Color3.fromRGB(255,165,155), Color3.fromRGB(130,40,42)},
    ["Ocean Blue"]     = {Color3.fromRGB(80,160,255), Color3.fromRGB(160,200,255), Color3.fromRGB(30,70,140)},
    ["Emerald Green"]  = {Color3.fromRGB(80,220,120), Color3.fromRGB(160,255,180), Color3.fromRGB(30,130,60)},
    ["Purple Haze"]    = {Color3.fromRGB(200,100,255),Color3.fromRGB(220,170,255), Color3.fromRGB(100,40,140)},
    ["Sunset Orange"]  = {Color3.fromRGB(255,150,60), Color3.fromRGB(255,200,140), Color3.fromRGB(150,70,20)},
    ["Cyberpunk Pink"] = {Color3.fromRGB(255,60,180), Color3.fromRGB(255,150,220), Color3.fromRGB(140,20,100)},
    ["Midnight"]       = {Color3.fromRGB(140,140,220),Color3.fromRGB(190,190,240), Color3.fromRGB(60,60,120)},
    ["Gold"]           = {Color3.fromRGB(255,210,60), Color3.fromRGB(255,230,140), Color3.fromRGB(150,110,20)},
    ["Lime"]           = {Color3.fromRGB(180,255,80), Color3.fromRGB(220,255,170), Color3.fromRGB(90,150,30)},
    ["White"]          = {Color3.fromRGB(230,230,230),Color3.fromRGB(255,255,255), Color3.fromRGB(120,120,120)},
}
local CurrentTheme = "Blood Red"
local THEME = {
    Background=Color3.fromRGB(12,9,11), CardBg=Color3.fromRGB(18,13,16),
    PillBg=Color3.fromRGB(16,12,14), SidebarActive=Color3.fromRGB(27,16,19),
    Border=Color3.fromRGB(36,24,28), BorderActive=Color3.fromRGB(90,36,42),
    Accent=Color3.fromRGB(246,92,82), AccentSoft=Color3.fromRGB(255,165,155),
    AccentDark=Color3.fromRGB(130,40,42), TextPrimary=Color3.fromRGB(240,240,240),
    TextMuted=Color3.fromRGB(140,130,135), TextDim=Color3.fromRGB(85,75,80),
    Divider=Color3.fromRGB(48,36,40), ToggleOff=Color3.fromRGB(36,28,32),
    KnobOff=Color3.fromRGB(78,68,73), KnobOn=Color3.fromRGB(255,255,255),
    BtnHover=Color3.fromRGB(34,22,26), BgLoading=Color3.fromRGB(6,4,6),
    Green=Color3.fromRGB(80,220,120), Red=Color3.fromRGB(255,70,70), Yellow=Color3.fromRGB(255,210,60)
}
local ThemeLinks = {}
local function Link(el, prop) table.insert(ThemeLinks, {El=el, Prop=prop}) end
local function refreshTheme()
    for _, e in ipairs(ThemeLinks) do
        if e.El and e.El.Parent then
            pcall(function() e.El[e.Prop] = THEME.Accent end)
        end
    end
end
local function ApplyPreset(name)
    local p = PALETTES[name]; if not p then return end
    CurrentTheme = name
    THEME.Accent = p[1]; THEME.AccentSoft = p[2]; THEME.AccentDark = p[3]; THEME.BorderActive = p[3]
    refreshTheme()
    ShowNotification("Theme", "🎨 " .. name)
end
local function ApplyCustomColor(color)
    CurrentTheme = "Custom"
    THEME.Accent = color
    THEME.AccentSoft = Color3.new(math.min(1,color.R+0.3), math.min(1,color.G+0.3), math.min(1,color.B+0.3))
    THEME.AccentDark = Color3.new(color.R*0.5, color.G*0.5, color.B*0.5)
    THEME.BorderActive = Color3.new(color.R*0.5, color.G*0.5, color.B*0.5)
    refreshTheme()
end

local ICONS = {
    Search="rbxassetid://7733911828", Chevron="rbxassetid://7733717447",
    Combat="rbxassetid://7734053426", Visuals="rbxassetid://7733774602",
    Settings="rbxassetid://7734053426", User="rbxassetid://7733954760",
    Chart="rbxassetid://7733749837", Clock="rbxassetid://7733734762",
    Compass="rbxassetid://7733720755", Signal="rbxassetid://7734058495",
    Speed="rbxassetid://7733799901", Key="rbxassetid://7734056411",
    Copy="rbxassetid://7733717447", Info="rbxassetid://7733749837"
}

-- FS
local HAS_FS = (typeof(writefile)=="function" and typeof(readfile)=="function" and typeof(isfile)=="function")
local CFG_DIR = "nursultan"
local function ensureDir()
    if not HAS_FS then return end
    if typeof(isfolder)=="function" and typeof(makefolder)=="function" then
        if not isfolder("nursultan") then pcall(makefolder, "nursultan") end
    end
end
local function SaveCfg(n, t)
    if not HAS_FS then return false end
    ensureDir()
    local ok, e = pcall(function() return HttpService:JSONEncode(t) end)
    if not ok then return false end
    return pcall(writefile, CFG_DIR.."/"..n..".json", e)
end
local function LoadCfg(n)
    if not HAS_FS then return nil end
    local p = CFG_DIR.."/"..n..".json"
    if not (typeof(isfile)=="function" and isfile(p)) then return nil end
    local ok, d = pcall(readfile, p)
    if not ok then return nil end
    local ok2, dec = pcall(function() return HttpService:JSONDecode(d) end)
    return ok2 and dec or nil
end
local function ListCfgs()
    if not HAS_FS or typeof(listfiles)~="function" then return {} end
    local ok, f = pcall(listfiles, CFG_DIR)
    if not ok then return {} end
    local o = {}
    for _, x in ipairs(f) do
        local n = x:match("([^/\\]+)%.json$")
        if n then table.insert(o, n) end
    end
    return o
end

-- ROOT
if CoreGui:FindFirstChild("nursultanUI") then CoreGui.nursultanUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "nursultanUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = SafeParent()

-- NOTIFICATIONS
local NCon = Instance.new("Frame", ScreenGui)
NCon.AnchorPoint = Vector2.new(0.5,1)
NCon.Size = UDim2.new(0,320,0,200)
NCon.Position = UDim2.new(0.5,0,0.88,0)
NCon.BackgroundTransparency = 1
NCon.ZIndex = 100
local NLay = Instance.new("UIListLayout", NCon)
NLay.SortOrder = Enum.SortOrder.LayoutOrder
NLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
NLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
NLay.Padding = UDim.new(0,8)

function ShowNotification(titleText, descText, duration)
    duration = duration or 2.2
    local card = Instance.new("Frame", NCon)
    card.Size = UDim2.new(1,0,0,52)
    card.BackgroundColor3 = THEME.CardBg
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.ZIndex = 101
    card.Position = UDim2.new(0, 60, 0, 0)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = THEME.Accent
    stroke.Thickness = 1
    stroke.Transparency = 1
    Link(stroke, "Color")
    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1,-20,0,20)
    title.Position = UDim2.new(0,10,0,6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = THEME.Accent
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Text = titleText
    title.TextTransparency = 1
    Link(title, "TextColor3")
    local desc = Instance.new("TextLabel", card)
    desc.Size = UDim2.new(1,-20,0,18)
    desc.Position = UDim2.new(0,10,0,26)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 11
    desc.TextColor3 = THEME.TextPrimary
    desc.TextXAlignment = Enum.TextXAlignment.Center
    desc.Text = descText
    desc.TextTransparency = 1
    TweenService:Create(card, ANIM.SlideIn, {Position = UDim2.new(0,0,0,0), BackgroundTransparency = 0.05}):Play()
    TweenService:Create(stroke, ANIM.FadeIn, {Transparency = 0}):Play()
    TweenService:Create(title, ANIM.FadeIn, {TextTransparency = 0}):Play()
    TweenService:Create(desc, ANIM.FadeIn, {TextTransparency = 0}):Play()
    task.delay(duration, function()
        if card and card.Parent then
            TweenService:Create(stroke, ANIM.Fast, {Transparency = 1}):Play()
            TweenService:Create(title, ANIM.Fast, {TextTransparency = 1}):Play()
            TweenService:Create(desc, ANIM.Fast, {TextTransparency = 1}):Play()
            local tw = TweenService:Create(card, ANIM.SlideOut, {
                BackgroundTransparency = 1, Position = UDim2.new(0, 60, 0, 0)
            })
            tw:Play()
            tw.Completed:Connect(function() card:Destroy() end)
        end
    end)
end

-- LOADING SCREEN
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "nursultanLoading"
LoadGui.IgnoreGuiInset = true
LoadGui.DisplayOrder = 999
LoadGui.Parent = SafeParent()

local LBG = Instance.new("Frame", LoadGui)
LBG.Size = UDim2.new(1,0,1,0)
LBG.BackgroundColor3 = THEME.BgLoading
LBG.BorderSizePixel = 0

local LGlow = Instance.new("ImageLabel", LBG)
LGlow.Size = UDim2.new(0,900,0,900)
LGlow.AnchorPoint = Vector2.new(0.5,0.5)
LGlow.Position = UDim2.new(0.5,0,0.5,0)
LGlow.BackgroundTransparency = 1
LGlow.Image = "rbxassetid://5028857084"
LGlow.ImageColor3 = THEME.AccentDark
LGlow.ImageTransparency = 0.75

local LGlow2 = Instance.new("ImageLabel", LBG)
LGlow2.Size = UDim2.new(0,700,0,700)
LGlow2.AnchorPoint = Vector2.new(0.5,0.5)
LGlow2.Position = UDim2.new(0.5,0,0.5,0)
LGlow2.BackgroundTransparency = 1
LGlow2.Image = "rbxassetid://5028857084"
LGlow2.ImageColor3 = THEME.Accent
LGlow2.ImageTransparency = 0.9

local Particles = {}
for i = 1, 15 do
    local dot = Instance.new("Frame", LBG)
    dot.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
    dot.BackgroundColor3 = THEME.Accent
    dot.BorderSizePixel = 0
    dot.BackgroundTransparency = math.random(30, 70) / 100
    dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    table.insert(Particles, dot)
end

local LH = Instance.new("Frame", LBG)
LH.AnchorPoint = Vector2.new(0.5,0.5)
LH.Position = UDim2.new(0.5,0,0.5,-70)
LH.Size = UDim2.new(0,0,0,0)
LH.BackgroundTransparency = 1

local LPulse = Instance.new("ImageLabel", LH)
LPulse.Size = UDim2.new(2,0,2,0)
LPulse.Position = UDim2.new(-0.5,0,-0.5,0)
LPulse.BackgroundTransparency = 1
LPulse.Image = "rbxassetid://5028857084"
LPulse.ImageColor3 = THEME.Accent
LPulse.ImageTransparency = 0.7

local LHal = Instance.new("ImageLabel", LH)
LHal.Size = UDim2.new(1.8,0,1.8,0)
LHal.Position = UDim2.new(-0.4,0,-0.4,0)
LHal.BackgroundTransparency = 1
LHal.Image = "rbxassetid://5028857084"
LHal.ImageColor3 = THEME.Accent
LHal.ImageTransparency = 0.55

local LLogo = Instance.new("ImageLabel", LH)
LLogo.Size = UDim2.new(1,0,1,0)
LLogo.BackgroundTransparency = 1
LLogo.Image = LOGO_ID
LLogo.ScaleType = Enum.ScaleType.Fit
LLogo.ImageColor3 = THEME.Accent
LLogo.ImageTransparency = 0.15

local LTitle = Instance.new("TextLabel", LBG)
LTitle.Size = UDim2.new(1,0,0,40)
LTitle.Position = UDim2.new(0,0,0.5,60)
LTitle.BackgroundTransparency = 1
LTitle.Font = Enum.Font.GothamBold
LTitle.TextSize = 34
LTitle.TextColor3 = THEME.TextPrimary
LTitle.Text = "nursultan"
LTitle.TextTransparency = 1

local LTitleShadow = Instance.new("TextLabel", LBG)
LTitleShadow.Size = UDim2.new(1,0,0,40)
LTitleShadow.Position = UDim2.new(0,2,0.5,62)
LTitleShadow.BackgroundTransparency = 1
LTitleShadow.Font = Enum.Font.GothamBold
LTitleShadow.TextSize = 34
LTitleShadow.TextColor3 = THEME.Accent
LTitleShadow.Text = "nursultan"
LTitleShadow.TextTransparency = 1
LTitleShadow.ZIndex = 0

local LSub = Instance.new("TextLabel", LBG)
LSub.Size = UDim2.new(1,0,0,18)
LSub.Position = UDim2.new(0,0,0.5,102)
LSub.BackgroundTransparency = 1
LSub.Font = Enum.Font.Gotham
LSub.TextSize = 12
LSub.TextColor3 = THEME.TextMuted
LSub.Text = "инициализация..."
LSub.TextTransparency = 1

local LBarBG = Instance.new("Frame", LBG)
LBarBG.AnchorPoint = Vector2.new(0.5,0.5)
LBarBG.Position = UDim2.new(0.5,0,0.5,155)
LBarBG.Size = UDim2.new(0,0,0,8)
LBarBG.BackgroundColor3 = THEME.CardBg
LBarBG.BorderSizePixel = 0
Instance.new("UICorner", LBarBG).CornerRadius = UDim.new(1,0)

local LBarFill = Instance.new("Frame", LBarBG)
LBarFill.Size = UDim2.new(0,0,1,0)
LBarFill.BackgroundColor3 = THEME.Accent
LBarFill.BorderSizePixel = 0
Instance.new("UICorner", LBarFill).CornerRadius = UDim.new(1,0)

local LBarShimmer = Instance.new("Frame", LBarBG)
LBarShimmer.Size = UDim2.new(0,40,1,0)
LBarShimmer.Position = UDim2.new(-0.2,0,0,0)
LBarShimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
LBarShimmer.BackgroundTransparency = 0.6
LBarShimmer.BorderSizePixel = 0

local LPercent = Instance.new("TextLabel", LBG)
LPercent.AnchorPoint = Vector2.new(0.5,0.5)
LPercent.Position = UDim2.new(0.5,0,0.5,180)
LPercent.Size = UDim2.new(0,100,0,16)
LPercent.BackgroundTransparency = 1
LPercent.Font = Enum.Font.GothamBold
LPercent.TextSize = 13
LPercent.TextColor3 = THEME.AccentSoft
LPercent.Text = "0%"
LPercent.TextTransparency = 1

local LDisc = Instance.new("TextLabel", LBG)
LDisc.AnchorPoint = Vector2.new(0.5,0)
LDisc.Position = UDim2.new(0.5,0,1,-40)
LDisc.Size = UDim2.new(1,0,0,20)
LDisc.BackgroundTransparency = 1
LDisc.Font = Enum.Font.Gotham
LDisc.TextSize = 11
LDisc.TextColor3 = THEME.TextDim
LDisc.Text = T("Disclaimer")
LDisc.TextTransparency = 1

local rainbowActive = true
task.spawn(function()
    local hue = 0
    while rainbowActive do
        if not LBG.Parent then break end
        hue = (hue + 2.5) % 360
        local col = HSVtoRGB(hue, 0.85, 1)
        pcall(function()
            LLogo.ImageColor3 = col
            LHal.ImageColor3 = col
            LPulse.ImageColor3 = col
            LBarFill.BackgroundColor3 = col
            LPercent.TextColor3 = col
            LGlow.ImageColor3 = Color3.new(col.R*0.5, col.G*0.5, col.B*0.5)
            LGlow2.ImageColor3 = col
            LTitle.TextColor3 = Color3.new(
                math.min(1, col.R*0.9 + 0.3),
                math.min(1, col.G*0.9 + 0.3),
                math.min(1, col.B*0.9 + 0.3)
            )
            LTitleShadow.TextColor3 = col
        end)
        RunService.Heartbeat:Wait()
    end
end)

task.spawn(function()
    task.wait(0.1)
    TweenService:Create(LH, ANIM.Elastic, {Size = UDim2.new(0,140,0,140)}):Play()
    task.wait(0.3)
    TweenService:Create(LTitle, ANIM.FadeIn, {TextTransparency = 0}):Play()
    TweenService:Create(LTitleShadow, ANIM.FadeIn, {TextTransparency = 0.5}):Play()
    task.wait(0.15)
    TweenService:Create(LSub, ANIM.FadeIn, {TextTransparency = 0}):Play()
    task.wait(0.2)
    TweenService:Create(LBarBG, ANIM.Bounce, {Size = UDim2.new(0,380,0,8)}):Play()
    task.wait(0.2)
    TweenService:Create(LPercent, ANIM.FadeIn, {TextTransparency = 0}):Play()
    TweenService:Create(LDisc, ANIM.FadeIn, {TextTransparency = 0}):Play()
end)

for _, dot in ipairs(Particles) do
    task.spawn(function()
        while rainbowActive and dot.Parent do
            TweenService:Create(dot, TweenInfo.new(math.random(3,6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundTransparency = math.random(30, 80) / 100
            }):Play()
            task.wait(math.random(3,6))
        end
    end)
end

task.spawn(function()
    while rainbowActive and LH.Parent do
        TweenService:Create(LPulse, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(2.4,0,2.4,0), Position = UDim2.new(-0.7,0,-0.7,0), ImageTransparency = 0.95
        }):Play()
        task.wait(1.2)
        TweenService:Create(LPulse, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(2,0,2,0), Position = UDim2.new(-0.5,0,-0.5,0), ImageTransparency = 0.7
        }):Play()
        task.wait(1.2)
    end
end)

task.spawn(function()
    while rainbowActive and LGlow2.Parent do
        TweenService:Create(LGlow2, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,850,0,850), ImageTransparency = 0.95
        }):Play()
        task.wait(1.5)
        TweenService:Create(LGlow2, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,700,0,700), ImageTransparency = 0.85
        }):Play()
        task.wait(1.5)
    end
end)

task.spawn(function()
    while rainbowActive and LLogo.Parent do
        TweenService:Create(LLogo, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 5}):Play()
        task.wait(1.5)
        TweenService:Create(LLogo, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = -5}):Play()
        task.wait(1.5)
    end
end)

task.spawn(function()
    while rainbowActive and LBarShimmer.Parent do
        LBarShimmer.Position = UDim2.new(-0.2, 0, 0, 0)
        TweenService:Create(LBarShimmer, TweenInfo.new(1.0, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1.1, 0, 0, 0)
        }):Play()
        task.wait(1.1)
    end
end)

local LoadSteps = {"Инициализация...","Загрузка модулей...","Применение темы...","Почти готово..."}
local stepIdx = 1
task.spawn(function()
    while stepIdx <= #LoadSteps and rainbowActive do
        task.wait(0.9)
        if LSub.Parent then
            local txt = LoadSteps[stepIdx]
            LSub.TextTransparency = 0
            TweenService:Create(LSub, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            task.wait(0.2)
            LSub.Text = txt
            TweenService:Create(LSub, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
            stepIdx = stepIdx + 1
        end
    end
end)

task.spawn(function()
    task.wait(0.6)
    local total = 3.5
    local start = tick()
    while true do
        local a = math.clamp((tick()-start)/total, 0, 1)
        local e = 1 - (1-a)^5
        if LBarFill and LBarFill.Parent then
            LBarFill.Size = UDim2.new(e,0,1,0)
            LPercent.Text = string.format("%d%%", math.floor(e*100))
        end
        if a >= 1 then break end
        task.wait()
    end
    task.wait(0.3)
    rainbowActive = false
    task.wait(0.15)
    local tweens = {}
    table.insert(tweens, TweenService:Create(LBG, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}))
    for _, el in ipairs({LTitle, LTitleShadow, LSub, LPercent, LDisc, LBarBG, LBarFill, LBarShimmer, LLogo, LHal, LPulse, LGlow, LGlow2}) do
        if el.Parent then
            local prop = "ImageTransparency"
            if el:IsA("TextLabel") then prop = "TextTransparency" end
            if el == LBarBG or el == LBarFill or el == LBarShimmer then prop = "BackgroundTransparency" end
            table.insert(tweens, TweenService:Create(el, TweenInfo.new(0.5), {[prop] = 1}))
        end
    end
    for _, p in ipairs(Particles) do
        table.insert(tweens, TweenService:Create(p, TweenInfo.new(0.5), {BackgroundTransparency = 1}))
    end
    for _, tw in ipairs(tweens) do tw:Play() end
    tweens[1].Completed:Wait()
    LoadGui:Destroy()
end)

-- BIND MANAGER
local BindM = {binds = {}, listening = nil, onChange = {}}
function BindM:getKeyByLabel(l)
    for k, v in pairs(self.binds) do if v.label == l then return k end end
end
function BindM:set(k, l, cb)
    for oldKey, v in pairs(self.binds) do
        if v.label == l and oldKey ~= k then self.binds[oldKey] = nil end
    end
    self.binds[k] = {label=l, callback=cb}
    for _, f in ipairs(self.onChange) do f() end
end
function BindM:unset(k) self.binds[k] = nil; for _, f in ipairs(self.onChange) do f() end end
function BindM:unsetByLabel(l)
    for k, v in pairs(self.binds) do
        if v.label == l then self.binds[k] = nil end
    end
    for _, f in ipairs(self.onChange) do f() end
end
function BindM:trigger(k)
    local b = self.binds[k]
    if b and b.callback then task.spawn(function() pcall(b.callback) end) end
end
function BindM:startListening(l, onSet) self.listening = {label=l, onSet=onSet} end
function BindM:cancelListening() self.listening = nil end
function BindM:handleKey(k)
    if not self.listening then return false end
    local label = self.listening.label
    local onSet = self.listening.onSet
    self.listening = nil
    self:unsetByLabel(label)
    if k == "Unknown" or k == "Escape" or k == "Delete" then
        if onSet then onSet(nil) end
        ShowNotification("Bind", LANG == "RU" and "Очищен" or "Cleared")
    else
        if onSet then onSet(k) end
        ShowNotification("Bind", (LANG == "RU" and "Установлен: " or "Set: ") .. k)
    end
    return true
end

-- CONFIG
local CfgM = {data = {}, currentName = "default"}
function CfgM:register(k, gS, sS) self.data[k] = {getState=gS, setState=sS} end
function CfgM:getState(k)
    local d = self.data[k]; if d and d.getState then return d.getState() end
end
function CfgM:setState(k, s)
    local d = self.data[k]; if d and d.setState then d.setState(s) end
end
function CfgM:save(name)
    name = name or self.currentName
    self.currentName = name
    local out = {toggles = {}, binds = {}, lang = LANG, theme = CurrentTheme, name = name,
        customColor = {R = THEME.Accent.R, G = THEME.Accent.G, B = THEME.Accent.B}}
    for k, v in pairs(self.data) do if v.getState then out.toggles[k] = v.getState() end end
    for key, b in pairs(BindM.binds) do out.binds[b.label] = key end
    if SaveCfg(name, out) then ShowNotification("Config", "💾 " .. name)
    else ShowNotification("Config", "❌ No writefile") end
end
function CfgM:load(name)
    name = name or self.currentName
    self.currentName = name
    local d = LoadCfg(name)
    if not d then ShowNotification("Config", "❌ " .. name); return end
    if d.lang then LANG = d.lang end
    if d.customColor then
        ApplyCustomColor(Color3.new(d.customColor.R, d.customColor.G, d.customColor.B))
    elseif d.theme and PALETTES[d.theme] then ApplyPreset(d.theme) end
    if d.toggles then for k, v in pairs(d.toggles) do if self.data[k] then self:setState(k, v) end end end
    if d.binds then
        for label, key in pairs(d.binds) do
            if self.data[label] then
                BindM:set(key, label, function() self:setState(label, not self:getState(label)) end)
            end
        end
    end
    ShowNotification("Config", "📂 " .. name)
end
function CfgM:delete(name)
    if not HAS_FS then return end
    local p = CFG_DIR.."/"..name..".json"
    if typeof(isfile)=="function" and isfile(p) then
        pcall(function() delfile(p) end)
        ShowNotification("Config", "🗑️ " .. name)
    end
end

-- KILLAURA
local KillAura = {_running=false, _thread=nil, _lastAttack=0, _canAttack=true,
                  _lastSuccess=false, _currentTarget=nil, _currentTargetPlayer=nil,
                  _initialTargetSet=false, IgnoreNaked=false, AttackCooldown=0.1, TargetDistance=80}

local AttackRemote
pcall(function()
    local gr = ReplicatedStorage:WaitForChild("GameRemotes", 5)
    if gr then AttackRemote = gr:WaitForChild("Attack", 5) end
end)
if not AttackRemote then
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if r.Name == "Attack" and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
            AttackRemote = r; break
        end
    end
end
print("[nursultan KA] Attack: " .. (AttackRemote and AttackRemote:GetFullName() or "❌ нет"))

local function isNaked(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.MaxHealth <= 100
end

local function getClosestPlayer()
    if KillAura._currentTarget and KillAura._currentTarget.Parent then
        local hrp = KillAura._currentTarget:FindFirstChild("HumanoidRootPart")
        local hum = KillAura._currentTarget:FindFirstChildOfClass("Humanoid")
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hum and hum.Health > 0 and myHrp then
            local d = (hrp.Position - myHrp.Position).Magnitude
            if d <= KillAura.TargetDistance then
                return KillAura._currentTarget, KillAura._currentTargetPlayer, d
            end
        end
    end
    local closest, closestPlr, shortest = nil, nil, math.huge
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil, nil, 0 end
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                if KillAura.IgnoreNaked and isNaked(v) then continue end
                local d = (hrp.Position - myHrp.Position).Magnitude
                if d < shortest then closest = v.Character; closestPlr = v; shortest = d end
            end
        end
    end
    if not KillAura._initialTargetSet and closest then
        KillAura._currentTarget = closest
        KillAura._currentTargetPlayer = closestPlr
        KillAura._initialTargetSet = true
        return closest, closestPlr, shortest
    end
    if not KillAura._currentTarget or not KillAura._currentTarget.Parent then
        KillAura._currentTarget = closest
        KillAura._currentTargetPlayer = closestPlr
    end
    return KillAura._currentTarget, KillAura._currentTargetPlayer, shortest
end

local function canAttackNow()
    if not KillAura._canAttack then return false end
    if KillAura._lastSuccess then
        return (tick() - KillAura._lastAttack) >= KillAura.AttackCooldown
    else
        return (tick() - KillAura._lastAttack) >= 0.05
    end
end

local function attackTarget(target)
    if not target then KillAura._lastSuccess = false; return end
    local hum = target:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then KillAura._lastSuccess = false; return end
    if not AttackRemote then return end
    if not canAttackNow() then return end
    KillAura._canAttack = false
    KillAura._lastAttack = tick()
    local ok = pcall(function() AttackRemote:InvokeServer(target); KillAura._lastSuccess = true end)
    if not ok then
        task.spawn(function() pcall(function() AttackRemote:InvokeServer(target) end) end)
    end
    task.delay(KillAura.AttackCooldown, function() KillAura._canAttack = true end)
end

local function kaLoop()
    while KillAura._running do
        local target, _, dist = getClosestPlayer()
        if target and dist <= KillAura.TargetDistance then attackTarget(target) end
        RunService.Heartbeat:Wait()
    end
end

function KillAura.start()
    if KillAura._running then return end
    KillAura._running = true
    KillAura._lastAttack = 0; KillAura._canAttack = true
    KillAura._currentTarget = nil; KillAura._currentTargetPlayer = nil
    KillAura._initialTargetSet = false
    KillAura._thread = task.spawn(kaLoop)
    print("[nursultan KA] ✅ Запущена")
end
function KillAura.stop()
    if not KillAura._running then return end
    KillAura._running = false
    if KillAura._thread then pcall(function() task.cancel(KillAura._thread) end); KillAura._thread = nil end
    KillAura._currentTarget = nil; KillAura._currentTargetPlayer = nil
    KillAura._initialTargetSet = false
    print("[nursultan KA] ⛔ Остановлена")
end

-- INFINITE JUMP
local InfJump = {Enabled = false, _conn = nil}
function InfJump.start()
    if InfJump.Enabled then return end
    InfJump.Enabled = true
    InfJump._conn = UserInputService.JumpRequest:Connect(function()
        if not InfJump.Enabled then return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end
function InfJump.stop()
    if not InfJump.Enabled then return end
    InfJump.Enabled = false
    if InfJump._conn then InfJump._conn:Disconnect(); InfJump._conn = nil end
end

-- WALK SPEED
local WalkSpeedValue = 16
local WalkSpeedEnabled = false
local function applyWalkSpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = WalkSpeedValue end
end
Conn(RunService.Heartbeat:Connect(function()
    if not WalkSpeedEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed ~= WalkSpeedValue then hum.WalkSpeed = WalkSpeedValue end
end))
Conn(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if WalkSpeedEnabled then applyWalkSpeed() end
end))

-- DUPE
local function getGR() return ReplicatedStorage:FindFirstChild("GameRemotes") end
local function getMoveItem()
    local gr = getGR(); return gr and (gr:FindFirstChild("MoveItem") or gr:FindFirstChild("MoveItems"))
end
local function getSortItem()
    local gr = getGR(); return gr and (gr:FindFirstChild("SortItem") or gr:FindFirstChild("SortItems"))
end
local function chestDupe(mode)
    local s = getSortItem()
    if not s then ShowNotification("Dupe", "❌ No SortItem"); return end
    if mode == 1 then pcall(function() s:InvokeServer(36) end)
    else
        for i = 36, 62 do task.spawn(function() pcall(function() s:InvokeServer(i) end) end) end
    end
end
function DupeSelected()
    local mv = getMoveItem()
    if not mv then ShowNotification("Dupe", "❌ No MoveItem"); return end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg or not pg:FindFirstChild("HUDGui") then return end
    local slots = pg.HUDGui.Inventory:FindFirstChild("Slots")
    if not slots then return end
    local slot = slots:FindFirstChild("Slot-1")
    if not slot or not slot:FindFirstChild("SlotNA") then return end
    local c = tonumber(slot.SlotNA.Count.Text)
    if not c or c >= 64 then return end
    local hm = 64 - c
    pcall(function() mv:InvokeServer(-1, 82, true, -hm) end)
end
function DupeInfinite()
    local mv = getMoveItem()
    if not mv then ShowNotification("Dupe", "❌ No MoveItem"); return end
    pcall(function() mv:InvokeServer(-1, 0, true, -9.99e100) end)
end
function DumpDupe()
    local mv = getMoveItem()
    if not mv then return end
    for i = 36, 62 do task.spawn(function() pcall(function() mv:InvokeServer(i, i-27, true) end) end) end
    task.wait(0.3)
    chestDupe(2)
end
local AutoDupe = false
Conn(RunService.Heartbeat:Connect(function()
    if not AutoDupe then return end
    local s = getSortItem()
    if not s then return end
    for i = 36, 62 do task.spawn(function() pcall(function() s:InvokeServer(i) end) end) end
    task.wait(0.5)
end))

-- DROP ALL
local function getDropItem()
    local gr = getGR(); return gr and (gr:FindFirstChild("DropItem") or gr:FindFirstChild("Drop"))
end
local function getDropAllRemote()
    local gr = getGR(); return gr and (gr:FindFirstChild("DropAll") or gr:FindFirstChild("DropAllItems"))
end

function DropAllItems()
    local da = getDropAllRemote()
    if da then
        local ok = pcall(function()
            if da:IsA("RemoteEvent") then da:FireServer()
            else da:InvokeServer() end
        end)
        if ok then ShowNotification("Drop", "✅ Drop All"); return end
    end
    local dr = getDropItem()
    if not dr then ShowNotification("Drop", "❌ No DropItem"); return end
    for i = 0, 35 do
        task.spawn(function() pcall(function() dr:InvokeServer(i, true) end) end)
        task.wait(0.02)
    end
    for i = 1, 36 do
        task.spawn(function() pcall(function() dr:InvokeServer(true) end) end)
        task.wait(0.02)
    end
    ShowNotification("Drop", "✅ Дроп выполнен")
end

-- ESP
local ESPC = {Enabled=false, Nameplate=true, Boxes=false, TeamCheck=true, Color=Color3.fromRGB(246,92,82)}
local espObjs, avCache = {}, {}
local function getAvatar(p)
    if avCache[p.UserId] then return avCache[p.UserId] end
    local ok, u = pcall(function()
        return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if ok and u then avCache[p.UserId] = u; return u end
    return "rbxassetid://0"
end
local function removeESP(p)
    if espObjs[p] then
        if espObjs[p].Highlight then espObjs[p].Highlight:Destroy() end
        if espObjs[p].BB then espObjs[p].BB:Destroy() end
        espObjs[p] = nil
    end
end
local function removeAllESP()
    for p, _ in pairs(espObjs) do removeESP(p) end
    table.clear(espObjs)
end
local function updateESP(p)
    if not ESPC.Enabled or p == LocalPlayer then removeESP(p); return end
    local char = p.Character
    if not char then removeESP(p); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local same = ESPC.TeamCheck and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
    if not hrp or not hum or hum.Health <= 0 or same then removeESP(p); return end
    if not espObjs[p] then espObjs[p] = {} end
    if ESPC.Boxes then
        if not espObjs[p].Highlight or not espObjs[p].Highlight.Parent then
            local hl = Instance.new("Highlight")
            hl.Name = "nursultanHL_"..p.Name
            hl.Adornee = char
            hl.FillColor = ESPC.Color
            hl.OutlineColor = Color3.fromRGB(255,255,255)
            hl.FillTransparency = 0.45
            hl.Parent = ScreenGui
            espObjs[p].Highlight = hl
        else
            espObjs[p].Highlight.Adornee = char
            espObjs[p].Highlight.Enabled = true
        end
    elseif espObjs[p].Highlight then
        espObjs[p].Highlight:Destroy(); espObjs[p].Highlight = nil
    end
    if ESPC.Nameplate then
        if not espObjs[p].BB or not espObjs[p].BB.Parent then
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0,180,0,44)
            bb.StudsOffset = Vector3.new(0,3.6,0)
            bb.AlwaysOnTop = true
            bb.Adornee = hrp
            bb.Parent = ScreenGui
            local bg = Instance.new("Frame", bb)
            bg.Size = UDim2.new(1,0,1,0)
            bg.BackgroundColor3 = Color3.fromRGB(20,20,20)
            bg.BackgroundTransparency = 0.15
            bg.BorderSizePixel = 0
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0,6)
            local av = Instance.new("ImageLabel", bg)
            av.Size = UDim2.new(0,32,0,32)
            av.Position = UDim2.new(0,5,0,6)
            av.BackgroundTransparency = 1
            av.Image = getAvatar(p)
            Instance.new("UICorner", av).CornerRadius = UDim.new(0,4)
            local nm = Instance.new("TextLabel", bg)
            nm.Size = UDim2.new(0,110,0,14)
            nm.Position = UDim2.new(0,42,0,6)
            nm.BackgroundTransparency = 1
            nm.Font = Enum.Font.GothamBold
            nm.TextSize = 11
            nm.TextColor3 = Color3.fromRGB(255,255,255)
            nm.TextXAlignment = Enum.TextXAlignment.Left
            nm.Text = p.Name
            local pl = Instance.new("TextLabel", bg)
            pl.Size = UDim2.new(0,42,0,14)
            pl.Position = UDim2.new(1,-46,0,6)
            pl.BackgroundTransparency = 1
            pl.Font = Enum.Font.Gotham
            pl.TextSize = 10
            pl.TextColor3 = Color3.fromRGB(150,150,150)
            pl.TextXAlignment = Enum.TextXAlignment.Right
            pl.Text = "0"
            local hb = Instance.new("Frame", bg)
            hb.Size = UDim2.new(1,-10,0,5)
            hb.Position = UDim2.new(0,5,1,-11)
            hb.BackgroundColor3 = Color3.fromRGB(40,40,40)
            hb.BorderSizePixel = 0
            Instance.new("UICorner", hb).CornerRadius = UDim.new(1,0)
            local hf = Instance.new("Frame", hb)
            hf.Size = UDim2.new(1,0,1,0)
            hf.BackgroundColor3 = Color3.fromRGB(80,200,80)
            hf.BorderSizePixel = 0
            Instance.new("UICorner", hf).CornerRadius = UDim.new(1,0)
            local ht = Instance.new("TextLabel", bg)
            ht.Size = UDim2.new(0,42,0,10)
            ht.Position = UDim2.new(1,-46,0,20)
            ht.BackgroundTransparency = 1
            ht.Font = Enum.Font.GothamBold
            ht.TextSize = 10
            ht.TextColor3 = Color3.fromRGB(255,255,255)
            ht.TextXAlignment = Enum.TextXAlignment.Right
            ht.Text = "100"
            espObjs[p].BB = bb
            espObjs[p].HbF = hf
            espObjs[p].HpT = ht
            espObjs[p].Nm = nm
            espObjs[p].Pl = pl
        else
            espObjs[p].BB.Adornee = hrp
            espObjs[p].BB.Enabled = true
        end
        local r = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
        espObjs[p].HbF.Size = UDim2.new(r,0,1,0)
        if r > 0.5 then espObjs[p].HbF.BackgroundColor3 = THEME.Green
        elseif r > 0.25 then espObjs[p].HbF.BackgroundColor3 = THEME.Yellow
        else espObjs[p].HbF.BackgroundColor3 = THEME.Red end
        espObjs[p].HpT.Text = tostring(math.floor(hum.Health))
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then
            local d = math.floor((myHrp.Position - hrp.Position).Magnitude)
            espObjs[p].Nm.Text = p.Name .. " [" .. d .. "m]"
        end
        local ping = 0
        pcall(function() ping = math.floor(p:GetNetworkPing()*1000) end)
        espObjs[p].Pl.Text = tostring(ping)
    elseif espObjs[p].BB then
        espObjs[p].BB:Destroy(); espObjs[p].BB = nil
    end
end
Conn(RunService.RenderStepped:Connect(function()
    if not ESPC.Enabled then return end
    for _, p in ipairs(Players:GetPlayers()) do updateESP(p) end
end))
Conn(Players.PlayerRemoving:Connect(removeESP))

-- TARGET INFO
local TIGui = Instance.new("ScreenGui")
TIGui.Name = "nursultanTI"
TIGui.ResetOnSpawn = false
TIGui.Parent = SafeParent()
local TIF = Instance.new("Frame", TIGui)
TIF.AnchorPoint = Vector2.new(0.5,1)
TIF.Size = UDim2.new(0,240,0,70)
TIF.Position = UDim2.new(0.5,0,0.5,-30)
TIF.BackgroundColor3 = Color3.fromRGB(15,10,12)
TIF.BackgroundTransparency = 0.15
TIF.BorderSizePixel = 0
TIF.Visible = false
Instance.new("UICorner", TIF).CornerRadius = UDim.new(0,8)
local TIS = Instance.new("UIStroke", TIF)
TIS.Color = THEME.Accent
TIS.Thickness = 1
Link(TIS, "Color")
local TIBar = Instance.new("Frame", TIF)
TIBar.Size = UDim2.new(0,3,1,-12)
TIBar.Position = UDim2.new(0,5,0,6)
TIBar.BackgroundColor3 = THEME.Accent
TIBar.BorderSizePixel = 0
Instance.new("UICorner", TIBar).CornerRadius = UDim.new(1,0)
Link(TIBar, "BackgroundColor3")
local TIName = Instance.new("TextLabel", TIF)
TIName.Size = UDim2.new(1,-20,0,20)
TIName.Position = UDim2.new(0,14,0,6)
TIName.BackgroundTransparency = 1
TIName.Font = Enum.Font.GothamBold
TIName.TextSize = 15
TIName.TextColor3 = THEME.TextPrimary
TIName.TextXAlignment = Enum.TextXAlignment.Left
TIName.Text = "Player"
local TIHP = Instance.new("TextLabel", TIF)
TIHP.Size = UDim2.new(0,80,0,14)
TIHP.Position = UDim2.new(0,14,0,28)
TIHP.BackgroundTransparency = 1
TIHP.Font = Enum.Font.Gotham
TIHP.TextSize = 11
TIHP.TextColor3 = THEME.Green
TIHP.TextXAlignment = Enum.TextXAlignment.Left
TIHP.Text = "HP: 100/100"
local TID = Instance.new("TextLabel", TIF)
TID.Size = UDim2.new(0,80,0,14)
TID.Position = UDim2.new(1,-94,0,28)
TID.BackgroundTransparency = 1
TID.Font = Enum.Font.Gotham
TID.TextSize = 11
TID.TextColor3 = THEME.TextMuted
TID.TextXAlignment = Enum.TextXAlignment.Right
TID.Text = "0m"
local TIHBBG = Instance.new("Frame", TIF)
TIHBBG.Size = UDim2.new(1,-28,0,5)
TIHBBG.Position = UDim2.new(0,14,1,-14)
TIHBBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
TIHBBG.BorderSizePixel = 0
Instance.new("UICorner", TIHBBG).CornerRadius = UDim.new(1,0)
local TIHBF = Instance.new("Frame", TIHBBG)
TIHBF.Size = UDim2.new(1,0,1,0)
TIHBF.BackgroundColor3 = THEME.Green
TIHBF.BorderSizePixel = 0
Instance.new("UICorner", TIHBF).CornerRadius = UDim.new(1,0)
local TargetInfoEnabled = false
Conn(RunService.RenderStepped:Connect(function()
    if not TargetInfoEnabled then TIF.Visible = false; return end
    local m = UserInputService:GetMouseLocation()
    local ray = Camera:ViewportPointToRay(m.X, m.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local res = Workspace:Raycast(ray.Origin, ray.Direction*2000, params)
    if not res then TIF.Visible = false; return end
    local char = res.Instance:FindFirstAncestorOfClass("Model")
    if not char then TIF.Visible = false; return end
    local plr = Players:GetPlayerFromCharacter(char)
    if not plr or plr == LocalPlayer then TIF.Visible = false; return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then TIF.Visible = false; return end
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local d = myHrp and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0
    TIName.Text = plr.Name
    TIHP.Text = string.format("HP: %d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth))
    TID.Text = d .. "m"
    local r = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
    TIHBF.Size = UDim2.new(r,0,1,0)
    if r > 0.5 then TIHBF.BackgroundColor3 = THEME.Green; TIHP.TextColor3 = THEME.Green
    elseif r > 0.25 then TIHBF.BackgroundColor3 = THEME.Yellow; TIHP.TextColor3 = THEME.Yellow
    else TIHBF.BackgroundColor3 = THEME.Red; TIHP.TextColor3 = THEME.Red end
    TIF.Visible = true
end))

-- RGB MODEL
local RGBModel = {Enabled=false, _thread=nil, _highlight=nil, _origColors={}, _origTex={}, _respawnConn=nil}
local function createOrUpdateHighlight()
    local char = LocalPlayer.Character
    if not char then return end
    if not RGBModel._highlight or not RGBModel._highlight.Parent then
        local hl = Instance.new("Highlight")
        hl.Name = "nursultanRGB"
        hl.Adornee = char
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = ScreenGui
        RGBModel._highlight = hl
    end
    RGBModel._highlight.Adornee = char
end
local function rgbLoop()
    local hue = 0
    while RGBModel.Enabled do
        hue = (hue + 4) % 360
        local col = HSVtoRGB(hue, 0.9, 1)
        if RGBModel._highlight and RGBModel._highlight.Parent then
            RGBModel._highlight.FillColor = col
            RGBModel._highlight.OutlineColor = HSVtoRGB((hue + 60) % 360, 1, 1)
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not RGBModel._origColors[part] then
                        RGBModel._origColors[part] = {Color = part.Color, Material = part.Material}
                    end
                    pcall(function() part.Color = col end)
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    if RGBModel._origTex[part] == nil then RGBModel._origTex[part] = part.Transparency end
                    pcall(function() part.Transparency = 1 end)
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end
function RGBModel.start()
    if RGBModel.Enabled then return end
    RGBModel.Enabled = true
    RGBModel._origColors = {}
    RGBModel._origTex = {}
    createOrUpdateHighlight()
    RGBModel._thread = task.spawn(rgbLoop)
    RGBModel._respawnConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if RGBModel.Enabled then
            RGBModel._origColors = {}
            RGBModel._origTex = {}
            createOrUpdateHighlight()
        end
    end)
end
function RGBModel.stop()
    if not RGBModel.Enabled then return end
    RGBModel.Enabled = false
    if RGBModel._thread then pcall(function() task.cancel(RGBModel._thread) end); RGBModel._thread = nil end
    if RGBModel._respawnConn then RGBModel._respawnConn:Disconnect(); RGBModel._respawnConn = nil end
    if RGBModel._highlight then RGBModel._highlight:Destroy(); RGBModel._highlight = nil end
    local char = LocalPlayer.Character
    if char then
        for part, data in pairs(RGBModel._origColors) do
            if part and part.Parent then
                pcall(function() part.Color = data.Color; part.Material = data.Material end)
            end
        end
        for part, t in pairs(RGBModel._origTex) do
            if part and part.Parent then pcall(function() part.Transparency = t end) end
        end
    end
    RGBModel._origColors = {}
    RGBModel._origTex = {}
end

-- SHADERS/SKY/OPTIMIZE
local Shaders = {}
local function getOrCreate(cls, name)
    local o = Lighting:FindFirstChild(name)
    if not o then o = Instance.new(cls); o.Name = name; o.Parent = Lighting end
    return o
end
local function SetShader(name, on)
    if name == "Bloom" then
        if on then Shaders.Bloom = getOrCreate("BloomEffect","NullBloom"); Shaders.Bloom.Intensity=1.2; Shaders.Bloom.Size=24
        elseif Shaders.Bloom then Shaders.Bloom:Destroy(); Shaders.Bloom=nil end
    elseif name == "CC" then
        if on then Shaders.CC = getOrCreate("ColorCorrectionEffect","NullCC"); Shaders.CC.Brightness=0.1; Shaders.CC.Contrast=0.2; Shaders.CC.Saturation=0.25
        elseif Shaders.CC then Shaders.CC:Destroy(); Shaders.CC=nil end
    elseif name == "SunRays" then
        if on then Shaders.SR = getOrCreate("SunRaysEffect","NullSR"); Shaders.SR.Intensity=0.15
        elseif Shaders.SR then Shaders.SR:Destroy(); Shaders.SR=nil end
    elseif name == "DoF" then
        if on then Shaders.DoF = getOrCreate("DepthOfFieldEffect","NullDoF"); Shaders.DoF.FarIntensity=0.15; Shaders.DoF.FocusDistance=30
        elseif Shaders.DoF then Shaders.DoF:Destroy(); Shaders.DoF=nil end
    elseif name == "Blur" then
        if on then Shaders.Blur = getOrCreate("BlurEffect","NullBlur"); Shaders.Blur.Size=6
        elseif Shaders.Blur then Shaders.Blur:Destroy(); Shaders.Blur=nil end
    elseif name == "Sharpen" then
        if on then Shaders.Sh = getOrCreate("SharpenEffect","NullSh"); Shaders.Sh.Size=1.5; Shaders.Sh.Strength=0.5
        elseif Shaders.Sh then Shaders.Sh:Destroy(); Shaders.Sh=nil end
    end
end
local SKIES = {
    Galaxy={Bk="rbxassetid://159454299",Dn="rbxassetid://159454296",Ft="rbxassetid://159454293",Lf="rbxassetid://159454286",Rt="rbxassetid://159454300",Up="rbxassetid://159454288"},
    Night={Bk="rbxassetid://171410628",Dn="rbxassetid://171410649",Ft="rbxassetid://171410620",Lf="rbxassetid://171410666",Rt="rbxassetid://171410657",Up="rbxassetid://171410636"},
    Blue={Bk="rbxassetid://12064107",Dn="rbxassetid://12064152",Ft="rbxassetid://12064121",Lf="rbxassetid://12063984",Rt="rbxassetid://12064115",Up="rbxassetid://12064129"},
    Red={Bk="rbxassetid://570557054",Dn="rbxassetid://570557180",Ft="rbxassetid://570557250",Lf="rbxassetid://570557323",Rt="rbxassetid://570557407",Up="rbxassetid://570557483"}
}
local DefSky
for _, o in ipairs(Lighting:GetChildren()) do if o:IsA("Sky") then DefSky = o end end
local function SetSky(n)
    for _, o in ipairs(Lighting:GetChildren()) do if o:IsA("Sky") then o:Destroy() end end
    if n == "Default" then
        if DefSky then DefSky:Clone().Parent = Lighting end
        return ShowNotification("Sky", "Default")
    end
    local p = SKIES[n]; if not p then return end
    local s = Instance.new("Sky")
    s.SkyboxBk=p.Bk; s.SkyboxDn=p.Dn; s.SkyboxFt=p.Ft
    s.SkyboxLf=p.Lf; s.SkyboxRt=p.Rt; s.SkyboxUp=p.Up
    s.Parent = Lighting
    ShowNotification("Sky", n)
end
local Removed = {}
local SavedL = {Shadows=Lighting.GlobalShadows, Bright=Lighting.Brightness}
local function OptimizeWorld()
    Removed = {}
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
            if o.Enabled then o.Enabled = false; table.insert(Removed, o) end
        end
    end
    Lighting.GlobalShadows = false
end
local function RestoreWorld()
    for _, o in ipairs(Removed) do
        if o and o.Parent then pcall(function() o.Enabled = true end) end
    end
    Removed = {}
    Lighting.GlobalShadows = SavedL.Shadows
end
local function UnlockFPS()
    pcall(function() setfpscap(9999) end)
    pcall(function() setfpscap(0) end)
end
local function RestoreFPS() pcall(function() setfpscap(60) end) end

-- BINDS OVERLAY
local BOV = Instance.new("Frame", ScreenGui)
BOV.Size = UDim2.new(0,240,0,60)
BOV.Position = UDim2.new(0,16,0,320)
BOV.BackgroundColor3 = THEME.Background
BOV.BorderSizePixel = 0
BOV.Visible = false
Instance.new("UICorner", BOV).CornerRadius = UDim.new(0,8)
local BOS = Instance.new("UIStroke", BOV)
BOS.Color = THEME.Border
Link(BOS, "Color")
local BOT = Instance.new("TextLabel", BOV)
BOT.Size = UDim2.new(1,0,0,24)
BOT.BackgroundTransparency = 1
BOT.Font = Enum.Font.GothamBold
BOT.TextSize = 12
BOT.TextColor3 = THEME.Accent
BOT.Text = "◆ BINDS"
Link(BOT, "TextColor3")
local BOL = Instance.new("Frame", BOV)
BOL.Size = UDim2.new(1,-16,0,0)
BOL.Position = UDim2.new(0,8,0,30)
BOL.AutomaticSize = Enum.AutomaticSize.Y
BOL.BackgroundTransparency = 1
local BOLay = Instance.new("UIListLayout", BOL)
BOLay.Padding = UDim.new(0,3)
BOLay.SortOrder = Enum.SortOrder.LayoutOrder
local function refreshBO()
    for _, c in ipairs(BOL:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local count = 0
    for key, b in pairs(BindM.binds) do
        count = count + 1
        local r = Instance.new("Frame", BOL)
        r.Size = UDim2.new(1,0,0,18)
        r.BackgroundTransparency = 1
        local kl = Instance.new("TextLabel", r)
        kl.Size = UDim2.new(0,70,1,0)
        kl.BackgroundColor3 = THEME.SidebarActive
        kl.BorderSizePixel = 0
        kl.Font = Enum.Font.GothamBold
        kl.TextSize = 10
        kl.TextColor3 = THEME.AccentSoft
        kl.Text = "  "..key
        kl.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", kl).CornerRadius = UDim.new(0,4)
        local nl = Instance.new("TextLabel", r)
        nl.Size = UDim2.new(1,-76,1,0)
        nl.Position = UDim2.new(0,76,0,0)
        nl.BackgroundTransparency = 1
        nl.Font = Enum.Font.GothamMedium
        nl.TextSize = 10.5
        nl.TextColor3 = THEME.TextPrimary
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.Text = b.label
    end
    BOV.Size = UDim2.new(0,240,0, count == 0 and 90 or 36 + count * 21 + 6)
end
table.insert(BindM.onChange, refreshBO)

-- HUD
local Hud = Instance.new("Frame", ScreenGui)
Hud.Size = UDim2.new(0, 720, 0, 76)
Hud.Position = UDim2.new(0, 16, 0, 48)
Hud.BackgroundTransparency = 1
local HVL = Instance.new("UIListLayout", Hud)
HVL.SortOrder = Enum.SortOrder.LayoutOrder
HVL.Padding = UDim.new(0,6)
local function row(h, o)
    local r = Instance.new("Frame", Hud)
    r.Size = UDim2.new(1,0,0,h)
    r.BackgroundTransparency = 1
    r.LayoutOrder = o
    local l = Instance.new("UIListLayout", r)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.Padding = UDim.new(0,6)
    return r
end
local TR = row(30, 1)
local BR = row(30, 2)
local function pill(p, o)
    local f = Instance.new("Frame", p)
    f.AutomaticSize = Enum.AutomaticSize.X
    f.Size = UDim2.new(0,0,1,0)
    f.BackgroundColor3 = THEME.PillBg
    f.BorderSizePixel = 0
    f.LayoutOrder = o
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)
    local s = Instance.new("UIStroke", f)
    s.Color = THEME.Border
    s.Thickness = 1
    local pad = Instance.new("UIPadding", f)
    pad.PaddingLeft = UDim.new(0,8)
    pad.PaddingRight = UDim.new(0,8)
    local l = Instance.new("UIListLayout", f)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.Padding = UDim.new(0,6)
    return f
end
local function div(p, o)
    local d = Instance.new("Frame", p)
    d.Size = UDim2.new(0,1,0,14)
    d.BackgroundColor3 = THEME.Divider
    d.BorderSizePixel = 0
    d.LayoutOrder = o
end
local function txt(p, t, o)
    local l = Instance.new("TextLabel", p)
    l.AutomaticSize = Enum.AutomaticSize.X
    l.Size = UDim2.new(0,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = t
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 13
    l.TextColor3 = THEME.TextPrimary
    l.LayoutOrder = o
    return l
end
local function ico(p, i, o)
    local im = Instance.new("ImageLabel", p)
    im.Size = UDim2.new(0,14,0,14)
    im.BackgroundTransparency = 1
    im.Image = i
    im.ScaleType = Enum.ScaleType.Fit
    im.ImageColor3 = THEME.Accent
    im.LayoutOrder = o
    Link(im, "ImageColor3")
    return im
end
local BP = pill(TR, 1)
local HW = Instance.new("Frame", BP)
HW.Size = UDim2.new(0,24,0,24)
HW.BackgroundTransparency = 1
HW.LayoutOrder = 1
local HG = Instance.new("ImageLabel", HW)
HG.Size = UDim2.new(2,0,2,0)
HG.Position = UDim2.new(-0.5,0,-0.5,0)
HG.BackgroundTransparency = 1
HG.Image = "rbxassetid://5028857084"
HG.ImageColor3 = THEME.Accent
HG.ImageTransparency = 0.65
Link(HG, "ImageColor3")
local HL2 = Instance.new("ImageLabel", HW)
HL2.Size = UDim2.new(1.35,0,1.35,0)
HL2.Position = UDim2.new(-0.175,0,-0.175,0)
HL2.BackgroundTransparency = 1
HL2.Image = LOGO_ID
HL2.ScaleType = Enum.ScaleType.Fit
HL2.ImageColor3 = THEME.Accent
Link(HL2, "ImageColor3")
div(BP, 2)
txt(BP, "nursultan", 3)
local SP = pill(TR, 2)
ico(SP, ICONS.User, 1)
txt(SP, string.lower(LocalPlayer.Name), 2)
div(SP, 3)
ico(SP, ICONS.Chart, 4)
local FpsL = txt(SP, "0 Fps", 5)
div(SP, 6)
ico(SP, ICONS.Clock, 7)
local TimeL = txt(SP, "00:00:00", 8)
local PP = pill(BR, 1)
ico(PP, ICONS.Compass, 1)
div(PP, 2)
local PosL = txt(PP, "0, 0, 0", 3)
local PiP = pill(BR, 2)
ico(PiP, ICONS.Signal, 1)
div(PiP, 2)
local PingL = txt(PiP, "0 Ping", 3)
local SpP = pill(BR, 3)
ico(SpP, ICONS.Speed, 1)
div(SpP, 2)
local SpL = txt(SpP, "0.0 Bps", 3)
do
    local drag, ds, sp
    Hud.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; ds = i.Position; sp = Hud.Position end
    end)
    Conn(UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Hud.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end))
    Conn(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end))
end
local fc, lf = 0, os.clock()
local lpos = Vector3.zero
local lt = os.clock()
Conn(RunService.RenderStepped:Connect(function()
    fc = fc + 1
    local now = os.clock()
    if now - lf >= 1 then FpsL.Text = string.format("%d Fps", fc); fc = 0; lf = now end
    TimeL.Text = os.date("%H:%M:%S")
    local ok, pg = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    PingL.Text = ok and string.format("%d Ping", pg) or "0 Ping"
    local ch = LocalPlayer.Character
    if ch and ch:FindFirstChild("HumanoidRootPart") then
        local hrp = ch.HumanoidRootPart
        local cp = hrp.Position
        PosL.Text = string.format("%d, %d, %d", math.floor(cp.X), math.floor(cp.Y), math.floor(cp.Z))
        local dt = now - lt
        if dt >= 0.1 then
            local d = (Vector3.new(cp.X,0,cp.Z) - Vector3.new(lpos.X,0,lpos.Z)).Magnitude
            SpL.Text = string.format("%.1f Bps", d/dt)
            lpos = cp; lt = now
        end
    end
end))

-- MAIN GUI
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 880, 0, 560)
Main.Position = UDim2.new(0.5, -440, 0.5, -280)
Main.BackgroundColor3 = THEME.Background
Main.BorderSizePixel = 0
Main.BackgroundTransparency = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
local MS = Instance.new("UIStroke", Main)
MS.Color = THEME.Border
Link(MS, "Color")
local Glow = Instance.new("ImageLabel", Main)
Glow.BackgroundTransparency = 1
Glow.Position = UDim2.new(0,-45,0,-45)
Glow.Size = UDim2.new(1,90,1,90)
Glow.ZIndex = 0
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = THEME.AccentDark
Glow.ImageTransparency = 0.83
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(24,24,276,276)
Link(Glow, "ImageColor3")

task.spawn(function()
    task.wait(4.3)
    TweenService:Create(Main, ANIM.Bounce, {BackgroundTransparency = 0}):Play()
end)

do
    local drag, ds, sp
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; ds = i.Position; sp = Main.Position end
    end)
    Conn(UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            TweenService:Create(Main, TweenInfo.new(0.04), {
                Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
            }):Play()
        end
    end))
    Conn(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end))
end

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,60)
TopBar.BackgroundTransparency = 1
local LogoH = Instance.new("Frame", TopBar)
LogoH.Size = UDim2.new(0,68,0,68)
LogoH.Position = UDim2.new(0,52,0,-4)
LogoH.BackgroundTransparency = 1
local LHalo = Instance.new("ImageLabel", LogoH)
LHalo.Size = UDim2.new(2.1,0,2.1,0)
LHalo.Position = UDim2.new(-0.55,0,-0.55,0)
LHalo.BackgroundTransparency = 1
LHalo.Image = "rbxassetid://5028857084"
LHalo.ImageColor3 = THEME.Accent
LHalo.ImageTransparency = 0.58
Link(LHalo, "ImageColor3")
local LImg = Instance.new("ImageLabel", LogoH)
LImg.Size = UDim2.new(1,0,1,0)
LImg.BackgroundTransparency = 1
LImg.Image = LOGO_ID
LImg.ScaleType = Enum.ScaleType.Fit
LImg.ImageColor3 = THEME.Accent
Link(LImg, "ImageColor3")
local SearchBox = Instance.new("Frame", TopBar)
SearchBox.Size = UDim2.new(0,280,0,30)
SearchBox.Position = UDim2.new(0,205,0,15)
SearchBox.BackgroundColor3 = THEME.CardBg
SearchBox.BorderSizePixel = 0
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,6)
Instance.new("UIStroke", SearchBox).Color = THEME.Border
local SIcon = Instance.new("ImageLabel", SearchBox)
SIcon.Size = UDim2.new(0,15,0,15)
SIcon.Position = UDim2.new(0,10,0.5,-7.5)
SIcon.BackgroundTransparency = 1
SIcon.Image = ICONS.Search
SIcon.ImageColor3 = THEME.TextMuted
local Search = Instance.new("TextBox", SearchBox)
Search.PlaceholderText = T("SearchPlaceholder")
Search.PlaceholderColor3 = THEME.TextMuted
Search.TextColor3 = THEME.TextPrimary
Search.Font = Enum.Font.Gotham
Search.TextSize = 12.5
Search.Position = UDim2.new(0,34,0,0)
Search.Size = UDim2.new(1,-40,1,0)
Search.BackgroundTransparency = 1
Search.TextXAlignment = Enum.TextXAlignment.Left

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,175,1,-90)
Sidebar.Position = UDim2.new(0,14,0,60)
Sidebar.BackgroundTransparency = 1
local SL = Instance.new("UIListLayout", Sidebar)
SL.Padding = UDim.new(0,3)
SL.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-215,1,-90)
Content.Position = UDim2.new(0,200,0,60)
Content.BackgroundTransparency = 1

local DiscBar = Instance.new("Frame", Main)
DiscBar.Size = UDim2.new(1, -28, 0, 22)
DiscBar.Position = UDim2.new(0, 14, 1, -26)
DiscBar.BackgroundColor3 = THEME.CardBg
DiscBar.BackgroundTransparency = 0.3
DiscBar.BorderSizePixel = 0
Instance.new("UICorner", DiscBar).CornerRadius = UDim.new(0, 6)
local DiscText = Instance.new("TextLabel", DiscBar)
DiscText.Size = UDim2.new(1, -20, 1, 0)
DiscText.Position = UDim2.new(0, 10, 0, 0)
DiscText.BackgroundTransparency = 1
DiscText.Font = Enum.Font.Gotham
DiscText.TextSize = 10
DiscText.TextColor3 = THEME.TextDim
DiscText.TextXAlignment = Enum.TextXAlignment.Center
DiscText.Text = T("Disclaimer")
DiscText.TextTruncate = Enum.TextTruncate.AtEnd

local activeTab, rows, pages = nil, {}, {}
local function makePage(n)
    local p = Instance.new("Frame", Content)
    p.Name = n.."Page"
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.Visible = false
    local c1 = Instance.new("ScrollingFrame", p)
    c1.Size = UDim2.new(0.485,0,1,0)
    c1.BackgroundTransparency = 1
    c1.ScrollBarThickness = 2
    c1.ScrollBarImageColor3 = THEME.Accent
    c1.AutomaticCanvasSize = Enum.AutomaticSize.Y
    c1.CanvasSize = UDim2.new(0,0,0,0)
    Link(c1, "ScrollBarImageColor3")
    local c2 = Instance.new("ScrollingFrame", p)
    c2.Size = UDim2.new(0.485,0,1,0)
    c2.Position = UDim2.new(0.515,0,0,0)
    c2.BackgroundTransparency = 1
    c2.ScrollBarThickness = 2
    c2.ScrollBarImageColor3 = THEME.Accent
    c2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    c2.CanvasSize = UDim2.new(0,0,0,0)
    Link(c2, "ScrollBarImageColor3")
    for _, c in ipairs({c1,c2}) do
        local l = Instance.new("UIListLayout", c)
        l.Padding = UDim.new(0,12)
        l.SortOrder = Enum.SortOrder.LayoutOrder
    end
    pages[n] = {Page=p, Col1=c1, Col2=c2}
    return pages[n]
end
local function addTab(key, icon, default, order)
    local td = makePage(key)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1,-4,0,30)
    b.LayoutOrder = order
    b.BackgroundColor3 = default and THEME.SidebarActive or THEME.Background
    b.BackgroundTransparency = default and 0 or 1
    b.Text = ""
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local s = Instance.new("UIStroke", b)
    s.Color = default and THEME.BorderActive or Color3.fromRGB(0,0,0)
    s.Transparency = default and 0 or 1
    local ic = Instance.new("ImageLabel", b)
    ic.Size = UDim2.new(0,16,0,16)
    ic.Position = UDim2.new(0,10,0.5,-8)
    ic.BackgroundTransparency = 1
    ic.Image = icon
    ic.ImageColor3 = default and THEME.Accent or THEME.TextMuted
    local t = Instance.new("TextLabel", b)
    t.Size = UDim2.new(1,-36,1,0)
    t.Position = UDim2.new(0,34,0,0)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 12
    t.TextColor3 = default and THEME.TextPrimary or THEME.TextMuted
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = T(key)
    if default then
        activeTab = {Btn=b, Icon=ic, Title=t, Stroke=s, Name=key}
        td.Page.Visible = true
    end
    b.MouseEnter:Connect(function()
        if activeTab.Btn ~= b then
            TweenService:Create(t, ANIM.Fast, {TextColor3=THEME.TextPrimary}):Play()
            TweenService:Create(ic, ANIM.Fast, {ImageColor3=THEME.TextPrimary}):Play()
            TweenService:Create(b, ANIM.Fast, {Position = UDim2.new(0,4,0,0)}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if activeTab.Btn ~= b then
            TweenService:Create(t, ANIM.Fast, {TextColor3=THEME.TextMuted}):Play()
            TweenService:Create(ic, ANIM.Fast, {ImageColor3=THEME.TextMuted}):Play()
            TweenService:Create(b, ANIM.Fast, {Position = UDim2.new(0,0,0,0)}):Play()
        end
    end)
    b.MouseButton1Click:Connect(function()
        if activeTab.Btn == b then return end
        if pages[activeTab.Name] then
            local oldPage = pages[activeTab.Name].Page
            TweenService:Create(oldPage, ANIM.Fast, {Position = UDim2.new(0,-15,0,0)}):Play()
            task.wait(0.08)
            oldPage.Visible = false
            oldPage.Position = UDim2.new(0,0,0,0)
        end
        TweenService:Create(activeTab.Btn, ANIM.Fast, {BackgroundTransparency=1}):Play()
        TweenService:Create(activeTab.Stroke, ANIM.Fast, {Transparency=1}):Play()
        TweenService:Create(activeTab.Icon, ANIM.Fast, {ImageColor3=THEME.TextMuted}):Play()
        TweenService:Create(activeTab.Title, ANIM.Fast, {TextColor3=THEME.TextMuted}):Play()
        td.Page.Visible = true
        td.Page.Position = UDim2.new(0, 15, 0, 0)
        TweenService:Create(td.Page, ANIM.SlideIn, {Position = UDim2.new(0,0,0,0)}):Play()
        TweenService:Create(b, ANIM.Fast, {BackgroundTransparency=0, BackgroundColor3=THEME.SidebarActive}):Play()
        TweenService:Create(s, ANIM.Fast, {Transparency=0, Color=THEME.BorderActive}):Play()
        TweenService:Create(ic, ANIM.Fast, {ImageColor3=THEME.Accent}):Play()
        TweenService:Create(t, ANIM.Fast, {TextColor3=THEME.TextPrimary}):Play()
        activeTab = {Btn=b, Icon=ic, Title=t, Stroke=s, Name=key}
    end)
end

-- ELEMENTS
local function createCard(parent, title, order)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1,0,0,0)
    c.AutomaticSize = Enum.AutomaticSize.Y
    c.BackgroundColor3 = THEME.CardBg
    c.BorderSizePixel = 0
    c.LayoutOrder = order
    Instance.new("UICorner", c).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", c)
    s.Color = THEME.Border
    local p = Instance.new("UIPadding", c)
    p.PaddingTop = UDim.new(0,12); p.PaddingBottom = UDim.new(0,14)
    p.PaddingLeft = UDim.new(0,14); p.PaddingRight = UDim.new(0,14)
    local l = Instance.new("UIListLayout", c)
    l.Padding = UDim.new(0,10)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    local h = Instance.new("Frame", c)
    h.Size = UDim2.new(1,0,0,20)
    h.BackgroundTransparency = 1
    h.LayoutOrder = 0
    local t = Instance.new("TextLabel", h)
    t.Size = UDim2.new(1,-20,1,0)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13.5
    t.TextColor3 = THEME.TextPrimary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = title
    local i = Instance.new("ImageLabel", h)
    i.Size = UDim2.new(0,14,0,14)
    i.Position = UDim2.new(1,-14,0.5,-7)
    i.BackgroundTransparency = 1
    i.Image = ICONS.Chevron
    i.ImageColor3 = THEME.Accent
    Link(i, "ImageColor3")
    return c
end

local toggles = {}
local function createBindBtn(parent, label, getCb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,44,0,18)
    b.Position = UDim2.new(1,-86,0.5,-9)
    b.BackgroundColor3 = THEME.CardBg
    b.Text = "—"
    b.AutoButtonColor = false
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.TextColor3 = THEME.TextMuted
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    local s = Instance.new("UIStroke", b)
    s.Color = THEME.Border
    local function up()
        local k = BindM:getKeyByLabel(label)
        b.Text = k or "—"
        b.TextColor3 = k and THEME.Accent or THEME.TextMuted
        s.Color = k and THEME.BorderActive or THEME.Border
    end
    up()
    table.insert(BindM.onChange, up)
    b.MouseButton1Click:Connect(function()
        if BindM.listening and BindM.listening.label == label then
            BindM:cancelListening(); up(); return
        end
        b.Text = "[...]"
        b.TextColor3 = THEME.AccentSoft
        s.Color = THEME.Accent
        BindM:startListening(label, function(k)
            up()
            if k then BindM:set(k, label, getCb) end
        end)
    end)
end

local function addToggle(card, key, default, cb)
    local r = Instance.new("Frame", card)
    r.Name = key
    r.Size = UDim2.new(1,0,0,24)
    r.BackgroundTransparency = 1
    table.insert(rows, {Frame=r, Name=T(key):lower(), Key=key})
    local t = Instance.new("TextLabel", r)
    t.Size = UDim2.new(1,-130,1,0)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 12.5
    t.TextColor3 = THEME.TextPrimary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = T(key)
    local sw = Instance.new("TextButton", r)
    sw.Size = UDim2.new(0,36,0,18)
    sw.Position = UDim2.new(1,-36,0.5,-9)
    sw.BackgroundColor3 = default and THEME.Accent or THEME.ToggleOff
    sw.Text = ""
    sw.AutoButtonColor = false
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame", sw)
    kn.Size = UDim2.new(0,14,0,14)
    kn.Position = default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
    kn.BackgroundColor3 = default and THEME.KnobOn or THEME.KnobOff
    kn.BorderSizePixel = 0
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local on = default
    local function setS(s, sup)
        on = s
        TweenService:Create(sw, ANIM.Bounce, {BackgroundColor3 = on and THEME.Accent or THEME.ToggleOff}):Play()
        TweenService:Create(kn, ANIM.Bounce, {
            BackgroundColor3 = on and THEME.KnobOn or THEME.KnobOff,
            Position = on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
        }):Play()
        if cb and not sup then cb(on) end
    end
    sw.MouseButton1Click:Connect(function() setS(not on) end)
    createBindBtn(r, key, function() setS(not on) end)
    toggles[key] = {Set=setS, Get=function() return on end}
    CfgM:register(key, function() return on end, setS)
    return setS
end

local function addSlider(card, key, mn, mx, def, cb)
    local r = Instance.new("Frame", card)
    r.Size = UDim2.new(1,0,0,40)
    r.BackgroundTransparency = 1
    table.insert(rows, {Frame=r, Name=T(key):lower(), Key=key})
    local t = Instance.new("TextLabel", r)
    t.Size = UDim2.new(1,-60,0,16)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 12.5
    t.TextColor3 = THEME.TextPrimary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = T(key)
    local vl = Instance.new("TextLabel", r)
    vl.Size = UDim2.new(0,50,0,16)
    vl.Position = UDim2.new(1,-50,0,0)
    vl.BackgroundTransparency = 1
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12
    vl.TextColor3 = THEME.Accent
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.Text = string.format("%.2f", def)
    Link(vl, "TextColor3")
    local sb = Instance.new("Frame", r)
    sb.Size = UDim2.new(1,0,0,6)
    sb.Position = UDim2.new(0,0,0,26)
    sb.BackgroundColor3 = THEME.ToggleOff
    sb.BorderSizePixel = 0
    Instance.new("UICorner", sb).CornerRadius = UDim.new(1,0)
    local sf = Instance.new("Frame", sb)
    sf.Size = UDim2.new((def-mn)/(mx-mn),0,1,0)
    sf.BackgroundColor3 = THEME.Accent
    sf.BorderSizePixel = 0
    Instance.new("UICorner", sf).CornerRadius = UDim.new(1,0)
    Link(sf, "BackgroundColor3")
    local kn = Instance.new("Frame", sb)
    kn.Size = UDim2.new(0,14,0,14)
    kn.AnchorPoint = Vector2.new(0.5,0.5)
    kn.Position = UDim2.new((def-mn)/(mx-mn),0,0.5,0)
    kn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    kn.BorderSizePixel = 0
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local cur = def
    local drag = false
    local function setV(v)
        v = math.clamp(v, mn, mx); cur = v
        local a = (v-mn)/(mx-mn)
        TweenService:Create(sf, ANIM.Fast, {Size = UDim2.new(a,0,1,0)}):Play()
        TweenService:Create(kn, ANIM.Fast, {Position = UDim2.new(a,0,0.5,0)}):Play()
        vl.Text = string.format("%.2f", v)
        if cb then cb(v) end
    end
    sb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            local rel = (i.Position.X - sb.AbsolutePosition.X)/sb.AbsoluteSize.X
            setV(mn + rel*(mx-mn))
        end
    end)
    Conn(UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (i.Position.X - sb.AbsolutePosition.X)/sb.AbsoluteSize.X
            setV(mn + rel*(mx-mn))
        end
    end))
    Conn(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end))
    toggles[key] = {Set=setV, Get=function() return cur end}
    CfgM:register(key, function() return cur end, setV)
    return setV
end

local function addButton(card, key, cb)
    local r = Instance.new("Frame", card)
    r.Size = UDim2.new(1,0,0,30)
    r.BackgroundTransparency = 1
    table.insert(rows, {Frame=r, Name=T(key):lower(), Key=key})
    local b = Instance.new("TextButton", r)
    b.Size = UDim2.new(1,0,1,0)
    b.BackgroundColor3 = THEME.SidebarActive
    b.Text = ""
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local s = Instance.new("UIStroke", b)
    s.Color = THEME.Border
    local t = Instance.new("TextLabel", b)
    t.Size = UDim2.new(1,-24,1,0)
    t.Position = UDim2.new(0,12,0,0)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 12.5
    t.TextColor3 = THEME.TextPrimary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = T(key)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, ANIM.Fast, {BackgroundColor3=THEME.BtnHover}):Play()
        TweenService:Create(s, ANIM.Fast, {Color=THEME.BorderActive}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, ANIM.Fast, {BackgroundColor3=THEME.SidebarActive}):Play()
        TweenService:Create(s, ANIM.Fast, {Color=THEME.Border}):Play()
    end)
    b.MouseButton1Click:Connect(function()
        if cb then cb() end
        local ripple = Instance.new("Frame", b)
        ripple.Size = UDim2.new(0, 0, 1, 0)
        ripple.BackgroundColor3 = THEME.Accent
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(0,6)
        TweenService:Create(ripple, TweenInfo.new(0.4), {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1}):Play()
        task.delay(0.4, function() ripple:Destroy() end)
    end)
    return b
end

local function addTextInput(card, key, default, cb)
    local r = Instance.new("Frame", card)
    r.Size = UDim2.new(1,0,0,30)
    r.BackgroundTransparency = 1
    table.insert(rows, {Frame=r, Name=T(key):lower(), Key=key})
    local i = Instance.new("TextBox", r)
    i.Size = UDim2.new(1,0,1,0)
    i.BackgroundColor3 = THEME.SidebarActive
    i.BorderSizePixel = 0
    i.Font = Enum.Font.Gotham
    i.TextSize = 12
    i.TextColor3 = THEME.TextPrimary
    i.PlaceholderColor3 = THEME.TextMuted
    i.Text = default or ""
    i.PlaceholderText = T(key)
    i.TextXAlignment = Enum.TextXAlignment.Left
    i.ClearTextOnFocus = false
    Instance.new("UICorner", i).CornerRadius = UDim.new(0,6)
    Instance.new("UIPadding", i).PaddingLeft = UDim.new(0,10)
    Instance.new("UIStroke", i).Color = THEME.Border
    i.FocusLost:Connect(function() if cb then cb(i.Text) end end)
    return i
end

local function addColorPicker(card, key, defaultColor, cb)
    local frame = Instance.new("Frame", card)
    frame.Size = UDim2.new(1, 0, 0, 140)
    frame.BackgroundTransparency = 1
    table.insert(rows, {Frame=frame, Name=T(key):lower(), Key=key})
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 18)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 12.5
    title.TextColor3 = THEME.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = T(key)
    local preview = Instance.new("Frame", frame)
    preview.Size = UDim2.new(0, 65, 0, 90)
    preview.Position = UDim2.new(1, -65, 0, 22)
    preview.BackgroundColor3 = defaultColor
    preview.BorderSizePixel = 0
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", preview).Color = THEME.Border
    local hexLbl = Instance.new("TextLabel", preview)
    hexLbl.Size = UDim2.new(1, 0, 0, 14)
    hexLbl.Position = UDim2.new(0, 0, 1, 4)
    hexLbl.BackgroundTransparency = 1
    hexLbl.Font = Enum.Font.GothamBold
    hexLbl.TextSize = 10
    hexLbl.TextColor3 = THEME.TextPrimary
    hexLbl.Text = "#FFFFFF"
    local H, S, V = RGBtoHSV(defaultColor)
    H = (H or 0) % 360
    local function makeSlider(yOff, label, isHue)
        local container = Instance.new("Frame", frame)
        container.Size = UDim2.new(1, -75, 0, 24)
        container.Position = UDim2.new(0, 0, 0, yOff)
        container.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", container)
        lbl.Size = UDim2.new(0, 60, 0, 10)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 9
        lbl.TextColor3 = THEME.TextMuted
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = label
        local track = Instance.new("Frame", container)
        track.Size = UDim2.new(1, 0, 0, 12)
        track.Position = UDim2.new(0, 0, 0, 11)
        track.BackgroundColor3 = Color3.fromRGB(255,255,255)
        track.BorderSizePixel = 0
        Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", track).Color = THEME.Border
        local grad = Instance.new("UIGradient", track)
        if isHue then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0)),
            })
        end
        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 4, 1, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        knob.BorderSizePixel = 0
        Instance.new("UIStroke", knob).Color = Color3.fromRGB(0,0,0)
        return track, knob, grad
    end
    local hTrack, hKnob = makeSlider(24, T("Hue"), true)
    local sTrack, sKnob, sGrad = makeSlider(52, T("Saturation"), false)
    local vTrack, vKnob, vGrad = makeSlider(80, T("Value"), false)
    local updating = false
    local function updateVisuals()
        if updating then return end
        updating = true
        hKnob.Position = UDim2.new(H / 360, -2, 0, 0)
        sKnob.Position = UDim2.new(S, -2, 0, 0)
        vKnob.Position = UDim2.new(V, -2, 0, 0)
        local hueColor = HSVtoRGB(H, 1, 1)
        sGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1, hueColor),
        })
        vGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(1, HSVtoRGB(H, S, 1)),
        })
        local result = HSVtoRGB(H, S, V)
        preview.BackgroundColor3 = result
        hexLbl.Text = string.format("#%02X%02X%02X",
            math.floor(result.R*255 + 0.5),
            math.floor(result.G*255 + 0.5),
            math.floor(result.B*255 + 0.5))
        if cb then cb(result) end
        updating = false
    end
    local function hookDrag(track, setFn)
        local dragging = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local rel = (i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                setFn(math.clamp(rel, 0, 1))
                updateVisuals()
            end
        end)
        Conn(UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = (i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                setFn(math.clamp(rel, 0, 1))
                updateVisuals()
            end
        end))
        Conn(UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end))
    end
    hookDrag(hTrack, function(v) H = v * 360 end)
    hookDrag(sTrack, function(v) S = v end)
    hookDrag(vTrack, function(v) V = v end)
    updateVisuals()
end

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = Search.Text:lower()
    for _, it in ipairs(rows) do
        if q == "" then it.Frame.Visible = true
        else it.Frame.Visible = string.find((it.Name or ""):lower(), q, 1, true) ~= nil end
    end
end)

-- UNLOAD
local function Unload()
    for _, c in ipairs(Conn_list) do
        if c and typeof(c) == "RBXScriptConnection" then c:Disconnect() end
    end
    table.clear(Conn_list)
    rainbowActive = false
    removeAllESP()
    KillAura.stop()
    InfJump.stop()
    pcall(function() RGBModel.stop() end)
    pcall(function()
        Lighting.GlobalShadows = SavedL.Shadows
        Lighting.Brightness = SavedL.Bright
        for _, o in ipairs(Lighting:GetChildren()) do
            if o:IsA("Sky") then o:Destroy() end
        end
        if DefSky then DefSky:Clone().Parent = Lighting end
        for _, cls in ipairs({"BloomEffect","ColorCorrectionEffect","SunRaysEffect","DepthOfFieldEffect","BlurEffect","SharpenEffect"}) do
            for _, o in ipairs(Lighting:GetChildren()) do
                if o:IsA(cls) and o.Name:sub(1,4) == "Null" then o:Destroy() end
            end
        end
    end)
    RestoreFPS()
    if ScreenGui then ScreenGui:Destroy() end
    if TIGui then TIGui:Destroy() end
    if LoadGui and LoadGui.Parent then LoadGui:Destroy() end
end

-- BUILD TABS
addTab("Combat", ICONS.Combat, true, 1)
addTab("Visuals", ICONS.Visuals, false, 2)
addTab("Dupe", ICONS.Copy, false, 3)
addTab("Binds", ICONS.Key, false, 4)
addTab("Configs", ICONS.Settings, false, 5)
addTab("Info", ICONS.Info, false, 6)
addTab("Settings", ICONS.Settings, false, 7)

-- COMBAT
do
    local c = pages["Combat"]
    local kaCard = createCard(c.Col1, T("KillauraTitle"), 1)
    addToggle(kaCard, "KillauraEnable", false, function(s)
        if s then KillAura.start() else KillAura.stop() end
    end)
    addSlider(kaCard, "KARange", 5, 200, 80, function(v) KillAura.TargetDistance = v end)
    addSlider(kaCard, "KADelay", 0.05, 1, 0.1, function(v) KillAura.AttackCooldown = v end)
    addToggle(kaCard, "IgnoreNaked", false, function(s) KillAura.IgnoreNaked = s end)

    local tiCard = createCard(c.Col2, T("TargetInfoTitle"), 1)
    addToggle(tiCard, "TargetInfoEnable", false, function(s) TargetInfoEnabled = s end)
    addToggle(tiCard, "InfJumpEnable", false, function(s)
        if s then InfJump.start() else InfJump.stop() end
    end)
    addToggle(tiCard, "WalkSpeedEnable", false, function(s)
        WalkSpeedEnabled = s
        if s then applyWalkSpeed() end
    end)
    addSlider(tiCard, "WalkSpeedValue", 16, 200, 16, function(v)
        WalkSpeedValue = v
        if WalkSpeedEnabled then applyWalkSpeed() end
    end)
end

-- VISUALS
do
    local v = pages["Visuals"]
    local espCard = createCard(v.Col1, T("ESPTitle"), 1)
    addToggle(espCard, "ESPEnable", false, function(s)
        ESPC.Enabled = s
        if not s then removeAllESP() end
    end)
    addToggle(espCard, "ESPNameplate", true, function(s) ESPC.Nameplate = s end)
    addToggle(espCard, "ESPBoxes", false, function(s) ESPC.Boxes = s end)
    addToggle(espCard, "ESPTeam", true, function(s) ESPC.TeamCheck = s end)
    local hudCard = createCard(v.Col1, T("HUDTitle"), 2)
    addToggle(hudCard, "HUDShow", true, function(s) Hud.Visible = s end)
    local shCard = createCard(v.Col2, T("ShadersTitle"), 1)
    addToggle(shCard, "ShBloom", false, function(s) SetShader("Bloom", s) end)
    addToggle(shCard, "ShCC", false, function(s) SetShader("CC", s) end)
    addToggle(shCard, "ShSunRays", false, function(s) SetShader("SunRays", s) end)
    addToggle(shCard, "ShDoF", false, function(s) SetShader("DoF", s) end)
    addToggle(shCard, "ShBlur", false, function(s) SetShader("Blur", s) end)
    addToggle(shCard, "ShSharpen", false, function(s) SetShader("Sharpen", s) end)
    local skyCard = createCard(v.Col2, T("SkyTitle"), 2)
    addButton(skyCard, "SkyGalaxy", function() SetSky("Galaxy") end)
    addButton(skyCard, "SkyNight", function() SetSky("Night") end)
    addButton(skyCard, "SkyBlue", function() SetSky("Blue") end)
    addButton(skyCard, "SkyRed", function() SetSky("Red") end)
    addButton(skyCard, "SkyDefault", function() SetSky("Default") end)
    local opCard = createCard(v.Col2, T("OptimizeTitle"), 3)
    addToggle(opCard, "FPSUnlock", false, function(s)
        if s then UnlockFPS() else RestoreFPS() end
    end)
    addToggle(opCard, "FPSCleanup", false, function(s)
        if s then OptimizeWorld() else RestoreWorld() end
    end)
    addToggle(opCard, "RemoveShadows", false, function(s) Lighting.GlobalShadows = not s end)
    local rgbCard = createCard(v.Col2, T("RGBTitle"), 4)
    addToggle(rgbCard, "RGBModel", false, function(s)
        if s then RGBModel.start() else RGBModel.stop() end
    end)
end

-- DUPE
do
    local d = pages["Dupe"]
    local card = createCard(d.Col1, T("DupeTitle"), 1)
    addButton(card, "DupeSelected", DupeSelected)
    addButton(card, "DupeChest1", function() chestDupe(1) end)
    addButton(card, "DupeChestAll", function() chestDupe(2) end)
    addButton(card, "DupeInf", DupeInfinite)
    addButton(card, "DumpDupe", DumpDupe)
    addButton(card, "DropAll", DropAllItems)
    addToggle(card, "AutoDupe", false, function(s) AutoDupe = s end)
end

-- BINDS
do
    local b = pages["Binds"]
    local card = createCard(b.Col1, T("BindsTitle"), 1)
    addButton(card, "BindsShow", function()
        BOV.Visible = not BOV.Visible
        if BOV.Visible then refreshBO() end
    end)
end

-- CONFIGS
do
    local cfg = pages["Configs"]
    local saveCard = createCard(cfg.Col1, T("ConfigTitle"), 1)
    local nameBox = addTextInput(saveCard, "CfgName", "default", function(v) CfgM.currentName = v end)
    addButton(saveCard, "CfgSave", function() CfgM:save(nameBox.Text) end)
    addButton(saveCard, "CfgLoad", function() CfgM:load(nameBox.Text) end)
    addButton(saveCard, "CfgDelete", function() CfgM:delete(nameBox.Text) end)
    local listCard = createCard(cfg.Col1, "📋 Список конфигов", 2)
    local listLbl = Instance.new("TextLabel", listCard)
    listLbl.Size = UDim2.new(1, 0, 0, 0)
    listLbl.AutomaticSize = Enum.AutomaticSize.Y
    listLbl.BackgroundTransparency = 1
    listLbl.Font = Enum.Font.Code
    listLbl.TextSize = 11
    listLbl.TextColor3 = THEME.TextPrimary
    listLbl.TextXAlignment = Enum.TextXAlignment.Left
    listLbl.TextYAlignment = Enum.TextYAlignment.Top
    listLbl.TextWrapped = true
    listLbl.Text = "— нажми обновить —"
    addButton(listCard, "CfgList", function()
        local l = ListCfgs()
        if #l > 0 then listLbl.Text = "• " .. table.concat(l, "\n• ")
        else listLbl.Text = "(пусто)" end
    end)
    local infoCard = createCard(cfg.Col2, T("CfgWhatSaves"), 1)
    local infoLbl = Instance.new("TextLabel", infoCard)
    infoLbl.Size = UDim2.new(1, 0, 0, 0)
    infoLbl.AutomaticSize = Enum.AutomaticSize.Y
    infoLbl.BackgroundTransparency = 1
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 11
    infoLbl.TextColor3 = THEME.TextMuted
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.TextYAlignment = Enum.TextYAlignment.Top
    infoLbl.TextWrapped = true
    infoLbl.Text = [[
В конфиге сохраняется:
• Все тумблеры (вкл/выкл)
• Значения слайдеров
• Бинды на клавиши
• Тема (палитра)
• Кастомный цвет
• Язык интерфейса

Конфиги хранятся в:
nursultan/*.json
    ]]
end

-- INFO
do
    local inf = pages["Info"]
    local card = createCard(inf.Col1, "📖 Заголовок", 1)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, 0, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = THEME.TextPrimary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Text = [[
Привет я создатель скрипта(vovotool) скрипт сделал спощью сурсов + ии + моих знаний сам скрипт со открытом кодом можешь использовать как тебе угодно очень качесвеный скрипт
подходит дял всех играх по типо майркафта в роблоксе 

• рекомендую тг где много скритов https://t.me/vomagla
• я гей
• нурсультан бустит ээээээх нурик бустит
    ]]

    -- Если надо еще карточку — копируй блок ниже и меняй
    local card2 = createCard(inf.Col1, "я не знаю", 2)

    local lbl2 = Instance.new("TextLabel", card2)
    lbl2.Size = UDim2.new(1, 0, 0, 0)
    lbl2.AutomaticSize = Enum.AutomaticSize.Y
    lbl2.BackgroundTransparency = 1
    lbl2.Font = Enum.Font.Gotham
    lbl2.TextSize = 12
    lbl2.TextColor3 = THEME.TextPrimary
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.TextYAlignment = Enum.TextYAlignment.Top
    lbl2.TextWrapped = true
    lbl2.Text = [[
я не знаю
    ]]
end

-- SETTINGS
do
    local s = pages["Settings"]
    local card = createCard(s.Col1, "🔧 Настройки", 1)
    addButton(card, "LangBtn", function()
        LANG = (LANG == "RU") and "EN" or "RU"
        ShowNotification("Language", LANG)
    end)
    addButton(card, "UnloadBtn", function() task.delay(0.2, Unload) end)
    local themeCard = createCard(s.Col2, T("ThemeTitle"), 1)
    local presetLbl = Instance.new("TextLabel", themeCard)
    presetLbl.Size = UDim2.new(1,0,0,16)
    presetLbl.BackgroundTransparency = 1
    presetLbl.Font = Enum.Font.GothamBold
    presetLbl.TextSize = 11
    presetLbl.TextColor3 = THEME.TextMuted
    presetLbl.TextXAlignment = Enum.TextXAlignment.Left
    presetLbl.Text = T("ThemePresets")
    for name, _ in pairs(PALETTES) do
        local r = Instance.new("Frame", themeCard)
        r.Size = UDim2.new(1,0,0,26)
        r.BackgroundTransparency = 1
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(1,0,1,0)
        b.BackgroundColor3 = THEME.SidebarActive
        b.Text = ""
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", b).Color = THEME.Border
        local cb2 = Instance.new("Frame", b)
        cb2.Size = UDim2.new(0,14,0,14)
        cb2.Position = UDim2.new(0,10,0.5,-7)
        cb2.BackgroundColor3 = PALETTES[name][1]
        cb2.BorderSizePixel = 0
        Instance.new("UICorner", cb2).CornerRadius = UDim.new(1,0)
        local lbl = Instance.new("TextLabel", b)
        lbl.Size = UDim2.new(1,-40,1,0)
        lbl.Position = UDim2.new(0,32,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextColor3 = THEME.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = name
        b.MouseEnter:Connect(function()
            TweenService:Create(b, ANIM.Fast, {BackgroundColor3=THEME.BtnHover}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, ANIM.Fast, {BackgroundColor3=THEME.SidebarActive}):Play()
        end)
        b.MouseButton1Click:Connect(function() ApplyPreset(name) end)
    end
    addColorPicker(themeCard, "ThemeCustom", THEME.Accent, function(color)
        ApplyCustomColor(color)
    end)
end

-- INPUT
local uiVisible = true
Conn(UserInputService.InputBegan:Connect(function(i, gp)
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local k = i.KeyCode.Name
    if BindM.listening then BindM:handleKey(k); return end
    if BindM.binds[k] then BindM:trigger(k); return end
    -- R хоткей для Killaura (работает всегда)
    if i.KeyCode == Enum.KeyCode.R then
        if toggles["KillauraEnable"] then
            local newState = not toggles["KillauraEnable"].Get()
            toggles["KillauraEnable"].Set(newState)
        end
        return
    end
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        if uiVisible then
            Main.Visible = true
            Main.BackgroundTransparency = 1
            Main.Position = UDim2.new(0.5,-440,0.5,-250)
            TweenService:Create(Main, ANIM.Bounce, {
                Position = UDim2.new(0.5,-440,0.5,-280),
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(Glow, ANIM.Smooth, {ImageTransparency = 0.83}):Play()
        else
            local tw = TweenService:Create(Main, ANIM.Smooth, {
                Position = UDim2.new(0.5,-440,0.5,-250),
                BackgroundTransparency = 1
            })
            TweenService:Create(Glow, ANIM.Smooth, {ImageTransparency = 1}):Play()
            tw:Play()
            tw.Completed:Connect(function()
                if not uiVisible then Main.Visible = false end
            end)
        end
    elseif i.KeyCode == Enum.KeyCode.End then
        task.delay(0.3, Unload)
    end
end))

task.spawn(function()
    task.wait(4.5)
    ShowNotification("nursultan", LANG == "RU" and "ФАН-ПРОЕКТ. Мы не связаны с реальным Nursultan." or "FAN PROJECT. Not related to real Nursultan.", 5)
end)