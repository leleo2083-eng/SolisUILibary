--[[
	Solis UI — single-file Roblox UI library
	Pure Instance.new with a built-in branded layout and toast notifications.
	The default logo uses Roblox asset 105894109382235 and can be overridden.

	GitHub import:
		local Library = loadstring(game:HttpGet(
			"https://raw.githubusercontent.com/YOUR_NAME/YOUR_REPO/main/SolisUI.lua"
		))()

	Basic API:
		local Window = Library:CreateWindow({ Name = "Menu" })
		local Tab = Window:AddTab({ Name = "Home", Subtitle = "...", Icon = "H" })
		local Sub = Tab:AddSubTab("General")

		Sub:AddToggle({ Name, Description, Default, Callback })
		Sub:AddButton({ Name, Callback })
		Sub:AddInput({ Name, Description, Placeholder, Default, Callback })
		Sub:AddDropdown({ Name, Description, Options, Default, Callback })
		Sub:AddSlider({ Name, Min, Max, Default, Suffix, Callback })

	Toggle, input, dropdown, and slider handles support :Set(value) and :Get().

	Built-in themes:
		Library:SetTheme("Dark")
		Library:SetTheme("Light")
		Library:SetTheme("OLED")
		Library:SetTheme(customThemeTable)

	Notifications:
		Window:Notify({ Title, Content, Type, Duration, Callback })
		Library:Notify({ Title, Content, Type, Duration, Callback })
		Types: "Info", "Success", "Warning", "Error"

	Window helpers:
		Window:SetVisible(boolean)
		Window:Toggle()
		Window:SetLogo(assetId)
		Window:Destroy()
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local Players          = game:GetService("Players")

local DEFAULT_LOGO = "rbxassetid://105894109382235"
local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local NOTIFICATION_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local NOTIFICATION_STYLES = {
	info = {
		Name = "Info",
		Color = Color3.fromRGB(118, 151, 194),
	},
	success = {
		Name = "Success",
		Color = Color3.fromRGB(105, 166, 124),
	},
	warning = {
		Name = "Warning",
		Color = Color3.fromRGB(190, 154, 84),
	},
	error = {
		Name = "Error",
		Color = Color3.fromRGB(190, 99, 99),
	},
}

--------------------------------------------------------------------------------
-- Palette (fully monochrome)
--------------------------------------------------------------------------------

-- Default palette (= the "Dark" theme in themes.lua). Every key keeps a
-- UNIQUE value so a color can be reverse-mapped to its role when tagging
-- instances for retheming; the ±1 steps from the design hexes are invisible.
local C = {
	WindowBg     = Color3.fromRGB(20, 20, 20),    -- #141414
	CardBg       = Color3.fromRGB(24, 24, 24),    -- #181818
	Border       = Color3.fromRGB(35, 35, 35),    -- #232323
	Element      = Color3.fromRGB(31, 31, 31),    -- #1F1F1F
	ElementHover = Color3.fromRGB(38, 38, 38),    -- #262626
	Badge        = Color3.fromRGB(42, 42, 42),    -- #2A2A2A
	BadgeIdle    = Color3.fromRGB(34, 34, 34),    -- #222222
	NavActive    = Color3.fromRGB(30, 30, 30),    -- #1E1E1E
	NavHover     = Color3.fromRGB(26, 26, 26),    -- #1A1A1A
	PillActive   = Color3.fromRGB(36, 36, 36),    -- #242424
	White        = Color3.fromRGB(255, 255, 255),
	TextGray     = Color3.fromRGB(154, 154, 154), -- #9A9A9A
	TextDim      = Color3.fromRGB(139, 139, 139), -- #8B8B8B
	KnobOff      = Color3.fromRGB(85, 85, 85),    -- #555555
	KnobOn       = Color3.fromRGB(17, 17, 17),    -- #111111
	TrackBg      = Color3.fromRGB(43, 43, 43),    -- #2B2B2B
	Placeholder  = Color3.fromRGB(86, 86, 86),    -- #565656
}

-- Built into this file so consumers only need one GitHub request.
-- Keep values unique within each theme; the library uses color values to tag
-- newly-created instances with their palette role.
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
	},
}

-- Reverse lookup (hex -> palette key), rebuilt on every theme change. Used
-- to tag created instances with the palette role they were painted with so
-- Library:SetTheme can repaint the live UI.
local REVERSE = {}
local function rebuildReverse()
	table.clear(REVERSE)
	for key, color in pairs(C) do
		REVERSE[color:ToHex()] = key
	end
end
rebuildReverse()

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function tween(inst, props)
	TweenService:Create(inst, TWEEN, props):Play()
end

-- Recolors a themable property and updates its theme tag, so state changes
-- (active tab, toggle on/off) survive a later SetTheme repaint.
local function paint(inst, prop, key, instant)
	inst:SetAttribute("Theme_" .. prop, key)
	if instant then
		inst[prop] = C[key]
	else
		tween(inst, { [prop] = C[key] })
	end
end

local function make(className, props)
	local inst = Instance.new(className)
	if inst:IsA("GuiObject") then
		inst.BorderSizePixel = 0
		inst.BackgroundColor3 = C.WindowBg
	end
	if inst:IsA("GuiButton") then
		inst.AutoButtonColor = false
	end
	if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
		inst.Font = Enum.Font.Gotham
		inst.TextColor3 = C.White
		inst.TextSize = 13
	end
	for k, v in pairs(props) do
		if k ~= "Parent" then
			inst[k] = v
		end
	end
	-- Tag themable colors with their palette role for SetTheme repaints.
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

local function corner(parent, radius)
	return make("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

local function circle(parent)
	return make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent })
end

local function stroke(parent, color)
	return make("UIStroke", {
		Color = color or C.Border,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function pad(parent, top, bottom, left, right)
	return make("UIPadding", {
		PaddingTop = UDim.new(0, top),
		PaddingBottom = UDim.new(0, bottom),
		PaddingLeft = UDim.new(0, left),
		PaddingRight = UDim.new(0, right),
		Parent = parent,
	})
end

-- Keeps UIListLayout children in creation order.
local function autoOrder(inst)
	inst.LayoutOrder = #inst.Parent:GetChildren()
end

local function isInside(gui, pos)
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local function fire(callback, ...)
	if typeof(callback) == "function" then
		task.spawn(callback, ...)
	end
end

local function normalizeAssetId(value)
	if value == nil or value == "" then
		return DEFAULT_LOGO
	end
	if type(value) == "number" then
		return "rbxassetid://" .. tostring(math.floor(value))
	end
	local text = tostring(value)
	if string.match(text, "^rbxassetid://")
		or string.match(text, "^rbxthumb://")
		or string.match(text, "^https?://") then
		return text
	end
	local id = string.match(text, "%d+")
	return id and ("rbxassetid://" .. id) or DEFAULT_LOGO
end

local function getNotificationStyle(kind)
	local key = string.lower(tostring(kind or "Info"))
	return NOTIFICATION_STYLES[key] or NOTIFICATION_STYLES.info
end

-- True only if the gui and every GuiObject ancestor is visible.
local function guiVisible(gui)
	local node = gui
	while node and node:IsA("GuiObject") do
		if not node.Visible then
			return false
		end
		node = node.Parent
	end
	return true
end

-- Drags the frame from anywhere except the rects in `blockers`.
-- GuiObject.InputBegan also fires on ancestors when a child button is
-- pressed (Active does not sink input to ancestors), so interactive
-- regions must be excluded by hit-testing.
local function makeDraggable(frame, blockers)
	local dragging = false
	local dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local pos = Vector2.new(input.Position.X, input.Position.Y)
		for _, gui in ipairs(blockers) do
			if guiVisible(gui) and isInside(gui, pos) then
				return
			end
		end
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
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

--------------------------------------------------------------------------------
-- Drawn icons (Frames only — guaranteed to render on any client)
--------------------------------------------------------------------------------

-- Three stacked bars ("sort" icon) for the dropdown button.
local function sortIcon(parent)
	local holder = make("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -7, 0.5, 0),
		Size = UDim2.fromOffset(9, 7),
		Parent = parent,
	})
	for i, width in ipairs({ 9, 7, 5 }) do
		make("Frame", {
			Position = UDim2.fromOffset(0, (i - 1) * 3),
			Size = UDim2.fromOffset(width, 1),
			BackgroundColor3 = C.TextDim,
			Parent = holder,
		})
	end
	return holder
end

-- Tiny "text field with caret" icon for the input box.
local function inputIcon(parent)
	local holder = make("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -7, 0.5, 0),
		Size = UDim2.fromOffset(10, 10),
		Parent = parent,
	})
	local box = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = holder,
	})
	corner(box, 2)
	stroke(box, C.TextDim)
	make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(1, 4),
		BackgroundColor3 = C.TextDim,
		Parent = holder,
	})
	return holder
end

--------------------------------------------------------------------------------
-- Classes
--------------------------------------------------------------------------------

local Library = {
	Version = "2.0.3-clean",
	Themes = THEMES,
	DefaultLogo = DEFAULT_LOGO,
	_windows = {},
	_windowObjects = {},
	_currentTheme = "Dark",
}
local Window = {}  Window.__index = Window
local Tab    = {}  Tab.__index = Tab
local SubTab = {}  SubTab.__index = SubTab

--------------------------------------------------------------------------------
-- Theming
--------------------------------------------------------------------------------

local THEME_PROPS = {
	"BackgroundColor3", "TextColor3", "PlaceholderColor3",
	"ScrollBarImageColor3", "Color",
}

-- Applies a theme table (palette key -> Color3, see themes.lua) to every
-- window, tweening all tagged instances to their new colors.
function Library:SetTheme(theme)
	local themeName = nil
	if type(theme) == "string" then
		themeName = theme
		theme = THEMES[theme]
		if not theme then
			warn(("[Solis UI] unknown theme %q"):format(themeName))
			return false
		end
	elseif type(theme) ~= "table" then
		warn("[Solis UI] SetTheme expects a built-in theme name or theme table")
		return false
	end

	-- Validate first so a bad custom theme cannot partially recolor the UI.
	for key in pairs(C) do
		local value = theme[key]
		if value ~= nil and typeof(value) ~= "Color3" then
			warn(("[Solis UI] theme key %s must be a Color3"):format(key))
			return false
		end
	end
	for key in pairs(C) do
		local value = theme[key]
		if value ~= nil then
			C[key] = value
		end
	end

	Library._currentTheme = themeName or "Custom"
	rebuildReverse()
	for _, gui in ipairs(Library._windows) do
		if gui and gui.Parent then
			for _, inst in ipairs(gui:GetDescendants()) do
				local goal
				for _, prop in ipairs(THEME_PROPS) do
					local key = inst:GetAttribute("Theme_" .. prop)
					if key and C[key] then
						goal = goal or {}
						goal[prop] = C[key]
					end
				end
				if goal then
					tween(inst, goal)
				end
			end
		end
	end
	return true
end

function Library:GetTheme()
	return Library._currentTheme
end

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

-- Compatibility spelling for scripts that used `Notification` instead.
function Library:Notification(opts)
	return self:Notify(opts)
end

function Library:DestroyAll()
	local windows = table.clone(Library._windows)
	for _, screenGui in ipairs(windows) do
		if screenGui then
			screenGui:Destroy()
		end
	end
	table.clear(Library._windows)
	table.clear(Library._windowObjects or {})
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

function Library:CreateWindow(opts)
	opts = opts or {}

	local logoAsset = normalizeAssetId(opts.Logo or DEFAULT_LOGO)
	local windowSize = opts.Size or UDim2.fromOffset(700, 490)
	local windowPosition = opts.Position or UDim2.fromScale(0.5, 0.5)

	local screenGui = make("ScreenGui", {
		Name = opts.GuiName or "SolisUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = opts.DisplayOrder or 10,
	})

	-- Optional explicit parent; otherwise executor/CoreGui first and PlayerGui fallback.
	if typeof(opts.Parent) == "Instance" then
		screenGui.Parent = opts.Parent
	else
		local ok = pcall(function()
			screenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
		end)
		if not ok then
			screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
		end
	end
	table.insert(Library._windows, screenGui)

	local main = make("Frame", {
		Name = "Main",
		Size = windowSize,
		Position = windowPosition,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = C.WindowBg,
		ClipsDescendants = true,
		ZIndex = 2,
		Parent = screenGui,
	})
	corner(main, 12)
	stroke(main, C.Border)


	-- Regions that must never start a window drag: nav buttons, sub-tab
	-- pills, content pages and open dropdown lists register themselves here.
	local noDrag = {}
	makeDraggable(main, noDrag)

	-- Left sidebar -----------------------------------------------------------
	local sidebar = make("Frame", {
		Size = UDim2.new(0, 190, 1, 0),
		BackgroundTransparency = 1,
		Parent = main,
	})

	local brand = make("Frame", {
		Name = "Brand",
		Position = UDim2.fromOffset(12, 12),
		Size = UDim2.new(1, -24, 0, 54),
		BackgroundColor3 = C.CardBg,
		Parent = sidebar,
	})
	corner(brand, 10)
	stroke(brand, C.Border)

	local logoHolder = make("Frame", {
		Position = UDim2.fromOffset(9, 9),
		Size = UDim2.fromOffset(36, 36),
		BackgroundColor3 = C.Element,
		Parent = brand,
	})
	corner(logoHolder, 9)

	make("TextLabel", {
		Text = "S",
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextColor3 = C.White,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = logoHolder,
	})

	local brandLogo = make("ImageLabel", {
		Name = "Logo",
		Image = logoAsset,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.new(1, -6, 1, -6),
		ScaleType = Enum.ScaleType.Fit,
		Parent = logoHolder,
	})

	make("TextLabel", {
		Text = opts.Name or "Solis UI",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = C.White,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(54, 9),
		Size = UDim2.new(1, -62, 0, 17),
		Parent = brand,
	})

	make("TextLabel", {
		Text = opts.BrandSubtitle or ("SOLIS LIBRARY  •  v" .. Library.Version),
		Font = Enum.Font.GothamMedium,
		TextSize = 9,
		TextColor3 = C.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(54, 28),
		Size = UDim2.new(1, -62, 0, 13),
		Parent = brand,
	})

	local navList = make("Frame", {
		Position = UDim2.fromOffset(0, 78),
		Size = UDim2.new(1, 0, 1, -112),
		BackgroundTransparency = 1,
		Parent = sidebar,
	})
	pad(navList, 0, 8, 12, 12)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 7),
		Parent = navList,
	})

	local statusDot = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 16, 1, -19),
		Size = UDim2.fromOffset(6, 6),
		BackgroundColor3 = NOTIFICATION_STYLES.success.Color,
		Parent = sidebar,
	})
	circle(statusDot)
	make("TextLabel", {
		Text = opts.StatusText or "Solis is ready",
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = C.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 28, 1, -27),
		Size = UDim2.new(1, -40, 0, 16),
		Parent = sidebar,
	})

	-- Vertical separator
	make("Frame", {
		Position = UDim2.fromOffset(190, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = C.Border,
		Parent = main,
	})

	-- Right content area -----------------------------------------------------
	local content = make("Frame", {
		Position = UDim2.fromOffset(191, 0),
		Size = UDim2.new(1, -191, 1, 0),
		BackgroundTransparency = 1,
		Parent = main,
	})

	-- Notifications are outside the main window so they remain unclipped.
	local notificationHolder = make("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.new(0, 300, 1, -32),
		BackgroundTransparency = 1,
		ZIndex = 200,
		Parent = screenGui,
	})
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		Parent = notificationHolder,
	})

	local window = setmetatable({
		ScreenGui = screenGui,
		Main = main,
		Logo = brandLogo,
		_logoAsset = logoAsset,
		_navList = navList,
		_content = content,
		_notificationHolder = notificationHolder,
		_notificationOrder = 0,
		_noDrag = noDrag,
		_tabs = {},
		_activeTab = nil,
	}, Window)

	-- Bind Notify directly onto every returned window as well as exposing it
	-- through the Window metatable. Some executors/loaders have returned a
	-- plain copied table and dropped its metatable, which caused
	-- `attempt to call missing method 'Notify' of table`. This closure keeps
	-- notifications working with both colon and dot call styles even then.
	window.Notify = function(selfOrOptions, maybeOptions)
		local notificationOptions
		if selfOrOptions == window then
			notificationOptions = maybeOptions
		else
			notificationOptions = selfOrOptions
		end
		return Window.Notify(window, notificationOptions)
	end
	window.Notification = window.Notify -- backwards-compatible alias

	table.insert(Library._windowObjects, window)

	if opts.Visible == false then
		screenGui.Enabled = false
	end

	return window
end

function Window:SetVisible(visible)
	self.ScreenGui.Enabled = visible == true
end

function Window:Toggle()
	self.ScreenGui.Enabled = not self.ScreenGui.Enabled
	return self.ScreenGui.Enabled
end

function Window:SetLogo(assetId)
	self._logoAsset = normalizeAssetId(assetId)
	if self.Logo then
		self.Logo.Image = self._logoAsset
	end
	return self._logoAsset
end

function Window:Notify(opts)
	if type(opts) == "string" then
		opts = { Content = opts }
	end
	opts = opts or {}

	local holder = self._notificationHolder
	if not holder or not holder.Parent then
		return nil
	end

	local style = getNotificationStyle(opts.Type)
	local duration = tonumber(opts.Duration)
	if duration == nil then duration = 4 end
	duration = math.max(duration, 0)
	self._notificationOrder = self._notificationOrder + 1

	local titleText = tostring(opts.Title or style.Name)
	local contentText = tostring(opts.Content or opts.Description or opts.Message or "Notification")

	local slot = make("Frame", {
		Name = "NotificationSlot",
		Size = UDim2.new(1, 0, 0, 62),
		BackgroundTransparency = 1,
		LayoutOrder = self._notificationOrder,
		ZIndex = 200,
		Parent = holder,
	})

	-- Intentionally flat and minimal: no icon, logo, shadow, accent stripe,
	-- oversized badge, or decorative animation.
	local card = make("CanvasGroup", {
		Name = style.Name .. "Notification",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 12, 0, 0),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = C.CardBg,
		GroupTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 201,
		Parent = slot,
	})
	corner(card, 6)
	stroke(card, C.Border)

	make("TextLabel", {
		Text = titleText,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = C.White,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 9),
		Size = UDim2.new(1, -42, 0, 16),
		ZIndex = 202,
		Parent = card,
	})

	make("TextLabel", {
		Text = contentText,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 29),
		Size = UDim2.new(1, -24, 0, 24),
		ZIndex = 202,
		Parent = card,
	})

	local closeButton = make("TextButton", {
		Text = "×",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = C.TextDim,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -7, 0, 5),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		ZIndex = 204,
		Parent = card,
	})

	local closed = false
	local handle = {}

	local function close(reason)
		if closed then return end
		closed = true
		TweenService:Create(card, NOTIFICATION_TWEEN, {
			Position = UDim2.new(1, 12, 0, 0),
			GroupTransparency = 1,
		}):Play()
		task.delay(0.2, function()
			if slot and slot.Parent then
				slot:Destroy()
			end
		end)
		fire(opts.Callback or opts.OnClose, reason or "closed")
	end

	function handle:Close()
		close("manual")
	end

	function handle:IsOpen()
		return not closed
	end

	closeButton.MouseEnter:Connect(function()
		tween(closeButton, { TextColor3 = C.White })
	end)
	closeButton.MouseLeave:Connect(function()
		tween(closeButton, { TextColor3 = C.TextDim })
	end)
	closeButton.MouseButton1Click:Connect(function()
		close("manual")
	end)

	TweenService:Create(card, NOTIFICATION_TWEEN, {
		Position = UDim2.new(1, 0, 0, 0),
		GroupTransparency = 0,
	}):Play()

	if duration > 0 then
		task.delay(duration, function()
			close("timeout")
		end)
	end

	return handle
end

function Window:Destroy()
	local index = table.find(Library._windows, self.ScreenGui)
	if index then
		table.remove(Library._windows, index)
	end
	local objectIndex = table.find(Library._windowObjects, self)
	if objectIndex then
		table.remove(Library._windowObjects, objectIndex)
	end
	if self.ScreenGui then
		self.ScreenGui:Destroy()
	end
end

function Window:_selectTab(tab)
	if self._activeTab == tab then return end
	local prev = self._activeTab
	self._activeTab = tab

	if prev then
		prev._page.Visible = false
		paint(prev._nav, "BackgroundColor3", "WindowBg")
		paint(prev._navLabel, "TextColor3", "TextGray")
		paint(prev._navBadge, "BackgroundColor3", "BadgeIdle")
		paint(prev._navIcon, "TextColor3", "TextGray")
	end

	tab._page.Visible = true
	paint(tab._nav, "BackgroundColor3", "NavActive")
	paint(tab._navLabel, "TextColor3", "White")
	paint(tab._navBadge, "BackgroundColor3", "Badge")
	paint(tab._navIcon, "TextColor3", "White")
end

function Window:AddTab(opts)
	if type(opts) == "string" then opts = { Name = opts } end
	opts = opts or {}
	local name = opts.Name or "Tab"
	local icon = opts.Icon or string.upper(string.sub(name, 1, 1))
	local window = self

	-- Sidebar nav button -------------------------------------------------
	local nav = make("TextButton", {
		Text = "",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = C.WindowBg,
		Parent = self._navList,
	})
	autoOrder(nav)
	corner(nav, 8)
	stroke(nav, C.Border)
	table.insert(window._noDrag, nav)

	local navBadge = make("Frame", {
		Size = UDim2.fromOffset(24, 24),
		Position = UDim2.new(0, 8, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = C.BadgeIdle,
		Parent = nav,
	})
	circle(navBadge)
	local navIcon = make("TextLabel", {
		Text = icon,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = C.TextGray,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = navBadge,
	})

	local navLabel = make("TextLabel", {
		Text = name,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = C.TextGray,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(40, 0),
		Size = UDim2.new(1, -48, 1, 0),
		Parent = nav,
	})

	-- Tab page -------------------------------------------------------------
	local page = make("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = self._content,
	})

	local header = make("Frame", {
		Size = UDim2.new(1, 0, 0, 88),
		BackgroundTransparency = 1,
		Parent = page,
	})

	local badge = make("Frame", {
		Size = UDim2.fromOffset(28, 28),
		Position = UDim2.fromOffset(16, 16),
		BackgroundColor3 = C.Badge,
		Parent = header,
	})
	circle(badge)
	make("TextLabel", {
		Text = icon,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = C.White,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = badge,
	})

	make("TextLabel", {
		Text = name,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = C.White,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(54, 17),
		Size = UDim2.new(1, -70, 0, 14),
		Parent = header,
	})
	make("TextLabel", {
		Text = opts.Subtitle or "",
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(54, 33),
		Size = UDim2.new(1, -70, 0, 12),
		Parent = header,
	})

	local pillRow = make("Frame", {
		Position = UDim2.fromOffset(16, 54),
		Size = UDim2.new(1, -32, 0, 24),
		BackgroundTransparency = 1,
		Parent = header,
	})
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = pillRow,
	})

	-- Divider under the header section
	make("Frame", {
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = C.Border,
		Parent = header,
	})

	local pagesHolder = make("Frame", {
		Position = UDim2.fromOffset(0, 88),
		Size = UDim2.new(1, 0, 1, -88),
		BackgroundTransparency = 1,
		Parent = page,
	})

	local tab = setmetatable({
		_window = window,
		_nav = nav,
		_navLabel = navLabel,
		_navBadge = navBadge,
		_navIcon = navIcon,
		_page = page,
		_pillRow = pillRow,
		_pagesHolder = pagesHolder,
		_subTabs = {},
		_activeSub = nil,
	}, Tab)

	nav.MouseButton1Click:Connect(function()
		window:_selectTab(tab)
	end)
	nav.MouseEnter:Connect(function()
		if window._activeTab ~= tab then
			tween(nav, { BackgroundColor3 = C.NavHover })
		end
	end)
	nav.MouseLeave:Connect(function()
		tween(nav, { BackgroundColor3 = window._activeTab == tab and C.NavActive or C.WindowBg })
	end)

	table.insert(self._tabs, tab)
	if not self._activeTab then
		self:_selectTab(tab)
	end
	return tab
end

--------------------------------------------------------------------------------
-- Tab / sub-tabs
--------------------------------------------------------------------------------

function Tab:_selectSub(sub)
	if self._activeSub == sub then return end
	local prev = self._activeSub
	self._activeSub = sub

	if prev then
		prev._page.Visible = false
		paint(prev._pill, "BackgroundColor3", "WindowBg")
		paint(prev._pill, "TextColor3", "TextGray")
	end

	sub._page.Visible = true
	paint(sub._pill, "BackgroundColor3", "PillActive")
	paint(sub._pill, "TextColor3", "White")
end

function Tab:AddSubTab(name)
	name = tostring(name or "General")
	local tab = self

	local pill = make("TextButton", {
		Text = name,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = C.TextGray,
		BackgroundColor3 = C.WindowBg,
		Size = UDim2.new(0, 0, 0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = self._pillRow,
	})
	autoOrder(pill)
	corner(pill, 6)
	pad(pill, 0, 0, 12, 12)
	table.insert(tab._window._noDrag, pill)

	local page = make("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = C.Border,
		Parent = self._pagesHolder,
	})
	pad(page, 12, 16, 16, 16)
	table.insert(tab._window._noDrag, page)

	-- Scale widths inside a ScrollingFrame are relative to the canvas, which
	-- ignores the page's UIPadding — subtract both side paddings explicitly
	-- or the card overflows and clips at the right edge.
	local card = make("Frame", {
		Size = UDim2.new(1, -32, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = C.CardBg,
		Parent = page,
	})
	corner(card, 10)
	stroke(card)
	pad(card, 14, 14, 16, 16)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = card,
	})

	local sub = setmetatable({
		_tab = tab,
		_window = tab._window,
		_pill = pill,
		_page = page,
		_card = card,
	}, SubTab)

	pill.MouseButton1Click:Connect(function()
		tab:_selectSub(sub)
	end)
	pill.MouseEnter:Connect(function()
		if tab._activeSub ~= sub then
			tween(pill, { BackgroundColor3 = C.NavHover })
		end
	end)
	pill.MouseLeave:Connect(function()
		tween(pill, { BackgroundColor3 = tab._activeSub == sub and C.PillActive or C.WindowBg })
	end)

	table.insert(self._subTabs, sub)
	if not self._activeSub then
		self:_selectSub(sub)
	end
	return sub
end

--------------------------------------------------------------------------------
-- Component rows
--------------------------------------------------------------------------------

local function newRow(card, height)
	local row = make("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundTransparency = 1,
		Parent = card,
	})
	autoOrder(row)
	return row
end

-- Medium white label + dim description, leaving `rightReserve` px for the control.
local function rowLabels(row, name, desc, rightReserve)
	rightReserve = rightReserve or 0
	make("TextLabel", {
		Text = name,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = C.White,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = desc and UDim2.new(1, -rightReserve, 0, 14) or UDim2.new(1, -rightReserve, 1, 0),
		Parent = row,
	})
	if desc then
		make("TextLabel", {
			Text = desc,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = C.TextDim,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 16),
			Size = UDim2.new(1, -rightReserve, 0, 12),
			Parent = row,
		})
	end
end

function SubTab:AddToggle(opts)
	opts = opts or {}
	local value = opts.Default == true

	local row = newRow(self._card, 30)
	rowLabels(row, opts.Name or "Toggle", opts.Description, 44)

	local pill = make("TextButton", {
		Text = "",
		Size = UDim2.fromOffset(34, 18),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = C.Badge,
		Parent = row,
	})
	circle(pill)

	local knob = make("Frame", {
		Size = UDim2.fromOffset(14, 14),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 2, 0.5, 0),
		BackgroundColor3 = C.KnobOff,
		Parent = pill,
	})
	circle(knob)

	local function render(animate)
		local knobPos = value and UDim2.new(0, 18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		paint(pill, "BackgroundColor3", value and "White" or "Badge", not animate)
		paint(knob, "BackgroundColor3", value and "KnobOn" or "KnobOff", not animate)
		if animate then
			tween(knob, { Position = knobPos })
		else
			knob.Position = knobPos
		end
	end

	local function set(v)
		v = v == true
		if v == value then return end
		value = v
		render(true)
		fire(opts.Callback, value)
	end

	pill.MouseButton1Click:Connect(function()
		set(not value)
	end)
	render(false)

	return {
		Set = function(_, v) set(v) end,
		Get = function() return value end,
	}
end

function SubTab:AddButton(opts)
	opts = opts or {}

	local btn = make("TextButton", {
		Text = opts.Name or "Button",
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = C.TextGray,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = C.Element,
		Parent = self._card,
	})
	autoOrder(btn)
	corner(btn, 6)

	btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = C.ElementHover }) end)
	btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = C.Element }) end)
	btn.MouseButton1Click:Connect(function()
		fire(opts.Callback)
	end)

	return btn
end

function SubTab:AddInput(opts)
	opts = opts or {}

	local row = newRow(self._card, 30)
	rowLabels(row, opts.Name or "Input", opts.Description, 120)

	local holder = make("Frame", {
		Size = UDim2.fromOffset(110, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = C.Element,
		Parent = row,
	})
	corner(holder, 6)

	local box = make("TextBox", {
		Text = opts.Default or "",
		PlaceholderText = opts.Placeholder or "...",
		PlaceholderColor3 = C.Placeholder,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = C.TextGray,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -30, 1, 0),
		Parent = holder,
	})

	inputIcon(holder)

	box.FocusLost:Connect(function(enterPressed)
		fire(opts.Callback, box.Text, enterPressed)
	end)

	return {
		Set = function(_, text) box.Text = tostring(text) end,
		Get = function() return box.Text end,
	}
end

function SubTab:AddDropdown(opts)
	opts = opts or {}
	local options = opts.Options or {}
	local value = opts.Default or options[1] or ""

	local row = newRow(self._card, 30)
	rowLabels(row, opts.Name or "Dropdown", opts.Description, 90)

	local btn = make("TextButton", {
		Text = "",
		Size = UDim2.fromOffset(80, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = C.Element,
		Parent = row,
	})
	corner(btn, 6)

	local valueLabel = make("TextLabel", {
		Text = value,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = C.TextGray,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -26, 1, 0),
		Parent = btn,
	})

	sortIcon(btn)

	local window = self._window
	local subPage = self._page
	local tabPage = self._tab._page

	local listHeight = #options * 22 + math.max(#options - 1, 0) * 2 + 8

	-- The list lives at ScreenGui level: a ScrollingFrame always clips its
	-- descendants, so an in-card overlay would be cut off at the viewport.
	local list = make("Frame", {
		Visible = false,
		Active = true, -- sink clicks landing on the padding between options
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(0, 80, 0, 0),
		BackgroundColor3 = C.Element,
		ClipsDescendants = true,
		ZIndex = 100,
		Parent = window.ScreenGui,
	})
	corner(list, 6)
	stroke(list)
	pad(list, 4, 4, 4, 4)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = list,
	})
	table.insert(window._noDrag, list)

	local open = false
	local closeGen = 0
	local openConns = {}

	-- AbsolutePosition is reported in inset-adjusted space, while offsets
	-- inside an IgnoreGuiInset ScreenGui are physical screen pixels, so the
	-- topbar inset must be added back when converting.
	local function reposition()
		local inset = GuiService:GetGuiInset()
		local p, s = btn.AbsolutePosition, btn.AbsoluteSize
		list.Position = UDim2.fromOffset(p.X + inset.X + s.X - 80, p.Y + inset.Y + s.Y + 4)
	end

	local function setOpen(o)
		if open == o then return end
		open = o
		closeGen = closeGen + 1
		if open then
			reposition()
			list.Visible = true
			tween(list, { Size = UDim2.new(0, 80, 0, listHeight) })
			-- follow the button while the window drags or the page scrolls;
			-- close instead of floating detached once the button is scrolled
			-- out of the page's visible rect
			table.insert(openConns, btn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				local bp, bs = btn.AbsolutePosition, btn.AbsoluteSize
				local pp, ps = subPage.AbsolutePosition, subPage.AbsoluteSize
				if bp.Y + bs.Y < pp.Y or bp.Y > pp.Y + ps.Y then
					setOpen(false)
				else
					reposition()
				end
			end))
			-- close when the sub-tab or tab holding this dropdown is switched away
			table.insert(openConns, subPage:GetPropertyChangedSignal("Visible"):Connect(function()
				if not subPage.Visible then setOpen(false) end
			end))
			table.insert(openConns, tabPage:GetPropertyChangedSignal("Visible"):Connect(function()
				if not tabPage.Visible then setOpen(false) end
			end))
			table.insert(openConns, UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch then
					local pos = Vector2.new(input.Position.X, input.Position.Y)
					if not isInside(btn, pos) and not isInside(list, pos) then
						setOpen(false)
					end
				end
			end))
		else
			for _, conn in ipairs(openConns) do
				conn:Disconnect()
			end
			table.clear(openConns)
			tween(list, { Size = UDim2.new(0, 80, 0, 0) })
			local gen = closeGen
			task.delay(0.16, function()
				-- only hide if no reopen/reclose happened since this close
				if gen == closeGen and not open then
					list.Visible = false
				end
			end)
		end
	end

	local function select(option, silent)
		value = option
		valueLabel.Text = option
		setOpen(false)
		if not silent then
			fire(opts.Callback, option)
		end
	end

	for _, option in ipairs(options) do
		local optBtn = make("TextButton", {
			Text = option,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = C.TextGray,
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundColor3 = C.Element,
			Parent = list,
		})
		autoOrder(optBtn)
		corner(optBtn, 4)
		optBtn.MouseEnter:Connect(function()
			tween(optBtn, { BackgroundColor3 = C.ElementHover, TextColor3 = C.White })
		end)
		optBtn.MouseLeave:Connect(function()
			tween(optBtn, { BackgroundColor3 = C.Element, TextColor3 = C.TextGray })
		end)
		optBtn.MouseButton1Click:Connect(function()
			select(option)
		end)
	end

	btn.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)
	btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = C.ElementHover }) end)
	btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = C.Element }) end)

	return {
		Set = function(_, option) select(option) end,
		Get = function() return value end,
	}
end

function SubTab:AddSlider(opts)
	opts = opts or {}
	local min = opts.Min or 0
	local max = opts.Max or 100
	local suffix = opts.Suffix or ""
	local value = math.clamp(opts.Default or min, min, max)

	local row = newRow(self._card, 32)

	make("TextLabel", {
		Text = opts.Name or "Slider",
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = C.White,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(0.6, 0, 0, 14),
		Parent = row,
	})

	local valueLabel = make("TextLabel", {
		Text = tostring(value) .. suffix,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.TextDim,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 1),
		Size = UDim2.new(1, 0, 0, 13),
		Parent = row,
	})

	local track = make("Frame", {
		Position = UDim2.fromOffset(0, 24),
		Size = UDim2.new(1, 0, 0, 4),
		BackgroundColor3 = C.TrackBg,
		Parent = row,
	})
	circle(track)

	local fill = make("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = C.White,
		Parent = track,
	})
	circle(fill)

	local knob = make("Frame", {
		Size = UDim2.fromOffset(12, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = C.White,
		ZIndex = 2,
		Parent = track,
	})
	circle(knob)

	-- Transparent button capturing presses over the track and knob.
	local hit = make("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -6, 0, 16),
		Size = UDim2.new(1, 12, 0, 20),
		Parent = row,
	})

	local function applyValue(v, animate, fireCallback)
		value = math.clamp(math.floor(v + 0.5), min, max)
		local pct = max > min and (value - min) / (max - min) or 0
		valueLabel.Text = tostring(value) .. suffix
		local fillSize = UDim2.new(pct, 0, 1, 0)
		local knobPos = UDim2.new(pct, 0, 0.5, 0)
		if animate then
			tween(fill, { Size = fillSize })
			tween(knob, { Position = knobPos })
		else
			fill.Size = fillSize
			knob.Position = knobPos
		end
		if fireCallback then
			fire(opts.Callback, value)
		end
	end

	local function valueFromX(x)
		local rel = (x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
		return min + (max - min) * math.clamp(rel, 0, 1)
	end

	local dragging = false

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			applyValue(valueFromX(input.Position.X), true, true)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			applyValue(valueFromX(input.Position.X), true, true)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	applyValue(value, false, false)

	return {
		Set = function(_, v) applyValue(v, true, true) end,
		Get = function() return value end,
	}
end

return Library
