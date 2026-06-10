--[[
    Solis UI Library
    A minimal dark Roblox Luau UI library with tabs, pages, sections,
    reusable controls, flags, notifications, and a muted amber accent.

    GitHub usage:
    local Solis = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_NAME/Solis/main/src/Solis.lua"))()
]]

local Solis = {}
Solis.__index = Solis

Solis.Version = "1.1.3"
Solis.Icon = "rbxassetid://105894109382235"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local DefaultTheme = {
    Background = Color3.fromRGB(10, 10, 11),
    Sidebar = Color3.fromRGB(13, 13, 15),
    Surface = Color3.fromRGB(18, 18, 20),
    SurfaceLight = Color3.fromRGB(24, 24, 27),
    SurfaceHover = Color3.fromRGB(31, 31, 35),
    Border = Color3.fromRGB(43, 43, 47),
    Text = Color3.fromRGB(243, 243, 245),
    Muted = Color3.fromRGB(156, 156, 162),
    MutedDark = Color3.fromRGB(104, 104, 110),
    Accent = Color3.fromRGB(214, 156, 82),
    AccentSoft = Color3.fromRGB(74, 50, 25),
    Success = Color3.fromRGB(94, 220, 132),
    Error = Color3.fromRGB(241, 88, 88),
}

local function mergeTheme(theme)
    local merged = {}

    for key, value in pairs(DefaultTheme) do
        merged[key] = value
    end

    for key, value in pairs(theme or {}) do
        merged[key] = value
    end

    return merged
end

local function create(className, properties, children)
    local instance = Instance.new(className)
    local parent = nil

    for key, value in pairs(properties or {}) do
        if key == "Parent" then
            parent = value
        else
            instance[key] = value
        end
    end

    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end

    if parent then
        instance.Parent = parent
    end

    return instance
end

local function corner(radius)
    local roundness = (radius or 6) + 3

    return create("UICorner", {
        CornerRadius = UDim.new(0, roundness),
    })
end

local function stroke(color, transparency, thickness)
    return create("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    })
end

local function padding(left, top, right, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
    })
end

local function listLayout(direction, spacing, align)
    return create("UIListLayout", {
        FillDirection = direction or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, spacing or 0),
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left,
    })
end

local function tween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local activeTween = TweenService:Create(instance, info, properties)
    activeTween:Play()
    return activeTween
end

local function normalizeIcon(icon)
    if typeof(icon) == "number" then
        return "rbxassetid://" .. tostring(icon)
    end

    if typeof(icon) == "string" then
        if icon:match("^rbxasset") or icon:match("^http") then
            return icon
        end

        if icon:match("^%d+$") then
            return "rbxassetid://" .. icon
        end

        return Solis.Icon
    end

    return Solis.Icon
end

local function parentGui()
    if not LocalPlayer then
        error("Solis must run from a Roblox client LocalScript.", 3)
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local function roundToStep(value, step)
    if not step or step <= 0 then
        return value
    end

    return math.floor((value / step) + 0.5) * step
end

local function formatNumber(value, decimals)
    decimals = decimals or 0

    if decimals <= 0 then
        return tostring(math.floor(value + 0.5))
    end

    local formatString = "%." .. tostring(decimals) .. "f"
    return string.format(formatString, value)
end

local function connectHover(button, normal, hover)
    button.MouseEnter:Connect(function()
        tween(button, { BackgroundColor3 = hover }, 0.12)
    end)

    button.MouseLeave:Connect(function()
        tween(button, { BackgroundColor3 = normal }, 0.12)
    end)
end

local function makeDraggable(frame, dragTargets)
    local dragging = false
    local dragStart = nil
    local startPosition = nil
    local connections = {}

    local function begin(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end

    local function update(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end

    for _, target in ipairs(dragTargets) do
        table.insert(connections, target.InputBegan:Connect(begin))
    end

    table.insert(connections, UserInputService.InputChanged:Connect(update))

    return connections
end

local function automaticCanvas(scrollingFrame, layout)
    local function update()
        scrollingFrame.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    update()
end

local function createText(parent, theme, options)
    return create("TextLabel", {
        Parent = parent,
        Name = options.Name or "Text",
        AnchorPoint = options.AnchorPoint or Vector2.new(0, 0),
        BackgroundTransparency = 1,
        Position = options.Position or UDim2.fromOffset(0, 0),
        Size = options.Size or UDim2.new(1, 0, 0, 18),
        Font = options.Font or Enum.Font.Gotham,
        Text = options.Text or "",
        TextColor3 = options.Color or theme.Text,
        TextSize = options.TextSize or 13,
        TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = options.TextYAlignment or Enum.TextYAlignment.Center,
        TextWrapped = options.TextWrapped or false,
        TextTransparency = options.TextTransparency or 0,
    })
end

local WindowMethods = {}
local TabMethods = {}
local PageMethods = {}
local SectionMethods = {}

local function selectPage(page)
    local tab = page.Tab
    local window = tab.Window

    for _, item in ipairs(tab.Pages) do
        item.Frame.Visible = false
        item.Button.BackgroundColor3 = window.Theme.Surface
        item.Button.TextColor3 = window.Theme.Muted
    end

    page.Frame.Visible = true
    page.Button.BackgroundColor3 = window.Theme.SurfaceLight
    page.Button.TextColor3 = window.Theme.Text
    tab.ActivePage = page
end

local function selectTab(tab)
    local window = tab.Window

    for _, item in ipairs(window.Tabs) do
        item.Button.BackgroundColor3 = window.Theme.Surface
        item.Button.BackgroundTransparency = 0.12
        item.TitleLabel.TextColor3 = window.Theme.Muted
        item.IconFrame.BackgroundColor3 = window.Theme.SurfaceLight
        item.IconFrame.BackgroundTransparency = 1
        if item.AccentBar then
            item.AccentBar.Visible = false
        end

        for _, page in ipairs(item.Pages) do
            page.Frame.Visible = false
            page.Button.Visible = false
        end
    end

    tab.Button.BackgroundTransparency = 0
    tab.Button.BackgroundColor3 = window.Theme.SurfaceLight
    tab.TitleLabel.TextColor3 = window.Theme.Text
    tab.IconFrame.BackgroundColor3 = window.Theme.SurfaceHover
    tab.IconFrame.BackgroundTransparency = 1
    if tab.AccentBar then
        tab.AccentBar.Visible = true
    end
    window.HeaderIcon.Image = tab.Icon
    window.HeaderTitle.Text = tab.Name
    window.HeaderSubtitle.Text = tab.Subtitle
    window.ActiveTab = tab

    for _, page in ipairs(tab.Pages) do
        page.Button.Visible = true
    end

    if not tab.ActivePage and tab.Pages[1] then
        selectPage(tab.Pages[1])
    elseif tab.ActivePage then
        selectPage(tab.ActivePage)
    end
end

local function createSectionRow(section, height, name)
    local row = create("Frame", {
        Parent = section.Content,
        Name = name or "Control",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, height or 48),
    })

    return row
end

local function setFlag(window, flag, value, control)
    if not flag then
        return
    end

    window.Flags[flag] = value
    window.Options[flag] = control
end

local function createControlText(section, row, title, description)
    local theme = section.Window.Theme

    createText(row, theme, {
        Name = "Title",
        Text = title or "Control",
        Position = UDim2.new(0, 0, 0, description and 4 or 0),
        Size = UDim2.new(1, -168, 0, 18),
        TextSize = 13,
        Color = theme.Text,
    })

    if description and description ~= "" then
        createText(row, theme, {
            Name = "Description",
            Text = description,
            Position = UDim2.new(0, 0, 0, 23),
            Size = UDim2.new(1, -168, 0, 17),
            TextSize = 11,
            Color = theme.Muted,
        })
    end
end

function Solis:CreateWindow(options)
    options = options or {}

    local theme = mergeTheme(options.Theme)
    local guiParent = options.Parent or parentGui()
    local title = options.Title or options.Name or "Solis"
    local footer = options.Footer or options.Subtitle or "Roblox UI Library"
    local size = options.Size or UDim2.fromOffset(650, 430)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    local guiName = "Solis_" .. title:gsub("%W", "")

    local oldGui = guiParent:FindFirstChild(guiName)
    if oldGui and options.AllowMultiple ~= true then
        oldGui:Destroy()
    end

    local screenGui = create("ScreenGui", {
        Parent = guiParent,
        Name = guiName,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = options.DisplayOrder or 1000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local main = create("Frame", {
        Parent = screenGui,
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, {
        corner(12),
        stroke(theme.Border, 0.2, 1),
    })

    local sidebar = create("Frame", {
        Parent = main,
        Name = "Sidebar",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 176, 1, 0),
    })

    local sidebarRadius = 18

    create("Frame", {
        Parent = sidebar,
        Name = "SidebarTopLeft",
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(sidebarRadius * 2, sidebarRadius * 2),
    }, {
        corner(sidebarRadius),
    })

    create("Frame", {
        Parent = sidebar,
        Name = "SidebarBottomLeft",
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.fromOffset(sidebarRadius * 2, sidebarRadius * 2),
    }, {
        corner(sidebarRadius),
    })

    create("Frame", {
        Parent = sidebar,
        Name = "SidebarTopFill",
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(sidebarRadius, 0),
        Size = UDim2.new(1, -sidebarRadius, 0, sidebarRadius),
    })

    create("Frame", {
        Parent = sidebar,
        Name = "SidebarMiddleFill",
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, sidebarRadius),
        Size = UDim2.new(1, 0, 1, -(sidebarRadius * 2)),
    })

    create("Frame", {
        Parent = sidebar,
        Name = "SidebarBottomFill",
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, sidebarRadius, 1, 0),
        Size = UDim2.new(1, -sidebarRadius, 0, sidebarRadius),
    })


    create("Frame", {
        Parent = sidebar,
        Name = "Divider",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundTransparency = 0.25,
    })

    local brand = create("Frame", {
        Parent = sidebar,
        Name = "Brand",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 14),
        Size = UDim2.new(1, -28, 0, 44),
    })

    local brandIconFrame = create("Frame", {
        Parent = brand,
        Name = "IconFrame",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(38, 38),
        Position = UDim2.fromOffset(0, 3),
    }, {
        corner(7),
    })

    create("ImageLabel", {
        Parent = brandIconFrame,
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = normalizeIcon(options.Icon or Solis.Icon),
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(34, 34),
        ScaleType = Enum.ScaleType.Fit,
    })

    createText(brand, theme, {
        Name = "Name",
        Text = title,
        Position = UDim2.fromOffset(48, 5),
        Size = UDim2.new(1, -48, 0, 18),
        TextSize = 13,
        Color = theme.Text,
    })

    createText(brand, theme, {
        Name = "Footer",
        Text = footer,
        Position = UDim2.fromOffset(48, 22),
        Size = UDim2.new(1, -48, 0, 15),
        TextSize = 10,
        Color = theme.Muted,
    })

    local tabList = create("ScrollingFrame", {
        Parent = sidebar,
        Name = "Tabs",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 72),
        Size = UDim2.new(1, -28, 1, -86),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, {
        listLayout(Enum.FillDirection.Vertical, 8),
    })

    local content = create("Frame", {
        Parent = main,
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(176, 1),
        Size = UDim2.new(1, -177, 1, -2),
    })

    local header = create("Frame", {
        Parent = content,
        Name = "Header",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.new(1, -28, 0, 44),
    })

    local headerIconFrame = create("Frame", {
        Parent = header,
        Name = "IconFrame",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.fromOffset(0, 4),
    }, {
        corner(7),
    })

    local headerIcon = create("ImageLabel", {
        Parent = headerIconFrame,
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = normalizeIcon(options.Icon or Solis.Icon),
        Position = UDim2.fromOffset(5, 5),
        Size = UDim2.fromOffset(16, 16),
        ScaleType = Enum.ScaleType.Fit,
    })

    local headerTitle = createText(header, theme, {
        Name = "Title",
        Text = title,
        Position = UDim2.fromOffset(38, 1),
        Size = UDim2.new(1, -108, 0, 18),
        TextSize = 12,
        Color = theme.Text,
    })

    local headerSubtitle = createText(header, theme, {
        Name = "Footer",
        Text = footer,
        Position = UDim2.fromOffset(38, 18),
        Size = UDim2.new(1, -108, 0, 18),
        TextSize = 10,
        Color = theme.Muted,
    })

    local closeButton = create("TextButton", {
        Parent = header,
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 4),
        Size = UDim2.fromOffset(26, 26),
        Font = Enum.Font.GothamBold,
        Text = "x",
        TextColor3 = theme.Muted,
        TextSize = 12,
        AutoButtonColor = false,
    }, {
        corner(6),
        stroke(theme.Border, 0.25, 1),
    })

    local hideButton = create("TextButton", {
        Parent = header,
        Name = "Hide",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -32, 0, 4),
        Size = UDim2.fromOffset(26, 26),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = theme.Muted,
        TextSize = 16,
        AutoButtonColor = false,
    }, {
        corner(6),
        stroke(theme.Border, 0.25, 1),
    })

    connectHover(closeButton, theme.Surface, theme.SurfaceHover)
    connectHover(hideButton, theme.Surface, theme.SurfaceHover)

    local pageTabs = create("Frame", {
        Parent = content,
        Name = "PageTabs",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 58),
        Size = UDim2.new(1, -28, 0, 26),
    }, {
        listLayout(Enum.FillDirection.Horizontal, 8, Enum.HorizontalAlignment.Left),
    })

    create("Frame", {
        Parent = content,
        Name = "HeaderDivider",
        BackgroundColor3 = theme.Border,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 86),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local notifications = create("Frame", {
        Parent = screenGui,
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(300, 500),
    }, {
        listLayout(Enum.FillDirection.Vertical, 10, Enum.HorizontalAlignment.Right),
    })

    local window = setmetatable({
        Title = title,
        Footer = footer,
        Name = title,
        Subtitle = footer,
        Gui = screenGui,
        Main = main,
        Sidebar = sidebar,
        TabList = tabList,
        PageTabs = pageTabs,
        Content = content,
        Notifications = notifications,
        HeaderIcon = headerIcon,
        HeaderTitle = headerTitle,
        HeaderSubtitle = headerSubtitle,
        Theme = theme,
        Tabs = {},
        Flags = {},
        Options = {},
        Connections = {},
        Visible = true,
        StoredSize = size,
    }, { __index = WindowMethods })

    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    hideButton.MouseButton1Click:Connect(function()
        window:SetVisible(false)
    end)

    if toggleKey then
        table.insert(window.Connections, UserInputService.InputBegan:Connect(function(input, processed)
            if processed then
                return
            end

            if input.KeyCode == toggleKey then
                window:SetVisible(not window.Visible)
            end
        end))
    end

    for _, connection in ipairs(makeDraggable(main, { sidebar, header, brand })) do
        table.insert(window.Connections, connection)
    end

    return window
end

function WindowMethods:SetVisible(visible)
    self.Visible = visible

    if visible then
        self.Main.Visible = true
        self.Main.Size = UDim2.new(
            self.StoredSize.X.Scale,
            self.StoredSize.X.Offset,
            self.StoredSize.Y.Scale,
            0
        )
        tween(self.Main, { Size = self.StoredSize }, 0.16)
    else
        self.StoredSize = self.Main.Size
        tween(self.Main, {
            Size = UDim2.new(
                self.StoredSize.X.Scale,
                self.StoredSize.X.Offset,
                self.StoredSize.Y.Scale,
                0
            ),
        }, 0.12)

        task.delay(0.12, function()
            if not self.Visible and self.Main then
                self.Main.Visible = false
            end
        end)
    end
end

function WindowMethods:Show()
    self:SetVisible(true)
end

function WindowMethods:Hide()
    self:SetVisible(false)
end

function WindowMethods:Toggle()
    self:SetVisible(not self.Visible)
end

function WindowMethods:Destroy()
    for _, connection in ipairs(self.Connections) do
        if connection.Disconnect then
            connection:Disconnect()
        end
    end

    if self.Gui then
        self.Gui:Destroy()
    end
end

function WindowMethods:CreateTab(options, icon)
    if typeof(options) == "string" then
        options = {
            Name = options,
            Icon = icon,
        }
    else
        options = options or {}
    end

    local tab = setmetatable({
        Window = self,
        Name = options.Name or "Tab",
        Subtitle = options.Subtitle or options.Description or "",
        Icon = normalizeIcon(options.Icon or Solis.Icon),
        Pages = {},
        ActivePage = nil,
    }, { __index = TabMethods })

    local button = create("TextButton", {
        Parent = self.TabList,
        Name = tab.Name,
        BackgroundColor3 = self.Theme.Surface,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        Text = "",
        AutoButtonColor = false,
    }, {
        corner(6),
        stroke(self.Theme.Border, 0.7, 1),
    })

    local accentBar = create("Frame", {
        Parent = button,
        Name = "Accent",
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 10),
        Size = UDim2.fromOffset(3, 22),
        Visible = false,
    }, {
        corner(2),
    })

    local iconFrame = create("Frame", {
        Parent = button,
        Name = "IconFrame",
        BackgroundColor3 = self.Theme.SurfaceLight,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(10, 9),
        Size = UDim2.fromOffset(24, 24),
    }, {
        corner(6),
    })

    create("ImageLabel", {
        Parent = iconFrame,
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = tab.Icon,
        Position = UDim2.fromOffset(5, 5),
        Size = UDim2.fromOffset(14, 14),
        ScaleType = Enum.ScaleType.Fit,
    })

    local title = createText(button, self.Theme, {
        Name = "Title",
        Text = tab.Name,
        Position = UDim2.fromOffset(43, 8),
        Size = UDim2.new(1, -50, 0, 17),
        TextSize = 12,
        Color = self.Theme.Muted,
    })

    createText(button, self.Theme, {
        Name = "Subtitle",
        Text = tab.Subtitle,
        Position = UDim2.fromOffset(43, 24),
        Size = UDim2.new(1, -50, 0, 13),
        TextSize = 10,
        Color = self.Theme.MutedDark,
    })

    tab.Button = button
    tab.TitleLabel = title
    tab.IconFrame = iconFrame
    tab.AccentBar = accentBar

    button.MouseButton1Click:Connect(function()
        selectTab(tab)
    end)

    table.insert(self.Tabs, tab)

    if options.DefaultPage ~= false then
        tab:CreatePage(options.Page or "Common")
    end

    if not self.ActiveTab then
        selectTab(tab)
    end

    return tab
end

function WindowMethods:Notify(options)
    options = options or {}

    local title = options.Title or "Solis"
    local content = options.Content or options.Text or ""
    local duration = options.Duration or 4

    local notification = create("Frame", {
        Parent = self.Notifications,
        Name = "Notification",
        BackgroundColor3 = self.Theme.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(292, 0),
        ClipsDescendants = true,
    }, {
        corner(8),
        stroke(self.Theme.Border, 1, 1),
    })

    create("ImageLabel", {
        Parent = notification,
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = Solis.Icon,
        Position = UDim2.fromOffset(14, 14),
        Size = UDim2.fromOffset(24, 24),
        ScaleType = Enum.ScaleType.Fit,
    })

    createText(notification, self.Theme, {
        Name = "Title",
        Text = title,
        Position = UDim2.fromOffset(48, 11),
        Size = UDim2.new(1, -62, 0, 18),
        TextSize = 13,
        Color = self.Theme.Text,
    })

    createText(notification, self.Theme, {
        Name = "Content",
        Text = content,
        Position = UDim2.fromOffset(48, 29),
        Size = UDim2.new(1, -62, 0, 32),
        TextSize = 11,
        Color = self.Theme.Muted,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
    })

    tween(notification, {
        BackgroundTransparency = 0,
        Size = UDim2.fromOffset(292, 70),
    }, 0.18)

    local outline = notification:FindFirstChildOfClass("UIStroke")
    if outline then
        tween(outline, { Transparency = 0.2 }, 0.18)
    end

    task.delay(duration, function()
        if not notification.Parent then
            return
        end

        tween(notification, {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(292, 0),
        }, 0.16)

        if outline then
            tween(outline, { Transparency = 1 }, 0.16)
        end

        task.delay(0.16, function()
            if notification.Parent then
                notification:Destroy()
            end
        end)
    end)
end

function WindowMethods:GetFlag(flag)
    return self.Flags[flag]
end

function WindowMethods:SetFlag(flag, value)
    local control = self.Options[flag]

    if control and control.Set then
        control:Set(value)
    else
        self.Flags[flag] = value
    end
end

function TabMethods:CreatePage(name)
    local window = self.Window

    local page = setmetatable({
        Tab = self,
        Window = window,
        Name = name or "Page",
        Sections = {},
    }, { __index = PageMethods })

    local button = create("TextButton", {
        Parent = window.PageTabs,
        Name = page.Name,
        BackgroundColor3 = window.Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(math.max(66, (#page.Name * 7) + 22), 24),
        Text = page.Name,
        TextColor3 = window.Theme.Muted,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Visible = false,
    }, {
        corner(6),
    })

    local frame = create("ScrollingFrame", {
        Parent = window.Content,
        Name = page.Name,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 94),
        Size = UDim2.new(1, -28, 1, -106),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = window.Theme.MutedDark,
        CanvasSize = UDim2.fromOffset(0, 0),
        Visible = false,
    }, {
        padding(0, 0, 3, 12),
    })

    local layout = listLayout(Enum.FillDirection.Vertical, 10)
    layout.Parent = frame
    automaticCanvas(frame, layout)

    page.Button = button
    page.Frame = frame
    page.Layout = layout

    button.MouseButton1Click:Connect(function()
        selectPage(page)
    end)

    table.insert(self.Pages, page)

    if window.ActiveTab == self then
        button.Visible = true

        if not self.ActivePage then
            selectPage(page)
        end
    end

    return page
end

function TabMethods:CreateSection(title)
    if not self.ActivePage and not self.Pages[1] then
        self:CreatePage("Common")
    end

    return (self.ActivePage or self.Pages[1]):CreateSection(title)
end

function TabMethods:CreateButton(options)
    return self:CreateSection(options and options.Section or "Main"):CreateButton(options)
end

function TabMethods:CreateToggle(options)
    return self:CreateSection(options and options.Section or "Main"):CreateToggle(options)
end

function TabMethods:CreateSlider(options)
    return self:CreateSection(options and options.Section or "Main"):CreateSlider(options)
end

function TabMethods:CreateDropdown(options)
    return self:CreateSection(options and options.Section or "Main"):CreateDropdown(options)
end

function TabMethods:CreateInput(options)
    return self:CreateSection(options and options.Section or "Main"):CreateInput(options)
end

function TabMethods:CreateKeybind(options)
    return self:CreateSection(options and options.Section or "Main"):CreateKeybind(options)
end

function PageMethods:CreateSection(title)
    local section = setmetatable({
        Page = self,
        Tab = self.Tab,
        Window = self.Window,
        Title = title or "Section",
    }, { __index = SectionMethods })

    local holder = create("Frame", {
        Parent = self.Frame,
        Name = section.Title,
        BackgroundColor3 = self.Window.Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        corner(7),
        stroke(self.Window.Theme.Border, 0.3, 1),
        padding(12, 10, 12, 12),
    })

    local layout = listLayout(Enum.FillDirection.Vertical, 4)
    layout.Parent = holder

    createText(holder, self.Window.Theme, {
        Name = "Title",
        Text = section.Title,
        Size = UDim2.new(1, 0, 0, 20),
        TextSize = 12,
        Color = self.Window.Theme.Muted,
    })

    section.Frame = holder
    section.Content = holder
    section.Layout = layout

    table.insert(self.Sections, section)

    return section
end

function PageMethods:CreateButton(options)
    return self:CreateSection(options and options.Section or "Main"):CreateButton(options)
end

function PageMethods:CreateToggle(options)
    return self:CreateSection(options and options.Section or "Main"):CreateToggle(options)
end

function PageMethods:CreateSlider(options)
    return self:CreateSection(options and options.Section or "Main"):CreateSlider(options)
end

function PageMethods:CreateDropdown(options)
    return self:CreateSection(options and options.Section or "Main"):CreateDropdown(options)
end

function PageMethods:CreateInput(options)
    return self:CreateSection(options and options.Section or "Main"):CreateInput(options)
end

function PageMethods:CreateKeybind(options)
    return self:CreateSection(options and options.Section or "Main"):CreateKeybind(options)
end

function SectionMethods:CreateLabel(text)
    local theme = self.Window.Theme
    local row = createSectionRow(self, 24, "Label")

    createText(row, theme, {
        Text = tostring(text or "Label"),
        Size = UDim2.new(1, 0, 1, 0),
        TextSize = 12,
        Color = theme.Text,
    })

    return row
end

function SectionMethods:CreateParagraph(options)
    options = options or {}
    local theme = self.Window.Theme
    local row = createSectionRow(self, options.Height or 62, "Paragraph")

    createText(row, theme, {
        Text = options.Title or "Paragraph",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 18),
        TextSize = 13,
        Color = theme.Text,
    })

    createText(row, theme, {
        Text = options.Content or options.Text or "",
        Position = UDim2.fromOffset(0, 20),
        Size = UDim2.new(1, 0, 1, -20),
        TextSize = 11,
        Color = theme.Muted,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
    })

    return row
end

function SectionMethods:CreateDivider()
    return create("Frame", {
        Parent = self.Content,
        Name = "Divider",
        BackgroundColor3 = self.Window.Theme.Border,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
    })
end

function SectionMethods:CreateButton(options)
    options = options or {}
    local theme = self.Window.Theme
    local callback = options.Callback or options.Func or function() end
    local row = createSectionRow(self, 34, "Button")

    local button = create("TextButton", {
        Parent = row,
        Name = "Button",
        BackgroundColor3 = theme.SurfaceLight,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = options.Name or options.Text or options.Title or "Button",
        TextColor3 = theme.Muted,
        TextSize = 12,
        AutoButtonColor = false,
    }, {
        corner(7),
    })

    connectHover(button, theme.SurfaceLight, theme.SurfaceHover)

    button.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)

    return button
end

function SectionMethods:CreateToggle(options)
    options = options or {}

    local theme = self.Window.Theme
    local window = self.Window
    local callback = options.Callback or function() end
    local value = options.Default == true
    local row = createSectionRow(self, options.Description and 48 or 36, "Toggle")

    createControlText(self, row, options.Name or options.Text or options.Title or "Toggle", options.Description)

    local hitbox = create("TextButton", {
        Parent = row,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        AutoButtonColor = false,
    })

    local track = create("Frame", {
        Parent = row,
        Name = "Track",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(31, 18),
        BackgroundColor3 = value and theme.Accent or theme.SurfaceLight,
        BorderSizePixel = 0,
    }, {
        corner(9),
    })

    local knob = create("Frame", {
        Parent = track,
        Name = "Knob",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = value and UDim2.fromOffset(15, 9) or UDim2.fromOffset(3, 9),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = value and theme.Background or theme.Muted,
        BorderSizePixel = 0,
    }, {
        corner(6),
    })

    local control = {}

    function control:Set(newValue)
        value = newValue == true
        setFlag(window, options.Flag, value, control)
        tween(track, { BackgroundColor3 = value and theme.Accent or theme.SurfaceLight }, 0.14)
        tween(knob, {
            Position = value and UDim2.fromOffset(15, 9) or UDim2.fromOffset(3, 9),
            BackgroundColor3 = value and theme.Background or theme.Muted,
        }, 0.14)
        task.spawn(callback, value)
    end

    function control:Get()
        return value
    end

    hitbox.MouseButton1Click:Connect(function()
        control:Set(not value)
    end)

    setFlag(window, options.Flag, value, control)

    if options.CallbackOnCreation then
        task.spawn(callback, value)
    end

    return control
end

function SectionMethods:CreateSlider(options)
    options = options or {}

    local theme = self.Window.Theme
    local window = self.Window
    local callback = options.Callback or function() end
    local min = options.Min or options.Minimum or 0
    local max = options.Max or options.Maximum or 100
    if max < min then
        min, max = max, min
    end

    local step = options.Step or options.Increment or 1
    local range = math.max(max - min, 0.0001)
    local decimals = options.Decimals or options.Rounding or (step < 1 and 2 or 0)
    local suffix = options.Suffix or ""
    local value = math.clamp(options.Default or min, min, max)
    value = roundToStep(value, step)

    local row = createSectionRow(self, 62, "Slider")
    createControlText(self, row, options.Name or options.Text or options.Title or "Slider", options.Description)

    local valueLabel = createText(row, theme, {
        Name = "Value",
        Text = formatNumber(value, decimals) .. suffix,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 3),
        Size = UDim2.fromOffset(80, 18),
        TextSize = 11,
        Color = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local bar = create("Frame", {
        Parent = row,
        Name = "Bar",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, -8),
        Size = UDim2.new(1, 0, 0, 4),
        BackgroundColor3 = theme.SurfaceLight,
        BorderSizePixel = 0,
    }, {
        corner(2),
    })

    local fill = create("Frame", {
        Parent = bar,
        Name = "Fill",
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromScale((value - min) / range, 1),
    }, {
        corner(2),
    })

    local knob = create("Frame", {
        Parent = bar,
        Name = "Knob",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale((value - min) / range, 0.5),
        Size = UDim2.fromOffset(11, 11),
        BackgroundColor3 = theme.Text,
        BorderSizePixel = 0,
    }, {
        corner(6),
    })

    local dragging = false
    local control = {}

    local function updateVisual()
        local alpha = (value - min) / range
        alpha = math.clamp(alpha, 0, 1)
        valueLabel.Text = formatNumber(value, decimals) .. suffix
        fill.Size = UDim2.fromScale(alpha, 1)
        knob.Position = UDim2.fromScale(alpha, 0.5)
    end

    local function setFromPosition(x)
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local rawValue = min + (range * alpha)
        control:Set(rawValue)
    end

    function control:Set(newValue)
        value = math.clamp(roundToStep(newValue, step), min, max)
        setFlag(window, options.Flag, value, control)
        updateVisual()
        task.spawn(callback, value)
    end

    function control:Get()
        return value
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromPosition(input.Position.X)
        end
    end)

    table.insert(window.Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromPosition(input.Position.X)
        end
    end))

    table.insert(window.Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    setFlag(window, options.Flag, value, control)
    updateVisual()

    if options.CallbackOnCreation then
        task.spawn(callback, value)
    end

    return control
end

function SectionMethods:CreateDropdown(options)
    options = options or {}

    local theme = self.Window.Theme
    local window = self.Window
    local callback = options.Callback or function() end
    local values = options.Values or options.Options or {}
    local value = options.Default or values[1]
    local open = false

    local row = createSectionRow(self, 48, "Dropdown")
    createControlText(self, row, options.Name or options.Text or options.Title or "Dropdown", options.Description)

    local button = create("TextButton", {
        Parent = row,
        Name = "Button",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 5),
        Size = UDim2.fromOffset(150, 28),
        BackgroundColor3 = theme.SurfaceLight,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = tostring(value or "Select"),
        TextColor3 = theme.Muted,
        TextSize = 11,
        AutoButtonColor = false,
    }, {
        corner(6),
    })

    local list = create("Frame", {
        Parent = row,
        Name = "List",
        BackgroundColor3 = theme.SurfaceLight,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -150, 0, 38),
        Size = UDim2.fromOffset(150, 0),
        ClipsDescendants = true,
        Visible = false,
    }, {
        corner(6),
        stroke(theme.Border, 0.35, 1),
        listLayout(Enum.FillDirection.Vertical, 0),
    })

    local control = {}

    local function rebuild()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, item in ipairs(values) do
            local itemButton = create("TextButton", {
                Parent = list,
                Name = tostring(item),
                BackgroundColor3 = theme.SurfaceLight,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 26),
                Font = Enum.Font.Gotham,
                Text = tostring(item),
                TextColor3 = theme.Muted,
                TextSize = 11,
                AutoButtonColor = false,
            })

            connectHover(itemButton, theme.SurfaceLight, theme.SurfaceHover)

            itemButton.MouseButton1Click:Connect(function()
                control:Set(item)
                setOpen(false)
            end)
        end
    end

    local function setOpen(nextOpen)
        open = nextOpen
        list.Visible = open
        local height = math.min(#values, 6) * 26
        row.Size = open and UDim2.new(1, 0, 0, 48 + height + 6) or UDim2.new(1, 0, 0, 48)
        tween(list, { Size = UDim2.fromOffset(150, open and height or 0) }, 0.14)
    end

    function control:Set(newValue)
        value = newValue
        button.Text = tostring(value or "Select")
        setFlag(window, options.Flag, value, control)
        task.spawn(callback, value)
    end

    function control:Get()
        return value
    end

    function control:Refresh(newValues, keepValue)
        values = newValues or {}
        if not keepValue then
            value = values[1]
            button.Text = tostring(value or "Select")
        end
        rebuild()
        setOpen(false)
    end

    button.MouseButton1Click:Connect(function()
        setOpen(not open)
    end)

    connectHover(button, theme.SurfaceLight, theme.SurfaceHover)
    rebuild()
    setFlag(window, options.Flag, value, control)

    if options.CallbackOnCreation then
        task.spawn(callback, value)
    end

    return control
end

function SectionMethods:CreateInput(options)
    options = options or {}

    local theme = self.Window.Theme
    local window = self.Window
    local callback = options.Callback or function() end
    local value = options.Default or ""
    local row = createSectionRow(self, options.Description and 50 or 38, "Input")

    createControlText(self, row, options.Name or options.Text or options.Title or "Input", options.Description)

    local box = create("TextBox", {
        Parent = row,
        Name = "Input",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 5),
        Size = UDim2.fromOffset(150, 28),
        BackgroundColor3 = theme.SurfaceLight,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderText = options.Placeholder or "",
        PlaceholderColor3 = theme.MutedDark,
        Text = tostring(value),
        TextColor3 = theme.Muted,
        TextSize = 11,
    }, {
        corner(6),
        padding(8, 0, 8, 0),
    })

    local control = {}

    function control:Set(newValue)
        value = tostring(newValue or "")
        box.Text = value
        setFlag(window, options.Flag, value, control)
        task.spawn(callback, value)
    end

    function control:Get()
        return value
    end

    box.FocusLost:Connect(function(enterPressed)
        if options.OnlyOnEnter and not enterPressed then
            return
        end

        control:Set(box.Text)
    end)

    setFlag(window, options.Flag, value, control)

    if options.CallbackOnCreation then
        task.spawn(callback, value)
    end

    return control
end

function SectionMethods:CreateKeybind(options)
    options = options or {}

    local theme = self.Window.Theme
    local window = self.Window
    local callback = options.Callback or function() end
    local value = options.Default or Enum.KeyCode.RightShift
    local waiting = false
    local row = createSectionRow(self, options.Description and 50 or 38, "Keybind")

    createControlText(self, row, options.Name or options.Text or options.Title or "Keybind", options.Description)

    local button = create("TextButton", {
        Parent = row,
        Name = "Button",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 5),
        Size = UDim2.fromOffset(150, 28),
        BackgroundColor3 = theme.SurfaceLight,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = value.Name,
        TextColor3 = theme.Muted,
        TextSize = 11,
        AutoButtonColor = false,
    }, {
        corner(6),
    })

    local control = {}

    function control:Set(newValue)
        value = newValue
        button.Text = value and value.Name or "None"
        setFlag(window, options.Flag, value, control)
    end

    function control:Get()
        return value
    end

    button.MouseButton1Click:Connect(function()
        waiting = true
        button.Text = "Press key..."
    end)

    table.insert(window.Connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if waiting then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                control:Set(input.KeyCode)
            end

            waiting = false
            return
        end

        if value and input.KeyCode == value then
            task.spawn(callback, input.KeyCode)
        end
    end))

    connectHover(button, theme.SurfaceLight, theme.SurfaceHover)
    setFlag(window, options.Flag, value, control)

    return control
end

WindowMethods.AddTab = WindowMethods.CreateTab
WindowMethods.AddKeyTab = WindowMethods.CreateTab
WindowMethods.AddNotification = WindowMethods.Notify
WindowMethods.Notification = WindowMethods.Notify

TabMethods.AddPage = TabMethods.CreatePage
TabMethods.AddSection = TabMethods.CreateSection
TabMethods.AddGroupbox = TabMethods.CreateSection
TabMethods.AddLeftGroupbox = TabMethods.CreateSection
TabMethods.AddRightGroupbox = TabMethods.CreateSection
TabMethods.AddButton = TabMethods.CreateButton
TabMethods.AddToggle = TabMethods.CreateToggle
TabMethods.AddSlider = TabMethods.CreateSlider
TabMethods.AddDropdown = TabMethods.CreateDropdown
TabMethods.AddInput = TabMethods.CreateInput
TabMethods.AddKeybind = TabMethods.CreateKeybind

PageMethods.AddSection = PageMethods.CreateSection
PageMethods.AddGroupbox = PageMethods.CreateSection
PageMethods.AddLeftGroupbox = PageMethods.CreateSection
PageMethods.AddRightGroupbox = PageMethods.CreateSection
PageMethods.AddButton = PageMethods.CreateButton
PageMethods.AddToggle = PageMethods.CreateToggle
PageMethods.AddSlider = PageMethods.CreateSlider
PageMethods.AddDropdown = PageMethods.CreateDropdown
PageMethods.AddInput = PageMethods.CreateInput
PageMethods.AddKeybind = PageMethods.CreateKeybind

SectionMethods.AddLabel = SectionMethods.CreateLabel
SectionMethods.AddParagraph = SectionMethods.CreateParagraph
SectionMethods.AddDivider = SectionMethods.CreateDivider
SectionMethods.AddButton = SectionMethods.CreateButton
SectionMethods.AddToggle = SectionMethods.CreateToggle
SectionMethods.AddSlider = SectionMethods.CreateSlider
SectionMethods.AddDropdown = SectionMethods.CreateDropdown
SectionMethods.AddInput = SectionMethods.CreateInput
SectionMethods.AddKeybind = SectionMethods.CreateKeybind

return Solis
