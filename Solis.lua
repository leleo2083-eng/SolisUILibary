--[[
    Solis UI v2.2 — single-file Roblox UI library
    
    FEATURES:
      • Built-in icon library with 40+ curated icons
      • Hotbar auto-scales width to match tab count
      • Hotbar colors match menu theme
      • Hotbar hidden during loading, revealed with main window
      • Minimize hides both main window AND hotbar
      • Dropdown: MaxVisible, Searchable, SetOptions, Refresh
      • Integrated Global Tag System — fixed-size screen-space tags
        that match the UI style with traveling glow animation
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local Players          = game:GetService("Players")
local Stats            = game:GetService("Stats")
local RunService       = game:GetService("RunService")
local AssetService     = game:GetService("AssetService")
local TextService      = game:GetService("TextService")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")

local DEFAULT_LOGO = "rbxassetid://105894109382235"
local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local NOTIFICATION_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local PROFILE_TWEEN = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ════════════════════════════════════════════════════════════════════════════
-- BUILT-IN ICON LIBRARY
-- ════════════════════════════════════════════════════════════════════════════
local ICONS = {
    home            = "rbxassetid://10723407389",
    dashboard       = "rbxassetid://10709790644",
    search          = "rbxassetid://10709751939",
    settings        = "rbxassetid://10734950309",
    gear            = "rbxassetid://10734950309",
    menu            = "rbxassetid://10734896206",
    list            = "rbxassetid://10709790373",
    grid            = "rbxassetid://10734950309",
    sliders         = "rbxassetid://10734897102",
    swords          = "rbxassetid://10747384394",
    sword           = "rbxassetid://10747384394",
    combat          = "rbxassetid://10747384394",
    shield          = "rbxassetid://10723434956",
    target          = "rbxassetid://10723434538",
    crosshair       = "rbxassetid://10723434538",
    aim             = "rbxassetid://10723434538",
    bolt            = "rbxassetid://79160363518966",
    lightning       = "rbxassetid://79160363518966",
    zap             = "rbxassetid://10723415903",
    fire            = "rbxassetid://10723415285",
    flame           = "rbxassetid://10723415285",
    star            = "rbxassetid://10734924532",
    sparkle         = "rbxassetid://10723422246",
    player          = "rbxassetid://10747387118",
    user            = "rbxassetid://10747387118",
    person          = "rbxassetid://10747387118",
    users           = "rbxassetid://10747387298",
    team            = "rbxassetid://10747387298",
    group           = "rbxassetid://10747387298",
    eye             = "rbxassetid://10709790644",
    visible         = "rbxassetid://10709790644",
    visuals         = "rbxassetid://10709790644",
    render          = "rbxassetid://10709790644",
    esp             = "rbxassetid://10709790644",
    eyeoff          = "rbxassetid://10709790497",
    hidden          = "rbxassetid://10709790497",
    globe           = "rbxassetid://10709778567",
    world           = "rbxassetid://10709778567",
    compass         = "rbxassetid://10709790373",
    map             = "rbxassetid://10709790373",
    move            = "rbxassetid://10723422998",
    arrows          = "rbxassetid://10723422998",
    heart           = "rbxassetid://10723415389",
    like            = "rbxassetid://10723415389",
    bell            = "rbxassetid://10723345067",
    notification    = "rbxassetid://10723345067",
    alert           = "rbxassetid://10723345067",
    info            = "rbxassetid://10723415389",
    about           = "rbxassetid://10723415389",
    help            = "rbxassetid://10723415389",
    warning         = "rbxassetid://10747387522",
    caution         = "rbxassetid://10747387522",
    check           = "rbxassetid://10709790948",
    checkmark       = "rbxassetid://10709790948",
    lock            = "rbxassetid://10723417148",
    unlock          = "rbxassetid://10723422607",
    power           = "rbxassetid://10723422754",
    toggle          = "rbxassetid://10723422754",
    refresh         = "rbxassetid://10723417783",
    folder          = "rbxassetid://10709791437",
    file            = "rbxassetid://10709791258",
    save            = "rbxassetid://10709791258",
    download        = "rbxassetid://10709790497",
    clipboard       = "rbxassetid://10709751190",
    chat            = "rbxassetid://10723345037",
    message         = "rbxassetid://10723345037",
    play            = "rbxassetid://10723422607",
    music           = "rbxassetid://10723421745",
    volume          = "rbxassetid://10723421745",
    camera          = "rbxassetid://10709778567",
    image           = "rbxassetid://10709791437",
    clock           = "rbxassetid://10723345037",
    time            = "rbxassetid://10723345037",
    timer           = "rbxassetid://10723345037",
    wrench          = "rbxassetid://10734950309",
    tool            = "rbxassetid://10734950309",
    code            = "rbxassetid://10709751190",
    terminal        = "rbxassetid://10709751190",
    script          = "rbxassetid://10709751190",
    bug             = "rbxassetid://10723415903",
    debug           = "rbxassetid://10723415903",
    layers          = "rbxassetid://10723417148",
    inventory       = "rbxassetid://10723415285",
    backpack        = "rbxassetid://10723415285",
    box             = "rbxassetid://10723415285",
    package         = "rbxassetid://10723415285",
    gift            = "rbxassetid://10723415389",
    crown           = "rbxassetid://10734924532",
    gem             = "rbxassetid://10723421745",
    coin            = "rbxassetid://13522871708",
    magic           = "rbxassetid://10734924532",
    wand            = "rbxassetid://10734924532",
    potion          = "rbxassetid://10723415285",
    skull           = "rbxassetid://10747384394",
    death           = "rbxassetid://10747384394",
    gamepad         = "rbxassetid://10723422998",
    controller      = "rbxassetid://10723422998",
    teleport        = "rbxassetid://10723415903",
    speed           = "rbxassetid://10723415903",
    running         = "rbxassetid://10723422998",
    favorite        = "rbxassetid://10734924532",
}

local NOTIFICATION_STYLES = {
    info    = { Name = "Info",    Color = Color3.fromRGB(118, 151, 194) },
    success = { Name = "Success", Color = Color3.fromRGB(105, 166, 124) },
    warning = { Name = "Warning", Color = Color3.fromRGB(190, 154, 84)  },
    error   = { Name = "Error",   Color = Color3.fromRGB(190, 99, 99)   },
}

local C = {
    WindowBg     = Color3.fromRGB(20, 20, 20),
    CardBg       = Color3.fromRGB(24, 24, 24),
    Border       = Color3.fromRGB(35, 35, 35),
    Element      = Color3.fromRGB(31, 31, 31),
    ElementHover = Color3.fromRGB(38, 38, 38),
    Badge        = Color3.fromRGB(42, 42, 42),
    BadgeIdle    = Color3.fromRGB(34, 34, 34),
    NavActive    = Color3.fromRGB(30, 30, 30),
    NavHover     = Color3.fromRGB(26, 26, 26),
    PillActive   = Color3.fromRGB(36, 36, 36),
    White        = Color3.fromRGB(255, 255, 255),
    TextGray     = Color3.fromRGB(154, 154, 154),
    TextDim      = Color3.fromRGB(139, 139, 139),
    KnobOff      = Color3.fromRGB(85, 85, 85),
    KnobOn       = Color3.fromRGB(17, 17, 17),
    TrackBg      = Color3.fromRGB(43, 43, 43),
    Placeholder  = Color3.fromRGB(86, 86, 86),
    HotbarBg     = Color3.fromRGB(24, 24, 24),
    HotbarBorder = Color3.fromRGB(35, 35, 35),
    HotbarActive = Color3.fromRGB(31, 31, 31),
    HotbarHover  = Color3.fromRGB(38, 38, 38),
    HotbarDot    = Color3.fromRGB(220, 220, 220),
}

local THEMES = {
    Dark = table.clone(C),
    Light = {
        WindowBg     = Color3.fromRGB(245, 245, 245),
        CardBg       = Color3.fromRGB(249, 249, 249),
        Border       = Color3.fromRGB(218, 218, 218),
        Element      = Color3.fromRGB(235, 235, 235),
        ElementHover = Color3.fromRGB(229, 229, 229),
        Badge        = Color3.fromRGB(224, 224, 224),
        BadgeIdle    = Color3.fromRGB(232, 232, 232),
        NavActive    = Color3.fromRGB(238, 238, 238),
        NavHover     = Color3.fromRGB(242, 242, 242),
        PillActive   = Color3.fromRGB(226, 226, 226),
        White        = Color3.fromRGB(20, 20, 20),
        TextGray     = Color3.fromRGB(84, 84, 84),
        TextDim      = Color3.fromRGB(105, 105, 105),
        KnobOff      = Color3.fromRGB(150, 150, 150),
        KnobOn       = Color3.fromRGB(250, 250, 250),
        TrackBg      = Color3.fromRGB(210, 210, 210),
        Placeholder  = Color3.fromRGB(135, 135, 135),
        HotbarBg     = Color3.fromRGB(249, 249, 249),
        HotbarBorder = Color3.fromRGB(218, 218, 218),
        HotbarActive = Color3.fromRGB(235, 235, 235),
        HotbarHover  = Color3.fromRGB(229, 229, 229),
        HotbarDot    = Color3.fromRGB(60, 60, 60),
    },
    OLED = {
        WindowBg     = Color3.fromRGB(0, 0, 0),
        CardBg       = Color3.fromRGB(5, 5, 5),
        Border       = Color3.fromRGB(25, 25, 25),
        Element      = Color3.fromRGB(12, 12, 12),
        ElementHover = Color3.fromRGB(20, 20, 20),
        Badge        = Color3.fromRGB(28, 28, 28),
        BadgeIdle    = Color3.fromRGB(16, 16, 16),
        NavActive    = Color3.fromRGB(9, 9, 9),
        NavHover     = Color3.fromRGB(6, 6, 6),
        PillActive   = Color3.fromRGB(22, 22, 22),
        White        = Color3.fromRGB(255, 255, 255),
        TextGray     = Color3.fromRGB(165, 165, 165),
        TextDim      = Color3.fromRGB(125, 125, 125),
        KnobOff      = Color3.fromRGB(75, 75, 75),
        KnobOn       = Color3.fromRGB(3, 3, 3),
        TrackBg      = Color3.fromRGB(32, 32, 32),
        Placeholder  = Color3.fromRGB(90, 90, 90),
        HotbarBg     = Color3.fromRGB(5, 5, 5),
        HotbarBorder = Color3.fromRGB(25, 25, 25),
        HotbarActive = Color3.fromRGB(12, 12, 12),
        HotbarHover  = Color3.fromRGB(20, 20, 20),
        HotbarDot    = Color3.fromRGB(200, 200, 200),
    },
}

local REVERSE = {}
local function rebuildReverse()
    table.clear(REVERSE)
    for key, color in pairs(C) do
        REVERSE[color:ToHex()] = key
    end
end
rebuildReverse()

local function tween(inst, props)
    TweenService:Create(inst, TWEEN, props):Play()
end
local function paint(inst, prop, key, instant)
    inst:SetAttribute("Theme_" .. prop, key)
    if instant then inst[prop] = C[key] else tween(inst, { [prop] = C[key] }) end
end
local function make(className, props)
    local inst = Instance.new(className)
    if inst:IsA("GuiObject") then
        inst.BorderSizePixel = 0
        inst.BackgroundColor3 = C.WindowBg
    end
    if inst:IsA("GuiButton") then inst.AutoButtonColor = false end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        inst.Font = Enum.Font.Gotham
        inst.TextColor3 = C.White
        inst.TextSize = 13
    end
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if inst:IsA("GuiObject") then
        local key = REVERSE[inst.BackgroundColor3:ToHex()]
        if key then inst:SetAttribute("Theme_BackgroundColor3", key) end
    end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        local key = REVERSE[inst.TextColor3:ToHex()]
        if key then inst:SetAttribute("Theme_TextColor3", key) end
    end
    if inst:IsA("TextBox") then
        local key = REVERSE[inst.PlaceholderColor3:ToHex()]
        if key then inst:SetAttribute("Theme_PlaceholderColor3", key) end
    end
    if inst:IsA("ScrollingFrame") then
        local key = REVERSE[inst.ScrollBarImageColor3:ToHex()]
        if key then inst:SetAttribute("Theme_ScrollBarImageColor3", key) end
    end
    if inst:IsA("UIStroke") then
        local key = REVERSE[inst.Color:ToHex()]
        if key then inst:SetAttribute("Theme_Color", key) end
    end
    inst.Parent = props.Parent
    return inst
end

local function corner(parent, radius) return make("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent }) end
local function circle(parent) return make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent }) end
local function stroke(parent, color)
    return make("UIStroke", {
        Color = color or C.Border, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    })
end
local function pad(parent, top, bottom, left, right)
    return make("UIPadding", {
        PaddingTop = UDim.new(0, top), PaddingBottom = UDim.new(0, bottom),
        PaddingLeft = UDim.new(0, left), PaddingRight = UDim.new(0, right),
        Parent = parent,
    })
end
local function autoOrder(inst) inst.LayoutOrder = #inst.Parent:GetChildren() end
local function isInside(gui, pos)
    local p, s = gui.AbsolutePosition, gui.AbsoluteSize
    return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end
local function fire(callback, ...)
    if typeof(callback) == "function" then task.spawn(callback, ...) end
end
local function normalizeAssetId(value)
    if value == nil or value == "" then return DEFAULT_LOGO end
    if type(value) == "number" then return "rbxassetid://" .. tostring(math.floor(value)) end
    local text = tostring(value)
    if string.match(text, "^rbxassetid://")
        or string.match(text, "^rbxthumb://")
        or string.match(text, "^https?://") then
        return text
    end
    local id = string.match(text, "%d+")
    return id and ("rbxassetid://" .. id) or DEFAULT_LOGO
end

local function resolveIcon(value)
    if value == nil or value == "" then return nil, nil end
    local str = tostring(value)
    local key = string.lower(str)
    if ICONS[key] then return "image", ICONS[key] end
    if string.match(str, "^rbxassetid://") or string.match(str, "^rbxthumb://") or string.match(str, "^https?://") then
        return "image", str
    end
    if tonumber(str) then return "image", "rbxassetid://" .. str end
    local numId = string.match(str, "%d+")
    if numId and #numId > 5 then return "image", "rbxassetid://" .. numId end
    return "text", string.upper(string.sub(str, 1, 1))
end

local function getNotificationStyle(kind)
    local key = string.lower(tostring(kind or "Info"))
    return NOTIFICATION_STYLES[key] or NOTIFICATION_STYLES.info
end
local function guiVisible(gui)
    local node = gui
    while node and node:IsA("GuiObject") do
        if not node.Visible then return false end
        node = node.Parent
    end
    return true
end

local function makeDraggable(frame, blockers)
    local dragging = false
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = Vector2.new(input.Position.X, input.Position.Y)
        for _, gui in ipairs(blockers) do
            if guiVisible(gui) and isInside(gui, pos) then return end
        end
        dragging = true
        dragStart = input.Position
        startPos  = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function sortIcon(parent)
    local holder = make("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(9, 7), Parent = parent,
    })
    for i, width in ipairs({ 9, 7, 5 }) do
        make("Frame", {
            Position = UDim2.fromOffset(0, (i - 1) * 3),
            Size = UDim2.fromOffset(width, 1),
            BackgroundColor3 = C.TextDim, Parent = holder,
        })
    end
    return holder
end

local function inputIcon(parent)
    local holder = make("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(10, 10), Parent = parent,
    })
    local box = make("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = holder })
    corner(box, 2); stroke(box, C.TextDim)
    make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1, 4), BackgroundColor3 = C.TextDim, Parent = holder,
    })
    return holder
end

local function createIconElement(parent, iconType, iconValue, size, zindex)
    size = size or 10
    zindex = zindex or 6
    if iconType == "image" then
        return make("ImageLabel", {
            Image = iconValue,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size, size),
            ScaleType = Enum.ScaleType.Fit,
            ImageColor3 = C.TextGray,
            ZIndex = zindex,
            Parent = parent,
        })
    else
        return make("TextLabel", {
            Text = iconValue or "?",
            Font = Enum.Font.GothamBold,
            TextSize = math.floor(size * 0.7),
            TextColor3 = C.TextGray,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = zindex,
            Parent = parent,
        })
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- TAG SYSTEM (screen-space, fixed pixel size, matches UI style)
-- ════════════════════════════════════════════════════════════════════════════
local TAG_BASE_URL     = "https://adorable-sallyanne-fgdfgdfgd-b2d051be.koyeb.app"
local TAG_REGISTER     = TAG_BASE_URL .. "/register"
local TAG_USERS        = TAG_BASE_URL .. "/users"
local TAG_W            = 200   -- fixed pixel width of tag
local TAG_H            = 52    -- fixed pixel height of tag
local TAG_WORLD_HEIGHT = 3.4   -- world-space studs above HumanoidRootPart where the tag floats
local TAG_MAX_DISTANCE = 800   -- max render distance in studs before fade

-- Detect HTTP request function
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or (http_request)
    or (request)

local TagSystem = {}
TagSystem._tags        = {}   -- [Player] = { frame, glowGradient, conn, canvasGroup, targetX, targetY }
TagSystem._screenGui   = nil
TagSystem._active      = {}   -- [UserId] = true
TagSystem._running     = false
TagSystem._connections = {}

-- Build the tag ScreenGui (once)
local function ensureTagGui()
    if TagSystem._screenGui and TagSystem._screenGui.Parent then return end
    local localPlayer = Players.LocalPlayer
    local targetParent
    pcall(function() targetParent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not targetParent then targetParent = localPlayer:WaitForChild("PlayerGui") end

    local sg = Instance.new("ScreenGui")
    sg.Name               = "SolisTagGui"
    sg.ResetOnSpawn       = false
    sg.IgnoreGuiInset     = true
    sg.ZIndexBehavior     = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder       = 8
    pcall(function() sg.Parent = targetParent end)
    if not sg.Parent then
        targetParent = localPlayer:WaitForChild("PlayerGui")
        sg.Parent = targetParent
    end
    TagSystem._screenGui = sg
end

-- Create one tag frame for a player (does NOT position it; RenderStepped does that)
local function buildTagFrame(player)
    ensureTagGui()
    local sg = TagSystem._screenGui

    -- Root container: fixed pixel size, positioned by RenderStepped loop
    local root = Instance.new("Frame")
    root.Name              = "SolisTag_" .. player.UserId
    root.Size              = UDim2.fromOffset(TAG_W, TAG_H)
    root.AnchorPoint       = Vector2.new(0.5, 0.5)
    root.BackgroundColor3  = Color3.fromRGB(22, 22, 26)
    root.BackgroundTransparency = 0.06
    root.BorderSizePixel   = 0
    root.Visible           = false
    root.ZIndex            = 10
    root.Parent            = sg

    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0, 10)
    cr.Parent = root

    -- Soft drop shadow under the tag for depth
    local shadow = Instance.new("ImageLabel")
    shadow.Name                = "Shadow"
    shadow.Image               = "rbxassetid://1316045217"
    shadow.ImageColor3         = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency   = 0.55
    shadow.ScaleType           = Enum.ScaleType.Slice
    shadow.SliceCenter         = Rect.new(10, 10, 118, 118)
    shadow.BackgroundTransparency = 1
    shadow.AnchorPoint         = Vector2.new(0.5, 0.5)
    shadow.Position           = UDim2.fromScale(0.5, 0.5)
    shadow.Size               = UDim2.new(1, 14, 1, 14)
    shadow.ZIndex             = 0
    shadow.Parent             = root

    -- Transparent overlay used for opacity fade (covers entire tag)
    local fadeOverlay = Instance.new("Frame")
    fadeOverlay.Name               = "FadeOverlay"
    fadeOverlay.Size               = UDim2.fromScale(1, 1)
    fadeOverlay.BackgroundColor3   = Color3.fromRGB(20, 20, 24)
    fadeOverlay.BackgroundTransparency = 1  -- 1 = invisible (tag shown)
    fadeOverlay.BorderSizePixel    = 0
    fadeOverlay.ZIndex             = 99
    fadeOverlay.Parent             = root
    local fadeCr = Instance.new("UICorner")
    fadeCr.CornerRadius = UDim.new(0, 10)
    fadeCr.Parent = fadeOverlay

    -- Traveling glow stroke
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Thickness          = 1.1
    glowStroke.ApplyStrokeMode    = Enum.ApplyStrokeMode.Border
    glowStroke.Color              = Color3.fromRGB(253, 128, 0)
    glowStroke.Transparency       = 0.2
    glowStroke.Parent             = root

    local glowGrad = Instance.new("UIGradient")
    glowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(253, 128, 0)),
        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(253, 128, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(253, 128, 0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(253, 128, 0)),
    })
    glowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1.0),
        NumberSequenceKeypoint.new(0.34, 1.0),
        NumberSequenceKeypoint.new(0.50, 0.0),
        NumberSequenceKeypoint.new(0.66, 1.0),
        NumberSequenceKeypoint.new(1.00, 1.0),
    })
    glowGrad.Parent = glowStroke

    -- ── Left: Avatar circle ────────────────────────────────────────────────
    local avatarHolder = Instance.new("Frame")
    avatarHolder.Size              = UDim2.fromOffset(34, 34)
    avatarHolder.Position          = UDim2.fromOffset(9, 9)
    avatarHolder.BackgroundColor3  = Color3.fromRGB(40, 40, 45)
    avatarHolder.BorderSizePixel   = 0
    avatarHolder.ZIndex            = 2
    avatarHolder.Parent            = root
    local avCr = Instance.new("UICorner")
    avCr.CornerRadius = UDim.new(1, 0)
    avCr.Parent = avatarHolder
    -- avatar ring (orange accent)
    local avRing = Instance.new("UIStroke")
    avRing.Thickness = 1
    avRing.Color = Color3.fromRGB(253, 128, 0)
    avRing.Transparency = 0.4
    avRing.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    avRing.Parent = avatarHolder

    local avatar = Instance.new("ImageLabel")
    avatar.Name                = "TagAvatar"
    avatar.Image                = ""
    avatar.BackgroundTransparency = 1
    avatar.Size                 = UDim2.fromOffset(28, 28)
    avatar.Position             = UDim2.fromOffset(3, 3)
    avatar.ScaleType            = Enum.ScaleType.Crop
    avatar.ImageColor3          = Color3.fromRGB(255, 255, 255)
    avatar.ZIndex               = 3
    avatar.Parent               = avatarHolder
    local avClip = Instance.new("UICorner")
    avClip.CornerRadius = UDim.new(1, 0)
    avClip.Parent = avatar

    -- Online status dot (bottom-right of avatar)
    local onlineRing = Instance.new("Frame")
    onlineRing.AnchorPoint            = Vector2.new(1, 1)
    onlineRing.Position               = UDim2.new(1, -1, 1, -1)
    onlineRing.Size                   = UDim2.fromOffset(11, 11)
    onlineRing.BackgroundColor3       = Color3.fromRGB(22, 22, 26)
    onlineRing.BorderSizePixel        = 0
    onlineRing.ZIndex                 = 4
    onlineRing.Parent                 = avatarHolder
    local orCr = Instance.new("UICorner")
    orCr.CornerRadius = UDim.new(1, 0)
    orCr.Parent = onlineRing

    local onlineDot = Instance.new("Frame")
    onlineDot.AnchorPoint            = Vector2.new(0.5, 0.5)
    onlineDot.Position               = UDim2.fromScale(0.5, 0.5)
    onlineDot.Size                   = UDim2.fromOffset(6, 6)
    onlineDot.BackgroundColor3       = Color3.fromRGB(70, 200, 120)
    onlineDot.BorderSizePixel        = 0
    onlineDot.ZIndex                 = 5
    onlineDot.Parent                 = onlineRing
    local odCr = Instance.new("UICorner")
    odCr.CornerRadius = UDim.new(1, 0)
    odCr.Parent = onlineDot

    -- ── Vertical divider between avatar and text ────────────────────────────
    local divider = Instance.new("Frame")
    divider.Size             = UDim2.fromOffset(1, 30)
    divider.Position         = UDim2.fromOffset(51, 11)
    divider.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    divider.BorderSizePixel  = 0
    divider.ZIndex           = 2
    divider.Parent           = root

    -- ── Right side: text content ────────────────────────────────────────────
    local textX = 60

    -- Player display name (bold, prominent)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text           = player.DisplayName
    nameLabel.Font           = Enum.Font.GothamBold
    nameLabel.TextSize       = 13
    nameLabel.TextColor3     = Color3.fromRGB(245, 245, 248)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size           = UDim2.fromOffset(TAG_W - textX - 12, 16)
    nameLabel.Position       = UDim2.fromOffset(textX, 9)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate   = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex         = 2
    nameLabel.Parent         = root

    -- @username below (dimmer)
    local userLabel = Instance.new("TextLabel")
    userLabel.Text           = "@" .. player.Name
    userLabel.Font           = Enum.Font.Gotham
    userLabel.TextSize       = 11
    userLabel.TextColor3     = Color3.fromRGB(140, 140, 148)
    userLabel.BackgroundTransparency = 1
    userLabel.Size           = UDim2.fromOffset(TAG_W - textX - 12, 13)
    userLabel.Position       = UDim2.fromOffset(textX, 26)
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.TextTruncate   = Enum.TextTruncate.AtEnd
    userLabel.ZIndex         = 2
    userLabel.Parent         = root

    -- "SOLIS" badge (bottom right, small pill)
    local badge = Instance.new("Frame")
    badge.Size             = UDim2.fromOffset(46, 16)
    badge.AnchorPoint      = Vector2.new(1, 1)
    badge.Position         = UDim2.new(1, -9, 1, -9)
    badge.BackgroundColor3 = Color3.fromRGB(253, 128, 0)
    badge.BackgroundTransparency = 0.82
    badge.BorderSizePixel  = 0
    badge.ZIndex           = 2
    badge.Parent           = root
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = badge
    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Thickness = 0.6
    badgeStroke.Color = Color3.fromRGB(253, 128, 0)
    badgeStroke.Transparency = 0.4
    badgeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    badgeStroke.Parent = badge

    local badgeLabel = Instance.new("TextLabel")
    badgeLabel.Text              = "SOLIS"
    badgeLabel.Font              = Enum.Font.GothamBold
    badgeLabel.TextSize          = 8
    badgeLabel.TextColor3        = Color3.fromRGB(255, 200, 140)
    badgeLabel.BackgroundTransparency = 1
    badgeLabel.Size              = UDim2.fromScale(1, 1)
    badgeLabel.TextXAlignment    = Enum.TextXAlignment.Center
    badgeLabel.TextYAlignment    = Enum.TextYAlignment.Center
    badgeLabel.ZIndex            = 3
    badgeLabel.Parent            = badge

    -- Fetch avatar thumbnail async
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and avatar and avatar.Parent then
            avatar.Image = img
        end
    end)

    return root, glowGrad, fadeOverlay
end

local function removeTag(player)
    local data = TagSystem._tags[player]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.frame and data.frame.Parent then data.frame:Destroy() end
        TagSystem._tags[player] = nil
    end
end

local function addTag(player)
    if player == Players.LocalPlayer then return end
    if TagSystem._tags[player] then return end

    local frame, glowGrad, fadeOverlay = buildTagFrame(player)
    local glowT = 0
    local currentFade = 0  -- 0 = overlay invisible (tag fully visible), 1 = overlay opaque (tag hidden)

    -- RenderStepped: update position + glow each frame
    -- Tag tracks the HumanoidRootPart (stable, no walk-bob) at a fixed world-space
    -- height above the character, so it stays steady at the same spot over the head.
    local conn = RunService.RenderStepped:Connect(function(dt)
        if not frame or not frame.Parent then return end

        local char = player.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if not hrp or not hrp:IsA("BasePart") then
            frame.Visible = false
            return
        end

        local camera = Workspace.CurrentCamera
        if not camera then frame.Visible = false; return end

        local cameraPos = camera.CFrame.Position

        -- Stable anchor point: fixed world height above the HumanoidRootPart.
        -- This does NOT bob with the walk animation, so the tag stays steady.
        local anchorWorld = hrp.Position + Vector3.new(0, TAG_WORLD_HEIGHT, 0)
        local distance = (anchorWorld - cameraPos).Magnitude

        local screenPos, onScreen = camera:WorldToScreenPoint(anchorWorld)

        if not onScreen or screenPos.Z <= 0 then
            frame.Visible = false
            return
        end

        -- Distance-based fade: full opacity up to 150 studs, fade out by TAG_MAX_DISTANCE
        local targetFade = 0  -- 0 = visible
        if distance > 150 then
            targetFade = math.clamp((distance - 150) / (TAG_MAX_DISTANCE - 150), 0, 1)
        end
        -- Smooth fade transitions only (NOT position)
        currentFade = currentFade + (targetFade - currentFade) * math.clamp(dt * 6, 0, 1)
        if currentFade > 0.98 then
            frame.Visible = false
            return
        end

        frame.Visible = true
        -- Force fixed pixel size every frame — never let it scale
        frame.Size = UDim2.fromOffset(TAG_W, TAG_H)
        if fadeOverlay and fadeOverlay.Parent then
            fadeOverlay.BackgroundTransparency = 1 - currentFade
        end

        -- LOCK tag directly to anchor each frame (anchor is center 0.5,0.5)
        -- Floor to integer pixels to kill sub-pixel jitter
        local px = math.floor(screenPos.X + 0.5)
        local py = math.floor(screenPos.Y + 0.5)
        frame.Position = UDim2.fromOffset(px, py)

        -- Animate the traveling glow (same speed as main window: 0.35 cycles/sec)
        glowT = (glowT + dt * 0.35) % 1
        glowGrad.Offset = Vector2.new(glowT * 2 - 1, 0)
    end)

    TagSystem._tags[player] = {
        frame = frame,
        glowGrad = glowGrad,
        fadeOverlay = fadeOverlay,
        conn = conn,
    }
end

local function tagRegister()
    if not httpRequest then return end
    pcall(function()
        httpRequest({
            Url    = TAG_REGISTER,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body   = '{"userId":' .. Players.LocalPlayer.UserId .. '}',
        })
    end)
end

local function tagFetchAndUpdate()
    if not httpRequest then return end
    local ok, res = pcall(function()
        return httpRequest({ Url = TAG_USERS, Method = "GET" })
    end)
    if not ok or not res or not res.Body then return end

    local sok, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    if not sok or type(data) ~= "table" then return end

    -- Build active set
    local active = {}
    for _, id in ipairs(data) do active[id] = true end
    TagSystem._active = active

    -- Add/remove tags
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if active[player.UserId] then
                addTag(player)
            else
                removeTag(player)
            end
        end
    end
end

local function startTagSystem()
    if TagSystem._running then return end
    TagSystem._running = true
    ensureTagGui()

    -- Remove tags when players leave
    local leaveConn = Players.PlayerRemoving:Connect(function(player)
        removeTag(player)
    end)
    table.insert(TagSystem._connections, leaveConn)

    -- Poll loop
    task.spawn(function()
        while TagSystem._running do
            tagRegister()
            tagFetchAndUpdate()
            task.wait(5)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- LIBRARY
-- ════════════════════════════════════════════════════════════════════════════
local Library = {
    Version       = "2.2",
    Themes        = THEMES,
    Icons         = ICONS,
    DefaultLogo   = DEFAULT_LOGO,
    _windows      = {},
    _windowObjects= {},
    _currentTheme = "Dark",
    TagSystem     = TagSystem,
}
local Window = {}; Window.__index = Window
local Tab    = {};    Tab.__index = Tab
local SubTab = {}; SubTab.__index = SubTab

local THEME_PROPS = { "BackgroundColor3", "TextColor3", "PlaceholderColor3", "ScrollBarImageColor3", "Color" }

function Library:SetTheme(theme)
    local themeName = nil
    if type(theme) == "string" then
        themeName = theme
        theme = THEMES[theme]
        if not theme then warn(("[Solis UI] unknown theme %q"):format(themeName)); return false end
    elseif type(theme) ~= "table" then
        warn("[Solis UI] SetTheme expects a built-in theme name or theme table"); return false
    end
    for key in pairs(C) do
        local value = theme[key]
        if value ~= nil and typeof(value) ~= "Color3" then
            warn(("[Solis UI] theme key %s must be a Color3"):format(key)); return false
        end
    end
    for key in pairs(C) do
        local value = theme[key]
        if value ~= nil then C[key] = value end
    end
    Library._currentTheme = themeName or "Custom"
    rebuildReverse()
    for _, gui in ipairs(Library._windows) do
        if gui and gui.Parent then
            for _, inst in ipairs(gui:GetDescendants()) do
                local goal
                for _, prop in ipairs(THEME_PROPS) do
                    local key = inst:GetAttribute("Theme_" .. prop)
                    if key and C[key] then goal = goal or {}; goal[prop] = C[key] end
                end
                if goal then tween(inst, goal) end
            end
        end
    end
    return true
end

function Library:GetTheme() return Library._currentTheme end
function Library:GetIcons() return ICONS end
function Library:GetIcon(name) return ICONS[string.lower(tostring(name or ""))] end

function Library:Notify(opts)
    for index = #Library._windowObjects, 1, -1 do
        local window = Library._windowObjects[index]
        if window and window.ScreenGui and window.ScreenGui.Parent then
            return window:Notify(opts)
        end
    end
    warn("[Solis UI] create a window before calling Library:Notify")
    return nil
end
function Library:Notification(opts) return self:Notify(opts) end

function Library:DestroyAll()
    local windows = table.clone(Library._windows)
    for _, screenGui in ipairs(windows) do if screenGui then screenGui:Destroy() end end
    table.clear(Library._windows)
    table.clear(Library._windowObjects or {})
end

function Library:CreateWindow(opts)
    opts = opts or {}

    -- Auto-start the tag system
    startTagSystem()

    local logoAsset      = normalizeAssetId(opts.Logo or DEFAULT_LOGO)
    local windowSize     = opts.Size or UDim2.fromOffset(700, 490)
    local windowPosition = opts.Position or UDim2.fromScale(0.5, 0.5)
    local guiName        = opts.GuiName or "SolisUI"

    local HOTBAR_HEIGHT  = 36
    local HOTBAR_GAP     = 8

    local targetParent
    if typeof(opts.Parent) == "Instance" then
        targetParent = opts.Parent
    else
        pcall(function() targetParent = (gethui and gethui()) or game:GetService("CoreGui") end)
        if not targetParent then targetParent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    end

    local function removeExistingGui(parent)
        if opts.ReplaceExisting == false or not parent then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == guiName then child:Destroy() end
        end
    end

    removeExistingGui(targetParent)

    local screenGui = make("ScreenGui", {
        Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = opts.DisplayOrder or 10,
    })
    local parented = pcall(function() screenGui.Parent = targetParent end)
    if not parented then
        targetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
        removeExistingGui(targetParent)
        screenGui.Parent = targetParent
    end
    table.insert(Library._windows, screenGui)

    local containerW = windowSize.X.Offset
    local containerH = windowSize.Y.Offset + HOTBAR_GAP + HOTBAR_HEIGHT

    local container = make("Frame", {
        Name = "SolisContainer",
        Size = UDim2.fromOffset(containerW, containerH),
        Position = windowPosition,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = screenGui,
    })

    -- ── LOADING SCREEN ────────────────────────────────────────────────────
    local loadingEnabled          = opts.LoadingAnimation ~= false
    local loadingDuration         = math.clamp(tonumber(opts.LoadingDuration) or 2.65, 1.5, 8)
    local loadingIconSize         = math.clamp(math.floor(tonumber(opts.LoadingIconSize) or 112), 64, 190)
    local loadingText             = tostring(opts.LoadingText or "Solis")
    local loadingTextSize         = math.clamp(math.floor(tonumber(opts.LoadingTextSize) or 58), 40, 76)
    local loadingTextStartColor   = typeof(opts.LoadingTextStartColor)    == "Color3" and opts.LoadingTextStartColor   or Color3.fromRGB(255,255,255)
    local loadingTextHighlight    = typeof(opts.LoadingTextHighlightColor) == "Color3" and opts.LoadingTextHighlightColor or Color3.fromRGB(255,231,26)
    local loadingTextGold         = typeof(opts.LoadingTextGoldColor)     == "Color3" and opts.LoadingTextGoldColor    or Color3.fromRGB(255,183,1)
    local loadingTextEnd          = typeof(opts.LoadingTextEndColor)      == "Color3" and opts.LoadingTextEndColor     or Color3.fromRGB(253,128,0)
    local loadingTextDeep         = typeof(opts.LoadingTextDeepColor)     == "Color3" and opts.LoadingTextDeepColor    or Color3.fromRGB(228,87,0)
    local overlayTransparency     = math.clamp(tonumber(opts.LoadingOverlayTransparency) or 0.5, 0, 0.9)
    local colorTransitionDuration = math.clamp(tonumber(opts.LoadingColorTransitionDuration) or 0.95, 0.4, 2.5)

    local function sampleLoadingColor(alpha)
        alpha = math.clamp(alpha, 0, 1)
        if alpha <= 0.32 then return loadingTextHighlight:Lerp(loadingTextGold, alpha/0.32)
        elseif alpha <= 0.68 then return loadingTextGold:Lerp(loadingTextEnd, (alpha-0.32)/0.36)
        end
        return loadingTextEnd:Lerp(loadingTextDeep, (alpha-0.68)/0.32)
    end

    local loadingComplete       = not loadingEnabled
    local loadingMotionComplete = not loadingEnabled
    local loadingLayer, loadingContent, loadingLogo, loadingLogoScale
    local loadingTitleHolder, loadingTitleScale, loadingCaret
    local loadingProgressTrack, loadingProgressFill
    local loadingLetterLabels = {}
    local loadingLetterScales = {}
    local loadingLetterColors = {}
    local letterWidths        = {}

    if loadingEnabled then
        loadingLayer = make("CanvasGroup", {
            Name = "StartupLoader", Size = UDim2.fromScale(1,1),
            BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1,
            GroupTransparency = 0, ZIndex = 500, Parent = screenGui,
        })
        loadingContent = make("CanvasGroup", {
            Name = "LoadingContent", Size = UDim2.fromOffset(560,300),
            Position = UDim2.new(0.5,0,0.5,18), AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1, GroupTransparency = 1, ZIndex = 501, Parent = loadingLayer,
        })
        loadingLogo = make("ImageLabel", {
            Name = "LoadingLogo", Image = logoAsset,
            Size = UDim2.fromOffset(loadingIconSize,loadingIconSize),
            Position = UDim2.new(0.5,0,0,84), AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1, BorderSizePixel = 0, ImageTransparency = 0,
            ScaleType = Enum.ScaleType.Fit, ZIndex = 502, Parent = loadingContent,
        })
        loadingLogoScale = make("UIScale", { Scale = 0.58, Parent = loadingLogo })

        local characterCount = math.max(#loadingText, 1)
        local letterSpacing  = math.max(1, math.floor(loadingTextSize * 0.025))
        local titleWidth = 0
        for index = 1, #loadingText do
            local ch = string.sub(loadingText, index, index)
            local measured = TextService:GetTextSize(ch, loadingTextSize, Enum.Font.GothamBold, Vector2.new(200,90))
            local w = math.max(math.ceil(measured.X), math.floor(loadingTextSize*0.24))
            letterWidths[index] = w
            titleWidth = titleWidth + w
            if index < #loadingText then titleWidth = titleWidth + letterSpacing end
        end
        titleWidth = math.max(titleWidth, 80)

        loadingTitleHolder = make("Frame", {
            Name = "LoadingTitle", Size = UDim2.fromOffset(titleWidth+12, 82),
            Position = UDim2.new(0.5,0,0,151), AnchorPoint = Vector2.new(0.5,0),
            BackgroundTransparency = 1, ZIndex = 502, Parent = loadingContent,
        })
        loadingTitleScale = make("UIScale", { Scale = 0.94, Parent = loadingTitleHolder })

        local xOff = 6
        for index = 1, #loadingText do
            local ch    = string.sub(loadingText, index, index)
            local w     = letterWidths[index]
            local alpha = #loadingText > 1 and ((index-1)/(#loadingText-1)) or 0.5
            local letter = make("TextLabel", {
                Name = "Letter"..index, Text = ch,
                Font = Enum.Font.GothamBold, TextSize = loadingTextSize,
                TextColor3 = loadingTextStartColor, TextTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                BackgroundTransparency = 1, Position = UDim2.fromOffset(xOff,10),
                Size = UDim2.fromOffset(w,72), ZIndex = 503, Parent = loadingTitleHolder,
            })
            local ls = make("UIScale", { Scale = 0.78, Parent = letter })
            loadingLetterLabels[index] = letter
            loadingLetterScales[index] = ls
            loadingLetterColors[index] = sampleLoadingColor(alpha)
            xOff = xOff + w + letterSpacing
        end

        loadingCaret = make("Frame", {
            Name = "TypingCaret", Size = UDim2.fromOffset(2, math.floor(loadingTextSize*0.7)),
            Position = UDim2.fromOffset(6,20), BackgroundColor3 = loadingTextGold,
            BackgroundTransparency = 1, ZIndex = 504, Parent = loadingTitleHolder,
        })
        corner(loadingCaret, 1)

        local progressWidth = math.clamp(math.floor(titleWidth*0.76), 150, 270)
        loadingProgressTrack = make("Frame", {
            Name = "LoadingProgress", Size = UDim2.fromOffset(progressWidth,3),
            Position = UDim2.new(0.5,0,0,246), AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.9,
            ClipsDescendants = true, ZIndex = 502, Parent = loadingContent,
        })
        corner(loadingProgressTrack, 2)
        loadingProgressFill = make("Frame", {
            Name = "Fill", Size = UDim2.new(0,0,1,0),
            BackgroundColor3 = loadingTextEnd, ZIndex = 503, Parent = loadingProgressTrack,
        })
        corner(loadingProgressFill, 2)
        make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, loadingTextHighlight),
                ColorSequenceKeypoint.new(0.34, loadingTextGold),
                ColorSequenceKeypoint.new(0.72, loadingTextEnd),
                ColorSequenceKeypoint.new(1.00, loadingTextDeep),
            }),
            Rotation = 0, Parent = loadingProgressFill,
        })

        task.spawn(function()
            local characterCount2 = math.max(#loadingText, 1)
            local letterSpacing2  = math.max(1, math.floor(loadingTextSize*0.025))
            TweenService:Create(loadingLayer,    TweenInfo.new(0.34,Enum.EasingStyle.Quad,  Enum.EasingDirection.Out), {BackgroundTransparency=overlayTransparency}):Play()
            TweenService:Create(loadingContent,  TweenInfo.new(0.42,Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=UDim2.fromScale(0.5,0.5),GroupTransparency=0}):Play()
            TweenService:Create(loadingLogoScale,TweenInfo.new(0.62,Enum.EasingStyle.Back,  Enum.EasingDirection.Out), {Scale=1}):Play()
            TweenService:Create(loadingLogo,     TweenInfo.new(0.58,Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=UDim2.new(0.5,0,0,76)}):Play()
            TweenService:Create(loadingTitleScale,TweenInfo.new(0.52,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Scale=1}):Play()
            task.wait(0.36)
            if not loadingLayer or not loadingLayer.Parent then return end
            TweenService:Create(loadingCaret, TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundTransparency=0.08}):Play()
            local typingTime  = math.max(loadingDuration - colorTransitionDuration - 1.28, 0.45)
            local letterDelay = math.clamp(typingTime/characterCount2, 0.075, 0.19)
            local caretX = 6
            for index, letter in ipairs(loadingLetterLabels) do
                if not loadingLayer or not loadingLayer.Parent then return end
                local ls = loadingLetterScales[index]
                local w  = letterWidths[index]
                TweenService:Create(letter, TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {Position=UDim2.fromOffset(caretX,0),TextTransparency=0}):Play()
                TweenService:Create(ls,     TweenInfo.new(0.34,Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
                caretX = caretX + w + letterSpacing2
                TweenService:Create(loadingCaret,        TweenInfo.new(0.12,Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {Position=UDim2.fromOffset(caretX,20)}):Play()
                TweenService:Create(loadingProgressFill, TweenInfo.new(0.2, Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new((index/characterCount2)*0.58,0,1,0)}):Play()
                task.wait(letterDelay)
            end
            TweenService:Create(loadingCaret, TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundTransparency=1}):Play()
            task.wait(0.08)
            local stagger = math.clamp((colorTransitionDuration/math.max(characterCount2+1,2))*0.72, 0.055, 0.15)
            for index, letter in ipairs(loadingLetterLabels) do
                if not loadingLayer or not loadingLayer.Parent then return end
                local ls = loadingLetterScales[index]
                TweenService:Create(letter,TweenInfo.new(0.46,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{TextColor3=loadingLetterColors[index]}):Play()
                TweenService:Create(ls,    TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {Scale=1.065}):Play()
                task.delay(0.14, function()
                    if ls and ls.Parent then
                        TweenService:Create(ls,TweenInfo.new(0.24,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Scale=1}):Play()
                    end
                end)
                TweenService:Create(loadingProgressFill,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(0.58+((index/characterCount2)*0.42),0,1,0)}):Play()
                task.wait(stagger)
            end
            TweenService:Create(loadingProgressFill,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.fromScale(1,1)}):Play()
            task.wait(0.38)
            TweenService:Create(loadingLogoScale,  TweenInfo.new(0.22,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),  {Scale=1.035}):Play()
            TweenService:Create(loadingTitleScale, TweenInfo.new(0.22,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),  {Scale=1.018}):Play()
            task.wait(0.22)
            TweenService:Create(loadingLogoScale,  TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {Scale=1}):Play()
            TweenService:Create(loadingTitleScale, TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {Scale=1}):Play()
            task.wait(0.28)
            loadingMotionComplete = true
        end)
    end

    -- ── MAIN WINDOW ───────────────────────────────────────────────────────
    local main = make("Frame", {
        Name = "Main", Size = windowSize,
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = C.WindowBg, ClipsDescendants = true,
        Visible = not loadingEnabled, ZIndex = 2, Parent = container,
    })
    corner(main, 12); stroke(main, C.Border)

    -- Animated traveling outline
    local mainGlowStroke = make("UIStroke", {
        Color = Color3.fromRGB(253, 128, 0),
        Thickness = 1.6,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Transparency = 0,
        Parent = main,
    })
    local mainGlowGradient = make("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(253, 128, 0)),
            ColorSequenceKeypoint.new(0.42, Color3.fromRGB(253, 128, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.58, Color3.fromRGB(253, 128, 0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(253, 128, 0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 1.0),
            NumberSequenceKeypoint.new(0.36, 1.0),
            NumberSequenceKeypoint.new(0.50, 0.0),
            NumberSequenceKeypoint.new(0.64, 1.0),
            NumberSequenceKeypoint.new(1.00, 1.0),
        }),
        Parent = mainGlowStroke,
    })
    local mainRevealScale = make("UIScale", { Scale = loadingEnabled and 0.965 or 1, Parent = main })
    local glowT = 0
    local glowConn
    glowConn = RunService.RenderStepped:Connect(function(dt)
        if not main or not main.Parent then
            if glowConn then glowConn:Disconnect(); glowConn = nil end
            return
        end
        glowT = (glowT + dt * 0.35) % 1
        mainGlowGradient.Offset = Vector2.new(glowT * 2 - 1, 0)
    end)

    -- ── HOTBAR ────────────────────────────────────────────────────────────
    local hotbar = make("Frame", {
        Name = "TabHotbar",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, windowSize.Y.Offset + HOTBAR_GAP),
        Size = UDim2.fromOffset(0, HOTBAR_HEIGHT),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = C.HotbarBg,
        ClipsDescendants = false,
        Visible = not loadingEnabled,
        ZIndex = 3, Parent = container,
    })
    corner(hotbar, 11)
    make("UIStroke", { Color = C.HotbarBorder, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = hotbar })
    pad(hotbar, 5, 5, 10, 10)

    local hotbarInner = make("Frame", {
        Name = "HotbarInner",
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1, ZIndex = 4, Parent = hotbar,
    })
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4), Parent = hotbarInner,
    })

    local minimized = false
    local mainTopButtons = {}
    local burgerButton
    local windowRef
    local noDrag = {}
    table.insert(noDrag, hotbar)

    local function setMinimized(o)
        minimized = o == true
        for _, b in ipairs(mainTopButtons) do if b and b.Parent then b.Visible = not minimized end end
        if burgerButton and burgerButton.Parent then burgerButton.Visible = minimized end
        main.Visible = not minimized
        hotbar.Visible = not minimized
        if windowRef then windowRef._minimized = minimized end
    end

    local controls = make("Frame", {
        Name = "CornerControls", AnchorPoint = Vector2.new(1,0),
        Position = UDim2.new(1,-6,0,8), Size = UDim2.fromOffset(36,16),
        BackgroundTransparency = 1, ZIndex = 10, Parent = main,
    })
    local closeBtn = make("TextButton", {
        Text = "", Font = Enum.Font.GothamBold, TextSize = 1, TextColor3 = C.White,
        AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,0),
        Size = UDim2.fromOffset(14,14), BackgroundColor3 = Color3.fromRGB(190,60,60),
        ZIndex = 12, Parent = controls,
    })
    closeBtn.AutoButtonColor = false; circle(closeBtn); closeBtn.BorderSizePixel = 0
    local minimizeBtn = make("TextButton", {
        Text = "", Font = Enum.Font.GothamBold, TextSize = 1, TextColor3 = C.White,
        AnchorPoint = Vector2.new(1,0), Position = UDim2.new(0,12,0,0),
        Size = UDim2.fromOffset(14,14), BackgroundColor3 = Color3.fromRGB(255,195,0),
        ZIndex = 12, Parent = controls,
    })
    minimizeBtn.AutoButtonColor = false; circle(minimizeBtn); minimizeBtn.BorderSizePixel = 0
    table.insert(mainTopButtons, closeBtn); table.insert(mainTopButtons, minimizeBtn)
    table.insert(noDrag, closeBtn); table.insert(noDrag, minimizeBtn)

    burgerButton = make("TextButton", {
        Text = "", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.White,
        AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,12),
        Size = UDim2.fromOffset(34,18), BackgroundColor3 = C.CardBg,
        Visible = false, ZIndex = 11, Parent = screenGui,
    })
    corner(burgerButton, 10); stroke(burgerButton, C.Border)
    local bih = make("Frame", { BackgroundTransparency=1, Position=UDim2.fromOffset(6,0), Size=UDim2.fromOffset(18,18), Parent=burgerButton, ZIndex=12 })
    make("Frame",{BackgroundColor3=C.White,Size=UDim2.fromOffset(12,2),Position=UDim2.fromOffset(3,4), Parent=bih,ZIndex=13})
    make("Frame",{BackgroundColor3=C.White,Size=UDim2.fromOffset(12,2),Position=UDim2.fromOffset(3,8), Parent=bih,ZIndex=13})
    make("Frame",{BackgroundColor3=C.White,Size=UDim2.fromOffset(12,2),Position=UDim2.fromOffset(3,12),Parent=bih,ZIndex=13})
    make("ImageLabel",{Name="BurgerLogo",Image=logoAsset,BackgroundTransparency=1,Position=UDim2.fromOffset(26,5),Size=UDim2.fromOffset(8,8),ZIndex=14,ScaleType=Enum.ScaleType.Fit,Parent=burgerButton})

    burgerButton.MouseButton1Click:Connect(function() setMinimized(false) end)
    closeBtn.MouseButton1Click:Connect(function()
        if windowRef and windowRef.Destroy then windowRef:Destroy()
        else if screenGui then screenGui:Destroy() end end
    end)
    minimizeBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
    makeDraggable(container, noDrag)

    -- ── SIDEBAR ───────────────────────────────────────────────────────────
    local sidebar = make("Frame", { Size=UDim2.new(0,190,1,0), BackgroundTransparency=1, Parent=main })
    local brand = make("Frame", { Name="Brand", Position=UDim2.fromOffset(12,12), Size=UDim2.new(1,-24,0,54), BackgroundColor3=C.CardBg, Parent=sidebar })
    corner(brand,10); stroke(brand,C.Border)
    local logoHolder = make("Frame", { Position=UDim2.fromOffset(9,9), Size=UDim2.fromOffset(36,36), BackgroundColor3=C.Element, Parent=brand })
    corner(logoHolder,9)
    make("TextLabel",{Text="S",Font=Enum.Font.GothamBold,TextSize=15,TextColor3=C.White,BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Parent=logoHolder})
    local brandLogo = make("ImageLabel",{Name="Logo",Image=logoAsset,BackgroundTransparency=1,Position=UDim2.fromOffset(3,3),Size=UDim2.new(1,-6,1,-6),ScaleType=Enum.ScaleType.Fit,Parent=logoHolder})
    make("TextLabel",{Text=opts.Name or "Solis UI",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(54,9),Size=UDim2.new(1,-62,0,17),Parent=brand})
    make("TextLabel",{Text=opts.BrandSubtitle or ("SOLIS FREE..."..Library.Version),Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(54,28),Size=UDim2.new(1,-62,0,13),Parent=brand})
    local statusDot = make("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,16,1,-19),Size=UDim2.fromOffset(6,6),BackgroundColor3=NOTIFICATION_STYLES.success.Color,Parent=sidebar})
    circle(statusDot)
    make("TextLabel",{Text=opts.StatusText or "Solis is ready",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.new(0,28,1,-27),Size=UDim2.new(1,-40,0,16),Parent=sidebar})
    make("Frame",{Position=UDim2.fromOffset(190,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=C.Border,Parent=main})
    local content = make("Frame",{Position=UDim2.fromOffset(191,0),Size=UDim2.new(1,-191,1,0),BackgroundTransparency=1,Parent=main})

    -- ── NOTIFICATIONS ─────────────────────────────────────────────────────
    local notificationHolder = make("Frame",{
        Name="Notifications",AnchorPoint=Vector2.new(1,0),
        Position=UDim2.new(1,-16,0,16),Size=UDim2.new(0,300,1,-32),
        BackgroundTransparency=1,ZIndex=200,Parent=screenGui,
    })
    make("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Right,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=notificationHolder})

    -- ── PROFILE + PERFORMANCE ─────────────────────────────────────────────
    local localPlayer      = Players.LocalPlayer
    local profileKey       = typeof(opts.ProfileKey)=="EnumItem" and opts.ProfileKey or Enum.KeyCode.K
    local profileWidth     = math.max(280, tonumber(opts.ProfileWidth) or 312)
    local bottomMargin     = math.max(10,  tonumber(opts.ProfileBottomMargin) or 18)
    local profileOpenPos   = UDim2.new(1,-18,1,-bottomMargin)
    local profileClosedPos = UDim2.new(1,profileWidth+28,1,-bottomMargin)
    local profileOpen      = false

    local profilePanel = make("CanvasGroup",{Name="UserProfile",AnchorPoint=Vector2.new(1,1),Position=profileClosedPos,Size=UDim2.fromOffset(profileWidth,382),BackgroundColor3=C.CardBg,GroupTransparency=1,ClipsDescendants=true,ZIndex=150,Parent=screenGui})
    corner(profilePanel,14)
    local profileHeader=make("Frame",{Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,65),BackgroundTransparency=1,ZIndex=151,Parent=profilePanel})
    make("TextLabel",{Text=opts.ProfileTitle or "PLAYER PROFILE",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(18,13),Size=UDim2.new(1,-36,0,18),ZIndex=152,Parent=profileHeader})
    make("TextLabel",{Text="Live session overview",Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(18,34),Size=UDim2.new(1,-36,0,15),ZIndex=152,Parent=profileHeader})
    make("Frame",{Position=UDim2.new(0,18,1,-1),Size=UDim2.new(1,-36,0,1),BackgroundColor3=C.Border,ZIndex=151,Parent=profileHeader})
    local identityCard=make("Frame",{Position=UDim2.fromOffset(16,82),Size=UDim2.new(1,-32,0,116),BackgroundColor3=C.Element,ZIndex=151,Parent=profilePanel})
    corner(identityCard,11);stroke(identityCard,C.Border)
    local avatarHolder=make("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,14,0.5,0),Size=UDim2.fromOffset(76,76),BackgroundColor3=C.Badge,ZIndex=152,Parent=identityCard})
    circle(avatarHolder);stroke(avatarHolder,C.Border)
    local avatar=make("ImageLabel",{Name="Avatar",Image="",BackgroundTransparency=1,Position=UDim2.fromOffset(4,4),Size=UDim2.new(1,-8,1,-8),ScaleType=Enum.ScaleType.Crop,ZIndex=153,Parent=avatarHolder})
    circle(avatar)
    local onlineRing=make("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,0,1,0),Size=UDim2.fromOffset(18,18),BackgroundColor3=C.Element,ZIndex=154,Parent=avatarHolder})
    circle(onlineRing)
    local onlineDot=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(10,10),BackgroundColor3=NOTIFICATION_STYLES.success.Color,ZIndex=155,Parent=onlineRing})
    circle(onlineDot)
    make("TextLabel",{Text=localPlayer and localPlayer.DisplayName or "Player",Font=Enum.Font.GothamBold,TextSize=17,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(105,22),Size=UDim2.new(1,-119,0,23),ZIndex=152,Parent=identityCard})
    make("TextLabel",{Text=localPlayer and ("@"..localPlayer.Name) or "@unknown",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(105,47),Size=UDim2.new(1,-119,0,16),ZIndex=152,Parent=identityCard})
    local connectedBadge=make("Frame",{Position=UDim2.fromOffset(105,74),Size=UDim2.fromOffset(92,24),BackgroundColor3=C.BadgeIdle,ZIndex=152,Parent=identityCard})
    corner(connectedBadge,7)
    local connectedDot=make("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,9,0.5,0),Size=UDim2.fromOffset(6,6),BackgroundColor3=NOTIFICATION_STYLES.success.Color,ZIndex=153,Parent=connectedBadge})
    circle(connectedDot)
    make("TextLabel",{Text="CONNECTED",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=C.TextGray,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(22,0),Size=UDim2.new(1,-27,1,0),ZIndex=153,Parent=connectedBadge})
    make("TextLabel",{Text="ACCOUNT DETAILS",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(18,216),Size=UDim2.new(1,-36,0,16),ZIndex=152,Parent=profilePanel})
    local details=make("Frame",{Position=UDim2.fromOffset(16,240),Size=UDim2.new(1,-32,0,126),BackgroundColor3=C.Element,ZIndex=151,Parent=profilePanel})
    corner(details,11);stroke(details,C.Border)
    local function addProfileDetail(index,labelText,valueText)
        local y=(index-1)*42
        local row=make("Frame",{Position=UDim2.fromOffset(0,y),Size=UDim2.new(1,0,0,42),BackgroundTransparency=1,ZIndex=152,Parent=details})
        make("TextLabel",{Text=labelText,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(16,0),Size=UDim2.new(0.46,-16,1,0),ZIndex=153,Parent=row})
        local vl=make("TextLabel",{Text=valueText,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.new(0.46,0,0,0),Size=UDim2.new(0.54,-16,1,0),ZIndex=153,Parent=row})
        if index<3 then make("Frame",{Position=UDim2.new(0,16,1,-1),Size=UDim2.new(1,-32,0,1),BackgroundColor3=C.Border,ZIndex=153,Parent=row}) end
        return vl
    end
    addProfileDetail(1,"USER ID",   localPlayer and tostring(localPlayer.UserId) or "N/A")
    addProfileDetail(2,"ACCOUNT AGE",localPlayer and (tostring(localPlayer.AccountAge).." days") or "N/A")
    local pingLabel=addProfileDetail(3,"PING","-- ms")

    local performanceWidth     = math.max(236,tonumber(opts.PerformanceWidth) or 266)
    local performanceHeight    = math.max(260,tonumber(opts.PerformanceHeight) or 294)
    local panelGap             = math.max(8,  tonumber(opts.ProfilePanelGap) or 12)
    local performanceOpenPos   = UDim2.new(1,-(18+profileWidth+panelGap),1,-bottomMargin)
    local performanceClosedPos = UDim2.new(1,performanceWidth+36,1,-bottomMargin)

    local performancePanel=make("CanvasGroup",{Name="LivePerformance",AnchorPoint=Vector2.new(1,1),Position=performanceClosedPos,Size=UDim2.fromOffset(performanceWidth,performanceHeight),BackgroundColor3=C.CardBg,GroupTransparency=1,ClipsDescendants=true,ZIndex=149,Parent=screenGui})
    corner(performancePanel,14)
    local performanceHeader=make("Frame",{Size=UDim2.new(1,0,0,56),BackgroundTransparency=1,ZIndex=150,Parent=performancePanel})
    make("TextLabel",{Text=opts.PerformanceTitle or "LIVE PERFORMANCE",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(16,11),Size=UDim2.new(1,-94,0,17),ZIndex=151,Parent=performanceHeader})
    make("TextLabel",{Text="Real-time frame tracker",Font=Enum.Font.Gotham,TextSize=9,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(16,31),Size=UDim2.new(1,-94,0,13),ZIndex=151,Parent=performanceHeader})
    local liveBadge=make("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-14,0,14),Size=UDim2.fromOffset(58,20),BackgroundColor3=C.BadgeIdle,ZIndex=151,Parent=performanceHeader})
    corner(liveBadge,6)
    local liveDot=make("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0),Size=UDim2.fromOffset(5,5),BackgroundColor3=NOTIFICATION_STYLES.success.Color,ZIndex=152,Parent=liveBadge})
    circle(liveDot)
    make("TextLabel",{Text="LIVE",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=C.TextGray,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(19,0),Size=UDim2.new(1,-23,1,0),ZIndex=152,Parent=liveBadge})
    local fpsSummary=make("Frame",{Position=UDim2.fromOffset(14,58),Size=UDim2.new(1,-28,0,56),BackgroundColor3=C.Element,ZIndex=150,Parent=performancePanel})
    corner(fpsSummary,10);stroke(fpsSummary,C.Border)
    make("TextLabel",{Text="FPS",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(12,8),Size=UDim2.new(0.5,-12,0,11),ZIndex=151,Parent=fpsSummary})
    local currentFpsLabel=make("TextLabel",{Text="--",Font=Enum.Font.GothamBold,TextSize=23,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(12,21),Size=UDim2.new(0.5,-12,0,28),ZIndex=151,Parent=fpsSummary})
    make("TextLabel",{Text="FRAME TIME",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Right,BackgroundTransparency=1,Position=UDim2.new(0.5,0,0,8),Size=UDim2.new(0.5,-12,0,11),ZIndex=151,Parent=fpsSummary})
    local frameTimeLabel=make("TextLabel",{Text="-- ms",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Right,BackgroundTransparency=1,Position=UDim2.new(0.5,0,0,26),Size=UDim2.new(0.5,-12,0,18),ZIndex=151,Parent=fpsSummary})
    make("TextLabel",{Text="FRAME HISTORY",Font=Enum.Font.GothamBold,TextSize=9,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(16,126),Size=UDim2.new(1,-32,0,13),ZIndex=150,Parent=performancePanel})
    local graphCard=make("Frame",{Position=UDim2.fromOffset(14,145),Size=UDim2.new(1,-28,0,82),BackgroundColor3=C.Element,ClipsDescendants=true,ZIndex=150,Parent=performancePanel})
    corner(graphCard,10);stroke(graphCard,C.Border)
    local graphPlot=make("Frame",{Position=UDim2.fromOffset(10,9),Size=UDim2.new(1,-20,1,-18),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=151,Parent=graphCard})
    for i=1,2 do make("Frame",{Position=UDim2.new(0,0,i/3,0),Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Border,BackgroundTransparency=0.35,ZIndex=151,Parent=graphPlot}) end
    local maxFpsSamples=48; local fpsSamples={}
    local graphPixelSize=Vector2.new(math.max(2,math.floor(performanceWidth-48)),64)
    local graphImage=make("ImageLabel",{Name="ContinuousFpsLine",BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=UDim2.fromScale(1,1),ScaleType=Enum.ScaleType.Stretch,ResampleMode=Enum.ResamplerMode.Default,ZIndex=153,Parent=graphPlot})
    local fpsEditableImage=nil; local graphSegments={}; local editableImageReady=false; local supportsAA=true
    local function ensureFallback()
        if #graphSegments>0 then return end; graphImage.Visible=false
        for i=1,maxFpsSamples-1 do
            local seg=make("Frame",{Name="FL"..i,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromOffset(0,0),Size=UDim2.fromOffset(0,1),BackgroundColor3=C.White,BorderSizePixel=0,Visible=false,ZIndex=153,Parent=graphPlot})
            graphSegments[i]=seg
        end
    end
    do
        local ok,ed=pcall(function()
            local img=AssetService:CreateEditableImage({Size=graphPixelSize})
            graphImage.ImageContent=Content.fromObject(img); return img
        end)
        if ok and ed then fpsEditableImage=ed; editableImageReady=true else ensureFallback() end
    end
    local function clearEG()
        if not editableImageReady or not fpsEditableImage then return false end
        local ok=pcall(function() fpsEditableImage:DrawRectangle(Vector2.zero,graphPixelSize,Color3.new(0,0,0),1,Enum.ImageCombineType.Overwrite) end)
        if not ok then editableImageReady=false; ensureFallback() end; return ok
    end
    local function drawEGL(a,b)
        if not editableImageReady or not fpsEditableImage then return false end
        if supportsAA then
            local ok=pcall(function() fpsEditableImage:DrawLine(a,b,C.White,0,Enum.ImageCombineType.Overwrite,Enum.AntiAliasing.Enabled) end)
            if ok then return true end; supportsAA=false
        end
        local ok=pcall(function() fpsEditableImage:DrawLine(a,b,C.White,0,Enum.ImageCombineType.Overwrite) end)
        if not ok then editableImageReady=false; ensureFallback() end; return ok
    end
    local statsStrip=make("Frame",{Position=UDim2.fromOffset(14,237),Size=UDim2.new(1,-28,0,43),BackgroundColor3=C.Element,ZIndex=150,Parent=performancePanel})
    corner(statsStrip,10);stroke(statsStrip,C.Border)
    local statValueLabels={}
    for i,sn in ipairs({"AVG","LOW","HIGH"}) do
        local sc=make("Frame",{Position=UDim2.new((i-1)/3,0,0,0),Size=UDim2.new(1/3,0,1,0),BackgroundTransparency=1,ZIndex=151,Parent=statsStrip})
        make("TextLabel",{Text=sn,Font=Enum.Font.GothamBold,TextSize=8,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Center,BackgroundTransparency=1,Position=UDim2.fromOffset(0,5),Size=UDim2.new(1,0,0,10),ZIndex=152,Parent=sc})
        statValueLabels[i]=make("TextLabel",{Text="--",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Center,BackgroundTransparency=1,Position=UDim2.fromOffset(0,19),Size=UDim2.new(1,0,0,15),ZIndex=152,Parent=sc})
    end
    local function redrawFpsGraph()
        local sc=#fpsSamples; local ps=graphPlot.AbsoluteSize
        if sc<2 or ps.X<=1 or ps.Y<=1 then
            if editableImageReady then clearEG() end
            for _,s in ipairs(graphSegments) do s.Visible=false end; return
        end
        local gm=60; for _,v in ipairs(fpsSamples) do gm=math.max(gm,v) end
        gm=math.max(30,math.ceil(gm/30)*30); local den=math.max(sc-1,1)
        if editableImageReady and clearEG() then
            local W=graphPixelSize.X; local H=graphPixelSize.Y
            local uW=math.max(1,W-2); local uH=math.max(1,H-6)
            for i=1,sc-1 do
                local pA=Vector2.new(1+((i-1)/den)*uW, 3+(1-math.clamp(fpsSamples[i]/gm,0,1))*uH)
                local pB=Vector2.new(1+(i/den)*uW,     3+(1-math.clamp(fpsSamples[i+1]/gm,0,1))*uH)
                if not drawEGL(pA,pB) then break end
            end
            if editableImageReady then return end
        end
        local uH=math.max(1,ps.Y-8)
        for i,seg in ipairs(graphSegments) do
            if i<sc then
                local x1=((i-1)/den)*ps.X; local x2=(i/den)*ps.X
                local y1=4+(1-math.clamp(fpsSamples[i]/gm,0,1))*uH
                local y2=4+(1-math.clamp(fpsSamples[i+1]/gm,0,1))*uH
                local dx=x2-x1; local dy=y2-y1; local len=math.sqrt(dx*dx+dy*dy)
                seg.Position=UDim2.fromOffset(x1,y1); seg.Size=UDim2.fromOffset(len+2,1)
                seg.Rotation=math.deg(math.atan2(dy,dx)); seg.Visible=true
            else seg.Visible=false end
        end
    end
    local function pushFpsSample(fps)
        fps=math.max(0,fps); table.insert(fpsSamples,fps)
        if #fpsSamples>maxFpsSamples then table.remove(fpsSamples,1) end
        local tot=0; local lo=math.huge; local hi=0
        for _,v in ipairs(fpsSamples) do tot=tot+v; lo=math.min(lo,v); hi=math.max(hi,v) end
        local avg=#fpsSamples>0 and tot/#fpsSamples or 0
        local ft=fps>0 and (1000/fps) or 0
        currentFpsLabel.Text=tostring(math.floor(fps+0.5))
        frameTimeLabel.Text=string.format("%.1f ms",ft)
        statValueLabels[1].Text=tostring(math.floor(avg+0.5))
        statValueLabels[2].Text=tostring(math.floor(lo+0.5))
        statValueLabels[3].Text=tostring(math.floor(hi+0.5))
        redrawFpsGraph()
    end
    local function setProfileVisible(visible,instant)
        profileOpen=visible==true
        local tp=profileOpen and profileOpenPos or profileClosedPos
        local ep=profileOpen and performanceOpenPos or performanceClosedPos
        local tr=profileOpen and 0 or 1
        if instant then
            profilePanel.Position=tp; profilePanel.GroupTransparency=tr
            performancePanel.Position=ep; performancePanel.GroupTransparency=tr
        else
            TweenService:Create(profilePanel,PROFILE_TWEEN,{Position=tp,GroupTransparency=tr}):Play()
            TweenService:Create(performancePanel,PROFILE_TWEEN,{Position=ep,GroupTransparency=tr}):Play()
        end
        if windowRef then windowRef._profileOpen=profileOpen end; return profileOpen
    end
    if localPlayer then
        task.spawn(function()
            local ok,img=pcall(function() return Players:GetUserThumbnailAsync(localPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420) end)
            if ok and avatar and avatar.Parent then avatar.Image=img end
        end)
    end
    task.spawn(function()
        while screenGui and screenGui.Parent do
            local txt="N/A"
            local ok,val=pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok and type(val)=="number" then txt=tostring(math.floor(val+0.5)).." ms" end
            if pingLabel and pingLabel.Parent then pingLabel.Text=txt end; task.wait(1)
        end
    end)

    windowRef = setmetatable({
        ScreenGui=screenGui, Main=main, Container=container, Logo=brandLogo,
        _logoAsset=logoAsset, _hotbar=hotbar, _hotbarInner=hotbarInner, _content=content,
        _notificationHolder=notificationHolder, _notificationOrder=0,
        _profilePanel=profilePanel, _performancePanel=performancePanel,
        _fpsEditableImage=fpsEditableImage, _profileKey=profileKey,
        _profileOpen=profileOpen, _setProfileVisible=setProfileVisible,
        _connections={}, _noDrag=noDrag, _tabs={}, _activeTab=nil,
    }, Window)
    windowRef.Notify=function(s,m) return Window.Notify(windowRef,s==windowRef and m or s) end
    windowRef.Notification=windowRef.Notify

    local ffc=0; local fe=0
    local fpsConn=RunService.RenderStepped:Connect(function(dt)
        if not screenGui or not screenGui.Parent then return end
        ffc=ffc+1; fe=fe+dt
        if fe>=0.25 then pushFpsSample(ffc/fe); ffc=0; fe=0 end
    end)
    table.insert(windowRef._connections,fpsConn)
    local pkConn=UserInputService.InputBegan:Connect(function(input,gp)
        if not loadingComplete or gp or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode==profileKey and Library._windowObjects[#Library._windowObjects]==windowRef then
            windowRef:ToggleProfile()
        end
    end)
    table.insert(windowRef._connections,pkConn)
    table.insert(Library._windowObjects,windowRef)
    if opts.Visible==false then screenGui.Enabled=false end

    if loadingEnabled and loadingLayer then
        task.defer(function()
            while not loadingMotionComplete and screenGui.Parent do RunService.Heartbeat:Wait() end
            if not screenGui.Parent or not loadingLayer.Parent then return end
            main.Visible=true; hotbar.Visible=true
            TweenService:Create(mainRevealScale,TweenInfo.new(0.46,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Scale=1}):Play()
            local fo=TweenService:Create(loadingLayer,TweenInfo.new(0.48,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{GroupTransparency=1})
            local ce=loadingContent and TweenService:Create(loadingContent,TweenInfo.new(0.46,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Position=UDim2.new(0.5,0,0.5,-18),GroupTransparency=1})
            local le=loadingLogoScale and TweenService:Create(loadingLogoScale,TweenInfo.new(0.42,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.84})
            local te=loadingTitleScale and TweenService:Create(loadingTitleScale,TweenInfo.new(0.42,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.95})
            local pe
            if loadingProgressFill and loadingProgressFill.Parent then
                loadingProgressFill.AnchorPoint=Vector2.new(0.5,0.5); loadingProgressFill.Position=UDim2.fromScale(0.5,0.5)
                pe=TweenService:Create(loadingProgressFill,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Size=UDim2.new(0,0,1,0)})
            end
            fo:Play(); if ce then ce:Play() end; if le then le:Play() end; if te then te:Play() end; if pe then pe:Play() end
            fo.Completed:Wait()
            if loadingLayer and loadingLayer.Parent then loadingLayer:Destroy() end
            if not screenGui.Parent then return end; loadingComplete=true
        end)
    end

    return windowRef
end

-- ════════════════════════════════════════════════════════════════════════════
-- WINDOW METHODS
-- ════════════════════════════════════════════════════════════════════════════
function Window:SetVisible(v) self.ScreenGui.Enabled = v==true end
function Window:Toggle() self.ScreenGui.Enabled = not self.ScreenGui.Enabled; return self.ScreenGui.Enabled end
function Window:SetProfileVisible(v)
    if not self._setProfileVisible then return false end
    self._profileOpen=self._setProfileVisible(v==true); return self._profileOpen
end
function Window:ToggleProfile() return self:SetProfileVisible(not self._profileOpen) end
function Window:SetLogo(id)
    self._logoAsset=normalizeAssetId(id)
    if self.Logo then self.Logo.Image=self._logoAsset end; return self._logoAsset
end

function Window:Notify(opts)
    if type(opts)=="string" then opts={Content=opts} end; opts=opts or {}
    local holder=self._notificationHolder; if not holder or not holder.Parent then return nil end
    local style=getNotificationStyle(opts.Type)
    local dur=tonumber(opts.Duration); if dur==nil then dur=4 end; dur=math.max(dur,0)
    self._notificationOrder=self._notificationOrder+1
    local title=tostring(opts.Title or style.Name)
    local body =tostring(opts.Content or opts.Description or opts.Message or "Notification")
    local slot=make("Frame",{Name="NotificationSlot",Size=UDim2.new(1,0,0,62),BackgroundTransparency=1,LayoutOrder=self._notificationOrder,ZIndex=200,Parent=holder})
    local card=make("CanvasGroup",{Name=style.Name.."Notification",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,12,0,0),Size=UDim2.fromScale(1,1),BackgroundColor3=C.CardBg,GroupTransparency=1,ClipsDescendants=true,ZIndex=201,Parent=slot})
    corner(card,6);stroke(card,C.Border)
    make("TextLabel",{Text=title,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(12,9),Size=UDim2.new(1,-42,0,16),ZIndex=202,Parent=card})
    make("TextLabel",{Text=body,Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,BackgroundTransparency=1,Position=UDim2.fromOffset(12,29),Size=UDim2.new(1,-24,0,24),ZIndex=202,Parent=card})
    local xb=make("TextButton",{Text="×",Font=Enum.Font.Gotham,TextSize=14,TextColor3=C.TextDim,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-7,0,5),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,ZIndex=204,Parent=card})
    local closed=false; local handle={}
    local function close(reason)
        if closed then return end; closed=true
        TweenService:Create(card,NOTIFICATION_TWEEN,{Position=UDim2.new(1,12,0,0),GroupTransparency=1}):Play()
        task.delay(0.2,function() if slot and slot.Parent then slot:Destroy() end end)
        fire(opts.Callback or opts.OnClose,reason or "closed")
    end
    function handle:Close() close("manual") end
    function handle:IsOpen() return not closed end
    xb.MouseEnter:Connect(function() tween(xb,{TextColor3=C.White}) end)
    xb.MouseLeave:Connect(function() tween(xb,{TextColor3=C.TextDim}) end)
    xb.MouseButton1Click:Connect(function() close("manual") end)
    TweenService:Create(card,NOTIFICATION_TWEEN,{Position=UDim2.new(1,0,0,0),GroupTransparency=0}):Play()
    if dur>0 then task.delay(dur,function() close("timeout") end) end; return handle
end

function Window:Destroy()
    for _,c in ipairs(self._connections or {}) do c:Disconnect() end
    table.clear(self._connections or {})
    if self._fpsEditableImage then pcall(function() self._fpsEditableImage:Destroy() end); self._fpsEditableImage=nil end
    local i=table.find(Library._windows,self.ScreenGui); if i then table.remove(Library._windows,i) end
    local j=table.find(Library._windowObjects,self);     if j then table.remove(Library._windowObjects,j) end
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

-- ════════════════════════════════════════════════════════════════════════════
-- TAB SYSTEM
-- ════════════════════════════════════════════════════════════════════════════
function Window:_selectTab(tab)
    if self._activeTab==tab then return end
    local prev=self._activeTab; self._activeTab=tab
    if prev then
        prev._page.Visible=false
        tween(prev._hBtn,{BackgroundColor3=C.HotbarBg})
        tween(prev._hLabel,{TextColor3=C.TextGray})
        if prev._hDot then tween(prev._hDot,{BackgroundTransparency=1}) end
        if prev._hIconElement then
            if prev._hIconElement:IsA("ImageLabel") then tween(prev._hIconElement,{ImageColor3=C.TextGray})
            elseif prev._hIconElement:IsA("TextLabel") then tween(prev._hIconElement,{TextColor3=C.TextGray}) end
        end
    end
    tab._page.Visible=true
    tween(tab._hBtn,{BackgroundColor3=C.HotbarActive})
    tween(tab._hLabel,{TextColor3=C.White})
    if tab._hDot then tween(tab._hDot,{BackgroundTransparency=0}) end
    if tab._hIconElement then
        if tab._hIconElement:IsA("ImageLabel") then tween(tab._hIconElement,{ImageColor3=C.White})
        elseif tab._hIconElement:IsA("TextLabel") then tween(tab._hIconElement,{TextColor3=C.White}) end
    end
end

function Window:AddTab(opts)
    if type(opts)=="string" then opts={Name=opts} end
    opts=opts or {}
    local name=opts.Name or "Tab"
    local iconInput = opts.Icon
    local win=self

    local iconType, iconValue = resolveIcon(iconInput)
    if not iconType then
        local autoKey = string.lower(name)
        if ICONS[autoKey] then iconType="image"; iconValue=ICONS[autoKey]
        else iconType="text"; iconValue=string.upper(string.sub(name,1,1)) end
    end

    local hBtn=make("TextButton",{
        Text="", AutomaticSize=Enum.AutomaticSize.X,
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=C.HotbarBg,
        ZIndex=5, Parent=self._hotbarInner,
    })
    hBtn.LayoutOrder=#self._hotbarInner:GetChildren()
    corner(hBtn,7); pad(hBtn,0,0,12,12)
    table.insert(win._noDrag,hBtn)

    local hRow=make("Frame",{BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,1,0),ZIndex=5,Parent=hBtn})
    make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=hRow})

    local iconBadge=make("Frame",{Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,LayoutOrder=1,ZIndex=6,Parent=hRow})
    local hIconElement = createIconElement(iconBadge, iconType, iconValue, 18, 7)

    local hLabel=make("TextLabel",{
        Text=name,Font=Enum.Font.GothamMedium,TextSize=12,
        TextColor3=C.TextGray,BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.X,
        Size=UDim2.new(0,0,1,0),LayoutOrder=2,ZIndex=6,Parent=hRow,
    })

    local hDot=make("Frame",{
        AnchorPoint=Vector2.new(0.5,0), Position=UDim2.new(0.5,0,1,4),
        Size=UDim2.fromOffset(4,4), BackgroundColor3=C.HotbarDot,
        BackgroundTransparency=1, ZIndex=6, Parent=hBtn,
    })
    circle(hDot)

    local page=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false,Parent=self._content})
    local header=make("Frame",{Size=UDim2.new(1,0,0,88),BackgroundTransparency=1,Parent=page})

    local headerBadge=make("Frame",{Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(14,14),BackgroundTransparency=1,Parent=header})
    local headerIconElement = createIconElement(headerBadge, iconType, iconValue, 26, 3)
    if headerIconElement:IsA("ImageLabel") then headerIconElement.ImageColor3=C.White
    elseif headerIconElement:IsA("TextLabel") then headerIconElement.TextColor3=C.White end

    make("TextLabel",{Text=name,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(54,17),Size=UDim2.new(1,-70,0,14),Parent=header})
    make("TextLabel",{Text=opts.Subtitle or "",Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(54,33),Size=UDim2.new(1,-70,0,12),Parent=header})
    local pillRow=make("Frame",{Position=UDim2.fromOffset(16,54),Size=UDim2.new(1,-32,0,24),BackgroundTransparency=1,Parent=header})
    make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=pillRow})
    make("Frame",{Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Border,Parent=header})
    local pagesHolder=make("Frame",{Position=UDim2.fromOffset(0,88),Size=UDim2.new(1,0,1,-88),BackgroundTransparency=1,Parent=page})

    local tab=setmetatable({
        _window=win,
        _hBtn=hBtn,_hLabel=hLabel,_hDot=hDot,_hIconElement=hIconElement,
        _page=page,_pillRow=pillRow,_pagesHolder=pagesHolder,
        _subTabs={},_activeSub=nil,
    },Tab)

    hBtn.MouseButton1Click:Connect(function() win:_selectTab(tab) end)
    hBtn.MouseEnter:Connect(function()
        if win._activeTab~=tab then tween(hBtn,{BackgroundColor3=C.HotbarHover}) end
    end)
    hBtn.MouseLeave:Connect(function()
        tween(hBtn,{BackgroundColor3=win._activeTab==tab and C.HotbarActive or C.HotbarBg})
    end)

    table.insert(self._tabs,tab)
    if not self._activeTab then self:_selectTab(tab) end
    return tab
end

-- ════════════════════════════════════════════════════════════════════════════
-- SUBTAB + ELEMENTS
-- ════════════════════════════════════════════════════════════════════════════
function Tab:_selectSub(sub)
    if self._activeSub==sub then return end
    local prev=self._activeSub; self._activeSub=sub
    if prev then prev._page.Visible=false; paint(prev._pill,"BackgroundColor3","WindowBg"); paint(prev._pill,"TextColor3","TextGray") end
    sub._page.Visible=true; paint(sub._pill,"BackgroundColor3","PillActive"); paint(sub._pill,"TextColor3","White")
end

function Tab:AddSubTab(name)
    name=tostring(name or "General"); local tab=self
    local pill=make("TextButton",{Text=name,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.TextGray,BackgroundColor3=C.WindowBg,Size=UDim2.new(0,0,0,24),AutomaticSize=Enum.AutomaticSize.X,Parent=self._pillRow})
    autoOrder(pill);corner(pill,6);pad(pill,0,0,12,12)
    table.insert(tab._window._noDrag,pill)
    local page=make("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=2,ScrollBarImageColor3=C.Border,Parent=self._pagesHolder})
    pad(page,12,16,16,16)
    table.insert(tab._window._noDrag,page)
    local card=make("Frame",{Size=UDim2.new(1,-32,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=C.CardBg,Parent=page})
    corner(card,10);stroke(card);pad(card,14,14,16,16)
    make("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=card})
    local sub=setmetatable({_tab=tab,_window=tab._window,_pill=pill,_page=page,_card=card},SubTab)
    pill.MouseButton1Click:Connect(function() tab:_selectSub(sub) end)
    pill.MouseEnter:Connect(function() if tab._activeSub~=sub then tween(pill,{BackgroundColor3=C.NavHover}) end end)
    pill.MouseLeave:Connect(function() tween(pill,{BackgroundColor3=tab._activeSub==sub and C.PillActive or C.WindowBg}) end)
    table.insert(self._subTabs,sub)
    if not self._activeSub then self:_selectSub(sub) end
    return sub
end

local function newRow(card,h)
    local r=make("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,Parent=card}); autoOrder(r); return r
end
local function rowLabels(row,name,desc,rr)
    rr=rr or 0
    make("TextLabel",{Text=name,Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=desc and UDim2.new(1,-rr,0,14) or UDim2.new(1,-rr,1,0),Parent=row})
    if desc then make("TextLabel",{Text=desc,Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(0,16),Size=UDim2.new(1,-rr,0,12),Parent=row}) end
end

function SubTab:AddToggle(opts)
    opts=opts or {}; local value=opts.Default==true
    local row=newRow(self._card,30); rowLabels(row,opts.Name or "Toggle",opts.Description,44)
    local pill=make("TextButton",{Text="",Size=UDim2.fromOffset(34,18),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=C.Badge,Parent=row})
    circle(pill)
    local knob=make("Frame",{Size=UDim2.fromOffset(14,14),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,2,0.5,0),BackgroundColor3=C.KnobOff,Parent=pill})
    circle(knob)
    local function render(a)
        local kp=value and UDim2.new(0,18,0.5,0) or UDim2.new(0,2,0.5,0)
        paint(pill,"BackgroundColor3",value and "White" or "Badge",not a)
        paint(knob,"BackgroundColor3",value and "KnobOn" or "KnobOff",not a)
        if a then tween(knob,{Position=kp}) else knob.Position=kp end
    end
    local function set(v) v=v==true; if v==value then return end; value=v; render(true); fire(opts.Callback,value) end
    pill.MouseButton1Click:Connect(function() set(not value) end); render(false)
    return {Set=function(_,v) set(v) end, Get=function() return value end}
end

function SubTab:AddButton(opts)
    opts=opts or {}
    local btn=make("TextButton",{Text=opts.Name or "Button",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.TextGray,Size=UDim2.new(1,0,0,28),BackgroundColor3=C.Element,Parent=self._card})
    autoOrder(btn);corner(btn,6)
    btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=C.ElementHover}) end)
    btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=C.Element}) end)
    btn.MouseButton1Click:Connect(function() fire(opts.Callback) end)
    return btn
end

function SubTab:AddSection(opts)
    if type(opts)=="string" then opts={Name=opts} end; opts=opts or {}
    local row=make("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Parent=self._card}); autoOrder(row)
    make("TextLabel",{Text=string.upper(tostring(opts.Name or "Section")),Font=Enum.Font.GothamBold,TextSize=10,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,1,-3),Parent=row})
    make("Frame",{Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Border,Parent=row})
    return row
end

function SubTab:AddDivider()
    local row=make("Frame",{Size=UDim2.new(1,0,0,9),BackgroundTransparency=1,Parent=self._card}); autoOrder(row)
    make("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Border,Parent=row})
    return row
end

function SubTab:AddLabel(opts)
    if type(opts)=="string" then opts={Text=opts} end; opts=opts or {}
    local lbl=make("TextLabel",{Text=tostring(opts.Text or "Label"),Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Size=UDim2.new(1,0,0,16),Parent=self._card})
    autoOrder(lbl)
    return {Set=function(_,t) lbl.Text=tostring(t) end, Get=function() return lbl.Text end, Instance=lbl}
end

function SubTab:AddParagraph(opts)
    opts=opts or {}
    local card=make("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=self._card}); autoOrder(card)
    make("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=card})
    if opts.Title then
        make("TextLabel",{Text=tostring(opts.Title),Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Size=UDim2.new(1,0,0,16),LayoutOrder=1,Parent=card})
    end
    local body=make("TextLabel",{Text=tostring(opts.Text or opts.Content or ""),Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),LayoutOrder=2,Parent=card})
    return {Set=function(_,t) body.Text=tostring(t) end, Get=function() return body.Text end, Instance=body}
end

function SubTab:AddKeybind(opts)
    opts=opts or {}
    local key=opts.Default
    if typeof(key)~="EnumItem" then key=nil end
    local row=newRow(self._card,30); rowLabels(row,opts.Name or "Keybind",opts.Description,80)
    local btn=make("TextButton",{Text=key and key.Name or "None",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.TextGray,Size=UDim2.fromOffset(70,22),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=C.Element,Parent=row})
    corner(btn,6)
    local listening=false; local conn
    local function setKey(k)
        if k~=nil and typeof(k)~="EnumItem" then return end
        key=k; btn.Text=key and key.Name or "None"; fire(opts.Callback,key)
    end
    local function stopListening()
        listening=false
        if conn then conn:Disconnect(); conn=nil end
        btn.Text=key and key.Name or "None"
        tween(btn,{BackgroundColor3=C.Element,TextColor3=C.TextGray})
    end
    btn.MouseEnter:Connect(function() if not listening then tween(btn,{BackgroundColor3=C.ElementHover}) end end)
    btn.MouseLeave:Connect(function() if not listening then tween(btn,{BackgroundColor3=C.Element}) end end)
    btn.MouseButton1Click:Connect(function()
        if listening then stopListening(); return end
        listening=true; btn.Text="..."; tween(btn,{BackgroundColor3=C.PillActive,TextColor3=C.White})
        conn=UserInputService.InputBegan:Connect(function(input,gp)
            if gp then return end
            if input.UserInputType==Enum.UserInputType.Keyboard then
                if input.KeyCode==Enum.KeyCode.Escape then setKey(nil) else setKey(input.KeyCode) end
                stopListening()
            elseif input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.MouseButton2 then
                stopListening()
            end
        end)
    end)
    local pressConn=UserInputService.InputBegan:Connect(function(input,gp)
        if gp or listening or not key then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode==key then fire(opts.OnPress or opts.Pressed,key) end
    end)
    table.insert(self._window._noDrag,btn)
    return {Set=function(_,k) setKey(k) end, Get=function() return key end, _connections={pressConn}}
end

function SubTab:AddInput(opts)
    opts=opts or {}
    local row=newRow(self._card,30); rowLabels(row,opts.Name or "Input",opts.Description,120)
    local holder=make("Frame",{Size=UDim2.fromOffset(110,22),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=C.Element,Parent=row})
    corner(holder,6)
    local box=make("TextBox",{Text=opts.Default or "",PlaceholderText=opts.Placeholder or "...",PlaceholderColor3=C.Placeholder,Font=Enum.Font.Gotham,TextSize=12,TextColor3=C.TextGray,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ClearTextOnFocus=false,ClipsDescendants=true,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-30,1,0),Parent=holder})
    inputIcon(holder)
    box.FocusLost:Connect(function(ep) fire(opts.Callback,box.Text,ep) end)
    return {Set=function(_,t) box.Text=tostring(t) end, Get=function() return box.Text end}
end

function SubTab:AddDropdown(opts)
    opts=opts or {}
    local options=opts.Options or {}; local value=opts.Default or options[1] or ""
    local maxVisible=math.max(1,math.floor(opts.MaxVisible or 5)); local searchable=opts.Searchable==true
    local IH=22; local IP=2; local SH=26; local LW=160
    local row=newRow(self._card,30); rowLabels(row,opts.Name or "Dropdown",opts.Description,130)
    local btn=make("TextButton",{Text="",Size=UDim2.fromOffset(120,22),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=C.Element,Parent=row})
    corner(btn,6)
    local vl=make("TextLabel",{Text=tostring(value),Font=Enum.Font.Gotham,TextSize=12,TextColor3=C.TextGray,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-26,1,0),Parent=btn})
    sortIcon(btn)
    local win=self._window; local sp=self._page; local tp=self._tab._page
    local list=make("Frame",{Visible=false,Active=true,Position=UDim2.fromOffset(0,0),Size=UDim2.new(0,LW,0,0),BackgroundColor3=C.Element,ClipsDescendants=true,ZIndex=100,Parent=win.ScreenGui})
    corner(list,6);stroke(list); table.insert(win._noDrag,list)
    local sb; local fq=""
    if searchable then
        local sh=make("Frame",{Position=UDim2.fromOffset(4,4),Size=UDim2.new(1,-8,0,SH-4),BackgroundColor3=C.WindowBg,ZIndex=101,Parent=list}); corner(sh,4)
        sb=make("TextBox",{Text="",PlaceholderText="Search...",PlaceholderColor3=C.Placeholder,Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ClearTextOnFocus=false,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-16,1,0),ZIndex=102,Parent=sh})
    end
    local sf=make("ScrollingFrame",{Position=UDim2.fromOffset(0,searchable and SH or 0),Size=UDim2.new(1,0,1,searchable and -SH or 0),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=3,ScrollBarImageColor3=C.Border,ZIndex=101,Parent=list})
    pad(sf,4,4,4,4)
    make("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,IP),Parent=sf})
    local open=false; local cg=0; local oc={}; local co=options; local ob={}
    local function repo()
        local inset=GuiService:GetGuiInset(); local p,s=btn.AbsolutePosition,btn.AbsoluteSize
        list.Position=UDim2.fromOffset(p.X+inset.X+s.X-LW,p.Y+inset.Y+s.Y+4)
    end
    local function calcH()
        local fc=0; for _,o in ipairs(co) do if fq=="" or string.find(string.lower(tostring(o)),string.lower(fq),1,true) then fc=fc+1 end end
        local vc=math.min(math.max(fc,1),maxVisible)
        return vc*IH+math.max(vc-1,0)*IP+8+(searchable and SH or 0)
    end
    local function closeDD()
        if not open then return end; open=false; cg=cg+1
        for _,c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(list,{Size=UDim2.new(0,LW,0,0)})
        local g=cg; task.delay(0.16,function() if g==cg and not open then list.Visible=false end end)
    end
    local function rebuild()
        for _,b in ipairs(ob) do if b and b.Parent then b:Destroy() end end; table.clear(ob)
        for _,o in ipairs(co) do
            local os=tostring(o)
            if fq=="" or string.find(string.lower(os),string.lower(fq),1,true) then
                local ob2=make("TextButton",{Text=os,Font=Enum.Font.Gotham,TextSize=12,TextColor3=C.TextGray,Size=UDim2.new(1,-8,0,IH),BackgroundColor3=C.Element,Parent=sf})
                autoOrder(ob2);corner(ob2,4);make("UIPadding",{PaddingLeft=UDim.new(0,8),Parent=ob2}); ob2.TextXAlignment=Enum.TextXAlignment.Left
                ob2.MouseEnter:Connect(function() tween(ob2,{BackgroundColor3=C.ElementHover,TextColor3=C.White}) end)
                ob2.MouseLeave:Connect(function() tween(ob2,{BackgroundColor3=C.Element,TextColor3=C.TextGray}) end)
                ob2.MouseButton1Click:Connect(function() value=o; vl.Text=os; closeDD(); fire(opts.Callback,o) end)
                table.insert(ob,ob2)
            end
        end
    end
    if sb then sb:GetPropertyChangedSignal("Text"):Connect(function() fq=sb.Text; rebuild(); if open then tween(list,{Size=UDim2.new(0,LW,0,calcH())}) end end) end
    rebuild()
    local function setOpen(o)
        if open==o then return end
        if o then
            open=true; cg=cg+1; repo(); list.Visible=true; tween(list,{Size=UDim2.new(0,LW,0,calcH())})
            table.insert(oc,btn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                local bp,bs=btn.AbsolutePosition,btn.AbsoluteSize; local pp,ps=sp.AbsolutePosition,sp.AbsoluteSize
                if bp.Y+bs.Y<pp.Y or bp.Y>pp.Y+ps.Y then closeDD() else repo() end
            end))
            table.insert(oc,sp:GetPropertyChangedSignal("Visible"):Connect(function() if not sp.Visible then closeDD() end end))
            table.insert(oc,tp:GetPropertyChangedSignal("Visible"):Connect(function() if not tp.Visible then closeDD() end end))
            table.insert(oc,UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    local pos=Vector2.new(input.Position.X,input.Position.Y)
                    if not isInside(btn,pos) and not isInside(list,pos) then closeDD() end
                end
            end))
        else closeDD() end
    end
    btn.MouseButton1Click:Connect(function() setOpen(not open) end)
    btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=C.ElementHover}) end)
    btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=C.Element}) end)
    return {
        Set=function(_,o) value=o; vl.Text=tostring(o) end, Get=function() return value end,
        SetOptions=function(_,no)
            co=no or {}; local se=false
            for _,o in ipairs(co) do if o==value then se=true; break end end
            if not se and co[1] then value=co[1]; vl.Text=tostring(value) end
            rebuild(); if open then tween(list,{Size=UDim2.new(0,LW,0,calcH())}) end
        end,
        Refresh=function() rebuild() end,
    }
end

function SubTab:AddMultiDropdown(opts)
    opts=opts or {}
    local options=opts.Options or {}
    local maxVisible=math.max(1,math.floor(opts.MaxVisible or 5)); local searchable=opts.Searchable==true
    local IH=22; local IP=2; local SH=26; local LW=160
    local selected={}
    if type(opts.Default)=="table" then for _,o in ipairs(opts.Default) do selected[o]=true end end
    local row=newRow(self._card,30); rowLabels(row,opts.Name or "Dropdown",opts.Description,130)
    local btn=make("TextButton",{Text="",Size=UDim2.fromOffset(120,22),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=C.Element,Parent=row})
    corner(btn,6)
    local vl=make("TextLabel",{Text="None",Font=Enum.Font.Gotham,TextSize=12,TextColor3=C.TextGray,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-26,1,0),Parent=btn})
    sortIcon(btn)
    local win=self._window; local sp=self._page; local tp=self._tab._page
    local list=make("Frame",{Visible=false,Active=true,Position=UDim2.fromOffset(0,0),Size=UDim2.new(0,LW,0,0),BackgroundColor3=C.Element,ClipsDescendants=true,ZIndex=100,Parent=win.ScreenGui})
    corner(list,6);stroke(list); table.insert(win._noDrag,list)
    local sb; local fq=""
    if searchable then
        local sh=make("Frame",{Position=UDim2.fromOffset(4,4),Size=UDim2.new(1,-8,0,SH-4),BackgroundColor3=C.WindowBg,ZIndex=101,Parent=list}); corner(sh,4)
        sb=make("TextBox",{Text="",PlaceholderText="Search...",PlaceholderColor3=C.Placeholder,Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ClearTextOnFocus=false,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-16,1,0),ZIndex=102,Parent=sh})
    end
    local sf=make("ScrollingFrame",{Position=UDim2.fromOffset(0,searchable and SH or 0),Size=UDim2.new(1,0,1,searchable and -SH or 0),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=3,ScrollBarImageColor3=C.Border,ZIndex=101,Parent=list})
    pad(sf,4,4,4,4)
    make("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,IP),Parent=sf})
    local open=false; local cg=0; local oc={}; local co=options; local ob={}
    local function selectedList()
        local out={}
        for _,o in ipairs(co) do if selected[o] then table.insert(out,o) end end
        return out
    end
    local function updateSummary()
        local sel=selectedList()
        if #sel==0 then vl.Text="None"
        elseif #sel==1 then vl.Text=tostring(sel[1])
        else vl.Text=#sel.." selected" end
    end
    local function repo()
        local inset=GuiService:GetGuiInset(); local p,s=btn.AbsolutePosition,btn.AbsoluteSize
        list.Position=UDim2.fromOffset(p.X+inset.X+s.X-LW,p.Y+inset.Y+s.Y+4)
    end
    local function calcH()
        local fc=0; for _,o in ipairs(co) do if fq=="" or string.find(string.lower(tostring(o)),string.lower(fq),1,true) then fc=fc+1 end end
        local vc=math.min(math.max(fc,1),maxVisible)
        return vc*IH+math.max(vc-1,0)*IP+8+(searchable and SH or 0)
    end
    local function closeDD()
        if not open then return end; open=false; cg=cg+1
        for _,c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(list,{Size=UDim2.new(0,LW,0,0)})
        local g=cg; task.delay(0.16,function() if g==cg and not open then list.Visible=false end end)
    end
    local function rebuild()
        for _,b in ipairs(ob) do if b and b.Parent then b:Destroy() end end; table.clear(ob)
        for _,o in ipairs(co) do
            local os=tostring(o)
            if fq=="" or string.find(string.lower(os),string.lower(fq),1,true) then
                local ob2=make("TextButton",{Text="",Size=UDim2.new(1,-8,0,IH),BackgroundColor3=C.Element,Parent=sf})
                autoOrder(ob2);corner(ob2,4)
                local box=make("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0),Size=UDim2.fromOffset(12,12),BackgroundColor3=selected[o] and C.White or C.Badge,Parent=ob2})
                corner(box,3)
                local check=make("TextLabel",{Text="✓",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=C.KnobOn,BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Visible=selected[o]==true,Parent=box})
                make("TextLabel",{Text=os,Font=Enum.Font.Gotham,TextSize=12,TextColor3=selected[o] and C.White or C.TextGray,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BackgroundTransparency=1,Position=UDim2.fromOffset(26,0),Size=UDim2.new(1,-32,1,0),Parent=ob2})
                ob2.MouseEnter:Connect(function() if not selected[o] then tween(ob2,{BackgroundColor3=C.ElementHover}) end end)
                ob2.MouseLeave:Connect(function() tween(ob2,{BackgroundColor3=C.Element}) end)
                ob2.MouseButton1Click:Connect(function()
                    selected[o]=not selected[o] or nil
                    box.BackgroundColor3=selected[o] and C.White or C.Badge
                    check.Visible=selected[o]==true
                    updateSummary(); fire(opts.Callback,selectedList())
                end)
                table.insert(ob,ob2)
            end
        end
    end
    if sb then sb:GetPropertyChangedSignal("Text"):Connect(function() fq=sb.Text; rebuild(); if open then tween(list,{Size=UDim2.new(0,LW,0,calcH())}) end end) end
    rebuild(); updateSummary()
    local function setOpen(o)
        if open==o then return end
        if o then
            open=true; cg=cg+1; repo(); list.Visible=true; tween(list,{Size=UDim2.new(0,LW,0,calcH())})
            table.insert(oc,btn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                local bp,bs=btn.AbsolutePosition,btn.AbsoluteSize; local pp,ps=sp.AbsolutePosition,sp.AbsoluteSize
                if bp.Y+bs.Y<pp.Y or bp.Y>pp.Y+ps.Y then closeDD() else repo() end
            end))
            table.insert(oc,sp:GetPropertyChangedSignal("Visible"):Connect(function() if not sp.Visible then closeDD() end end))
            table.insert(oc,tp:GetPropertyChangedSignal("Visible"):Connect(function() if not tp.Visible then closeDD() end end))
            table.insert(oc,UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    local pos=Vector2.new(input.Position.X,input.Position.Y)
                    if not isInside(btn,pos) and not isInside(list,pos) then closeDD() end
                end
            end))
        else closeDD() end
    end
    btn.MouseButton1Click:Connect(function() setOpen(not open) end)
    btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=C.ElementHover}) end)
    btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=C.Element}) end)
    return {
        Set=function(_,sel)
            table.clear(selected)
            if type(sel)=="table" then for _,o in ipairs(sel) do selected[o]=true end end
            rebuild(); updateSummary()
        end,
        Get=function() return selectedList() end,
        SetOptions=function(_,no)
            co=no or {}
            for o in pairs(selected) do
                local still=false
                for _,n in ipairs(co) do if n==o then still=true; break end end
                if not still then selected[o]=nil end
            end
            rebuild(); updateSummary(); if open then tween(list,{Size=UDim2.new(0,LW,0,calcH())}) end
        end,
        Refresh=function() rebuild(); updateSummary() end,
    }
end

-- ════════════════════════════════════════════════════════════════════════════
-- COLOR HELPERS
-- ════════════════════════════════════════════════════════════════════════════
local function colorToHex(c)
    return string.format("#%02X%02X%02X",
        math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
end
local function hexToColor(hex)
    hex = tostring(hex or ""):gsub("#","")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1,2),16)
    local g = tonumber(hex:sub(3,4),16)
    local b = tonumber(hex:sub(5,6),16)
    if not (r and g and b) then return nil end
    return Color3.fromRGB(r,g,b)
end

function SubTab:AddSlider(opts)
    opts=opts or {}
    local mn=opts.Min or 0; local mx=opts.Max or 100; local sf=opts.Suffix or ""
    local value=math.clamp(opts.Default or mn,mn,mx)
    local row=newRow(self._card,32)
    make("TextLabel",{Text=opts.Name or "Slider",Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=UDim2.new(0.6,0,0,14),Parent=row})
    local vl=make("TextLabel",{Text=tostring(value)..sf,Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Right,BackgroundTransparency=1,Position=UDim2.fromOffset(0,1),Size=UDim2.new(1,0,0,13),Parent=row})
    local track=make("Frame",{Position=UDim2.fromOffset(0,24),Size=UDim2.new(1,0,0,4),BackgroundColor3=C.TrackBg,Parent=row}); circle(track)
    local fill=make("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.White,Parent=track}); circle(fill)
    local knob=make("Frame",{Size=UDim2.fromOffset(12,12),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.White,ZIndex=2,Parent=track}); circle(knob)
    local hit=make("TextButton",{Text="",BackgroundTransparency=1,Position=UDim2.new(0,-6,0,16),Size=UDim2.new(1,12,0,20),Parent=row})
    local function apply(v,a,fc)
        value=math.clamp(math.floor(v+0.5),mn,mx)
        local pct=mx>mn and (value-mn)/(mx-mn) or 0; vl.Text=tostring(value)..sf
        if a then tween(fill,{Size=UDim2.new(pct,0,1,0)}); tween(knob,{Position=UDim2.new(pct,0,0.5,0)})
        else fill.Size=UDim2.new(pct,0,1,0); knob.Position=UDim2.new(pct,0,0.5,0) end
        if fc then fire(opts.Callback,value) end
    end
    local function fromX(x) return mn+(mx-mn)*math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1) end
    local dragging=false
    hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; apply(fromX(i.Position.X),true,true) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then apply(fromX(i.Position.X),true,true) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    apply(value,false,false)
    return {Set=function(_,v) apply(v,true,true) end, Get=function() return value end}
end

local function hsvToColor(h,s,v) return Color3.fromHSV(h,s,v) end
local function colorToHSV(c) return c:ToHSV() end

function SubTab:AddColorPicker(opts)
    opts=opts or {}
    local value = (typeof(opts.Default)=="Color3" and opts.Default) or hexToColor(opts.Default) or Color3.fromRGB(255,255,255)
    local h,s,v = colorToHSV(value)
    local row=newRow(self._card,30); rowLabels(row,opts.Name or "Color",opts.Description,44)

    local swatch=make("TextButton",{Text="",Size=UDim2.fromOffset(34,18),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=value,Parent=row})
    corner(swatch,5);stroke(swatch,C.Border)

    local win=self._window; local sp=self._page; local tp=self._tab._page
    local PW=200
    local panel=make("Frame",{Visible=false,Active=true,Size=UDim2.fromOffset(PW,0),BackgroundColor3=C.Element,ClipsDescendants=true,ZIndex=100,Parent=win.ScreenGui})
    corner(panel,6);stroke(panel); table.insert(win._noDrag,panel)
    local inner=make("Frame",{Position=UDim2.fromOffset(0,0),Size=UDim2.fromOffset(PW,168),BackgroundTransparency=1,ZIndex=101,Parent=panel})
    pad(inner,10,10,10,10)

    local svBox=make("Frame",{Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,110),BackgroundColor3=hsvToColor(h,1,1),ZIndex=101,Parent=inner})
    corner(svBox,4)
    make("UIGradient",{Color=ColorSequence.new(Color3.new(1,1,1),hsvToColor(h,1,1)),Parent=svBox})
    local svBlack=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),ZIndex=102,Parent=svBox}); corner(svBlack,4)
    make("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),Parent=svBlack})
    local svCursor=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(8,8),BackgroundColor3=Color3.new(1,1,1),ZIndex=103,Parent=svBox}); circle(svCursor); stroke(svCursor,Color3.new(0,0,0))
    local svHit=make("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=104,Parent=svBox})

    local hueBox=make("Frame",{Position=UDim2.fromOffset(0,118),Size=UDim2.new(1,0,0,12),BackgroundColor3=Color3.new(1,1,1),ZIndex=101,Parent=inner})
    corner(hueBox,4)
    make("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.50,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,0,0)),
    }),Parent=hueBox})
    local hueCursor=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(4,16),BackgroundColor3=Color3.new(1,1,1),ZIndex=103,Parent=hueBox}); corner(hueCursor,2); stroke(hueCursor,Color3.new(0,0,0))
    local hueHit=make("TextButton",{Text="",BackgroundTransparency=1,Position=UDim2.fromOffset(0,-4),Size=UDim2.new(1,0,0,20),ZIndex=104,Parent=hueBox})

    local hexHolder=make("Frame",{Position=UDim2.fromOffset(0,140),Size=UDim2.new(1,0,0,22),BackgroundColor3=C.WindowBg,ZIndex=101,Parent=inner}); corner(hexHolder,5)
    local hexBox=make("TextBox",{Text=colorToHex(value),PlaceholderText="#FFFFFF",PlaceholderColor3=C.Placeholder,Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Center,BackgroundTransparency=1,ClearTextOnFocus=false,Size=UDim2.fromScale(1,1),ZIndex=102,Parent=hexHolder})

    local function applyVisuals(a)
        local hueColor=hsvToColor(h,1,1)
        if a then tween(swatch,{BackgroundColor3=value}) else swatch.BackgroundColor3=value end
        svBox.BackgroundColor3=hueColor
        for _,g in ipairs(svBox:GetChildren()) do if g:IsA("UIGradient") and g.Parent==svBox then g.Color=ColorSequence.new(Color3.new(1,1,1),hueColor) end end
        svCursor.Position=UDim2.new(s,0,1-v,0)
        svCursor.BackgroundColor3 = v>0.5 and Color3.new(0,0,0) or Color3.new(1,1,1)
        hueCursor.Position=UDim2.new(h,0,0.5,0)
        hexBox.Text=colorToHex(value)
    end
    local function recompute(fc,a)
        value=hsvToColor(h,s,v); applyVisuals(a)
        if fc then fire(opts.Callback,value) end
    end

    local svDragging=false; local hueDragging=false
    local function svFrom(px,py)
        local p,sz=svBox.AbsolutePosition,svBox.AbsoluteSize
        s=math.clamp((px-p.X)/math.max(sz.X,1),0,1)
        v=1-math.clamp((py-p.Y)/math.max(sz.Y,1),0,1)
    end
    local function hueFrom(px)
        local p,sz=hueBox.AbsolutePosition,hueBox.AbsoluteSize
        h=math.clamp((px-p.X)/math.max(sz.X,1),0,1)
    end
    svHit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then svDragging=true; svFrom(i.Position.X,i.Position.Y); recompute(true,false) end end)
    hueHit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then hueDragging=true; hueFrom(i.Position.X); recompute(true,false) end end)
    local moveConn=UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        if svDragging then svFrom(i.Position.X,i.Position.Y); recompute(true,false)
        elseif hueDragging then hueFrom(i.Position.X); recompute(true,false) end
    end)
    local endConn=UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then svDragging=false; hueDragging=false end
    end)
    hexBox.FocusLost:Connect(function()
        local c=hexToColor(hexBox.Text)
        if c then value=c; h,s,v=colorToHSV(c); recompute(true,true) else hexBox.Text=colorToHex(value) end
    end)

    local open=false; local cg=0; local oc={}
    local function repo()
        local inset=GuiService:GetGuiInset(); local p,sz=swatch.AbsolutePosition,swatch.AbsoluteSize
        panel.Position=UDim2.fromOffset(p.X+inset.X+sz.X-PW,p.Y+inset.Y+sz.Y+4)
    end
    local function closePanel()
        if not open then return end; open=false; cg=cg+1
        for _,c in ipairs(oc) do c:Disconnect() end; table.clear(oc)
        tween(panel,{Size=UDim2.fromOffset(PW,0)})
        local g=cg; task.delay(0.16,function() if g==cg and not open then panel.Visible=false end end)
    end
    local function setOpen(o)
        if open==o then return end
        if o then
            open=true; cg=cg+1; repo(); panel.Visible=true; tween(panel,{Size=UDim2.fromOffset(PW,168)})
            table.insert(oc,swatch:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                local bp,bs=swatch.AbsolutePosition,swatch.AbsoluteSize; local pp,ps=sp.AbsolutePosition,sp.AbsoluteSize
                if bp.Y+bs.Y<pp.Y or bp.Y>pp.Y+ps.Y then closePanel() else repo() end
            end))
            table.insert(oc,sp:GetPropertyChangedSignal("Visible"):Connect(function() if not sp.Visible then closePanel() end end))
            table.insert(oc,tp:GetPropertyChangedSignal("Visible"):Connect(function() if not tp.Visible then closePanel() end end))
            table.insert(oc,UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    local pos=Vector2.new(input.Position.X,input.Position.Y)
                    if not isInside(swatch,pos) and not isInside(panel,pos) then closePanel() end
                end
            end))
        else closePanel() end
    end
    swatch.MouseButton1Click:Connect(function() setOpen(not open) end)
    swatch.MouseEnter:Connect(function() tween(swatch,{BackgroundColor3=value}) end)
    recompute(false,false)
    return {
        Set=function(_,c)
            c=(typeof(c)=="Color3" and c) or hexToColor(c)
            if not c then return end
            value=c; h,s,v=colorToHSV(c); recompute(false,true)
        end,
        Get=function() return value end,
        GetHex=function() return colorToHex(value) end,
        _connections={moveConn,endConn},
    }
end

return Library
