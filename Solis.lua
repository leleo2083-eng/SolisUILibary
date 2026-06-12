--[[
Solis UI Library
GitHub import:
	local Library = loadstring(game:HttpGet(
		"https://raw.githubusercontent.com/leleo2083-eng/SolisUILibary/refs/heads/main/Solis.lua"
	))()

Themes (loaded from themes.lua automatically):
	Library:SetTheme("Dark")
	Library:SetTheme("Light")
	Library:SetTheme("OLED")
	Library:SetTheme("Solis")   -- background image + warm amber palette + 50% transparent UI

API:
	local Window = Library:CreateWindow({ Name = "Menu" })
	local Tab    = Window:AddTab({ Name = "Home", Subtitle = "...", Icon = "H" })
	local Sub    = Tab:AddSubTab("General")

	Sub:AddToggle({ Name, Description, Default, Callback })
	Sub:AddButton({ Name, Callback })
	Sub:AddInput({ Name, Description, Placeholder, Default, Callback })
	Sub:AddDropdown({ Name, Description, Options, Default, Callback })
	Sub:AddSlider({ Name, Min, Max, Default, Suffix, Callback })

	Window:Notify({ Title, Content, Type, Duration, Callback })
	Library:Notify({ Title, Content, Type, Duration, Callback })

	Window:SetVisible(bool)  Window:Toggle()  Window:SetLogo(assetId)  Window:Destroy()

	Press K to toggle profile + performance panels.
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local Players          = game:GetService("Players")
local Stats            = game:GetService("Stats")
local RunService       = game:GetService("RunService")
local AssetService     = game:GetService("AssetService")
local TextService      = game:GetService("TextService")

local DEFAULT_LOGO       = "rbxassetid://105894109382235"
local TWEEN              = TweenInfo.new(0.15, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local NOTIFICATION_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local PROFILE_TWEEN      = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TRANSPARENCY_TWEEN = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local THEMES_URL = "https://raw.githubusercontent.com/leleo2083-eng/SolisUILibary/refs/heads/main/SolisUITheme.lua"

local NOTIFICATION_STYLES = {
	info    = { Name = "Info",    Color = Color3.fromRGB(118, 151, 194) },
	success = { Name = "Success", Color = Color3.fromRGB(105, 166, 124) },
	warning = { Name = "Warning", Color = Color3.fromRGB(190, 154, 84)  },
	error   = { Name = "Error",   Color = Color3.fromRGB(190, 99,  99)  },
}

local C = {
	WindowBg     = Color3.fromRGB(20,  20,  20),
	CardBg       = Color3.fromRGB(24,  24,  24),
	Border       = Color3.fromRGB(35,  35,  35),
	Element      = Color3.fromRGB(31,  31,  31),
	ElementHover = Color3.fromRGB(38,  38,  38),
	Badge        = Color3.fromRGB(42,  42,  42),
	BadgeIdle    = Color3.fromRGB(34,  34,  34),
	NavActive    = Color3.fromRGB(30,  30,  30),
	NavHover     = Color3.fromRGB(26,  26,  26),
	PillActive   = Color3.fromRGB(36,  36,  36),
	White        = Color3.fromRGB(255, 255, 255),
	TextGray     = Color3.fromRGB(154, 154, 154),
	TextDim      = Color3.fromRGB(139, 139, 139),
	KnobOff      = Color3.fromRGB(85,  85,  85),
	KnobOn       = Color3.fromRGB(17,  17,  17),
	TrackBg      = Color3.fromRGB(43,  43,  43),
	Placeholder  = Color3.fromRGB(86,  86,  86),
}

local CURRENT_IMAGE              = nil
local CURRENT_IMAGE_TRANSPARENCY = 0.85
local CURRENT_UI_TRANSPARENCY    = 0  -- 0 = solid, 0.5 = 50% transparent UI (used by Solis theme)

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
		White        = Color3.fromRGB(20,  20,  20),
		TextGray     = Color3.fromRGB(84,  84,  84),
		TextDim      = Color3.fromRGB(105, 105, 105),
		KnobOff      = Color3.fromRGB(150, 150, 150),
		KnobOn       = Color3.fromRGB(250, 250, 250),
		TrackBg      = Color3.fromRGB(210, 210, 210),
		Placeholder  = Color3.fromRGB(135, 135, 135),
	},
	OLED = {
		WindowBg     = Color3.fromRGB(0,   0,   0),
		CardBg       = Color3.fromRGB(5,   5,   5),
		Border       = Color3.fromRGB(25,  25,  25),
		Element      = Color3.fromRGB(12,  12,  12),
		ElementHover = Color3.fromRGB(20,  20,  20),
		Badge        = Color3.fromRGB(28,  28,  28),
		BadgeIdle    = Color3.fromRGB(16,  16,  16),
		NavActive    = Color3.fromRGB(9,   9,   9),
		NavHover     = Color3.fromRGB(6,   6,   6),
		PillActive   = Color3.fromRGB(22,  22,  22),
		White        = Color3.fromRGB(255, 255, 255),
		TextGray     = Color3.fromRGB(165, 165, 165),
		TextDim      = Color3.fromRGB(125, 125, 125),
		KnobOff      = Color3.fromRGB(75,  75,  75),
		KnobOn       = Color3.fromRGB(3,   3,   3),
		TrackBg      = Color3.fromRGB(32,  32,  32),
		Placeholder  = Color3.fromRGB(90,  90,  90),
	},
	Solis = {
		Image             = "https://raw.githubusercontent.com/leleo2083-eng/SolisUILibary/main/Solis.png",
		ImageTransparency = 0.82,
		UITransparency    = 0.5,
		WindowBg     = Color3.fromRGB(10,  8,   5),
		CardBg       = Color3.fromRGB(15,  12,  7),
		Border       = Color3.fromRGB(55,  40,  18),
		Element      = Color3.fromRGB(22,  17,  9),
		ElementHover = Color3.fromRGB(35,  26,  12),
		Badge        = Color3.fromRGB(70,  50,  16),
		BadgeIdle    = Color3.fromRGB(38,  28,  11),
		NavActive    = Color3.fromRGB(28,  21,  9),
		NavHover     = Color3.fromRGB(24,  18,  7),
		PillActive   = Color3.fromRGB(48,  34,  12),
		White        = Color3.fromRGB(255, 225, 165),
		TextGray     = Color3.fromRGB(200, 155, 78),
		TextDim      = Color3.fromRGB(165, 120, 55),
		KnobOff      = Color3.fromRGB(105, 75,  25),
		KnobOn       = Color3.fromRGB(10,  7,   2),
		TrackBg      = Color3.fromRGB(45,  32,  10),
		Placeholder  = Color3.fromRGB(115, 82,  30),
	},
}

-- ── Fetch remote themes ─────────────────────────────────────────────────────
task.spawn(function()
	local ok, result = pcall(function() return game:HttpGet(THEMES_URL) end)
	if not ok or type(result) ~= "string" or result == "" then return end
	local loader = loadstring or load
	if not loader then return end
	local fn = loader(result, "themes.lua")
	if not fn then return end
	local cOk, tbl = pcall(fn)
	if not cOk or type(tbl) ~= "table" then return end
	for name, palette in pairs(tbl) do
		if type(name) == "string" and type(palette) == "table" then
			THEMES[name] = palette
		end
	end
end)

-- ── Remote image resolver ───────────────────────────────────────────────────
local THEME_IMAGE_CACHE = {}

local function executorRequest(url)
	if request then local r = request({ Url = url, Method = "GET" }); return r and r.Body
	elseif http_request then local r = http_request({ Url = url, Method = "GET" }); return r and r.Body
	elseif syn and syn.request then local r = syn.request({ Url = url, Method = "GET" }); return r and r.Body
	elseif fluxus and fluxus.request then local r = fluxus.request({ Url = url, Method = "GET" }); return r and r.Body end
	local ok, body = pcall(function() return game:HttpGet(url) end)
	return ok and body or nil
end

local function getCustomAssetFn(path)
	if getcustomasset then return getcustomasset(path)
	elseif getsynasset then return getsynasset(path) end
	return nil
end

local function resolveThemeImage(imageValue)
	if type(imageValue) ~= "string" or imageValue == "" then return nil end
	if imageValue:match("^rbxassetid://") or imageValue:match("^rbxthumb://") then return imageValue end
	if not imageValue:match("^https?://") then
		if getcustomasset or getsynasset then
			local ok, asset = pcall(getCustomAssetFn, imageValue)
			if ok and asset then return asset end
		end
		return nil
	end
	if THEME_IMAGE_CACHE[imageValue] then return THEME_IMAGE_CACHE[imageValue] end
	if not writefile or (not getcustomasset and not getsynasset) then
		warn("[Solis UI] Executor does not support writefile/getcustomasset.")
		return nil
	end
	local fileName = "SolisUI_ThemeBG_" .. tostring(tick()):gsub("%.", "") .. ".png"
	local body = executorRequest(imageValue)
	if not body or #body < 100 then warn("[Solis UI] Failed to download theme image."); return nil end
	local wOk = pcall(function() writefile(fileName, body) end)
	if not wOk then warn("[Solis UI] Failed to save theme image."); return nil end
	local aOk, asset = pcall(getCustomAssetFn, fileName)
	if aOk and asset then THEME_IMAGE_CACHE[imageValue] = asset; return asset end
	return nil
end

-- ── Reverse lookup ──────────────────────────────────────────────────────────
local REVERSE = {}
local function rebuildReverse()
	table.clear(REVERSE)
	for key, color in pairs(C) do REVERSE[color:ToHex()] = key end
end
rebuildReverse()

-- ── Core helpers ────────────────────────────────────────────────────────────
local function tween(inst, props) TweenService:Create(inst, TWEEN, props):Play() end

local function paint(inst, prop, key, instant)
	inst:SetAttribute("Theme_" .. prop, key)
	if instant then inst[prop] = C[key] else tween(inst, { [prop] = C[key] }) end
end

local function make(className, props)
	local inst = Instance.new(className)
	if inst:IsA("GuiObject") then inst.BorderSizePixel = 0; inst.BackgroundColor3 = C.WindowBg end
	if inst:IsA("GuiButton") then inst.AutoButtonColor = false end
	if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
		inst.Font = Enum.Font.Gotham; inst.TextColor3 = C.White; inst.TextSize = 13
	end
	for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
	if inst:IsA("GuiObject") then
		local key = REVERSE[inst.BackgroundColor3:ToHex()]
		if key then inst:SetAttribute("Theme_BackgroundColor3", key) end
		-- Tag instances that should follow the theme's UI transparency.
		-- Any GuiObject created with a themed background and that is NOT fully
		-- transparent counts as "UI surface" and will fade with the Solis theme.
		if key and inst.BackgroundTransparency < 0.9 then
			inst:SetAttribute("ThemeUIElement", true)
			inst:SetAttribute("OriginalBgTransparency", inst.BackgroundTransparency)
		end
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
		inst:SetAttribute("ThemeUIStroke", true)
		inst:SetAttribute("OriginalStrokeTransparency", inst.Transparency)
	end
	inst.Parent = props.Parent
	return inst
end

local function corner(parent, radius) return make("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent }) end
local function circle(parent) return make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent }) end
local function stroke(parent, color) return make("UIStroke", { Color = color or C.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent }) end
local function pad(parent, t, b, l, r) return make("UIPadding", { PaddingTop = UDim.new(0,t), PaddingBottom = UDim.new(0,b), PaddingLeft = UDim.new(0,l), PaddingRight = UDim.new(0,r), Parent = parent }) end
local function autoOrder(inst) inst.LayoutOrder = #inst.Parent:GetChildren() end

local function isInside(gui, pos)
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local function fire(cb, ...) if typeof(cb) == "function" then task.spawn(cb, ...) end end

local function normalizeAssetId(value)
	if value == nil or value == "" then return DEFAULT_LOGO end
	if type(value) == "number" then return "rbxassetid://" .. tostring(math.floor(value)) end
	local text = tostring(value)
	if text:match("^rbxassetid://") or text:match("^rbxthumb://") or text:match("^https?://") then return text end
	local id = text:match("%d+")
	return id and ("rbxassetid://" .. id) or DEFAULT_LOGO
end

local function getNotificationStyle(kind)
	return NOTIFICATION_STYLES[string.lower(tostring(kind or "Info"))] or NOTIFICATION_STYLES.info
end

local function guiVisible(gui)
	local node = gui
	while node and node:IsA("GuiObject") do if not node.Visible then return false end; node = node.Parent end
	return true
end

local function makeDraggable(frame, blockers)
	local dragging, dragStart, startPos = false, nil, nil
	frame.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local pos = Vector2.new(input.Position.X, input.Position.Y)
		for _, gui in ipairs(blockers) do if guiVisible(gui) and isInside(gui, pos) then return end end
		dragging = true; dragStart = input.Position; startPos = frame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function sortIcon(parent)
	local h = make("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-7,0.5,0), Size = UDim2.fromOffset(9,7), Parent = parent })
	for i, w in ipairs({9,7,5}) do make("Frame", { Position = UDim2.fromOffset(0,(i-1)*3), Size = UDim2.fromOffset(w,1), BackgroundColor3 = C.TextDim, Parent = h }) end
	return h
end

local function inputIcon(parent)
	local h = make("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-7,0.5,0), Size = UDim2.fromOffset(10,10), Parent = parent })
	local b = make("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = h }); corner(b,2); stroke(b, C.TextDim)
	make("Frame", { AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(1,4), BackgroundColor3 = C.TextDim, Parent = h })
	return h
end

-- ── Apply UI transparency to all themed elements in a window ────────────────
local function applyUITransparency(screenGui, transparency)
	for _, inst in ipairs(screenGui:GetDescendants()) do
		if inst:IsA("GuiObject") and inst:GetAttribute("ThemeUIElement") then
			local orig = inst:GetAttribute("OriginalBgTransparency") or 0
			local target = math.clamp(orig + transparency, 0, 1)
			TweenService:Create(inst, TRANSPARENCY_TWEEN, { BackgroundTransparency = target }):Play()
		elseif inst:IsA("UIStroke") and inst:GetAttribute("ThemeUIStroke") then
			local orig = inst:GetAttribute("OriginalStrokeTransparency") or 0
			local target = math.clamp(orig + transparency, 0, 1)
			TweenService:Create(inst, TRANSPARENCY_TWEEN, { Transparency = target }):Play()
		end
	end
end

-- ══════════════════════════════════════════════════════════════════════════════
local Library = {
	Version = "2.2.0-solis-transparent", Themes = THEMES, DefaultLogo = DEFAULT_LOGO,
	_windows = {}, _windowObjects = {}, _currentTheme = "Dark",
}
local Window = {} Window.__index = Window
local Tab    = {} Tab.__index    = Tab
local SubTab = {} SubTab.__index = SubTab

local THEME_PROPS = { "BackgroundColor3", "TextColor3", "PlaceholderColor3", "ScrollBarImageColor3", "Color" }

function Library:SetTheme(theme)
	local themeName
	if type(theme) == "string" then
		themeName = theme; theme = THEMES[theme]
		if not theme then
			local avail = {}; for k in pairs(THEMES) do avail[#avail+1] = k end
			warn(("[Solis UI] unknown theme %q — available: %s"):format(themeName, table.concat(avail, ", ")))
			return false
		end
	elseif type(theme) ~= "table" then return false end

	for key in pairs(C) do
		local v = theme[key]
		if v ~= nil and typeof(v) ~= "Color3" then return false end
	end
	for key in pairs(C) do local v = theme[key]; if v ~= nil then C[key] = v end end

	local newImage = resolveThemeImage(theme.Image)
	local newImgTrans = math.clamp(tonumber(theme.ImageTransparency) or 0.85, 0, 1)
	local newUITrans  = math.clamp(tonumber(theme.UITransparency) or 0, 0, 1)
	CURRENT_IMAGE = newImage
	CURRENT_IMAGE_TRANSPARENCY = newImgTrans
	CURRENT_UI_TRANSPARENCY = newUITrans

	Library._currentTheme = themeName or "Custom"
	rebuildReverse()

	for idx, gui in ipairs(Library._windows) do
		if gui and gui.Parent then
			for _, inst in ipairs(gui:GetDescendants()) do
				local goal
				for _, prop in ipairs(THEME_PROPS) do
					local key = inst:GetAttribute("Theme_" .. prop)
					if key and C[key] then goal = goal or {}; goal[prop] = C[key] end
				end
				if goal then tween(inst, goal) end
			end

			-- Apply UI transparency tweening to all themed elements
			applyUITransparency(gui, CURRENT_UI_TRANSPARENCY)

			local wObj = Library._windowObjects[idx]
			if wObj and wObj._bgImage then
				if CURRENT_IMAGE then
					wObj._bgImage.Image = CURRENT_IMAGE
					wObj._bgImage.ImageTransparency = CURRENT_IMAGE_TRANSPARENCY
					wObj._bgImage.Visible = true
					-- Zoom out: render image smaller than the window using a tiled
					-- inner Scale so it occupies ~80% and shows full artwork.
					wObj._bgImage.ScaleType = Enum.ScaleType.Fit
				else
					wObj._bgImage.Visible = false; wObj._bgImage.Image = ""
				end
			end
		end
	end
	return true
end

function Library:GetTheme() return Library._currentTheme end

function Library:Notify(opts)
	for i = #Library._windowObjects, 1, -1 do
		local w = Library._windowObjects[i]
		if w and w.ScreenGui and w.ScreenGui.Parent then return w:Notify(opts) end
	end
end
function Library:Notification(opts) return self:Notify(opts) end

function Library:DestroyAll()
	local ws = table.clone(Library._windows)
	for _, sg in ipairs(ws) do if sg then sg:Destroy() end end
	table.clear(Library._windows); table.clear(Library._windowObjects)
end

-- ══════════════════════════════════════════════════════════════════════════════
function Library:CreateWindow(opts)
	opts = opts or {}
	local logoAsset      = normalizeAssetId(opts.Logo or DEFAULT_LOGO)
	local windowSize     = opts.Size     or UDim2.fromOffset(700, 490)
	local windowPosition = opts.Position or UDim2.fromScale(0.5, 0.5)
	local guiName        = opts.GuiName  or "SolisUI"

	local targetParent
	if typeof(opts.Parent) == "Instance" then targetParent = opts.Parent
	else pcall(function() targetParent = (gethui and gethui()) or game:GetService("CoreGui") end)
		if not targetParent then targetParent = Players.LocalPlayer:WaitForChild("PlayerGui") end
	end

	local function removeOld(p) if opts.ReplaceExisting == false or not p then return end; for _, c in ipairs(p:GetChildren()) do if c:IsA("ScreenGui") and c.Name == guiName then c:Destroy() end end end
	removeOld(targetParent)

	local screenGui = make("ScreenGui", { Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = opts.DisplayOrder or 10 })
	local ok = pcall(function() screenGui.Parent = targetParent end)
	if not ok then targetParent = Players.LocalPlayer:WaitForChild("PlayerGui"); removeOld(targetParent); screenGui.Parent = targetParent end
	table.insert(Library._windows, screenGui)

	-- ── Loading ─────────────────────────────────────────────────────────────
	local loadingEnabled            = opts.LoadingAnimation ~= false
	local loadingDuration           = math.clamp(tonumber(opts.LoadingDuration) or 2.65, 1.5, 8)
	local loadingIconSize           = math.clamp(math.floor(tonumber(opts.LoadingIconSize) or 112), 64, 190)
	local loadingText               = tostring(opts.LoadingText or "Solis")
	local loadingTextSize           = math.clamp(math.floor(tonumber(opts.LoadingTextSize) or 58), 40, 76)
	local loadingTextStartColor     = typeof(opts.LoadingTextStartColor)     == "Color3" and opts.LoadingTextStartColor     or Color3.fromRGB(255,255,255)
	local loadingTextHighlightColor = typeof(opts.LoadingTextHighlightColor) == "Color3" and opts.LoadingTextHighlightColor or Color3.fromRGB(255,231,26)
	local loadingTextGoldColor      = typeof(opts.LoadingTextGoldColor)      == "Color3" and opts.LoadingTextGoldColor      or Color3.fromRGB(255,183,1)
	local loadingTextEndColor       = typeof(opts.LoadingTextEndColor)       == "Color3" and opts.LoadingTextEndColor       or Color3.fromRGB(253,128,0)
	local loadingTextDeepColor      = typeof(opts.LoadingTextDeepColor)      == "Color3" and opts.LoadingTextDeepColor      or Color3.fromRGB(228,87,0)
	local overlayTransparency       = math.clamp(tonumber(opts.LoadingOverlayTransparency) or 0.5, 0, 0.9)
	local colorTransitionDuration   = math.clamp(tonumber(opts.LoadingColorTransitionDuration) or 0.95, 0.4, 2.5)

	local function sampleLC(a)
		a = math.clamp(a,0,1)
		if a <= 0.32 then return loadingTextHighlightColor:Lerp(loadingTextGoldColor, a/0.32)
		elseif a <= 0.68 then return loadingTextGoldColor:Lerp(loadingTextEndColor, (a-0.32)/0.36) end
		return loadingTextEndColor:Lerp(loadingTextDeepColor, (a-0.68)/0.32)
	end

	local loadingComplete, loadingMotionComplete = not loadingEnabled, not loadingEnabled
	local loadingLayer, loadingContent, loadingLogo, loadingLogoScale
	local loadingTitleHolder, loadingTitleScale, loadingCaret
	local loadingProgressTrack, loadingProgressFill
	local loadingLetterLabels, loadingLetterScales, loadingLetterColors = {}, {}, {}

	if loadingEnabled then
		loadingLayer = make("CanvasGroup", { Name = "StartupLoader", Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, GroupTransparency = 0, ZIndex = 500, Parent = screenGui })
		loadingContent = make("CanvasGroup", { Name = "LoadingContent", Size = UDim2.fromOffset(560,300), Position = UDim2.new(0.5,0,0.5,18), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, GroupTransparency = 1, ZIndex = 501, Parent = loadingLayer })
		loadingLogo = make("ImageLabel", { Name = "LoadingLogo", Image = logoAsset, Size = UDim2.fromOffset(loadingIconSize, loadingIconSize), Position = UDim2.new(0.5,0,0,84), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, ZIndex = 502, Parent = loadingContent })
		loadingLogoScale = make("UIScale", { Scale = 0.58, Parent = loadingLogo })

		local cc = math.max(#loadingText,1); local ls = math.max(1, math.floor(loadingTextSize * 0.025))
		local lw, tw = {}, 0
		for i = 1, #loadingText do
			local ch = string.sub(loadingText,i,i)
			local m = TextService:GetTextSize(ch, loadingTextSize, Enum.Font.GothamBold, Vector2.new(200,90))
			local w = math.max(math.ceil(m.X), math.floor(loadingTextSize*0.24))
			lw[i] = w; tw = tw + w; if i < #loadingText then tw = tw + ls end
		end
		tw = math.max(tw, 80)

		loadingTitleHolder = make("Frame", { Name = "LoadingTitle", Size = UDim2.fromOffset(tw+12,82), Position = UDim2.new(0.5,0,0,151), AnchorPoint = Vector2.new(0.5,0), BackgroundTransparency = 1, ZIndex = 502, Parent = loadingContent })
		loadingTitleScale = make("UIScale", { Scale = 0.94, Parent = loadingTitleHolder })

		local xo = 6
		for i = 1, #loadingText do
			local ch = string.sub(loadingText,i,i); local w = lw[i]
			local fa = #loadingText > 1 and ((i-1)/(#loadingText-1)) or 0.5
			local letter = make("TextLabel", { Name = "Letter"..i, Text = ch, Font = Enum.Font.GothamBold, TextSize = loadingTextSize, TextColor3 = loadingTextStartColor, TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, BackgroundTransparency = 1, Position = UDim2.fromOffset(xo,10), Size = UDim2.fromOffset(w,72), ZIndex = 503, Parent = loadingTitleHolder })
			local lsc = make("UIScale", { Scale = 0.78, Parent = letter })
			loadingLetterLabels[i] = letter; loadingLetterScales[i] = lsc; loadingLetterColors[i] = sampleLC(fa)
			xo = xo + w + ls
		end

		loadingCaret = make("Frame", { Name = "TypingCaret", Size = UDim2.fromOffset(2, math.floor(loadingTextSize*0.7)), Position = UDim2.fromOffset(6,20), BackgroundColor3 = loadingTextGoldColor, BackgroundTransparency = 1, ZIndex = 504, Parent = loadingTitleHolder }); corner(loadingCaret, 1)

		local pw = math.clamp(math.floor(tw*0.76), 150, 270)
		loadingProgressTrack = make("Frame", { Name = "LoadingProgress", Size = UDim2.fromOffset(pw,3), Position = UDim2.new(0.5,0,0,246), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.9, ClipsDescendants = true, ZIndex = 502, Parent = loadingContent }); corner(loadingProgressTrack, 2)
		loadingProgressFill = make("Frame", { Name = "Fill", Size = UDim2.new(0,0,1,0), BackgroundColor3 = loadingTextEndColor, ZIndex = 503, Parent = loadingProgressTrack }); corner(loadingProgressFill, 2)
		make("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, loadingTextHighlightColor), ColorSequenceKeypoint.new(0.34, loadingTextGoldColor), ColorSequenceKeypoint.new(0.72, loadingTextEndColor), ColorSequenceKeypoint.new(1, loadingTextDeepColor) }), Parent = loadingProgressFill })

		task.spawn(function()
			TweenService:Create(loadingLayer, TweenInfo.new(0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = overlayTransparency }):Play()
			TweenService:Create(loadingContent, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.fromScale(0.5,0.5), GroupTransparency = 0 }):Play()
			TweenService:Create(loadingLogoScale, TweenInfo.new(0.62, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
			TweenService:Create(loadingLogo, TweenInfo.new(0.58, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5,0,0,76) }):Play()
			TweenService:Create(loadingTitleScale, TweenInfo.new(0.52, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 }):Play()
			task.wait(0.36); if not loadingLayer or not loadingLayer.Parent then return end
			TweenService:Create(loadingCaret, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.08 }):Play()
			local att = math.max(loadingDuration - colorTransitionDuration - 1.28, 0.45)
			local ld = math.clamp(att/cc, 0.075, 0.19); local cx = 6
			for i, letter in ipairs(loadingLetterLabels) do
				if not loadingLayer or not loadingLayer.Parent then return end
				TweenService:Create(letter, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(cx,0), TextTransparency = 0 }):Play()
				TweenService:Create(loadingLetterScales[i], TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
				cx = cx + lw[i] + ls
				TweenService:Create(loadingCaret, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(cx,20) }):Play()
				TweenService:Create(loadingProgressFill, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new((i/cc)*0.58,0,1,0) }):Play()
				task.wait(ld)
			end
			TweenService:Create(loadingCaret, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play(); task.wait(0.08)
			local cs = math.clamp((colorTransitionDuration/math.max(cc+1,2))*0.72, 0.055, 0.15)
			for i, letter in ipairs(loadingLetterLabels) do
				if not loadingLayer or not loadingLayer.Parent then return end
				local lsc = loadingLetterScales[i]
				TweenService:Create(letter, TweenInfo.new(0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), { TextColor3 = loadingLetterColors[i] }):Play()
				TweenService:Create(lsc, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1.065 }):Play()
				task.delay(0.14, function() if lsc and lsc.Parent then TweenService:Create(lsc, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 }):Play() end end)
				TweenService:Create(loadingProgressFill, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0.58+((i/cc)*0.42),0,1,0) }):Play()
				task.wait(cs)
			end
			TweenService:Create(loadingProgressFill, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromScale(1,1) }):Play(); task.wait(0.38)
			TweenService:Create(loadingLogoScale, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Scale = 1.035 }):Play()
			TweenService:Create(loadingTitleScale, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Scale = 1.018 }):Play(); task.wait(0.22)
			TweenService:Create(loadingLogoScale, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Scale = 1 }):Play()
			TweenService:Create(loadingTitleScale, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Scale = 1 }):Play(); task.wait(0.28)
			loadingMotionComplete = true
		end)
	end

	-- ── Main frame ──────────────────────────────────────────────────────────
	local main = make("Frame", { Name = "Main", Size = windowSize, Position = windowPosition, AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = C.WindowBg, ClipsDescendants = true, Visible = not loadingEnabled, ZIndex = 2, Parent = screenGui })
	corner(main, 12); stroke(main, C.Border)

	-- Background image — zoomed out so the full artwork is visible inside the window.
	-- The image is sized at 70% of the window with a centered anchor so it
	-- shows the whole picture without filling edge-to-edge.
	local bgImage = make("ImageLabel", {
		Name = "ThemeBG",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.7, 0.7),
		BackgroundTransparency = 1,
		ImageTransparency = CURRENT_IMAGE_TRANSPARENCY,
		ScaleType = Enum.ScaleType.Fit,
		Image = CURRENT_IMAGE or "",
		Visible = CURRENT_IMAGE ~= nil,
		ZIndex = 0,
		Parent = main,
	})

	local mainRevealScale = make("UIScale", { Scale = loadingEnabled and 0.965 or 1, Parent = main })
	local noDrag = {}; makeDraggable(main, noDrag)

	-- ── Sidebar ─────────────────────────────────────────────────────────────
	local sidebar = make("Frame", { Size = UDim2.new(0,190,1,0), BackgroundTransparency = 1, Parent = main })
	local brand = make("Frame", { Name = "Brand", Position = UDim2.fromOffset(12,12), Size = UDim2.new(1,-24,0,54), BackgroundColor3 = C.CardBg, Parent = sidebar }); corner(brand, 10); stroke(brand, C.Border)
	local logoHolder = make("Frame", { Position = UDim2.fromOffset(9,9), Size = UDim2.fromOffset(36,36), BackgroundColor3 = C.Element, Parent = brand }); corner(logoHolder, 9)
	make("TextLabel", { Text = "S", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.White, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = logoHolder })
	local brandLogo = make("ImageLabel", { Name = "Logo", Image = logoAsset, BackgroundTransparency = 1, Position = UDim2.fromOffset(3,3), Size = UDim2.new(1,-6,1,-6), ScaleType = Enum.ScaleType.Fit, Parent = logoHolder })
	make("TextLabel", { Text = opts.Name or "Solis UI", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(54,9), Size = UDim2.new(1,-62,0,17), Parent = brand })
	make("TextLabel", { Text = opts.BrandSubtitle or ("SOLIS LIBRARY  •  v"..Library.Version), Font = Enum.Font.GothamMedium, TextSize = 9, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(54,28), Size = UDim2.new(1,-62,0,13), Parent = brand })

	local navList = make("Frame", { Position = UDim2.fromOffset(0,78), Size = UDim2.new(1,0,1,-112), BackgroundTransparency = 1, Parent = sidebar })
	pad(navList, 0, 8, 12, 12)
	make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,7), Parent = navList })

	local statusDot = make("Frame", { AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,16,1,-19), Size = UDim2.fromOffset(6,6), BackgroundColor3 = NOTIFICATION_STYLES.success.Color, Parent = sidebar }); circle(statusDot)
	make("TextLabel", { Text = opts.StatusText or "Solis is ready", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0,28,1,-27), Size = UDim2.new(1,-40,0,16), Parent = sidebar })
	make("Frame", { Position = UDim2.fromOffset(190,0), Size = UDim2.new(0,1,1,0), BackgroundColor3 = C.Border, Parent = main })

	local content = make("Frame", { Position = UDim2.fromOffset(191,0), Size = UDim2.new(1,-191,1,0), BackgroundTransparency = 1, Parent = main })

	-- ── Notifications ───────────────────────────────────────────────────────
	local notifHolder = make("Frame", { Name = "Notifications", AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-16,0,16), Size = UDim2.new(0,300,1,-32), BackgroundTransparency = 1, ZIndex = 200, Parent = screenGui })
	make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6), Parent = notifHolder })

	-- ── Profile panel ───────────────────────────────────────────────────────
	local lp = Players.LocalPlayer
	local profileKey = typeof(opts.ProfileKey) == "EnumItem" and opts.ProfileKey or Enum.KeyCode.K
	local pW = math.max(280, tonumber(opts.ProfileWidth) or 312)
	local bM = math.max(10, tonumber(opts.ProfileBottomMargin) or 18)
	local pOpenPos  = UDim2.new(1,-18,1,-bM); local pClosePos = UDim2.new(1, pW+28,1,-bM)
	local profileOpen = false; local window

	local profilePanel = make("CanvasGroup", { Name = "UserProfile", AnchorPoint = Vector2.new(1,1), Position = pClosePos, Size = UDim2.fromOffset(pW,382), BackgroundColor3 = C.CardBg, GroupTransparency = 1, ClipsDescendants = true, ZIndex = 150, Parent = screenGui }); corner(profilePanel, 14)
	local pH = make("Frame", { Size = UDim2.new(1,0,0,65), BackgroundTransparency = 1, ZIndex = 151, Parent = profilePanel })
	make("TextLabel", { Text = opts.ProfileTitle or "PLAYER PROFILE", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(18,13), Size = UDim2.new(1,-36,0,18), ZIndex = 152, Parent = pH })
	make("TextLabel", { Text = "Live session overview", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(18,34), Size = UDim2.new(1,-36,0,15), ZIndex = 152, Parent = pH })
	make("Frame", { Position = UDim2.new(0,18,1,-1), Size = UDim2.new(1,-36,0,1), BackgroundColor3 = C.Border, ZIndex = 151, Parent = pH })

	local idCard = make("Frame", { Position = UDim2.fromOffset(16,82), Size = UDim2.new(1,-32,0,116), BackgroundColor3 = C.Element, ZIndex = 151, Parent = profilePanel }); corner(idCard, 11); stroke(idCard, C.Border)
	local avH = make("Frame", { AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,14,0.5,0), Size = UDim2.fromOffset(76,76), BackgroundColor3 = C.Badge, ZIndex = 152, Parent = idCard }); circle(avH); stroke(avH, C.Border)
	local avatar = make("ImageLabel", { Name = "Avatar", Image = "", BackgroundTransparency = 1, Position = UDim2.fromOffset(4,4), Size = UDim2.new(1,-8,1,-8), ScaleType = Enum.ScaleType.Crop, ZIndex = 153, Parent = avH }); circle(avatar)
	local onRing = make("Frame", { AnchorPoint = Vector2.new(1,1), Position = UDim2.new(1,0,1,0), Size = UDim2.fromOffset(18,18), BackgroundColor3 = C.Element, ZIndex = 154, Parent = avH }); circle(onRing)
	local onDot = make("Frame", { AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(10,10), BackgroundColor3 = NOTIFICATION_STYLES.success.Color, ZIndex = 155, Parent = onRing }); circle(onDot)

	make("TextLabel", { Text = lp and lp.DisplayName or "Player", Font = Enum.Font.GothamBold, TextSize = 17, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(105,22), Size = UDim2.new(1,-119,0,23), ZIndex = 152, Parent = idCard })
	make("TextLabel", { Text = lp and ("@"..lp.Name) or "@unknown", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(105,47), Size = UDim2.new(1,-119,0,16), ZIndex = 152, Parent = idCard })

	local cBadge = make("Frame", { Position = UDim2.fromOffset(105,74), Size = UDim2.fromOffset(92,24), BackgroundColor3 = C.BadgeIdle, ZIndex = 152, Parent = idCard }); corner(cBadge, 7)
	local cDot = make("Frame", { AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,9,0.5,0), Size = UDim2.fromOffset(6,6), BackgroundColor3 = NOTIFICATION_STYLES.success.Color, ZIndex = 153, Parent = cBadge }); circle(cDot)
	make("TextLabel", { Text = "CONNECTED", Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(22,0), Size = UDim2.new(1,-27,1,0), ZIndex = 153, Parent = cBadge })

	make("TextLabel", { Text = "ACCOUNT DETAILS", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(18,216), Size = UDim2.new(1,-36,0,16), ZIndex = 152, Parent = profilePanel })
	local details = make("Frame", { Position = UDim2.fromOffset(16,240), Size = UDim2.new(1,-32,0,126), BackgroundColor3 = C.Element, ZIndex = 151, Parent = profilePanel }); corner(details, 11); stroke(details, C.Border)

	local function addPD(idx, lbl, val)
		local y = (idx-1)*42
		local r = make("Frame", { Position = UDim2.fromOffset(0,y), Size = UDim2.new(1,0,0,42), BackgroundTransparency = 1, ZIndex = 152, Parent = details })
		make("TextLabel", { Text = lbl, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(16,0), Size = UDim2.new(0.46,-16,1,0), ZIndex = 153, Parent = r })
		local vL = make("TextLabel", { Text = val, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.new(0.46,0,0,0), Size = UDim2.new(0.54,-16,1,0), ZIndex = 153, Parent = r })
		if idx < 3 then make("Frame", { Position = UDim2.new(0,16,1,-1), Size = UDim2.new(1,-32,0,1), BackgroundColor3 = C.Border, ZIndex = 153, Parent = r }) end
		return vL
	end
	addPD(1, "USER ID", lp and tostring(lp.UserId) or "N/A")
	addPD(2, "ACCOUNT AGE", lp and (tostring(lp.AccountAge).." days") or "N/A")
	local pingLabel = addPD(3, "PING", "-- ms")

	-- ── Performance panel ───────────────────────────────────────────────────
	local perfW = math.max(236, tonumber(opts.PerformanceWidth) or 266)
	local perfH = math.max(260, tonumber(opts.PerformanceHeight) or 294)
	local pGap  = math.max(8, tonumber(opts.ProfilePanelGap) or 12)
	local perfOpenPos  = UDim2.new(1, -(18+pW+pGap), 1, -bM); local perfClosePos = UDim2.new(1, perfW+36, 1, -bM)

	local perfPanel = make("CanvasGroup", { Name = "LivePerformance", AnchorPoint = Vector2.new(1,1), Position = perfClosePos, Size = UDim2.fromOffset(perfW, perfH), BackgroundColor3 = C.CardBg, GroupTransparency = 1, ClipsDescendants = true, ZIndex = 149, Parent = screenGui }); corner(perfPanel, 14)
	local perfHeader = make("Frame", { Size = UDim2.new(1,0,0,56), BackgroundTransparency = 1, ZIndex = 150, Parent = perfPanel })
	make("TextLabel", { Text = opts.PerformanceTitle or "LIVE PERFORMANCE", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(16,11), Size = UDim2.new(1,-94,0,17), ZIndex = 151, Parent = perfHeader })
	make("TextLabel", { Text = "Real-time frame tracker", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(16,31), Size = UDim2.new(1,-94,0,13), ZIndex = 151, Parent = perfHeader })
	local liveBadge = make("Frame", { AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,14), Size = UDim2.fromOffset(58,20), BackgroundColor3 = C.BadgeIdle, ZIndex = 151, Parent = perfHeader }); corner(liveBadge, 6)
	local liveDot = make("Frame", { AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,8,0.5,0), Size = UDim2.fromOffset(5,5), BackgroundColor3 = NOTIFICATION_STYLES.success.Color, ZIndex = 152, Parent = liveBadge }); circle(liveDot)
	make("TextLabel", { Text = "LIVE", Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(19,0), Size = UDim2.new(1,-23,1,0), ZIndex = 152, Parent = liveBadge })

	local fpsSummary = make("Frame", { Position = UDim2.fromOffset(14,58), Size = UDim2.new(1,-28,0,56), BackgroundColor3 = C.Element, ZIndex = 150, Parent = perfPanel }); corner(fpsSummary, 10); stroke(fpsSummary, C.Border)
	make("TextLabel", { Text = "FPS", Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(12,8), Size = UDim2.new(0.5,-12,0,11), ZIndex = 151, Parent = fpsSummary })
	local curFpsLbl = make("TextLabel", { Text = "--", Font = Enum.Font.GothamBold, TextSize = 23, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(12,21), Size = UDim2.new(0.5,-12,0,28), ZIndex = 151, Parent = fpsSummary })
	make("TextLabel", { Text = "FRAME TIME", Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, Position = UDim2.new(0.5,0,0,8), Size = UDim2.new(0.5,-12,0,11), ZIndex = 151, Parent = fpsSummary })
	local ftLbl = make("TextLabel", { Text = "-- ms", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, Position = UDim2.new(0.5,0,0,26), Size = UDim2.new(0.5,-12,0,18), ZIndex = 151, Parent = fpsSummary })
	make("TextLabel", { Text = "FRAME HISTORY", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(16,126), Size = UDim2.new(1,-32,0,13), ZIndex = 150, Parent = perfPanel })

	local graphCard = make("Frame", { Position = UDim2.fromOffset(14,145), Size = UDim2.new(1,-28,0,82), BackgroundColor3 = C.Element, ClipsDescendants = true, ZIndex = 150, Parent = perfPanel }); corner(graphCard, 10); stroke(graphCard, C.Border)
	local graphPlot = make("Frame", { Position = UDim2.fromOffset(10,9), Size = UDim2.new(1,-20,1,-18), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 151, Parent = graphCard })
	for i = 1, 2 do make("Frame", { Position = UDim2.new(0,0,i/3,0), Size = UDim2.new(1,0,0,1), BackgroundColor3 = C.Border, BackgroundTransparency = 0.35, ZIndex = 151, Parent = graphPlot }) end

	local maxFS = 48; local fpsS = {}
	local gpxSz = Vector2.new(math.max(2, math.floor(perfW-48)), 64)
	local graphImg = make("ImageLabel", { Name = "FpsLine", BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), ScaleType = Enum.ScaleType.Stretch, ZIndex = 153, Parent = graphPlot })
	local fpsEI, graphSegs, eiReady, supportsAA = nil, {}, false, true

	local function ensureFB()
		if #graphSegs > 0 then return end; graphImg.Visible = false
		for i = 1, maxFS-1 do graphSegs[i] = make("Frame", { AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(0,1), BackgroundColor3 = C.White, Visible = false, ZIndex = 153, Parent = graphPlot }) end
	end
	do
		local ok2, ed = pcall(function() local img = AssetService:CreateEditableImage({ Size = gpxSz }); graphImg.ImageContent = Content.fromObject(img); return img end)
		if ok2 and ed then fpsEI = ed; eiReady = true else ensureFB() end
	end
	local function clearEG()
		if not eiReady or not fpsEI then return false end
		local ok2 = pcall(function() fpsEI:DrawRectangle(Vector2.zero, gpxSz, Color3.new(0,0,0), 1, Enum.ImageCombineType.Overwrite) end)
		if not ok2 then eiReady = false; ensureFB() end; return ok2
	end
	local function drawEGL(pA, pB)
		if not eiReady or not fpsEI then return false end
		if supportsAA then local ok2 = pcall(function() fpsEI:DrawLine(pA, pB, C.White, 0, Enum.ImageCombineType.Overwrite, Enum.AntiAliasing.Enabled) end); if ok2 then return true end; supportsAA = false end
		local ok2 = pcall(function() fpsEI:DrawLine(pA, pB, C.White, 0, Enum.ImageCombineType.Overwrite) end)
		if not ok2 then eiReady = false; ensureFB() end; return ok2
	end

	local statsStrip = make("Frame", { Position = UDim2.fromOffset(14,237), Size = UDim2.new(1,-28,0,43), BackgroundColor3 = C.Element, ZIndex = 150, Parent = perfPanel }); corner(statsStrip, 10); stroke(statsStrip, C.Border)
	local svL = {}
	for i, nm in ipairs({"AVG","LOW","HIGH"}) do
		local cell = make("Frame", { Position = UDim2.new((i-1)/3,0,0,0), Size = UDim2.new(1/3,0,1,0), BackgroundTransparency = 1, ZIndex = 151, Parent = statsStrip })
		make("TextLabel", { Text = nm, Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,5), Size = UDim2.new(1,0,0,10), ZIndex = 152, Parent = cell })
		svL[i] = make("TextLabel", { Text = "--", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,19), Size = UDim2.new(1,0,0,15), ZIndex = 152, Parent = cell })
	end

	local function redrawFG()
		local n = #fpsS; local ps = graphPlot.AbsoluteSize
		if n < 2 or ps.X <= 1 or ps.Y <= 1 then if eiReady then clearEG() end; for _, s in ipairs(graphSegs) do s.Visible = false end; return end
		local gM = 60; for _, v in ipairs(fpsS) do gM = math.max(gM, v) end; gM = math.max(30, math.ceil(gM/30)*30)
		local den = math.max(n-1, 1)
		if eiReady and clearEG() then
			local w, h = gpxSz.X, gpxSz.Y; local uw, uh = math.max(1,w-2), math.max(1,h-6)
			for i = 1, n-1 do
				if not drawEGL(Vector2.new(1+((i-1)/den)*uw, 3+(1-math.clamp(fpsS[i]/gM,0,1))*uh), Vector2.new(1+(i/den)*uw, 3+(1-math.clamp(fpsS[i+1]/gM,0,1))*uh)) then break end
			end
			if eiReady then return end
		end
		local uh = math.max(1, ps.Y-8)
		for i, seg in ipairs(graphSegs) do
			if i < n then
				local x1,x2 = ((i-1)/den)*ps.X, (i/den)*ps.X
				local y1 = 4+(1-math.clamp(fpsS[i]/gM,0,1))*uh; local y2 = 4+(1-math.clamp(fpsS[i+1]/gM,0,1))*uh
				local dx,dy = x2-x1, y2-y1
				seg.Position = UDim2.fromOffset(x1,y1); seg.Size = UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)+2, 1)
				seg.Rotation = math.deg(math.atan2(dy,dx)); seg.Visible = true
			else seg.Visible = false end
		end
	end

	local function pushFS(fps)
		fps = math.max(0, fps); table.insert(fpsS, fps); if #fpsS > maxFS then table.remove(fpsS, 1) end
		local tot, lo, hi = 0, math.huge, 0
		for _, v in ipairs(fpsS) do tot = tot+v; lo = math.min(lo,v); hi = math.max(hi,v) end
		curFpsLbl.Text = tostring(math.floor(fps+0.5)); ftLbl.Text = string.format("%.1f ms", fps > 0 and (1000/fps) or 0)
		svL[1].Text = tostring(math.floor((#fpsS>0 and tot/#fpsS or 0)+0.5)); svL[2].Text = tostring(math.floor(lo+0.5)); svL[3].Text = tostring(math.floor(hi+0.5))
		redrawFG()
	end

	local function setPV(vis, inst2)
		profileOpen = vis == true
		local tP = profileOpen and pOpenPos or pClosePos; local pP = profileOpen and perfOpenPos or perfClosePos; local tr = profileOpen and 0 or 1
		if inst2 then profilePanel.Position = tP; profilePanel.GroupTransparency = tr; perfPanel.Position = pP; perfPanel.GroupTransparency = tr
		else TweenService:Create(profilePanel, PROFILE_TWEEN, { Position = tP, GroupTransparency = tr }):Play(); TweenService:Create(perfPanel, PROFILE_TWEEN, { Position = pP, GroupTransparency = tr }):Play() end
		if window then window._profileOpen = profileOpen end; return profileOpen
	end

	if lp then task.spawn(function()
		local ok2, img = pcall(function() return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
		if ok2 and avatar and avatar.Parent then avatar.Image = img end
	end) end

	task.spawn(function()
		while screenGui and screenGui.Parent do
			local t = "N/A"; local ok2, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			if ok2 and type(v) == "number" then t = tostring(math.floor(v+0.5)).." ms" end
			if pingLabel and pingLabel.Parent then pingLabel.Text = t end; task.wait(1)
		end
	end)

	window = setmetatable({
		ScreenGui = screenGui, Main = main, Logo = brandLogo,
		_logoAsset = logoAsset, _bgImage = bgImage, _navList = navList, _content = content,
		_notificationHolder = notifHolder, _notificationOrder = 0,
		_profilePanel = profilePanel, _performancePanel = perfPanel, _fpsEditableImage = fpsEI,
		_profileKey = profileKey, _profileOpen = profileOpen, _setProfileVisible = setPV,
		_connections = {}, _noDrag = noDrag, _tabs = {}, _activeTab = nil,
	}, Window)

	window.Notify = function(sO, mO) local o = sO == window and mO or sO; return Window.Notify(window, o) end
	window.Notification = window.Notify

	local fFC, fE = 0, 0
	table.insert(window._connections, RunService.RenderStepped:Connect(function(dt)
		if not screenGui or not screenGui.Parent then return end
		fFC = fFC+1; fE = fE+dt; if fE >= 0.25 then pushFS(fE>0 and (fFC/fE) or 0); fFC = 0; fE = 0 end
	end))
	table.insert(window._connections, UserInputService.InputBegan:Connect(function(inp, gp)
		if not loadingComplete or gp or UserInputService:GetFocusedTextBox() then return end
		if inp.KeyCode == profileKey and Library._windowObjects[#Library._windowObjects] == window then window:ToggleProfile() end
	end))

	table.insert(Library._windowObjects, window)
	if opts.Visible == false then screenGui.Enabled = false end

	-- If a theme with UI transparency is already active when this window is
	-- created, re-apply it so the new instances pick up the transparent look.
	if CURRENT_UI_TRANSPARENCY > 0 then
		task.defer(function()
			applyUITransparency(screenGui, CURRENT_UI_TRANSPARENCY)
		end)
	end

	if loadingEnabled and loadingLayer then
		task.defer(function()
			while not loadingMotionComplete and screenGui.Parent do RunService.Heartbeat:Wait() end
			if not screenGui.Parent or not loadingLayer.Parent then return end
			main.Visible = true
			local mr = TweenService:Create(mainRevealScale, TweenInfo.new(0.46, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 })
			local fo = TweenService:Create(loadingLayer, TweenInfo.new(0.48, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), { GroupTransparency = 1 })
			local ce = loadingContent and TweenService:Create(loadingContent, TweenInfo.new(0.46, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(0.5,0,0.5,-18), GroupTransparency = 1 }) or nil
			local le = loadingLogoScale and TweenService:Create(loadingLogoScale, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.84 }) or nil
			local te = loadingTitleScale and TweenService:Create(loadingTitleScale, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.95 }) or nil
			local pe; if loadingProgressFill and loadingProgressFill.Parent then loadingProgressFill.AnchorPoint = Vector2.new(0.5,0.5); loadingProgressFill.Position = UDim2.fromScale(0.5,0.5); pe = TweenService:Create(loadingProgressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(0,0,1,0) }) end
			mr:Play(); fo:Play(); if ce then ce:Play() end; if le then le:Play() end; if te then te:Play() end; if pe then pe:Play() end
			fo.Completed:Wait(); if loadingLayer and loadingLayer.Parent then loadingLayer:Destroy() end
			if not screenGui.Parent then return end; loadingComplete = true
		end)
	end
	return window
end

-- ── Window methods ──────────────────────────────────────────────────────────
function Window:SetVisible(v) self.ScreenGui.Enabled = v == true end
function Window:Toggle() self.ScreenGui.Enabled = not self.ScreenGui.Enabled; return self.ScreenGui.Enabled end
function Window:SetProfileVisible(v) if not self._setProfileVisible then return false end; self._profileOpen = self._setProfileVisible(v == true); return self._profileOpen end
function Window:ToggleProfile() return self:SetProfileVisible(not self._profileOpen) end
function Window:SetLogo(id) self._logoAsset = normalizeAssetId(id); if self.Logo then self.Logo.Image = self._logoAsset end; return self._logoAsset end

function Window:Notify(opts)
	if type(opts) == "string" then opts = { Content = opts } end; opts = opts or {}
	local holder = self._notificationHolder; if not holder or not holder.Parent then return nil end
	local style = getNotificationStyle(opts.Type); local dur = tonumber(opts.Duration); if dur == nil then dur = 4 end; dur = math.max(dur, 0)
	self._notificationOrder = self._notificationOrder + 1
	local tT = tostring(opts.Title or style.Name); local cT = tostring(opts.Content or opts.Description or opts.Message or "Notification")
	local slot = make("Frame", { Name = "NotifSlot", Size = UDim2.new(1,0,0,62), BackgroundTransparency = 1, LayoutOrder = self._notificationOrder, ZIndex = 200, Parent = holder })
	local card = make("CanvasGroup", { Name = style.Name.."Notif", AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,12,0,0), Size = UDim2.fromScale(1,1), BackgroundColor3 = C.CardBg, GroupTransparency = 1, ClipsDescendants = true, ZIndex = 201, Parent = slot }); corner(card, 6); stroke(card, C.Border)
	make("TextLabel", { Text = tT, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1, Position = UDim2.fromOffset(12,9), Size = UDim2.new(1,-42,0,16), ZIndex = 202, Parent = card })
	make("TextLabel", { Text = cT, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, BackgroundTransparency = 1, Position = UDim2.fromOffset(12,29), Size = UDim2.new(1,-24,0,24), ZIndex = 202, Parent = card })
	local cBtn = make("TextButton", { Text = "×", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = C.TextDim, AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-7,0,5), Size = UDim2.fromOffset(20,20), BackgroundTransparency = 1, ZIndex = 204, Parent = card })
	local closed = false; local handle = {}
	local function close(r) if closed then return end; closed = true; TweenService:Create(card, NOTIFICATION_TWEEN, { Position = UDim2.new(1,12,0,0), GroupTransparency = 1 }):Play(); task.delay(0.2, function() if slot and slot.Parent then slot:Destroy() end end); fire(opts.Callback or opts.OnClose, r or "closed") end
	function handle:Close() close("manual") end; function handle:IsOpen() return not closed end
	cBtn.MouseEnter:Connect(function() tween(cBtn, { TextColor3 = C.White }) end); cBtn.MouseLeave:Connect(function() tween(cBtn, { TextColor3 = C.TextDim }) end); cBtn.MouseButton1Click:Connect(function() close("manual") end)
	TweenService:Create(card, NOTIFICATION_TWEEN, { Position = UDim2.new(1,0,0,0), GroupTransparency = 0 }):Play()
	if dur > 0 then task.delay(dur, function() close("timeout") end) end; return handle
end

function Window:Destroy()
	for _, c in ipairs(self._connections or {}) do c:Disconnect() end; table.clear(self._connections or {})
	if self._fpsEditableImage then pcall(function() self._fpsEditableImage:Destroy() end); self._fpsEditableImage = nil end
	local i = table.find(Library._windows, self.ScreenGui); if i then table.remove(Library._windows, i) end
	local j = table.find(Library._windowObjects, self); if j then table.remove(Library._windowObjects, j) end
	if self.ScreenGui then self.ScreenGui:Destroy() end
end

function Window:_selectTab(tab)
	if self._activeTab == tab then return end; local prev = self._activeTab; self._activeTab = tab
	if prev then prev._page.Visible = false; paint(prev._nav, "BackgroundColor3", "WindowBg"); paint(prev._navLabel, "TextColor3", "TextGray"); paint(prev._navBadge, "BackgroundColor3", "BadgeIdle"); paint(prev._navIcon, "TextColor3", "TextGray") end
	tab._page.Visible = true; paint(tab._nav, "BackgroundColor3", "NavActive"); paint(tab._navLabel, "TextColor3", "White"); paint(tab._navBadge, "BackgroundColor3", "Badge"); paint(tab._navIcon, "TextColor3", "White")
	-- Re-apply transparency for the newly visible page
	if CURRENT_UI_TRANSPARENCY > 0 then
		task.defer(function() applyUITransparency(self.ScreenGui, CURRENT_UI_TRANSPARENCY) end)
	end
end

function Window:AddTab(opts)
	if type(opts) == "string" then opts = { Name = opts } end; opts = opts or {}
	local name = opts.Name or "Tab"; local icon = opts.Icon or string.upper(string.sub(name,1,1)); local win = self
	local nav = make("TextButton", { Text = "", Size = UDim2.new(1,0,0,40), BackgroundColor3 = C.WindowBg, Parent = self._navList }); autoOrder(nav); corner(nav, 8); stroke(nav, C.Border); table.insert(win._noDrag, nav)
	local nB = make("Frame", { Size = UDim2.fromOffset(24,24), Position = UDim2.new(0,8,0.5,0), AnchorPoint = Vector2.new(0,0.5), BackgroundColor3 = C.BadgeIdle, Parent = nav }); circle(nB)
	local nI = make("TextLabel", { Text = icon, Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.TextGray, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = nB })
	local nL = make("TextLabel", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(40,0), Size = UDim2.new(1,-48,1,0), Parent = nav })
	local page = make("Frame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Visible = false, Parent = self._content })
	local header = make("Frame", { Size = UDim2.new(1,0,0,88), BackgroundTransparency = 1, Parent = page })
	local badge = make("Frame", { Size = UDim2.fromOffset(28,28), Position = UDim2.fromOffset(16,16), BackgroundColor3 = C.Badge, Parent = header }); circle(badge)
	make("TextLabel", { Text = icon, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.White, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = badge })
	make("TextLabel", { Text = name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(54,17), Size = UDim2.new(1,-70,0,14), Parent = header })
	make("TextLabel", { Text = opts.Subtitle or "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(54,33), Size = UDim2.new(1,-70,0,12), Parent = header })
	local pillRow = make("Frame", { Position = UDim2.fromOffset(16,54), Size = UDim2.new(1,-32,0,24), BackgroundTransparency = 1, Parent = header })
	make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8), Parent = pillRow })
	make("Frame", { Position = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1), BackgroundColor3 = C.Border, Parent = header })
	local pgH = make("Frame", { Position = UDim2.fromOffset(0,88), Size = UDim2.new(1,0,1,-88), BackgroundTransparency = 1, Parent = page })
	local tab = setmetatable({ _window = win, _nav = nav, _navLabel = nL, _navBadge = nB, _navIcon = nI, _page = page, _pillRow = pillRow, _pagesHolder = pgH, _subTabs = {}, _activeSub = nil }, Tab)
	nav.MouseButton1Click:Connect(function() win:_selectTab(tab) end)
	nav.MouseEnter:Connect(function() if win._activeTab ~= tab then tween(nav, { BackgroundColor3 = C.NavHover }) end end)
	nav.MouseLeave:Connect(function() tween(nav, { BackgroundColor3 = win._activeTab == tab and C.NavActive or C.WindowBg }) end)
	table.insert(self._tabs, tab); if not self._activeTab then self:_selectTab(tab) end; return tab
end

-- ── Tab ─────────────────────────────────────────────────────────────────────
function Tab:_selectSub(sub)
	if self._activeSub == sub then return end; local prev = self._activeSub; self._activeSub = sub
	if prev then prev._page.Visible = false; paint(prev._pill, "BackgroundColor3", "WindowBg"); paint(prev._pill, "TextColor3", "TextGray") end
	sub._page.Visible = true; paint(sub._pill, "BackgroundColor3", "PillActive"); paint(sub._pill, "TextColor3", "White")
	if CURRENT_UI_TRANSPARENCY > 0 then
		task.defer(function() applyUITransparency(self._window.ScreenGui, CURRENT_UI_TRANSPARENCY) end)
	end
end

function Tab:AddSubTab(name)
	name = tostring(name or "General"); local tab = self
	local pill = make("TextButton", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.TextGray, BackgroundColor3 = C.WindowBg, Size = UDim2.new(0,0,0,24), AutomaticSize = Enum.AutomaticSize.X, Parent = self._pillRow }); autoOrder(pill); corner(pill, 6); pad(pill, 0, 0, 12, 12); table.insert(tab._window._noDrag, pill)
	local page = make("ScrollingFrame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Visible = false, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Border, Parent = self._pagesHolder }); pad(page, 12, 16, 16, 16); table.insert(tab._window._noDrag, page)
	local card = make("Frame", { Size = UDim2.new(1,-32,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.CardBg, Parent = page }); corner(card, 10); stroke(card); pad(card, 14, 14, 16, 16)
	make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8), Parent = card })
	local sub = setmetatable({ _tab = tab, _window = tab._window, _pill = pill, _page = page, _card = card }, SubTab)
	pill.MouseButton1Click:Connect(function() tab:_selectSub(sub) end)
	pill.MouseEnter:Connect(function() if tab._activeSub ~= sub then tween(pill, { BackgroundColor3 = C.NavHover }) end end)
	pill.MouseLeave:Connect(function() tween(pill, { BackgroundColor3 = tab._activeSub == sub and C.PillActive or C.WindowBg }) end)
	table.insert(self._subTabs, sub); if not self._activeSub then self:_selectSub(sub) end; return sub
end

-- ── SubTab components ───────────────────────────────────────────────────────
local function newRow(card, h) local r = make("Frame", { Size = UDim2.new(1,0,0,h), BackgroundTransparency = 1, Parent = card }); autoOrder(r); return r end
local function rowLabels(row, name, desc, rr)
	rr = rr or 0
	make("TextLabel", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = desc and UDim2.new(1,-rr,0,14) or UDim2.new(1,-rr,1,0), Parent = row })
	if desc then make("TextLabel", { Text = desc, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,-rr,0,12), Parent = row }) end
end

function SubTab:AddToggle(opts)
	opts = opts or {}; local value = opts.Default == true
	local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Toggle", opts.Description, 44)
	local pill = make("TextButton", { Text = "", Size = UDim2.fromOffset(34,18), AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,0,0.5,0), BackgroundColor3 = C.Badge, Parent = row }); circle(pill)
	local knob = make("Frame", { Size = UDim2.fromOffset(14,14), AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,2,0.5,0), BackgroundColor3 = C.KnobOff, Parent = pill }); circle(knob)
	local function render(a) local kp = value and UDim2.new(0,18,0.5,0) or UDim2.new(0,2,0.5,0); paint(pill, "BackgroundColor3", value and "White" or "Badge", not a); paint(knob, "BackgroundColor3", value and "KnobOn" or "KnobOff", not a); if a then tween(knob, { Position = kp }) else knob.Position = kp end end
	local function set(v) v = v == true; if v == value then return end; value = v; render(true); fire(opts.Callback, value) end
	pill.MouseButton1Click:Connect(function() set(not value) end); render(false)
	return { Set = function(_, v) set(v) end, Get = function() return value end }
end

function SubTab:AddButton(opts)
	opts = opts or {}
	local btn = make("TextButton", { Text = opts.Name or "Button", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.TextGray, Size = UDim2.new(1,0,0,28), BackgroundColor3 = C.Element, Parent = self._card }); autoOrder(btn); corner(btn, 6)
	btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = C.ElementHover }) end); btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = C.Element }) end)
	btn.MouseButton1Click:Connect(function() fire(opts.Callback) end); return btn
end

function SubTab:AddInput(opts)
	opts = opts or {}; local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Input", opts.Description, 120)
	local holder = make("Frame", { Size = UDim2.fromOffset(110,22), AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,0,0.5,0), BackgroundColor3 = C.Element, Parent = row }); corner(holder, 6)
	local box = make("TextBox", { Text = opts.Default or "", PlaceholderText = opts.Placeholder or "...", PlaceholderColor3 = C.Placeholder, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, ClearTextOnFocus = false, ClipsDescendants = true, Position = UDim2.fromOffset(8,0), Size = UDim2.new(1,-30,1,0), Parent = holder }); inputIcon(holder)
	box.FocusLost:Connect(function(ep) fire(opts.Callback, box.Text, ep) end)
	return { Set = function(_, t) box.Text = tostring(t) end, Get = function() return box.Text end }
end

function SubTab:AddDropdown(opts)
	opts = opts or {}; local options = opts.Options or {}; local value = opts.Default or options[1] or ""
	local row = newRow(self._card, 30); rowLabels(row, opts.Name or "Dropdown", opts.Description, 90)
	local btn = make("TextButton", { Text = "", Size = UDim2.fromOffset(80,22), AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,0,0.5,0), BackgroundColor3 = C.Element, Parent = row }); corner(btn, 6)
	local vl = make("TextLabel", { Text = value, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.fromOffset(8,0), Size = UDim2.new(1,-26,1,0), Parent = btn }); sortIcon(btn)
	local win = self._window; local sp = self._page; local tp = self._tab._page
	local lh = #options*22 + math.max(#options-1,0)*2 + 8
	local list = make("Frame", { Visible = false, Active = true, Size = UDim2.new(0,80,0,0), BackgroundColor3 = C.Element, ClipsDescendants = true, ZIndex = 100, Parent = win.ScreenGui }); corner(list, 6); stroke(list); pad(list, 4, 4, 4, 4)
	make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2), Parent = list }); table.insert(win._noDrag, list)
	local open, cg, oc = false, 0, {}
	local function repos() local ins = GuiService:GetGuiInset(); local p, s = btn.AbsolutePosition, btn.AbsoluteSize; list.Position = UDim2.fromOffset(p.X+ins.X+s.X-80, p.Y+ins.Y+s.Y+4) end
	local function setOpen(o)
		if open == o then return end; open = o; cg = cg+1
		if open then repos(); list.Visible = true; tween(list, { Size = UDim2.new(0,80,0,lh) })
			table.insert(oc, btn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() local bp, bs = btn.AbsolutePosition, btn.AbsoluteSize; local pp, ps = sp.AbsolutePosition, sp.AbsoluteSize; if bp.Y+bs.Y < pp.Y or bp.Y > pp.Y+ps.Y then setOpen(false) else repos() end end))
			table.insert(oc, sp:GetPropertyChangedSignal("Visible"):Connect(function() if not sp.Visible then setOpen(false) end end))
			table.insert(oc, tp:GetPropertyChangedSignal("Visible"):Connect(function() if not tp.Visible then setOpen(false) end end))
			table.insert(oc, UserInputService.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then local pos = Vector2.new(inp.Position.X, inp.Position.Y); if not isInside(btn, pos) and not isInside(list, pos) then setOpen(false) end end end))
		else for _, c in ipairs(oc) do c:Disconnect() end; table.clear(oc); tween(list, { Size = UDim2.new(0,80,0,0) }); local g = cg; task.delay(0.16, function() if g == cg and not open then list.Visible = false end end) end
	end
	local function sel(opt, silent) value = opt; vl.Text = opt; setOpen(false); if not silent then fire(opts.Callback, opt) end end
	for _, opt in ipairs(options) do
		local ob = make("TextButton", { Text = opt, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.TextGray, Size = UDim2.new(1,0,0,22), BackgroundColor3 = C.Element, Parent = list }); autoOrder(ob); corner(ob, 4)
		ob.MouseEnter:Connect(function() tween(ob, { BackgroundColor3 = C.ElementHover, TextColor3 = C.White }) end)
		ob.MouseLeave:Connect(function() tween(ob, { BackgroundColor3 = C.Element, TextColor3 = C.TextGray }) end)
		ob.MouseButton1Click:Connect(function() sel(opt) end)
	end
	btn.MouseButton1Click:Connect(function() setOpen(not open) end)
	btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = C.ElementHover }) end); btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = C.Element }) end)
	return { Set = function(_, o) sel(o) end, Get = function() return value end }
end

function SubTab:AddSlider(opts)
	opts = opts or {}; local mn, mx, suf = opts.Min or 0, opts.Max or 100, opts.Suffix or ""; local value = math.clamp(opts.Default or mn, mn, mx)
	local row = newRow(self._card, 32)
	make("TextLabel", { Text = opts.Name or "Slider", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(0.6,0,0,14), Parent = row })
	local vl = make("TextLabel", { Text = tostring(value)..suf, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,1), Size = UDim2.new(1,0,0,13), Parent = row })
	local track = make("Frame", { Position = UDim2.fromOffset(0,24), Size = UDim2.new(1,0,0,4), BackgroundColor3 = C.TrackBg, Parent = row }); circle(track)
	local fill = make("Frame", { Size = UDim2.new(0,0,1,0), BackgroundColor3 = C.White, Parent = track }); circle(fill)
	local knob = make("Frame", { Size = UDim2.fromOffset(12,12), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0,0,0.5,0), BackgroundColor3 = C.White, ZIndex = 2, Parent = track }); circle(knob)
	local hit = make("TextButton", { Text = "", BackgroundTransparency = 1, Position = UDim2.new(0,-6,0,16), Size = UDim2.new(1,12,0,20), Parent = row })
	local function apply(v, a, fc) value = math.clamp(math.floor(v+0.5), mn, mx); local pct = mx > mn and (value-mn)/(mx-mn) or 0; vl.Text = tostring(value)..suf; local fs = UDim2.new(pct,0,1,0); local kp = UDim2.new(pct,0,0.5,0); if a then tween(fill, { Size = fs }); tween(knob, { Position = kp }) else fill.Size = fs; knob.Position = kp end; if fc then fire(opts.Callback, value) end end
	local function vfx(x) return mn + (mx-mn) * math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1) end
	local dragging = false
	hit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; apply(vfx(i.Position.X), true, true) end end)
	UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(vfx(i.Position.X), true, true) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
	apply(value, false, false)
	return { Set = function(_, v) apply(v, true, true) end, Get = function() return value end }
end

return Library
