--[[
Solis UI — Themes File
Fetched automatically by SolisUI at startup.

Manual usage:
	local Themes = loadstring(game:HttpGet(
		"https://raw.githubusercontent.com/YOUR_NAME/YOUR_REPO/main/themes.lua"
	))()
	Library:SetTheme(Themes.Solis)

Optional theme keys:
	Image             — URL or rbxassetid for background image
	ImageTransparency — 0–1 how see-through the background is (default 0.85)
]]

local Themes = {}

Themes.Dark = {
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

Themes.Light = {
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
}

Themes.OLED = {
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
}

Themes.Solis = {
	Image             = "https://raw.githubusercontent.com/leleo2083-eng/SolisUILibary/main/Solis.png",
	ImageTransparency = 0.82,

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
}

return Themes
