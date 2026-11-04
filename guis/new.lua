local vape = {
	ActiveBinds = {},
	Categories = {},
	GUIColor = {
		Hue = 0.46,
		Sat = 0.96,
		Value = 0.52
	},
	HeldKeybinds = {},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId,
	Profile = 'default',
	RainbowSliders = {},
	Settings = {},
	SettingToggleNotifications = {},
	ThreadFix = setthreadidentity and true or false,
	ToggleNotifications = {},
	Version = '4.22',
	Windows = {}
}

local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
local runService = cloneref(game:GetService('RunService'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local notifications
local getvapeasset
local components
local clickgui
local scaledgui
local toolblur
local tooltip
local TextGUI
local scale = {Scale = 1}
local gui

local isfile = isfile or function(file)
	local success, data = pcall(function()
		return readfile(file)
	end)

	return success and data ~= nil and data ~= ''
end

local function loadJson(path)
	local success, data = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)

	return success and type(data) == 'table' and data or nil
end

local Library = (function()
	local cloneref = (cloneref or clonereference or function(instance: any)
	    return instance
	end)
	local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
	local GuiService: GuiService = cloneref(game:GetService("GuiService"))
	local Players: Players = cloneref(game:GetService("Players"))
	local RunService: RunService = cloneref(game:GetService("RunService"))
	local SoundService: SoundService = cloneref(game:GetService("SoundService"))
	local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
	local TextService: TextService = cloneref(game:GetService("TextService"))
	local Teams: Teams = cloneref(game:GetService("Teams"))
	local TweenService: TweenService = cloneref(game:GetService("TweenService"))

	local getgenv = getgenv or function()
	    return shared
	end
	local setclipboard = setclipboard or nil
	local protectgui = protectgui or (syn and syn.protect_gui) or function() end
	local gethui = gethui or function()
	    return CoreGui
	end

	local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
	local Mouse = cloneref(LocalPlayer:GetMouse())

	local Labels = {}
	local Buttons = {}
	local Toggles = {}
	local Options = {}
	local Tooltips = {}

	local BaseURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
	local CustomImageManager = {}
	local CustomImageManagerAssets = {
	    TransparencyTexture = {
	        RobloxId = 139785960036434,
	        Path = "Obsidian/assets/TransparencyTexture.png",
	        URL = BaseURL .. "assets/TransparencyTexture.png",

	        Id = nil,
	    },

	    SaturationMap = {
	        RobloxId = 4155801252,
	        Path = "Obsidian/assets/SaturationMap.png",
	        URL = BaseURL .. "assets/SaturationMap.png",

	        Id = nil,
	    },

	    LoadingIcon = {
	        RobloxId = 97544096941083,
	        Path = "Obsidian/assets/LoadingIcon.png",
	        URL = BaseURL .. "assets/LoadingIcon.png",

	        Id = nil,
	    },

	    CheckIcon = {
	        RobloxId = 97682394690683,
	        Path = "Obsidian/assets/CheckIcon.png",
	        URL = BaseURL .. "assets/CheckIcon.png",

	        Id = nil,
	    },
	}
	do
	    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
	        if not isfolder or not makefolder then
	            return
	        end

	        local Segments = Path:split("/")
	        local TraversedPath = ""

	        if IsFile then
	            table.remove(Segments, #Segments)
	        end

	        for _, Segment in ipairs(Segments) do
	            if not isfolder(TraversedPath .. Segment) then
	                makefolder(TraversedPath .. Segment)
	            end

	            TraversedPath = TraversedPath .. Segment .. "/"
	        end

	        return TraversedPath
	    end

	    function CustomImageManager.AddAsset(
	        AssetName: string,
	        RobloxAssetId: number,
	        URL: string,
	        ForceRedownload: boolean?
	    )
	        if CustomImageManagerAssets[AssetName] ~= nil then
	            error(string.format("Asset %q already exists", AssetName))
	        end

	        assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

	        CustomImageManagerAssets[AssetName] = {
	            RobloxId = RobloxAssetId,
	            Path = string.format("Obsidian/custom_assets/%s", AssetName),
	            URL = URL,

	            Id = nil,
	        }

	        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
	    end

	    function CustomImageManager.GetAsset(AssetName: string)
	        if not CustomImageManagerAssets[AssetName] then
	            return nil
	        end

	        local AssetData = CustomImageManagerAssets[AssetName]
	        if AssetData.Id then
	            return AssetData.Id
	        end

	        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

	        if getcustomasset then
	            local Success, NewID = pcall(getcustomasset, AssetData.Path)

	            if Success and NewID then
	                AssetID = NewID
	            end
	        end

	        AssetData.Id = AssetID
	        return AssetID
	    end

	    function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
	        if not getcustomasset or not writefile or not isfile then
	            return false, "missing functions"
	        end

	        local AssetData = CustomImageManagerAssets[AssetName]

	        RecursiveCreatePath(AssetData.Path, true)

	        if ForceRedownload ~= true and isfile(AssetData.Path) then
	            return true, nil
	        end

	        local success, errorMessage = pcall(function()
	            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
	        end)

	        return success, errorMessage
	    end

	    for AssetName, _ in CustomImageManagerAssets do
	        CustomImageManager.DownloadAsset(AssetName)
	    end
	end

	local Library = {
	    LocalPlayer = LocalPlayer,
	    IsRobloxFocused = true,

	    --// Device \\--
	    DevicePlatform = nil,
	    IsMobile = false,

	    --// Obsidian Windows \\--
	    ScreenGui = nil,
	    Floats = nil,
	    Overlay = nil,

	    Window = nil,
	    WindowContainer = nil,

	    --// Search \\--
	    SearchText = "",
	    Searching = false,
	    GlobalSearch = false,
	    LastSearchTab = nil,

	    --// Tabs \\--
	    ActiveTab = nil,
	    PreviousTab = nil,
	    Tabs = {},
	    TabButtons = {},

	    --// Dependency Boxes \\--
	    DependencyBoxes = {},

	    --// Keybinds Frame \\--
	    KeybindFrame = nil,
	    KeybindContainer = nil,
	    KeybindToggles = {},
	    KeybindMenu = nil,

	    --// Notifications \\--
	    Notifications = {},
	    NotifySide = "Right",
	    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	    --// Dialogues \\--
	    Dialogues = {},
	    ActiveDialog = nil,

	    --// Loading Window \\--
	    ActiveLoading = nil,

	    --// Context Menu \\--
	    ContextMenus = {}, 

	    --// Corners \\--
	    Corners = {},
	    SpecificCorners = {},

	    --// Animations \\--
	    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	    TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	    TabSwipeOffset = 26,
	    TabSwipeFrom = "bottom",

	    WindowAnimationInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	    DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	    KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	    GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	    RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

	    Animations = {
	        ToggleWindow = false,
	        TabSwitch = false,
	        Groupbox = false,
	        Dropdown = false,
	        KeyPicker = false
	    },

	    --// States \\--
	    Toggled = false,
	    Unloaded = false,

	    --// Elements \\--
	    Labels = Labels,
	    Buttons = Buttons,
	    Toggles = Toggles,
	    Options = Options,

	    --// Options \\--
	    ToggleKeybind = Enum.KeyCode.RightControl,
	    ShowToggleFrameInKeybinds = true,

	    NotifyOnError = false,
	    ShowCustomCursor = true,
	    ForceCheckbox = false,

	    CantDragForced = false,
	    DraggableElements = {},

	    --// Pop Out \\--
	    PopOutSnapDistance = 80,
	    PopOutDragThreshold = 8,
	    PopOutHoldTime = 0.15,

	    --// Signals \\--
	    Signals = {},
	    UnloadSignals = {},

	    OriginalMinSize = Vector2.new(480, 360),
	    MinSize = Vector2.new(480, 360),
	    DPIScale = 1,
	    CornerRadius = 4,

	    --// Scheme \\--
	    IsLightTheme = false,
	    Scheme = {
	        BackgroundColor = Color3.fromRGB(15, 15, 15),
	        MainColor = Color3.fromRGB(25, 25, 25),
	        AccentColor = Color3.fromRGB(125, 85, 255),
	        OutlineColor = Color3.fromRGB(40, 40, 40),
	        FontColor = Color3.new(1, 1, 1),
	        Font = Font.fromEnum(Enum.Font.Code),

	        RedColor = Color3.fromRGB(255, 50, 50),
	        DestructiveColor = Color3.fromRGB(220, 38, 38),
	        DarkColor = Color3.new(0, 0, 0),
	        WhiteColor = Color3.new(1, 1, 1),

	        BackgroundImage = ""
	    },

	    --// Registry \\--
	    Registry = {},
	    Scales = {},
	    ScalesOffset = {},

	    --// Mouse \\--
	    OriginalMouseIconEnabled = UserInputService.MouseIconEnabled,
	    ShowCursorBinding = string.sub(tostring({}), 10),

	    --// Image Manager \\--
	    ImageManager = CustomImageManager,
	    MaxSpriteIconSize = 24,

	    --// Misc \\--
	    Notify = nil, Toggle = nil -- we love luau lsp
	}

	if RunService:IsStudio() then
	    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
	        Library.IsMobile = true
	        Library.OriginalMinSize = Vector2.new(480, 240)
	    else
	        Library.IsMobile = false
	        Library.OriginalMinSize = Vector2.new(480, 360)
	    end
	else
	    pcall(function()
	        Library.DevicePlatform = UserInputService:GetPlatform()
	    end)

	    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
	    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
	end

	local Templates = {
	    --// UI \\--
	    Frame = {
	        BorderSizePixel = 0,
	    },
	    ImageLabel = {
	        BackgroundTransparency = 1,
	        BorderSizePixel = 0,
	    },
	    ImageButton = {
	        AutoButtonColor = false,
	        BorderSizePixel = 0,
	    },
	    ScrollingFrame = {
	        BorderSizePixel = 0,
	    },
	    TextLabel = {
	        BorderSizePixel = 0,
	        FontFace = "Font",
	        RichText = true,
	        TextColor3 = "FontColor",
	    },
	    TextButton = {
	        AutoButtonColor = false,
	        BorderSizePixel = 0,
	        FontFace = "Font",
	        RichText = true,
	        TextColor3 = "FontColor",
	    },
	    TextBox = {
	        BorderSizePixel = 0,
	        FontFace = "Font",
	        PlaceholderColor3 = function()
	            local H, S, V = Library.Scheme.FontColor:ToHSV()
	            return Color3.fromHSV(H, S, V / 2)
	        end,
	        Text = "",
	        TextColor3 = "FontColor",
	    },
	    UIListLayout = {
	        SortOrder = Enum.SortOrder.LayoutOrder,
	    },
	    UIStroke = {
	        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	    },

	    --// Library \\--
	    Window = {
	        Title = "No Title",
	        Footer = "No Footer",

	        Position = UDim2.fromOffset(6, 6),
	        Size = UDim2.fromOffset(720, 600),
	        IconSize = UDim2.fromOffset(30, 30),

	        AutoShow = true,
	        Center = true,
	        Resizable = true,
	        AlwaysOnTop = false,

	        --// Window Snapping \\--
	        Snapping = false,
	        SnapDistance = 28,
	        SnapMargin = 8,
	        SnapAvoidCoreGui = true,

	        SearchbarSize = UDim2.fromScale(1, 1),
	        GlobalSearch = false,

	        CornerRadius = 4,
	        NotifySide = "Right",
	        ShowCustomCursor = true,

	        Font = Enum.Font.Code,
	        ToggleKeybind = Enum.KeyCode.RightControl,

	        ShowMobileButtons = true,
	        MobileButtonsSide = "Left",

	        UnlockMouseWhileOpen = true,

	        EnableSidebarResize = false,
	        EnableCompacting = true,
	        DisableCompactingSnap = false,
	        SidebarCompacted = false,
	        MinContainerWidth = 256,

	        --// Snapping \\--
	        MinSidebarWidth = 128,
	        SidebarCompactWidth = 48,
	        SidebarCollapseThreshold = 0.5,

	        --// Dragging \\--
	        CompactWidthActivation = 128,

	        --// Background \\--
	        BackgroundImage = "",

	        --// Animations \\--
	        Animations = {
	            ToggleWindow = false,
	            TabSwitch = false,
	            Groupbox = false,
	            Dropdown = false,
	            KeyPicker = false,
	        },

	        TabTransitionTime = 0.22,
	        TabSwipeOffset = 26,
	        TabSwipeFrom = "bottom",
	        TabButtonsStyle = {
	            Gap = 0,
	            Padding = 0,
	            CornerRadius = 0,
	            Indicator = false,
	            IndicatorWidth = 2,
	            IndicatorHeight = 20,
	        },
	    },
	    Groupbox = {
	        Side = 1,
	        Name = "Groupbox",
	        IconName = nil,
	        Description = nil,
	        Visible = true,
	        Collapsed = false,
	        DisableCollapsing = false,
	        MaxHeight = nil,
	        PopOut = true,
	        MaxPopOutHeight = nil,
	        PopOutWidth = nil,
	    },
	    Tabbox = {
	        Side = 1,
	        Name = nil,
	        MaxHeight = nil,
	        PopOut = true,
	        MaxPopOutHeight = nil,
	        PopOutWidth = nil,
	    },
	    Settings = {
	        Width = nil,
	    },
	    Dialog = {
	        Title = "Dialog",
	        Description = "Description",
	        AutoDismiss = true,
	        OutsideClickDismiss = true,
	        FooterButtons = {}
	    },
	    Loading = {
	        Title = "mspaint",
	        Icon = 95816097006870,
	        IconSize = UDim2.fromOffset(30, 30),

	        LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
	        LoadingIconColor = nil,
	        LoadingIconTweenTime = 1,

	        CurrentStep = 0,
	        TotalSteps = 10,

	        ShowSidebar = false,
	        AutoResizeHeight = false,
	        AlwaysOnTop = true,

	        WindowWidth = 450,
	        WindowHeight = 275,

	        ContentWidth = 450,
	        SidebarWidth = 250,
	    },
	    Toggle = {
	        Text = "Toggle",
	        Default = false,

	        Callback = function() end,
	        Changed = function() end,

	        Risky = false,
	        Disabled = false,
	        Visible = true,
	    },
	    Input = {
	        Text = "Input",
	        Default = "",
	        Finished = false,
	        Numeric = false,
	        ClearTextOnFocus = true,
	        ClearTextOnBlur = false,
	        Placeholder = "",
	        AllowEmpty = true,
	        EmptyReset = "---",

	        Callback = function() end,
	        Changed = function() end,
	        VerifyValue = nil,

	        Disabled = false,
	        Visible = true,
	    },
	    Slider = {
	        Text = "Slider",
	        Default = 0,
	        Min = 0,
	        Max = 100,
	        Rounding = 0,

	        Prefix = "",
	        Suffix = "",

	        Callback = function() end,
	        Changed = function() end,

	        Disabled = false,
	        Visible = true,

	        AllowRightClickInput = true
	    },
	    Dropdown = {
	        Values = {},
	        DisabledValues = {},
	        ValueImages = {},

	        Multi = false,
	        DragSelect = false,
	        MaxVisibleDropdownItems = 8,
	        KeepDisabledValuePosition = false,

	        Callback = function() end,
	        Changed = function() end,

	        Disabled = false,
	        Visible = true,
	    },
	    Viewport = {
	        Object = nil,
	        Camera = nil,
	        Clone = true,
	        AutoFocus = true,
	        Interactive = false,
	        Height = 200,
	        Visible = true,
	    },
	    Image = {
	        Image = "",
	        Transparency = 0,
	        BackgroundTransparency = 0,
	        Color = Color3.new(1, 1, 1),
	        RectOffset = Vector2.zero,
	        RectSize = Vector2.zero,
	        ScaleType = Enum.ScaleType.Fit,
	        Height = 200,
	        Visible = true,
	    },
	    Video = {
	        Video = "",
	        Looped = false,
	        Playing = false,
	        Volume = 1,
	        Height = 200,
	        Visible = true,
	    },
	    UIPassthrough = {
	        Instance = nil,
	        Height = 24,
	        Visible = true,
	    },

	    --// Addons \\-
	    KeyPicker = {
	        Text = "KeyPicker",

	        Default = "None",
	        DefaultModifiers = {},

	        Blacklisted = {},
	        BlacklistedModifiers = {},
	        Whitelisted = {},
	        WhitelistedModifiers = {},

	        Mode = "Toggle",
	        Modes = { "Always", "Toggle", "Hold" },
	        SyncToggleState = false,

	        Callback = function() end,
	        ChangedCallback = function() end,
	        Changed = function() end,
	        Clicked = function() end,
	    },
	    ColorPicker = {
	        Default = Color3.new(1, 1, 1),

	        Resizable = true,

	        Callback = function() end,
	        Changed = function() end,
	    },
	}

	local Places = {
	    Bottom = { 0, 1 },
	    Right = { 1, 0 },
	}
	local Sizes = {
	    Left = { 0.5, 1 },
	    Right = { 0.5, 1 },
	}
	local SideIndex = {
	    left = 1,
	    right = 2,
	}

	--// Scheme Functions \\--
	local SchemeReplaceAlias = {
	    RedColor = "Red",
	    WhiteColor = "White",
	    DarkColor = "Dark"
	}

	local SchemeAlias = {
	    Red = "RedColor",
	    White = "WhiteColor",
	    Dark = "DarkColor"
	}

	local function GetSchemeValue(Index)
	    if not Index then
	        return nil
	    end

	    local ReplaceAliasIndex = SchemeReplaceAlias[Index]
	    if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
	        Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
	        Library.Scheme[ReplaceAliasIndex] = nil

	        return Library.Scheme[Index]
	    end

	    local AliasIndex = SchemeAlias[Index]
	    if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
	        warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
	        return Library.Scheme[AliasIndex]
	    end

	    return Library.Scheme[Index]
	end

	local function GetTextStrokeColor(): Color3
	    local Color = Library.Scheme.FontColor
	    return (Color.R * 0.299 + Color.G * 0.587 + Color.B * 0.114) > 0.5 and Library.Scheme.DarkColor or Library.Scheme.WhiteColor
	end

	--// Basic Functions \\--
	local function WaitForEvent(Event, Timeout, Condition)
	    local Bindable = Instance.new("BindableEvent")
	    local Connection = Event:Once(function(...)
	        if not Condition or typeof(Condition) == "function" and Condition(...) then
	            Bindable:Fire(true)
	        else
	            Bindable:Fire(false)
	        end
	    end)
	    task.delay(Timeout, function()
	        Connection:Disconnect()
	        Bindable:Fire(false)
	    end)

	    local Result = Bindable.Event:Wait()
	    Bindable:Destroy()

	    return Result
	end

	local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
	    return Input.UserInputType == Enum.UserInputType.MouseButton1
	        or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
	        or Input.UserInputType == Enum.UserInputType.Touch
	end
	local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
	    return IsMouseInput(Input, IncludeM2)
	        and Input.UserInputState == Enum.UserInputState.Begin
	        and Library.IsRobloxFocused
	end
	local function IsHoverInput(Input: InputObject)
	    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
	        and Input.UserInputState == Enum.UserInputState.Change
	end
	local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
	    return IsMouseInput(Input, IncludeM2)
	        and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
	        and Library.IsRobloxFocused
	end
	local function IsMouseClickInput(Input: InputObject)
	    return Input.UserInputType == Enum.UserInputType.MouseButton1 or
	        Input.UserInputType == Enum.UserInputType.MouseButton2 or
	        Input.UserInputType == Enum.UserInputType.MouseButton3
	end
	local function IsMovementInput(Input: InputObject)
	    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
	        and Library.IsRobloxFocused
	end

	local function GetTableSize(Table: { [any]: any })
	    local Size = 0

	    for _, _ in Table do
	        Size += 1
	    end

	    return Size
	end
	local function IsSequentialArray(Table: { [any]: any })
	    for Key in Table do
	        if typeof(Key) ~= "number" or Key < 1 or Key % 1 ~= 0 then
	            return false
	        end
	    end

	    return true
	end

	local function StopTween(Tween: TweenBase, Destroy: boolean?)
	    if not Tween then
	        return
	    end

	    if Tween.PlaybackState == Enum.PlaybackState.Playing then
	        Tween:Cancel()
	    end

	    if Destroy == true then
	        pcall(Tween.Destroy, Tween)
	    end
	end

	local function Trim(Text: string)
	    return Text:match("^%s*(.-)%s*$")
	end
	local function Round(Value, Rounding)
	    assert(Rounding >= 0, "Invalid rounding number.")

	    if Rounding == 0 then
	        return math.floor(Value)
	    end

	    return tonumber(string.format("%." .. Rounding .. "f", Value))
	end

	--// Fuzzy Search \\--
	local function LowerText(Text: string): string
	    return (Text:lower():gsub("[\195\206\208][\128-\191]", function(Char)
	        local Code = utf8.codepoint(Char)
	        if (Code >= 0xC0 and Code <= 0xDE and Code ~= 0xD7) or (Code >= 0x391 and Code <= 0x3AB) or (Code >= 0x410 and Code <= 0x42F) then
	            return utf8.char(Code + 32)
	        elseif Code >= 0x400 and Code <= 0x40F then
	            return utf8.char(Code + 80)
	        end

	        return Char
	    end))
	end

	local function FuzzyScore(Text: string, Search: string): (boolean, number)
	    if Search == "" then
	        return true, 0
	    end
	    if Text == "" then
	        return false, 0
	    end

	    --// Fast path: literal substring match (also the best possible score) \\--
	    local ExactIdx = Text:find(Search, 1, true)
	    if ExactIdx then
	        local PrevChar = ExactIdx > 1 and Text:sub(ExactIdx - 1, ExactIdx - 1) or ""
	        local AtBoundary = ExactIdx == 1 or PrevChar:match("[%s%p_]") ~= nil

	        return true, 1e5 - ExactIdx + (AtBoundary and 500 or 0) + (Search:len() * 5)
	    end

	    --// Fallback: fuzzy, in-order, non-consecutive character matching \\--
	    local TextChars, SearchChars = {}, {}
	    for Char in Text:gmatch(utf8.charpattern) do table.insert(TextChars, Char) end
	    for Char in Search:gmatch(utf8.charpattern) do table.insert(SearchChars, Char) end

	    local TextLen, SearchLen = #TextChars, #SearchChars
	    if SearchLen > TextLen then
	        return false, 0
	    end

	    local SearchIdx = 1
	    local Score = 0
	    local RunLength = 0
	    local LastMatchIdx = 0

	    for TextIdx = 1, TextLen do
	        if SearchIdx > SearchLen then
	            break
	        end

	        if TextChars[TextIdx] == SearchChars[SearchIdx] then
	            local PrevChar = TextIdx > 1 and TextChars[TextIdx - 1] or ""
	            local AtBoundary = TextIdx == 1 or PrevChar:match("[%s%p_]") ~= nil

	            RunLength = (LastMatchIdx == TextIdx - 1) and (RunLength + 1) or 1
	            Score += 1 + (AtBoundary and 6 or 0) + math.min(RunLength - 1, 5) * 3

	            LastMatchIdx = TextIdx
	            SearchIdx += 1
	        end
	    end

	    if SearchIdx <= SearchLen then
	        return false, 0 --// Not every Search character was found, in order
	    end

	    Score -= (LastMatchIdx - SearchLen) * 0.05 --// Slightly favour tighter matches
	    return true, Score
	end

	local function NormalizeSearch(Search: string): string
	    return (Search:gsub("%s+", ""))
	end

	local function TryFuzzyMatch(Text: any, Search: string): (boolean, number)
	    if typeof(Text) ~= "string" or Text == "" then
	        return false, 0
	    end

	    return FuzzyScore(LowerText(Text), Search)
	end

	local function FuzzyMatchScore(Text: any, Search: string): number
	    if typeof(Text) ~= "string" or Text == "" then
	        return 0
	    end

	    local Normalized = NormalizeSearch(LowerText(Text))
	    local Matched, Score = FuzzyScore(Normalized, Search)
	    if not Matched then
	        return 0
	    end

	    if Normalized == Search then
	        Score += 1000
	    end

	    return Score
	end

	local function MatchesSearch(ElementInfo, Search: string, ForceMatch: boolean?): boolean
	    if not ElementInfo then
	        return false
	    end
	    if ForceMatch then
	        return true
	    end

	    if TryFuzzyMatch(ElementInfo.Text, Search) then
	        return true
	    end
	    if TryFuzzyMatch(ElementInfo.Tooltip, Search) then
	        return true
	    end
	    if TryFuzzyMatch(ElementInfo.DisabledTooltip, Search) then
	        return true
	    end

	    --// Optional: search inside Dropdown value lists, so e.g. searching a specific option name reveals the Dropdown that contains it \\--
	    if typeof(ElementInfo.Values) == "table" then
	        local Checked = 0
	        for Key, Value in ElementInfo.Values do
	            Checked += 1
	            if Checked > 200 then
	                break
	            end

	            if TryFuzzyMatch(Value, Search) or (typeof(Value) ~= "string" and TryFuzzyMatch(tostring(Value), Search)) then
	                return true
	            end
	            if typeof(Key) == "string" and TryFuzzyMatch(Key, Search) then
	                return true
	            end
	        end
	    end

	    return false
	end

	local function GetPlayers(ExcludeLocalPlayer: boolean?)
	    local PlayerList = Players:GetPlayers()

	    if ExcludeLocalPlayer then
	        local Idx = table.find(PlayerList, LocalPlayer)
	        if Idx then
	            table.remove(PlayerList, Idx)
	        end
	    end

	    table.sort(PlayerList, function(Player1, Player2)
	        return Player1.Name:lower() < Player2.Name:lower()
	    end)

	    return PlayerList
	end
	local function GetTeams()
	    local TeamList = Teams:GetTeams()

	    table.sort(TeamList, function(Team1, Team2)
	        return Team1.Name:lower() < Team2.Name:lower()
	    end)

	    return TeamList
	end

	function Library:UpdateDependencyBoxes()
	    for _, Depbox in Library.DependencyBoxes do
	        Depbox:Update(true)
	    end

	    if Library.Searching then
	        Library:UpdateSearch(Library.SearchText)
	    end
	end

	function Library:UpdateAddons(Parent)
	    if not Parent or not Parent.Addons then
	        return
	    end

	    for _, Addon in Parent.Addons do
	        Addon:Update()
	    end
	end

	local function CheckDepbox(Box, Search, ForceVisible: boolean?)
	    local VisibleElements = 0
	    local BestScore = 0

	    for _, ElementInfo in Box.Elements do
	        if ElementInfo.Type == "Divider" then
	            ElementInfo.Holder.Visible = false
	            continue
	        elseif ElementInfo.SubButton then
	            --// Check if any of the Buttons Name matches with Search
	            local Visible = false

	            --// Check if Search matches Element's Name and if Element is Visible
	            if MatchesSearch(ElementInfo, Search, ForceVisible) and ElementInfo.Visible then
	                Visible = true
	                BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
	            else
	                ElementInfo.Base.Visible = false
	            end
	            if MatchesSearch(ElementInfo.SubButton, Search, ForceVisible) and ElementInfo.SubButton.Visible then
	                Visible = true
	                BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.SubButton.Text, Search))
	            else
	                ElementInfo.SubButton.Base.Visible = false
	            end
	            ElementInfo.Holder.Visible = Visible
	            if Visible then
	                VisibleElements += 1
	            end

	            continue
	        end

	        --// Check if Search matches Element's Name and if Element is Visible
	        if ElementInfo.Text and MatchesSearch(ElementInfo, Search, ForceVisible) and ElementInfo.Visible then
	            ElementInfo.Holder.Visible = true
	            VisibleElements += 1
	            BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
	        else
	            ElementInfo.Holder.Visible = false
	        end
	    end

	    for _, Depbox in Box.DependencyBoxes do
	        if not Depbox.Visible then
	            continue
	        end

	        local DepVisible, DepScore = CheckDepbox(Depbox, Search, ForceVisible)
	        VisibleElements += DepVisible
	        if DepScore > BestScore then
	            BestScore = DepScore
	        end
	    end

	    Box.Holder.Visible = VisibleElements > 0
	    return VisibleElements, BestScore
	end
	local function RestoreDepbox(Box)
	    for _, ElementInfo in Box.Elements do
	        ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

	        if ElementInfo.SubButton then
	            ElementInfo.Base.Visible = ElementInfo.Visible
	            ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
	        end
	    end

	    for _, Depbox in Box.DependencyBoxes do
	        RestoreDepbox(Depbox)
	    end

	    Box.Holder.Visible = Box.Visible
	    if Box.Visible then
	        Box:Resize()
	    end
	end

	--// Pop Out
	function SyncPopOutVisibility(Box: any)
	    if not Box.PopOutFloat then
	        return
	    end

	    Box.PopOutFloat.Visible = Box.BoxHolder.Visible ~= false and Box.Visible ~= false
	end

	local function RegisterPopOutClone(Source: Instance, Clone: Instance)
	    local SourceProps = Library.Registry[Source]
	    if SourceProps then
	        local CloneProps = {}
	        for Property, Index in SourceProps do
	            if Property ~= "FontFace" then
	                CloneProps[Property] = Index
	            end
	        end
	        if next(CloneProps) then
	            Library.Registry[Clone] = CloneProps
	        end
	    end

	    local SourceChildren = Source:GetChildren()
	    local CloneChildren = Clone:GetChildren()
	    for Index = 1, math.min(#SourceChildren, #CloneChildren) do
	        RegisterPopOutClone(SourceChildren[Index], CloneChildren[Index])
	    end
	end

	local function DimPopOutClone(Root: GuiObject)
	    for _, Descendant in Root:QueryDescendants("TextLabel, TextButton, TextBox") do
	        Descendant.TextTransparency = math.max(Descendant.TextTransparency, 0.45)
	    end

	    for _, Descendant in Root:QueryDescendants("ImageLabel, ImageButton") do
	        Descendant.ImageTransparency = math.max(Descendant.ImageTransparency, 0.45)
	    end

	    for _, Descendant in Root:QueryDescendants("GuiButton") do
	        Descendant.Active = false
	        Descendant.AutoButtonColor = false
	    end
	end

	local function IsScreenPointOutsideMain(Point: Vector2): boolean
	    local MainFrame = Library.Window and Library.Window.MainFrame
	    if not MainFrame or not Library.Toggled or not MainFrame.Visible then
	        return true
	    end

	    return not Library:MouseIsOverFrame(MainFrame, Point)
	end

	local function GetTopFloatAt(Point: Vector2): GuiObject?
	    local Best: GuiObject? = nil
	    local BestOrder = -math.huge
	    local Floats = Library.Floats

	    for _, Surface in Library.DraggableElements do
	        if not Surface or not Surface.Parent or not Surface.Visible then
	            continue
	        end
	        if Floats and Surface.Parent ~= Floats then
	            continue
	        end
	        if not Library:MouseIsOverFrame(Surface, Point) then
	            continue
	        end

	        local SiblingIndex = tonumber(select(2, pcall(function() return Surface:GetSiblingIndex() end))) or 0
	        local Order = Surface.ZIndex * 100000 + SiblingIndex
	        if Order >= BestOrder then
	            BestOrder = Order
	            Best = Surface
	        end
	    end

	    return Best
	end

	local function GetPopOutBodyMaxHeight(Box: any, Reserved: number): number
	    local Float = Box.PopOutFloat
	    local ScreenGui = Library.ScreenGui
	    if not Float or not ScreenGui then
	        return math.huge
	    end

	    local Gap = 12 * Library.DPIScale
	    local MaxBottom = ScreenGui.AbsolutePosition.Y + ScreenGui.AbsoluteSize.Y - Gap
	    local Available = math.min(MaxBottom - Float.AbsolutePosition.Y, ScreenGui.AbsoluteSize.Y * 0.9)
	    local ScreenMax = math.max(0, Available / Library.DPIScale - Reserved)

	    local CustomMax = Box.PopOutMaxHeight
	    if typeof(CustomMax) == "number" then
	        return math.min(ScreenMax, math.max(0, CustomMax))
	    end

	    return ScreenMax
	end

	--// Search
	local function ApplySearchToTab(Tab, Search)
	    if not Tab then
	        return false, 0
	    end

	    local HasVisible = false
	    local BestScore = 0

	    --// If the Tab itself matches Search (by name/description), don't filter out its contents -- pull everything in the Tab along with it \\--
	    local TabMatches = TryFuzzyMatch(Tab.Name, Search) or TryFuzzyMatch(Tab.Description, Search)
	    BestScore = math.max(BestScore, FuzzyMatchScore(Tab.Name, Search), FuzzyMatchScore(Tab.Description, Search))

	    for _, Groupbox in Tab.Groupboxes do
	        if Groupbox.Visible == false then
	            continue
	        end

	        --// Optional: matching the Groupbox's own name/description reveals every element inside it, without needing each one to match too
	        local GroupboxMatches = TabMatches or (TryFuzzyMatch(Groupbox.Name, Search) or TryFuzzyMatch(Groupbox.Description, Search))
	        BestScore = math.max(BestScore, FuzzyMatchScore(Groupbox.Name, Search), FuzzyMatchScore(Groupbox.Description, Search))

	        local VisibleElements = 0
	        for _, ElementInfo in Groupbox.Elements do
	            if ElementInfo.Type == "Divider" then
	                ElementInfo.Holder.Visible = false
	                continue
	            elseif ElementInfo.SubButton then
	                --// Check if any of the Buttons Name matches with Search
	                local Visible = false
	                if MatchesSearch(ElementInfo, Search, GroupboxMatches) and ElementInfo.Visible then
	                    Visible = true
	                    BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
	                else
	                    ElementInfo.Base.Visible = false
	                end

	                if MatchesSearch(ElementInfo.SubButton, Search, GroupboxMatches) and ElementInfo.SubButton.Visible then
	                    Visible = true
	                    BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.SubButton.Text, Search))
	                else
	                    ElementInfo.SubButton.Base.Visible = false
	                end

	                ElementInfo.Holder.Visible = Visible
	                if Visible then
	                    VisibleElements += 1
	                end

	                continue
	            end

	            --// Check if Search matches Element's Name and if Element is Visible
	            if ElementInfo.Text and MatchesSearch(ElementInfo, Search, GroupboxMatches) and ElementInfo.Visible then
	                ElementInfo.Holder.Visible = true
	                VisibleElements += 1
	                BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
	            else
	                ElementInfo.Holder.Visible = false
	            end
	        end

	        for _, Depbox in Groupbox.DependencyBoxes do
	            if not Depbox.Visible then
	                continue
	            end

	            local DepVisible, DepScore = CheckDepbox(Depbox, Search, GroupboxMatches)
	            VisibleElements += DepVisible
	            if DepScore > BestScore then
	                BestScore = DepScore
	            end
	        end

	        --// Update Groupbox Size and Visibility if found any element
	        if VisibleElements > 0 then
	            Groupbox:Resize()
	            HasVisible = true
	        end
	        Groupbox.BoxHolder.Visible = VisibleElements > 0
	        SyncPopOutVisibility(Groupbox)
	    end

	    for _, Tabbox in Tab.Tabboxes do
	        local VisibleTabs = 0
	        local VisibleElements = {}
	        local SubTabScores = {}

	        for _, SubTab in Tabbox.Tabs do
	            VisibleElements[SubTab] = 0

	            --// Optional: matching a Tabbox sub-tab's own name reveals every element inside it, without needing each one to match too
	            local SubTabMatches = TabMatches or TryFuzzyMatch(SubTab.Name, Search)
	            local SubScore = FuzzyMatchScore(SubTab.Name, Search)
	            BestScore = math.max(BestScore, SubScore)

	            for _, ElementInfo in SubTab.Elements do
	                if ElementInfo.Type == "Divider" then
	                    ElementInfo.Holder.Visible = false
	                    continue
	                elseif ElementInfo.SubButton then
	                    --// Check if any of the Buttons Name matches with Search
	                    local Visible = false
	                    if MatchesSearch(ElementInfo, Search, SubTabMatches) and ElementInfo.Visible then
	                        Visible = true
	                        local ElementScore = FuzzyMatchScore(ElementInfo.Text, Search)
	                        SubScore = math.max(SubScore, ElementScore)
	                        BestScore = math.max(BestScore, ElementScore)
	                    else
	                        ElementInfo.Base.Visible = false
	                    end

	                    if MatchesSearch(ElementInfo.SubButton, Search, SubTabMatches) and ElementInfo.SubButton.Visible then
	                        Visible = true
	                        local ElementScore = FuzzyMatchScore(ElementInfo.SubButton.Text, Search)
	                        SubScore = math.max(SubScore, ElementScore)
	                        BestScore = math.max(BestScore, ElementScore)
	                    else
	                        ElementInfo.SubButton.Base.Visible = false
	                    end

	                    ElementInfo.Holder.Visible = Visible
	                    if Visible then
	                        VisibleElements[SubTab] += 1
	                    end

	                    continue
	                end

	                --// Check if Search matches Element's Name and if Element is Visible
	                if ElementInfo.Text and MatchesSearch(ElementInfo, Search, SubTabMatches) and ElementInfo.Visible then
	                    ElementInfo.Holder.Visible = true
	                    VisibleElements[SubTab] += 1
	                    local ElementScore = FuzzyMatchScore(ElementInfo.Text, Search)
	                    SubScore = math.max(SubScore, ElementScore)
	                    BestScore = math.max(BestScore, ElementScore)
	                else
	                    ElementInfo.Holder.Visible = false
	                end
	            end

	            for _, Depbox in SubTab.DependencyBoxes do
	                if not Depbox.Visible then
	                    continue
	                end

	                local DepVisible, DepScore = CheckDepbox(Depbox, Search, SubTabMatches)
	                VisibleElements[SubTab] += DepVisible
	                SubScore = math.max(SubScore, DepScore)
	                BestScore = math.max(BestScore, DepScore)
	            end

	            SubTabScores[SubTab] = SubScore
	        end

	        local BestSubTab = nil
	        local BestSubScore = -1

	        for SubTab, Visible in VisibleElements do
	            SubTab.ButtonHolder.Visible = Visible > 0
	            if Visible > 0 then
	                VisibleTabs += 1
	                HasVisible = true

	                local SubScore = SubTabScores[SubTab] or 0
	                if SubScore > BestSubScore then
	                    BestSubScore = SubScore
	                    BestSubTab = SubTab
	                end
	            end
	        end

	        local ActiveSubTab = Tabbox.ActiveTab
	        local ActiveSubVisible = ActiveSubTab and (VisibleElements[ActiveSubTab] or 0) > 0
	        local ActiveSubScore = ActiveSubTab and (SubTabScores[ActiveSubTab] or -1) or -1

	        if ActiveSubVisible and ActiveSubScore >= BestSubScore then
	            ActiveSubTab:Resize()
	        elseif BestSubTab then
	            BestSubTab:Show()
	        end

	        --// Update Tabbox Visibility if any visible
	        Tabbox.BoxHolder.Visible = VisibleTabs > 0
	        SyncPopOutVisibility(Tabbox)
	    end

	    return HasVisible, BestScore
	end

	local function ResetTab(Tab)
	    if not Tab then
	        return
	    end

	    for _, Groupbox in Tab.Groupboxes do
	        for _, ElementInfo in Groupbox.Elements do
	            ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

	            if ElementInfo.SubButton then
	                ElementInfo.Base.Visible = ElementInfo.Visible
	                ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
	            end
	        end

	        for _, Depbox in Groupbox.DependencyBoxes do
	            RestoreDepbox(Depbox)
	        end

	        Groupbox:Resize()
	        Groupbox.BoxHolder.Visible = Groupbox.Visible ~= false
	        SyncPopOutVisibility(Groupbox)
	    end

	    for _, Tabbox in Tab.Tabboxes do
	        for _, SubTab in Tabbox.Tabs do
	            for _, ElementInfo in SubTab.Elements do
	                ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

	                if ElementInfo.SubButton then
	                    ElementInfo.Base.Visible = ElementInfo.Visible
	                    ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
	                end
	            end

	            for _, Depbox in SubTab.DependencyBoxes do
	                RestoreDepbox(Depbox)
	            end

	            SubTab.ButtonHolder.Visible = true
	        end

	        if Tabbox.ActiveTab then
	            Tabbox.ActiveTab:Resize()
	        end
	        Tabbox.BoxHolder.Visible = true
	        SyncPopOutVisibility(Tabbox)
	    end
	end

	function Library:UpdateSearch(SearchText)
	    Library.SearchText = SearchText

	    local TabsToSearch = {}
	    for _, Tab in Library.Tabs do
	        if typeof(Tab) == "table" and not Tab.IsKeyTab and not Tab.IsCustomTab then
	            table.insert(TabsToSearch, Tab)
	        end
	    end

	    for _, Tab in TabsToSearch do
	        ResetTab(Tab)
	    end

	    local Search = NormalizeSearch(LowerText(SearchText))
	    if Trim(Search) == "" then
	        Library.Searching = false
	        Library.LastSearchTab = nil
	        return
	    end
	    if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
	        Library.Searching = false
	        Library.LastSearchTab = nil
	        return
	    end

	    Library.Searching = true

	    local BestTab = nil
	    local BestScore = -1
	    local ActiveScore = -1
	    local ActiveHasVisible = false

	    for _, Tab in TabsToSearch do
	        local HasVisible, Score = ApplySearchToTab(Tab, Search)
	        if not HasVisible then
	            continue
	        end

	        if Tab == Library.ActiveTab then
	            ActiveHasVisible = true
	            ActiveScore = Score
	        end
	        if Score > BestScore then
	            BestScore = Score
	            BestTab = Tab
	        end
	    end

	    if not Library.GlobalSearch then
	        for _, Tab in TabsToSearch do
	            if Tab ~= BestTab then
	                ResetTab(Tab)
	            end
	        end
	    end

	    local StayOnActive = ActiveHasVisible and ActiveScore >= BestScore
	    if StayOnActive and Library.ActiveTab then
	        Library.ActiveTab:RefreshSides()
	    elseif BestTab then
	        local SearchMarker = SearchText
	        task.defer(function()
	            if Library.SearchText ~= SearchMarker then
	                return
	            end

	            if Library.ActiveTab ~= BestTab then
	                BestTab:Show()
	            elseif Library.ActiveTab then
	                Library.ActiveTab:RefreshSides()
	            end
	        end)
	    end

	    Library.LastSearchTab = nil
	end

	function Library:AddToRegistry(Instance, Properties)
	    Library.Registry[Instance] = Properties
	end

	function Library:RemoveFromRegistry(Instance)
	    Library.Registry[Instance] = nil
	end

	function Library:UpdateColorsUsingRegistry()
	    for Instance, Properties in Library.Registry do
	        for Property, Index in Properties do
	            local SchemeValue = GetSchemeValue(Index)

	            if SchemeValue or typeof(Index) == "function" then
	                Instance[Property] = SchemeValue or Index()
	            end
	        end
	    end
	end

	function Library:SetDPIScale(DPIScale: number)
	    Library.DPIScale = DPIScale / 100
	    Library.MinSize = Library.OriginalMinSize * Library.DPIScale

	    for _, UIScale in Library.Scales do
	        UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
	    end

	    for _, Option in Options do
	        if Option.Type == "Dropdown" then
	            Option:RecalculateListSize()
	            Option:RefreshPool()
	        end
	    end

	    for _, Notification in Library.Notifications do
	        Notification:Resize()
	    end
	end

	function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
	    local ConnectionType = typeof(Connection)
	    if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
	        table.insert(Library.Signals, Connection)
	    end

	    return Connection
	end

	function IsValidCustomIcon(Icon: string)
	    return typeof(Icon) == "string" and (Icon:match("^rbxasset://textures/") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
	end

	local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
	    return typeof(Icon) == "string" and (Icon:match("^content://") or (Icon:match("^rbxasset://%x+/") or Icon:match("^rbxasset://[^/]+/")) or (IncludeAssetId == true and Icon:match("^rbxassetid://")))
	end

	type Icon = {
	    Url: string,
	    Id: number,
	    IconName: string,
	    ImageRectOffset: Vector2,
	    ImageRectSize: Vector2,
	    FontFace: Font?,
	    Text: string?,
	    Custom: boolean?,
	}

	type IconModule = {
	    Icons: { string },
	    GetAsset: (Name: string) -> Icon?,
	}

	local FetchIcons = false
	local Icons: IconModule | nil = nil

	function Library:GetIcon(IconName: string): Icon?
	    if not FetchIcons or not Icons then
	        return nil
	    end

	    local Success, Icon = pcall(Icons.GetAsset, IconName)
	    return if Success then Icon else nil
	end

	function Library:GetCustomIcon(IconName: string): any
	    if not IconName then
	        return nil
	    end

	    if tonumber(IconName) then
	        IconName = string.format("rbxassetid://%s", tostring(IconName))
	    end

	    if IsCustomAssetIcon(IconName, true) then
	        return {
	            Url = IconName,
	            ImageRectOffset = Vector2.zero,
	            ImageRectSize = Vector2.zero,
	        }
	    elseif IsValidCustomIcon(IconName) then
	        return {
	            Url = IconName,
	            ImageRectOffset = Vector2.zero,
	            ImageRectSize = Vector2.zero,
	            Custom = true,
	        }
	    end

	    local LucideIcon = Library:GetIcon(IconName)
	    if LucideIcon then
	        return LucideIcon
	    end

	    return nil
	end

	function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
	    if typeof(Table) ~= "table" then
	        return Template
	    end

	    for k, v in Template do
	        if typeof(k) == "number" then
	            continue
	        end

	        if typeof(v) == "table" then
	            Table[k] = Library:Validate(Table[k], v)
	        elseif Table[k] == nil then
	            Table[k] = v
	        end
	    end

	    return Table
	end

	--// Creator Functions \\--
	local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
	    local ThemeProperties = Library.Registry[Instance] or {}

	    for key, value in Table do
	        if key ~= "Text" then
	            local SchemeValue = GetSchemeValue(value)

	            if SchemeValue or typeof(value) == "function" then
	                ThemeProperties[key] = value
	                value = SchemeValue or value()
	            else
	                ThemeProperties[key] = nil
	            end
	        end

	        Instance[key] = value
	    end

	    if GetTableSize(ThemeProperties) > 0 then
	        Library.Registry[Instance] = ThemeProperties
	    end
	end

	local function New(ClassName: string, Properties: { [string]: any }): any
	    local Instance = Instance.new(ClassName)

	    if Templates[ClassName] then
	        FillInstance(Templates[ClassName], Instance)
	    end
	    FillInstance(Properties, Instance)

	    if Properties["Parent"] and not Properties["ZIndex"] then
	        pcall(function()
	            Instance.ZIndex = Properties.Parent.ZIndex
	        end)
	    end

	    return Instance
	end

	--// Icon Instances \\--
	local IconTextProperties = { ImageColor3 = "TextColor3", ImageTransparency = "TextTransparency" }
	local IconSharedProperties = { "Name", "AnchorPoint", "Position", "Size", "SizeConstraint", "LayoutOrder", "ZIndex", "Visible", "Rotation", "ImageColor3", "ImageTransparency" }

	local function IconProperties(ClassName: string, Properties: { [string]: any }): { [string]: any }
	    if ClassName ~= "TextLabel" and ClassName ~= "TextButton" then
	        return Properties
	    end

	    local Mapped: { [string]: any } = {}
	    for Property, Value in Properties do
	        Mapped[IconTextProperties[Property] or Property] = Value
	    end

	    return Mapped
	end

	local function IsFontIcon(Icon: Icon?, Size: UDim2?, Parent: Instance?): boolean
	    if Icon == nil or Icon.FontFace == nil or Size == nil then
	        return false
	    end

	    local Height = Size.Y.Offset
	    if Size.Y.Scale ~= 0 then
	        if not (Parent and Parent:IsA("GuiObject")) then
	            return false
	        end

	        Height += Parent.AbsoluteSize.Y / Library.DPIScale * Size.Y.Scale
	    end

	    return Height > Library.MaxSpriteIconSize
	end

	local function ImageContent(Icon: Icon?): { [string]: any }
	    return {
	        Image = Icon and Icon.Url or "",
	        ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
	        ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
	    }
	end

	local function SetIconProperties(Target: GuiObject, Properties: { [string]: any })
	    FillInstance(IconProperties(Target.ClassName, Properties), Target)
	end

	local function TweenIcon(Target: GuiObject, Properties: { [string]: any }): Tween
	    local Tween = TweenService:Create(Target, Library.TweenInfo, IconProperties(Target.ClassName, Properties))
	    Tween:Play()

	    return Tween
	end

	function Library:CreateIcon(Icon: Icon?, Properties: { [string]: any }?, IsButton: boolean?): GuiObject
	    local IsFont = IsFontIcon(Icon, Properties and Properties.Size, Properties and Properties.Parent)
	    local ClassName = (if IsFont then "Text" else "Image") .. (if IsButton then "Button" else "Label")

	    local Merged: { [string]: any } = {
	        BackgroundTransparency = 1,
	        ImageColor3 = Color3.new(1, 1, 1),
	    }

	    if not IsFont then
	        Merged.ScaleType = Enum.ScaleType.Fit
	    end

	    if Properties then
	        for Property, Value in Properties do
	            Merged[Property] = Value
	        end
	    end

	    return Library:ApplyIcon(New(ClassName, IconProperties(ClassName, Merged)), Icon)
	end

	function Library:ApplyIcon(Target: GuiObject, Icon: Icon?): GuiObject
	    local IsFont = IsFontIcon(Icon, Target.Size, Target.Parent)
	    local IsText = Target:IsA("TextLabel") or Target:IsA("TextButton")

	    if IsFont ~= IsText then
	        local Theme = Library.Registry[Target] or {}
	        local Properties: { [string]: any } = { Parent = Target.Parent }

	        for _, Property in IconSharedProperties do
	            local Source = if IsText then IconTextProperties[Property] or Property else Property
	            Properties[Property] = if Theme[Source] ~= nil then Theme[Source] else (Target :: any)[Source]
	        end

	        local Replacement = Library:CreateIcon(Icon, Properties, Target:IsA("GuiButton"))
	        Library:RemoveFromRegistry(Target)
	        Target:Destroy()

	        return Replacement
	    end

	    if IsFont and Icon then
	        FillInstance({
	            FontFace = Icon.FontFace,
	            RichText = false,
	            Text = Icon.Text,
	            TextScaled = true,
	        }, Target)

	        if not Target:FindFirstChild("IconPadding") then
	            New("UIPadding", {
	                Name = "IconPadding",
	                PaddingLeft = UDim.new(-0.5, 0),
	                PaddingRight = UDim.new(-0.5, 0),
	                Parent = Target,
	            })
	        end
	    else
	        FillInstance(ImageContent(Icon), Target)
	    end

	    return Target
	end

	--// DEPRECATED
	function Library:ApplyLucideIcon(ImageGui: ImageLabel | ImageButton, Icon: Icon, Rotation: number?)
	    warn("Obsidian:ApplyLucideIcon is deprecated, please use Obsidian:CreateIcon or Obsidian:ApplyIcon instead.")

	    ImageGui.Rotation = Rotation or ImageGui.Rotation
	    FillInstance(ImageContent(Icon), ImageGui)
	end

	--// Main Instances \\-
	local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
	    local success, _error = pcall(function()
	        if not Parent then
	            Parent = CoreGui
	        end

	        local DestinationParent
	        if typeof(Parent) == "function" then
	            DestinationParent = Parent()
	        else
	            DestinationParent = Parent
	        end

	        Instance.Parent = DestinationParent
	    end)

	    if not (success and Instance.Parent) then
	        Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
	    end
	end

	local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
	    if SkipHiddenUI then
	        SafeParentUI(UI, CoreGui)
	        return
	    end

	    pcall(protectgui, UI)
	    SafeParentUI(UI, gethui)
	end

	local function SetAlwaysOnTop(Gui: ScreenGui, Enabled: boolean)
	    if not Gui then
	        return
	    end

	    pcall(function()
	        if sethiddenproperty then
	            sethiddenproperty(Gui, "OnTopOfCoreBlur", Enabled)
	        elseif setscriptable then
	            setscriptable(Gui, "OnTopOfCoreBlur", true)
	            Gui.OnTopOfCoreBlur = Enabled
	            setscriptable(Gui, "OnTopOfCoreBlur", false)
	        end
	    end)
	end

	local ScreenGui = New("ScreenGui", {
	    Name = "Obsidian",
	    DisplayOrder = 998,
	    ResetOnSpawn = false,
	    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	ParentUI(ScreenGui)
	Library.ScreenGui = ScreenGui

	ScreenGui.DescendantRemoving:Connect(function(Instance)
	    task.defer(function()
	        if Instance.Parent and Instance:IsDescendantOf(ScreenGui) then
	            return
	        end

	        Library:RemoveFromRegistry(Instance)
	    end)
	end)

	local ModalElement = New("TextButton", {
	    BackgroundTransparency = 1,
	    Modal = false,
	    Size = UDim2.fromScale(0, 0),
	    AnchorPoint = Vector2.zero,
	    Text = "",
	    ZIndex = -999,
	    Parent = ScreenGui,
	})

	--// Floats and Overlays
	local Floats = New("Frame", {
	    BackgroundTransparency = 1,
	    Size = UDim2.fromScale(1, 1),
	    ZIndex = 10,
	    Active = false,
	    Parent = ScreenGui,
	})

	local Overlay = New("Frame", {
	    BackgroundTransparency = 1,
	    Size = UDim2.fromScale(1, 1),
	    ZIndex = 20,
	    Active = false,
	    Parent = ScreenGui,
	})

	Library.Floats = Floats
	Library.Overlay = Overlay

	--// Cursor
	local Cursor
	local CursorCross
	local InnerCross = {}
	local CursorCustomImage
	do
	    Cursor = New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundTransparency = 1,
	        Size = UDim2.fromOffset(1, 1),
	        Visible = false,
	        ZIndex = 11000,
	        Parent = ScreenGui,
	    })

	    CursorCross = New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundTransparency = 1,
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.fromOffset(11, 11),
	        Parent = Cursor,
	    })

	    New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundColor3 = "DarkColor",
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.new(1, 0, 0, 3),
	        ZIndex = 1,
	        Parent = CursorCross,
	    })
	    table.insert(InnerCross, New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundColor3 = "WhiteColor",
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.new(1, -2, 0, 1),
	        ZIndex = 2,
	        Parent = CursorCross,
	    }))

	    New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundColor3 = "DarkColor",
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.new(0, 3, 1, 0),
	        ZIndex = 1,
	        Parent = CursorCross,
	    })
	    table.insert(InnerCross, New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundColor3 = "WhiteColor",
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.new(0, 1, 1, -2),
	        ZIndex = 2,
	        Parent = CursorCross,
	    }))

	    CursorCustomImage = Library:CreateIcon(nil, {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.fromOffset(20, 20),
	        ZIndex = 3,
	        Visible = false,
	        Parent = Cursor,
	    })
	end

	local function RestoreMouseIcon()
	    pcall(function() 
	        RunService:UnbindFromRenderStep(Library.ShowCursorBinding)
	        RunService.RenderStepped:Wait()
	    end)

	    UserInputService.MouseIconEnabled = Library.OriginalMouseIconEnabled
	    if Cursor then Cursor.Visible = false end
	end

	--// Notification \\--
	local NotificationArea
	local NotifyOrder = {}
	do
	    NotificationArea = New("Frame", {
	        AnchorPoint = Vector2.new(1, 0),
	        BackgroundTransparency = 1,
	        Position = UDim2.new(1, -6, 0, 6),
	        Size = UDim2.new(0, 300, 1, -6),
	        ZIndex = 200,
	        Parent = ScreenGui,
	    })
	    table.insert(
	        Library.Scales,
	        New("UIScale", {
	            Parent = NotificationArea,
	        })
	    )
	end

	--// Icons \\--
	local CheckIcon, ArrowIcon, ResizeIcon, KeyIcon, MoveIcon, PopOutIcon, CloseIcon, SettingsIcon
	function Library:SetIconModule(module: IconModule)
	    FetchIcons = true
	    Icons = module

	    CheckIcon = Library:GetIcon("check")
	    ArrowIcon = Library:GetIcon("chevron-up")
	    ResizeIcon = Library:GetIcon("move-diagonal-2")
	    KeyIcon = Library:GetIcon("key")
	    MoveIcon = Library:GetIcon("move")
	    PopOutIcon = Library:GetIcon("square-arrow-down-left")
	    CloseIcon = Library:GetIcon("x")
	    SettingsIcon = Library:GetIcon("settings")
	end

	local OnlineFetchIcons, OnlineIcons = pcall(function()
	    return (loadstring(
	        game:HttpGet("https://raw.githubusercontent.com/notpoiu/Molto/refs/heads/main/source.lua")
	    ) :: () -> IconModule)()
	end)
	do
	    if OnlineFetchIcons and OnlineIcons then
	        OnlineIcons.SetProvider("lucide")
	        Library:SetIconModule(OnlineIcons)
	    else
	        OnlineFetchIcons, OnlineIcons = pcall(function()
	            return (loadstring(
	                game:HttpGet("https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua")
	            ) :: () -> IconModule)()
	        end)
	        
	        if OnlineFetchIcons and OnlineIcons then
	            Library:SetIconModule(OnlineIcons)
	        end
	    end
	end

	--// Lib Functions \\--
	Library.Cursor = {}

	function Library.Cursor:ResetCross()
	    for _, Inner in InnerCross do
	        Library.Registry[Inner].BackgroundColor3 = "WhiteColor"
	        Inner.BackgroundColor3 = Library.Scheme.WhiteColor
	    end
	end

	function Library.Cursor:ResetIcon()
	    CursorCross.Visible = true
	    CursorCustomImage.Visible = false
	    CursorCustomImage.Size = UDim2.fromOffset(20, 20)
	    SetIconProperties(CursorCustomImage, { ImageColor3 = Color3.new(1, 1, 1) })
	end

	function Library.Cursor:ResetCursor()
	    Library.Cursor:ResetCross()
	    Library.Cursor:ResetIcon()
	end

	function Library.Cursor:ChangeCrossColor(Color: Color3)
	    assert(typeof(Color) == "Color3", "Color3 expected.")
	    for _, Inner in InnerCross do
	        Inner.BackgroundColor3 = Color
	        Library.Registry[Inner].BackgroundColor3 = nil
	    end
	end

	function Library.Cursor:ChangeIcon(ImageId: string)
	    if not ImageId or ImageId == "" then
	        Library.Cursor:ResetIcon()
	        return
	    end

	    local Icon = Library:GetCustomIcon(ImageId)
	    assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	    CursorCross.Visible = false
	    CursorCustomImage = Library:ApplyIcon(CursorCustomImage, Icon)
	    CursorCustomImage.Visible = true
	end

	function Library.Cursor:ChangeIconColor(Color: Color3)
	    assert(typeof(Color) == "Color3", "Color3 expected.")
	    SetIconProperties(CursorCustomImage, { ImageColor3 = Color })
	end

	function Library.Cursor:ChangeIconSize(Size: UDim2)
	    assert(typeof(Size) == "UDim2", "UDim2 expected.")
	    CursorCustomImage.Size = Size
	end

	--// DEPRECATED
	function Library:ChangeCursorCrossColor(Color: Color3)
	    warn("Obsidian:ChangeCursorCrossColor is deprecated, please use Obsidian.Cursor:ChangeCrossColor instead.")
	    Library.Cursor:ChangeCrossColor(Color)
	end

	--// DEPRECATED
	function Library:ResetCursorCross()
	    warn("Obsidian:ResetCursorCross is deprecated, please use Obsidian.Cursor:ResetCross instead.")
	    Library.Cursor:ResetCross()
	end

	--// DEPRECATED
	function Library:ChangeCursorIcon(ImageId: string)
	    warn("Obsidian:ChangeCursorIcon is deprecated, please use Obsidian.Cursor:ChangeIcon instead.")
	    Library.Cursor:ChangeIcon(ImageId)
	end

	--// DEPRECATED
	function Library:ChangeCursorIconColor(Color: Color3)
	    warn("Obsidian:ChangeCursorIconColor is deprecated, please use Obsidian.Cursor:ChangeIconColor instead.")
	    Library.Cursor:ChangeIconColor(Color)
	end

	--// DEPRECATED
	function Library:ChangeCursorIconSize(Size: UDim2)
	    warn("Obsidian:ChangeCursorIconSize is deprecated, please use Obsidian.Cursor:ChangeIconSize instead.")
	    Library.Cursor:ChangeIconSize(Size)
	end

	--// DEPRECATED
	function Library:ResetCursorIcon()
	    warn("Obsidian:ResetCursorIcon is deprecated, please use Obsidian.Cursor:ResetIcon instead.")
	    Library.Cursor:ResetIcon()
	end

	--// Colors \\--
	function Library:GetBetterColor(Color: Color3, Add: number): Color3
	    Add = Add * (Library.IsLightTheme and -4 or 2)
	    return Color3.fromRGB(
	        math.clamp(Color.R * 255 + Add, 0, 255),
	        math.clamp(Color.G * 255 + Add, 0, 255),
	        math.clamp(Color.B * 255 + Add, 0, 255)
	    )
	end

	function Library:GetLighterColor(Color: Color3): Color3
	    local H, S, V = Color:ToHSV()
	    return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
	end

	function Library:GetDarkerColor(Color: Color3): Color3
	    local H, S, V = Color:ToHSV()
	    return Color3.fromHSV(H, S, V / 2)
	end

	function Library:GetKeyString(KeyCode: Enum.KeyCode)
	    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
	        return string.char(KeyCode.Value)
	    end

	    return KeyCode.Name
	end

	function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
	    local Scale = Library.DPIScale
	    local Params = Instance.new("GetTextBoundsParams")
	    Params.Text = Text
	    Params.RichText = true
	    Params.Font = Font
	    Params.Size = Size * Scale
	    if Width then
	        Params.Width = Width * Scale
	    else
	        Params.Width = workspace.CurrentCamera.ViewportSize.X - 32
	    end

	    local Bounds = TextService:GetTextBoundsAsync(Params)
	    return math.ceil(Bounds.X / Scale), math.ceil(Bounds.Y / Scale)
	end

	function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
	    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	    return Mouse.X >= AbsPos.X
	        and Mouse.X <= AbsPos.X + AbsSize.X
	        and Mouse.Y >= AbsPos.Y
	        and Mouse.Y <= AbsPos.Y + AbsSize.Y
	end

	function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
	    local GuiPos = Frame.AbsolutePosition
	    local GuiSize = Frame.AbsoluteSize

	    local FramePos = ParentFrame.AbsolutePosition
	    local FrameSize = ParentFrame.AbsoluteSize

	    return GuiPos.X >= FramePos.X
	        and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
	        and GuiPos.Y >= FramePos.Y
	        and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
	end

	function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
	    if not (Func and typeof(Func) == "function") then
	        return
	    end

	    local Result = table.pack(xpcall(Func, function(Error)
	        task.defer(error, debug.traceback(Error, 2))
	        if Library.NotifyOnError and Library.Notify then
	            Library:Notify(Error)
	        end

	        return Error
	    end, ...))

	    if not Result[1] then
	        return nil
	    end

	    return table.unpack(Result, 2, Result.n)
	end

	function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
	    local Pos1 = TargetPos or UI.AbsolutePosition
	    local Size1 = UI.AbsoluteSize

	    for _, Other in ipairs(Library.DraggableElements) do
	        if Other == UI or not Other.Visible or not Other.Parent then
	            continue
	        end

	        local Pos2 = Other.AbsolutePosition
	        local Size2 = Other.AbsoluteSize

	        if Pos1.X < Pos2.X + Size2.X and
	            Pos1.X + Size1.X > Pos2.X and
	            Pos1.Y < Pos2.Y + Size2.Y and
	            Pos1.Y + Size1.Y > Pos2.Y then
	            return Other
	        end
	    end

	    return nil
	end

	function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
	    local ScreenSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)) - Vector2.new(100, 100)
	    local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
	    local Padding = 6

	    local CurrentX = Start.X
	    local CurrentY = Start.Y

	    local Size = UI.AbsoluteSize
	    if Size.X == 0 and Size.Y == 0 then
	        RunService.RenderStepped:Wait()
	        Size = UI.AbsoluteSize
	    end

	    if Size.X == 0 then Size = Vector2.new(150, 40) end

	    local MaxXInColumn = Size.X

	    while true do
	        local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
	        if not Obstacle then
	            break
	        end

	        if Obstacle.AbsoluteSize.X > MaxXInColumn then
	            MaxXInColumn = Obstacle.AbsoluteSize.X
	        end

	        local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
	        if NextY + Size.Y > ScreenSize.Y - Padding then
	            local NextX = CurrentX + MaxXInColumn + Padding

	            if NextX + Size.X > ScreenSize.X - Padding then
	                break
	            end

	            CurrentY = Start.Y
	            CurrentX = NextX
	            MaxXInColumn = Size.X
	        else
	            CurrentY = NextY
	        end
	    end

	    return UDim2.fromOffset(CurrentX, CurrentY)
	end

	function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
	    UI.Position = GetNonOverlappingPosition(UI, StartPos)
	end

	--// Window Snapping \\--
	local function GetCoreGuiInset(): (Vector2, Vector2)
	    local Success, TopLeft, BottomRight = pcall(function()
	        return GuiService:GetGuiInset()
	    end)

	    if Success and TopLeft and BottomRight then
	        return TopLeft, BottomRight
	    end

	    return Vector2.zero, Vector2.zero
	end

	local function GetSnapEdges(ElemSize: Vector2, ViewportSize: Vector2, Margin: number, AvoidCoreGui: boolean)
	    local SafeMin, SafeMax = Vector2.zero, ViewportSize

	    if AvoidCoreGui then
	        local TopLeftInset, BottomRightInset = GetCoreGuiInset()
	        SafeMin = TopLeftInset
	        SafeMax = ViewportSize - BottomRightInset
	    end

	    local TargetsX = {
	        LeftEdge = SafeMin.X + Margin,
	        Center = SafeMin.X + (SafeMax.X - SafeMin.X - ElemSize.X) / 2,
	        RightEdge = SafeMax.X - ElemSize.X - Margin,
	    }
	    local TargetsY = {
	        TopEdge = SafeMin.Y + Margin,
	        Center = SafeMin.Y + (SafeMax.Y - SafeMin.Y - ElemSize.Y) / 2,
	        BottomEdge = SafeMax.Y - ElemSize.Y - Margin,
	    }

	    return TargetsX, TargetsY
	end

	local function GetClosestSnapTarget(Value: number, Targets: { [string]: number }, Distance: number): (number?, string?)
	    local ClosestName, ClosestValue, ClosestDist = nil, nil, Distance

	    for Name, Target in Targets do
	        local Dist = math.abs(Value - Target)
	        if Dist <= ClosestDist then
	            ClosestDist = Dist
	            ClosestName = Name
	            ClosestValue = Target
	        end
	    end

	    return ClosestValue, ClosestName
	end

	local function GetSnapGuideOffset(Name: string, SnappedValue: number, ElemDimension: number): number
	    if Name == "RightEdge" or Name == "BottomEdge" then
	        return SnappedValue + ElemDimension
	    elseif Name == "Center" then
	        return SnappedValue + ElemDimension / 2
	    end

	    return SnappedValue -- LeftEdge / TopEdge
	end

	function Library:MakeDraggable(
	    UI: GuiObject,
	    DragFrame: GuiObject,
	    IgnoreToggled: boolean?,
	    IsMainWindow: boolean?,
	    SnapConfig: { Enabled: boolean, Distance: number?, Margin: number?, AvoidCoreGui: boolean? }?
	)
	    local StartPos
	    local FramePos
	    local Dragging = false
	    local Changed
	    local InputBegan
	    local InputChanged

	    local SnapGuideX, SnapGuideY

	    local function GetSnapGuides()
	        if not SnapGuideX then
	            SnapGuideX = New("Frame", {
	                BackgroundColor3 = "AccentColor",
	                BackgroundTransparency = 0.25,
	                BorderSizePixel = 0,
	                AnchorPoint = Vector2.new(0.5, 0),
	                Size = UDim2.new(0, 2, 1, 0),
	                Visible = false,
	                ZIndex = 10000,
	                Parent = ScreenGui,
	            })
	        end

	        if not SnapGuideY then
	            SnapGuideY = New("Frame", {
	                BackgroundColor3 = "AccentColor",
	                BackgroundTransparency = 0.25,
	                BorderSizePixel = 0,
	                AnchorPoint = Vector2.new(0, 0.5),
	                Size = UDim2.new(1, 0, 0, 2),
	                Visible = false,
	                ZIndex = 10000,
	                Parent = ScreenGui,
	            })
	        end

	        return SnapGuideX, SnapGuideY
	    end

	    local function HideSnapGuides()
	        if SnapGuideX then
	            SnapGuideX.Visible = false
	        end
	        if SnapGuideY then
	            SnapGuideY.Visible = false
	        end
	    end

	    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
	        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
	            return
	        end

	        StartPos = Input.Position
	        FramePos = UI.Position
	        Dragging = true

	        Changed = Input.Changed:Connect(function()
	            if Input.UserInputState ~= Enum.UserInputState.End then
	                return
	            end

	            Dragging = false
	            HideSnapGuides()

	            if Changed and Changed.Connected then
	                Changed:Disconnect()
	                Changed = nil
	            end
	        end)
	    end)

	    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
	        if
	            (not IgnoreToggled and not Library.Toggled)
	            or (IsMainWindow and Library.CantDragForced)
	            or not (ScreenGui and ScreenGui.Parent)
	        then
	            Dragging = false
	            HideSnapGuides()

	            if Changed and Changed.Connected then
	                Changed:Disconnect()
	                Changed = nil
	            end

	            return
	        end

	        if Dragging and IsHoverInput(Input) then
	            local Delta = Input.Position - StartPos
	            local NewX = FramePos.X.Offset + Delta.X
	            local NewY = FramePos.Y.Offset + Delta.Y

	            if SnapConfig and SnapConfig.Enabled then
	                local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
	                local Distance = SnapConfig.Distance or 28
	                local Margin = SnapConfig.Margin or 8

	                local AbsX = FramePos.X.Scale * ViewportSize.X + NewX
	                local AbsY = FramePos.Y.Scale * ViewportSize.Y + NewY

	                local ElemSize = UI.AbsoluteSize
	                local TargetsX, TargetsY = GetSnapEdges(ElemSize, ViewportSize, Margin, SnapConfig.AvoidCoreGui ~= false)
	                local SnappedX, SnappedXName = GetClosestSnapTarget(AbsX, TargetsX, Distance)
	                local SnappedY, SnappedYName = GetClosestSnapTarget(AbsY, TargetsY, Distance)

	                if SnappedX then
	                    NewX = SnappedX - FramePos.X.Scale * ViewportSize.X
	                end
	                if SnappedY then
	                    NewY = SnappedY - FramePos.Y.Scale * ViewportSize.Y
	                end

	                local GuideX, GuideY = GetSnapGuides()
	                GuideX.Visible = SnappedX ~= nil
	                if SnappedX then
	                    GuideX.Position = UDim2.fromOffset(GetSnapGuideOffset(SnappedXName, SnappedX, ElemSize.X), 0)
	                end

	                GuideY.Visible = SnappedY ~= nil
	                if SnappedY then
	                    GuideY.Position = UDim2.fromOffset(0, GetSnapGuideOffset(SnappedYName, SnappedY, ElemSize.Y))
	                end
	            end

	            UI.Position = UDim2.new(FramePos.X.Scale, NewX, FramePos.Y.Scale, NewY)
	        end
	    end)

	    Library:GiveSignal(InputChanged)
	    Library:GiveSignal(InputBegan)

	    UI.Destroying:Once(function()
	        if InputChanged and InputChanged.Connected then
	            InputChanged:Disconnect()
	        end

	        if InputBegan and InputBegan.Connected then
	            InputBegan:Disconnect()
	        end

	        if Changed and Changed.Connected then
	            Changed:Disconnect()
	        end

	        if SnapGuideX then
	            SnapGuideX:Destroy()
	        end
	        if SnapGuideY then
	            SnapGuideY:Destroy()
	        end

	        local IdxChanged = table.find(Library.Signals, InputChanged)
	        if IdxChanged then
	            table.remove(Library.Signals, IdxChanged)
	        end

	        local IdxBegan = table.find(Library.Signals, InputBegan)
	        if IdxBegan then
	            table.remove(Library.Signals, IdxBegan)
	        end
	    end)
	end

	function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
	    local StartPos
	    local FrameSize
	    local Dragging = false
	    local Changed
	    local InputBegan
	    local InputChanged

	    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
	        if not IsClickInput(Input) then
	            return
	        end

	        StartPos = Input.Position
	        FrameSize = UI.Size
	        Dragging = true

	        Changed = Input.Changed:Connect(function()
	            if Input.UserInputState ~= Enum.UserInputState.End then
	                return
	            end

	            Dragging = false
	            if Changed and Changed.Connected then
	                Changed:Disconnect()
	                Changed = nil
	            end
	        end)
	    end)

	    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
	        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
	            Dragging = false
	            if Changed and Changed.Connected then
	                Changed:Disconnect()
	                Changed = nil
	            end

	            return
	        end

	        if Dragging and IsHoverInput(Input) then
	            local Delta = Input.Position - StartPos
	            UI.Size = UDim2.new(
	                FrameSize.X.Scale,
	                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
	                FrameSize.Y.Scale,
	                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
	            )
	            if Callback then
	                Library:SafeCallback(Callback)
	            end
	        end
	    end)

	    Library:GiveSignal(InputChanged)
	    Library:GiveSignal(InputBegan)

	    UI.Destroying:Once(function()
	        if InputChanged and InputChanged.Connected then
	            InputChanged:Disconnect()
	        end

	        if InputBegan and InputBegan.Connected then
	            InputBegan:Disconnect()
	        end

	        if Changed and Changed.Connected then
	            Changed:Disconnect()
	        end

	        local IdxChanged = table.find(Library.Signals, InputChanged)
	        if IdxChanged then
	            table.remove(Library.Signals, IdxChanged)
	        end

	        local IdxBegan = table.find(Library.Signals, InputBegan)
	        if IdxBegan then
	            table.remove(Library.Signals, IdxBegan)
	        end
	    end)
	end

	function Library:MakeCover(Holder: GuiObject, Place: string)
	    local Pos = Places[Place] or { 0, 0 }
	    local Size = Sizes[Place] or { 1, 0.5 }

	    local Cover = New("Frame", {
	        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
	        BackgroundColor3 = Holder.BackgroundColor3,
	        Position = UDim2.fromScale(Pos[1], Pos[2]),
	        Size = UDim2.fromScale(Size[1], Size[2]),
	        Parent = Holder,
	    })

	    return Cover
	end

	function Library:MakeLine(Frame: GuiObject, Info)
	    local Line = New("Frame", {
	        AnchorPoint = Info.AnchorPoint or Vector2.zero,
	        BackgroundColor3 = "OutlineColor",
	        LayoutOrder = Info.LayoutOrder or 0,
	        Position = Info.Position,
	        Size = Info.Size,
	        ZIndex = Info.ZIndex or Frame.ZIndex,
	        Parent = Frame,
	    })

	    return Line
	end

	function Library:AddOutline(Frame: GuiObject)
	    local OutlineStroke = New("UIStroke", {
	        Color = "OutlineColor",
	        Thickness = 1,
	        ZIndex = 2,
	        Parent = Frame,
	    })
	    local ShadowStroke = New("UIStroke", {
	        Color = "DarkColor",
	        Thickness = 1.5,
	        ZIndex = 1,
	        Parent = Frame,
	    })
	    return OutlineStroke, ShadowStroke
	end

	function Library:AddBlank(Frame: GuiObject, Size: UDim2)
	    return New("Frame", {
	        BackgroundTransparency = 1,
	        Size = Size or UDim2.fromScale(0, 0),
	        Parent = Frame,
	    })
	end

	--// Animations \\--
	local TransparencyCache = {}
	local ActiveTabTweens = setmetatable({}, { __mode = "k" })

	function Library:PlayTabAnimation(Tab, Showing: boolean, OnComplete: (() -> ())?)
	    if type(Tab) ~= "table" or not Tab.Container then
	        if OnComplete then
	            OnComplete()
	        end

	        return
	    end

	    local TabContainer = Tab.Container :: Frame
	    local Existing = ActiveTabTweens[TabContainer]
	    if Existing then
	        StopTween(Existing, true)
	        ActiveTabTweens[TabContainer] = nil
	    end

	    local BaseZIndex = TabContainer.ZIndex
	    if not (Library.Animations and Library.Animations.TabSwitch) then
	        TabContainer.Visible = Showing
	        TabContainer.Position = UDim2.fromScale(0, 0)
	        TabContainer.ZIndex = BaseZIndex

	        if OnComplete then
	            OnComplete()
	        end

	        return
	    end

	    if Showing then
	        local TweenInfo = Library.TabTransitionInfo or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	        local Offset = Library.TabSwipeOffset or 26
	        local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
	        local StartPosition
	        local StartingPositions = {
	            Left = UDim2.fromOffset(-Offset, 0),
	            Right = UDim2.fromOffset(Offset, 0),
	            Top = UDim2.fromOffset(0, -Offset),
	            Bottom = UDim2.fromOffset(0, Offset),
	        }

	        if SwipeFrom == "auto" and Library.PreviousTab then
	            local CurrentOrder = Tab.Button.LayoutOrder
	            local PreviousOrder = Library.PreviousTab.Button.LayoutOrder
	            if CurrentOrder and PreviousOrder then -- this may be unnecessary but oh well
	                StartPosition = CurrentOrder > PreviousOrder and StartingPositions.Top or StartingPositions.Bottom -- bigger order means its under the current button
	            else
	                StartPosition = StartingPositions.Bottom
	            end
	        elseif SwipeFrom == "left" then
	            StartPosition = StartingPositions.Left
	        elseif SwipeFrom == "top" then
	            StartPosition = StartingPositions.Top
	        elseif SwipeFrom == "right" then
	            StartPosition = StartingPositions.Right
	        else -- bottom (Default)
	            StartPosition = StartingPositions.Bottom
	        end

	        TabContainer.ZIndex = BaseZIndex + 1
	        TabContainer.Position = StartPosition
	        TabContainer.Visible = true

	        local Tween = TweenService:Create(TabContainer, TweenInfo, {
	            Position = UDim2.fromScale(0, 0)
	        })

	        ActiveTabTweens[TabContainer] = Tween
	        Tween:Play()

	        local Connection; Connection = Tween.Completed:Connect(function(PlaybackState)
	            if Connection then
	                Connection:Disconnect()
	            end

	            if ActiveTabTweens[TabContainer] == Tween then
	                ActiveTabTweens[TabContainer] = nil
	            end

	            if PlaybackState == Enum.PlaybackState.Cancelled then
	                return
	            end

	            TabContainer.ZIndex = BaseZIndex
	            if OnComplete then
	                OnComplete()
	            end
	        end)
	    else
	        TabContainer.Visible = false
	        TabContainer.Position = UDim2.fromScale(0, 0)
	        TabContainer.ZIndex = BaseZIndex

	        if OnComplete then
	            OnComplete()
	        end
	    end
	end

	--// Pop Out \\--
	function Library:MakeBoxPopOut(Box: any, Options: {
	    Enabled: boolean?,
	    Header: GuiObject?,
	    Children: (() -> { GuiObject })?,
	    Before: (() -> ())?,
	    After: (() -> ())?,
	    MaxPopOutHeight: number?,
	    PopOutWidth: number?,
	})
	    Box.PoppedOut = false
	    Box.PopOutEnabled = Options.Enabled ~= false
	    Box.PopOutFloat = nil
	    Box.PopOutPlaceholder = nil
	    Box.PopOutMaxHeight = if typeof(Options.MaxPopOutHeight) == "number" then Options.MaxPopOutHeight else nil
	    Box.PopOutWidth = if typeof(Options.PopOutWidth) == "number" then Options.PopOutWidth else nil

	    if not Box.PopOutEnabled then
	        function Box:SetPoppedOut(_Value: boolean, _SetPoppedOut: UDim2) end
	        function Box:TogglePoppedOut() end
	        function Box:RefreshPopOutPlaceholder() end
	        function Box:SetMaxPopOutHeight(_Height: number?) end
	        function Box:SetPopOutWidth(_Width: number?) end
	        return
	    end

	    local BoxHolder = Box.BoxHolder
	    local Holder = Box.Holder
	    local Header = Options.Header

	    local Placeholder
	    local PlaceholderHeader
	    local Float
	    local FloatScale

	    local HandledChildren: { GuiObject } = {}
	    local OriginalParents: { [GuiObject]: Instance? } = {}
	    local OriginalLayoutOrders: { [GuiObject]: number } = {}

	    local DragState: "Idle" | "Holding" | "Dragging" = "Idle"
	    local DragInput: InputObject?
	    local PressMouse: Vector2?

	    local DragStartPos: UDim2?
	    local DragChanged: RBXScriptConnection?
	    local DragDidMove = false

	    --// UI Handler
	    local function GetPopOutWidth(): number
	        if typeof(Box.PopOutWidth) == "number" then
	            return math.max(50, math.floor(Box.PopOutWidth + 0.5))
	        end

	        if typeof(Box.PopOutDockedWidth) == "number" then
	            return math.max(50, math.floor(Box.PopOutDockedWidth + 0.5))
	        end

	        local Width = Holder.AbsoluteSize.X / Library.DPIScale
	        if Width < 50 then
	            Width = 200
	        end

	        return math.max(50, math.floor(Width + 0.5))
	    end

	    local function ApplyPopOutWidth()
	        if not (Box.PoppedOut and Float) then
	            return
	        end

	        Float.Size = UDim2.fromOffset(GetPopOutWidth(), Float.Size.Y.Offset)
	        if Box.Resize then
	            Box:Resize()
	        end
	    end

	    local function RaiseFloat()
	        if not Float or not Floats then
	            return
	        end

	        local MaxZ = Float.ZIndex
	        for _, Child in Floats:GetChildren() do
	            if Child:IsA("GuiObject") and Child ~= Float then
	                MaxZ = math.max(MaxZ, Child.ZIndex)
	            end
	        end

	        Float.ZIndex = MaxZ + 1
	        if Float.Parent == Floats then
	            Float.Parent = Overlay
	        end
	        Float.Parent = Floats
	    end

	    local function CreatePlaceholder()
	        local Frame = New("Frame", {
	            AutomaticSize = Enum.AutomaticSize.Y,
	            BackgroundColor3 = "BackgroundColor",
	            BackgroundTransparency = 0.12,
	            ClipsDescendants = true,
	            Size = UDim2.new(1, 0, 0, 0),
	            Parent = BoxHolder,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius),
	                Parent = Frame,
	            })
	        )
	        Library:AddOutline(Frame)

	        PlaceholderHeader = Header:Clone()
	        PlaceholderHeader.Parent = Frame
	        RegisterPopOutClone(Header, PlaceholderHeader)
	        DimPopOutClone(PlaceholderHeader)

	        if PopOutIcon then
	            local PlaceholderDockIcon = Library:CreateIcon(PopOutIcon, {
	                AnchorPoint = Vector2.new(1, 0.5),
	                ImageColor3 = "WhiteColor",
	                Position = UDim2.new(1, -8, 0.5, 0),
	                Size = UDim2.fromOffset(22, 22),
	                ZIndex = PlaceholderHeader.ZIndex + 1,
	                Parent = Frame,
	            }, true)
	            PlaceholderDockIcon.MouseButton1Click:Connect(function()
	                Box:SetPoppedOut(false)
	            end)
	        end

	        return Frame
	    end

	    function Box:RefreshPopOutPlaceholder()
	        if not Box.PoppedOut or not Placeholder or not Header then
	            return
	        end

	        if PlaceholderHeader then
	            PlaceholderHeader:Destroy()
	            PlaceholderHeader = nil
	        end

	        PlaceholderHeader = Header:Clone()
	        PlaceholderHeader.Parent = Placeholder
	        RegisterPopOutClone(Header, PlaceholderHeader)
	        DimPopOutClone(PlaceholderHeader)
	    end

	    function Box:SetPoppedOut(Value: boolean, FloatPosition: UDim2?)
	        if not Box.PopOutEnabled or Box.Destroyed then
	            return
	        end

	        Value = Value == true
	        if Box.PoppedOut == Value then
	            if Value and FloatPosition and Float then
	                Float.Position = FloatPosition
	            end
	            return
	        end

	        if Value then
	            if Options.Before then
	                Options.Before()
	            end

	            local BoxChildren = if Options.Children then Options.Children() else { Holder }
	            HandledChildren = {}

	            table.clear(OriginalParents)
	            table.clear(OriginalLayoutOrders)

	            for _, Child in BoxChildren do
	                if not Child or not Child.Parent then
	                    continue
	                end

	                table.insert(HandledChildren, Child)
	                OriginalParents[Child] = Child.Parent
	                OriginalLayoutOrders[Child] = Child.LayoutOrder
	            end

	            if #HandledChildren == 0 then
	                return
	            end

	            local DockedWidth = Holder.AbsoluteSize.X / Library.DPIScale
	            if DockedWidth < 50 then
	                DockedWidth = 200
	            end
	            Box.PopOutDockedWidth = math.max(50, math.floor(DockedWidth + 0.5))

	            local Width = GetPopOutWidth()

	            local AbsolutePosition = Holder.AbsolutePosition
	            Placeholder = CreatePlaceholder()
	            Box.PopOutPlaceholder = Placeholder

	            Float = New("Frame", {
	                Active = true,
	                AutomaticSize = Enum.AutomaticSize.Y,
	                BackgroundTransparency = 1,
	                Position = FloatPosition or UDim2.fromOffset(
	                    AbsolutePosition.X / Library.DPIScale,
	                    AbsolutePosition.Y / Library.DPIScale
	                ),
	                Size = UDim2.fromOffset(Width, 0),
	                ZIndex = 1,
	                Parent = Floats,
	            })
	            FloatScale = New("UIScale", {
	                Parent = Float,
	            })
	            table.insert(Library.Scales, FloatScale)
	            FloatScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[FloatScale]) or 0)

	            New("UIListLayout", {
	                Padding = UDim.new(0, 6),
	                Parent = Float,
	            })

	            for _, Child in HandledChildren do
	                Child.Parent = Float
	            end

	            if not table.find(Library.DraggableElements, Float) then
	                table.insert(Library.DraggableElements, Float)
	            end

	            Box.PopOutFloat = Float
	            Box.PoppedOut = true
	            SyncPopOutVisibility(Box)
	            RaiseFloat()

	            Float:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	                Box:Resize()
	            end)

	            if Options.After then
	                Options.After()
	            end

	            return
	        end

	        if Float then
	            local DraggableIndex = table.find(Library.DraggableElements, Float)
	            if DraggableIndex then
	                table.remove(Library.DraggableElements, DraggableIndex)
	            end
	        end

	        if FloatScale then
	            local ScaleIndex = table.find(Library.Scales, FloatScale)
	            if ScaleIndex then
	                table.remove(Library.Scales, ScaleIndex)
	            end

	            FloatScale = nil
	        end

	        for _, Child in HandledChildren do
	            if not Child or not Child.Parent then
	                continue
	            end

	            Child.Parent = OriginalParents[Child] or BoxHolder
	            Child.LayoutOrder = OriginalLayoutOrders[Child] or 0
	        end

	        if Placeholder then
	            Placeholder:Destroy()
	            Placeholder = nil
	        end
	        
	        PlaceholderHeader = nil

	        if Float then
	            Float:Destroy()
	            Float = nil
	        end

	        Box.PopOutFloat = nil
	        Box.PopOutPlaceholder = nil
	        Box.PopOutDockedWidth = nil
	        Box.PoppedOut = false

	        table.clear(HandledChildren)
	        table.clear(OriginalParents)
	        table.clear(OriginalLayoutOrders)

	        if Options.After then
	            Options.After()
	        end
	    end

	    function Box:TogglePoppedOut()
	        Box:SetPoppedOut(not Box.PoppedOut)
	    end

	    function Box:SetMaxPopOutHeight(Height: number?)
	        if Height ~= nil then
	            assert(typeof(Height) == "number", "Height must be a number or nil")
	            assert(Height >= 0, "Height must be higher than 0")
	        end

	        Box.PopOutMaxHeight = Height
	        if Box.PoppedOut and Box.Resize then
	            Box:Resize()
	        end
	    end

	    function Box:SetPopOutWidth(Width: number?)
	        if Width ~= nil then
	            assert(typeof(Width) == "number", "Width must be a number or nil")
	            assert(Width >= 0, "Width must be higher than 0")
	        end

	        Box.PopOutWidth = Width
	        ApplyPopOutWidth()
	    end

	    --// Drag Handler
	    local function StopDrag()
	        if DragState == "Idle" then
	            return
	        end

	        local WasDragging = DragState == "Dragging"
	        local DidMove = DragDidMove
	        DragState = "Idle"
	        DragInput = nil
	        PressMouse = nil
	        DragStartPos = nil
	        DragDidMove = false

	        if DragChanged and DragChanged.Connected then
	            DragChanged:Disconnect()
	            DragChanged = nil
	        end

	        if not WasDragging or not Box.PoppedOut or not Float then
	            return
	        end

	        local FloatCenter = Float.AbsolutePosition + (Float.AbsoluteSize * 0.5)
	        local NearPlaceholder = false
	        if Library.Toggled and Placeholder and Placeholder.Parent then
	            local PlaceholderCenter = Placeholder.AbsolutePosition + (Placeholder.AbsoluteSize * 0.5)
	            NearPlaceholder = (FloatCenter - PlaceholderCenter).Magnitude <= Library.PopOutSnapDistance
	        end

	        if NearPlaceholder or (DidMove and not IsScreenPointOutsideMain(FloatCenter)) then
	            Box:SetPoppedOut(false)
	        end
	    end

	    local function BeginDrag(Input: InputObject)
	        if DragState ~= "Idle" or Box.Destroyed or not (ScreenGui and ScreenGui.Parent) then
	            return
	        end

	        local Point = Vector2.new(Input.Position.X, Input.Position.Y)
	        local Top = GetTopFloatAt(Point)
	        if Box.PoppedOut then
	            if not Float or Top ~= Float then
	                return
	            end
	        elseif Top ~= nil and not Header:IsDescendantOf(Top) then
	            return
	        end

	        DragState = "Holding"
	        DragInput = Input
	        PressMouse = Vector2.new(Input.Position.X, Input.Position.Y)
	        DragStartPos = nil
	        DragDidMove = false

	        if Box.PoppedOut and Float then
	            RaiseFloat()
	        end

	        DragChanged = Input.Changed:Connect(function()
	            if Input.UserInputState == Enum.UserInputState.End then
	                StopDrag()
	            end
	        end)

	        task.delay(Library.PopOutHoldTime, function()
	            if (DragState :: any) ~= "Holding" or DragInput ~= Input then
	                return
	            end

	            DragState = "Dragging"
	            if Box.PoppedOut and Float then
	                RaiseFloat()
	                DragStartPos = Float.Position
	            end
	        end)
	    end

	    local function UpdateDrag(Input: InputObject)
	        if DragState ~= "Dragging" or not PressMouse then
	            return
	        end
	        if not (ScreenGui and ScreenGui.Parent) then
	            StopDrag()
	            return
	        end

	        local MousePosition = Vector2.new(Input.Position.X, Input.Position.Y)
	        local Delta = MousePosition - PressMouse

	        if not Box.PoppedOut then
	            if Delta.Magnitude < Library.PopOutDragThreshold then
	                return
	            end

	            Box:SetPoppedOut(true)
	            if not Float then
	                return
	            end

	            RaiseFloat()
	            DragStartPos = Float.Position
	            DragDidMove = true
	        elseif Delta.Magnitude >= Library.PopOutDragThreshold then
	            DragDidMove = true
	        end

	        if Float and DragStartPos then
	            Float.Position = UDim2.new(
	                DragStartPos.X.Scale,
	                DragStartPos.X.Offset + Delta.X,
	                DragStartPos.Y.Scale,
	                DragStartPos.Y.Offset + Delta.Y
	            )
	        end
	    end

	    local function BindDragSource(Gui: GuiObject)
	        Library:GiveSignal(Gui.InputBegan:Connect(function(Input: InputObject)
	            if IsClickInput(Input) then
	                BeginDrag(Input)
	            end
	        end))
	    end

	    BindDragSource(Header)
	    for _, Descendant in Header:QueryDescendants("GuiObject:not(ImageButton)") do
	        BindDragSource(Descendant)
	    end

	    Library:GiveSignal(Header.DescendantAdded:Connect(function(Descendant)
	        if Descendant:IsA("GuiObject") and not Descendant:IsA("ImageButton") then
	            BindDragSource(Descendant)
	        end
	    end))

	    Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
	        if IsHoverInput(Input) then
	            UpdateDrag(Input)
	        end
	    end))
	end

	--// Deprecated \\--
	function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
	    warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
	    local Holder = New("Frame", {
	        BackgroundColor3 = "DarkColor",
	        Position = UDim2.fromOffset(-2, -2),
	        Size = UDim2.new(1, 4, 1, 4),
	        ZIndex = ZIndex,
	        Parent = Frame,
	    })

	    local Outline = New("Frame", {
	        BackgroundColor3 = "OutlineColor",
	        Position = UDim2.fromOffset(1, 1),
	        Size = UDim2.new(1, -2, 1, -2),
	        ZIndex = ZIndex,
	        Parent = Holder,
	    })

	    if Corner and Corner > 0 then
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Corner + 1),
	            Parent = Holder,
	        })
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Corner),
	            Parent = Outline,
	        })
	    end

	    return Holder, Outline
	end

	function Library:AddDraggableLabel(...)
	    local Params = select(1, ...)
	    local Text
	    local Icon
	    local IconPosition = "left"

	    if typeof(Params) == "table" then
	        Text = Params.Text
	        Icon = Params.Icon
	        IconPosition = Params.IconPosition or "left"
	    elseif typeof(Params) == "string" then
	        Text = Params
	        Icon = select(2, ...)
	        IconPosition = select(3, ...) or "left"
	    end

	    if typeof(IconPosition) ~= "string" then
	        IconPosition = "left"
	    end

	    IconPosition = string.lower(IconPosition)
	    assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

	    local DraggableLabel = {
	        Connections = {},
	        Destroyed = false
	    }

	    local IconImage
	    local Label = New("TextLabel", {
	        AutomaticSize = Enum.AutomaticSize.XY,
	        BackgroundColor3 = "BackgroundColor",
	        Size = UDim2.fromOffset(0, 0),
	        Position = UDim2.fromOffset(6, 6),
	        Text = Text,
	        TextSize = 15,
	        ZIndex = 1,
	        Parent = Floats,
	    })

	    table.insert(
	        Library.Corners,
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Library.CornerRadius),
	            Parent = Label,
	        })
	    )

	    local Padding = New("UIPadding", {
	        PaddingBottom = UDim.new(0, 6),
	        PaddingLeft = UDim.new(0, 12),
	        PaddingRight = UDim.new(0, 12),
	        PaddingTop = UDim.new(0, 6),
	        Parent = Label,
	    })
	    table.insert(
	        Library.Scales,
	        New("UIScale", {
	            Parent = Label,
	        })
	    )

	    Library:AddOutline(Label)
	    Library:MakeDraggable(Label, Label, true)

	    function DraggableLabel:SetText(Text: string)
	        Label.Text = Text
	    end

	    function DraggableLabel:SetIcon(NewIcon: string)
	        Icon = NewIcon

	        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
	        if IsNotEmpty then
	            local CustomIcon = Library:GetCustomIcon(Icon)
	            assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	            IconImage = if IconImage then Library:ApplyIcon(IconImage, CustomIcon) else Library:CreateIcon(CustomIcon, {
	                ImageColor3 = "FontColor",
	                Size = UDim2.fromOffset(16, 16),
	                ZIndex = 2,
	                Parent = Label,
	            })
	        end

	        if IconImage then IconImage.Visible = IsNotEmpty end
	        DraggableLabel:SetIconPosition(IconPosition)
	    end

	    function DraggableLabel:SetIconPosition(NewPosition: string)
	        IconPosition = string.lower(NewPosition)
	        assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

	        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
	        Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
	        Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

	        if IconImage then
	            if IconPosition == "left" then
	                IconImage.AnchorPoint = Vector2.new(0, 0.5)
	                IconImage.Position = UDim2.new(0, -22, 0.5, 0)
	            else
	                IconImage.AnchorPoint = Vector2.new(1, 0.5)
	                IconImage.Position = UDim2.new(1, 22, 0.5, 0)
	            end
	        end
	    end

	    function DraggableLabel:SetVisible(Visible: boolean)
	        Label.Visible = Visible
	    end

	    DraggableLabel:SetIcon(Icon)
	    DraggableLabel.Label = Label

	    if not table.find(Library.DraggableElements, Label) then
	        table.insert(Library.DraggableElements, Label)
	    end

	    PositionDraggable(Label, Label.Position)

	    function DraggableLabel:Destroy()
	        DraggableLabel.Destroyed = true

	        if DraggableLabel.Connections then
	            for _, connection in DraggableLabel.Connections do
	                connection:Disconnect()
	            end
	        end

	        local ElemIdx = table.find(Library.DraggableElements, Label)
	        if ElemIdx then
	            table.remove(Library.DraggableElements, ElemIdx)
	        end

	        if Label then
	            Label:Destroy()
	        end
	    end

	    return DraggableLabel
	end

	function Library:AddDraggableButton(...)
	    local Params = select(1, ...)

	    local Text
	    local Func
	    local ExcludeScaling
	    local ExcludeDragging

	    if typeof(Params) == "table" then
	        Text = Params.Text
	        Func = Params.Callback or Params.Func
	        ExcludeScaling = Params.ExcludeScaling
	        ExcludeDragging = Params.ExcludeDragging
	    elseif typeof(Params) == "string" then
	        Text = Params
	        Func = select(2, ...)
	        ExcludeScaling = select(3, ...)
	        ExcludeDragging = select(4, ...)
	    end

	    local DraggableButton = {
	        Connections = {},
	        Destroyed = false
	    }

	    local Button = New("TextButton", {
	        BackgroundColor3 = "BackgroundColor",
	        Position = UDim2.fromOffset(6, 6),
	        TextSize = 16,
	        ZIndex = 1,
	        Parent = Floats,
	    })
	    table.insert(
	        Library.Corners,
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Library.CornerRadius),
	            Parent = Button,
	        })
	    )
	    if not ExcludeScaling then
	        table.insert(
	            Library.Scales,
	            New("UIScale", {
	                Parent = Button,
	            })
	        )
	    end
	    Library:AddOutline(Button)

	    local PressPosition
	    Button.InputBegan:Connect(function(Input: InputObject)
	        if IsMouseInput(Input) then
	            PressPosition = Button.AbsolutePosition
	        end
	    end)
	    Button.Activated:Connect(function()
	        if PressPosition and (Button.AbsolutePosition - PressPosition).Magnitude > 10 then
	            return
	        end

	        Library:SafeCallback(Func, DraggableButton)
	    end)

	    function DraggableButton:SetText(Text: string)
	        local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

	        Button.Text = Text
	        Button.Size = UDim2.fromOffset(X * 2, Y * 2)
	    end

	    if not ExcludeDragging then
	        Library:MakeDraggable(Button, Button, true)
	    end
	    DraggableButton:SetText(Text)
	    DraggableButton.Button = Button

	    if not table.find(Library.DraggableElements, Button) then
	        table.insert(Library.DraggableElements, Button)
	    end

	    PositionDraggable(Button, Button.Position)

	    function DraggableButton:Destroy()
	        DraggableButton.Destroyed = true

	        if DraggableButton.Connections then
	            for _, connection in DraggableButton.Connections do
	                connection:Disconnect()
	            end
	        end

	        local ElemIdx = table.find(Library.DraggableElements, Button)
	        if ElemIdx then
	            table.remove(Library.DraggableElements, ElemIdx)
	        end

	        if Button then
	            Button:Destroy()
	        end
	    end

	    return DraggableButton
	end

	function Library:AddDraggableMenu(Name: string)
	    local Holder = New("Frame", {
	        AutomaticSize = Enum.AutomaticSize.XY,
	        BackgroundColor3 = "BackgroundColor",
	        Position = UDim2.fromOffset(6, 6),
	        Size = UDim2.fromOffset(0, 0),
	        ZIndex = 1,
	        Parent = Floats,
	    })
	    table.insert(
	        Library.Corners,
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Library.CornerRadius),
	            Parent = Holder,
	        })
	    )
	    table.insert(
	        Library.Scales,
	        New("UIScale", {
	            Parent = Holder,
	        })
	    )
	    Library:AddOutline(Holder)

	    local DividerLine = Library:MakeLine(Holder, {
	        Position = UDim2.fromOffset(0, 34),
	        Size = UDim2.new(1, 0, 0, 1),
	    })

	    local Label = New("TextLabel", {
	        BackgroundTransparency = 1,
	        Size = UDim2.new(1, 0, 0, 34),
	        Text = Name,
	        TextSize = 15,
	        TextXAlignment = Enum.TextXAlignment.Left,
	        Parent = Holder,
	    })
	    local LabelPadding = New("UIPadding", {
	        PaddingLeft = UDim.new(0, 12),
	        PaddingRight = UDim.new(0, 12),
	        Parent = Label,
	    })

	    local Container = New("Frame", {
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(0, 35),
	        Size = UDim2.new(1, 0, 1, -35),
	        Parent = Holder,
	    })
	    New("UIListLayout", {
	        Padding = UDim.new(0, 7),
	        Parent = Container,
	    })
	    New("UIPadding", {
	        PaddingBottom = UDim.new(0, 7),
	        PaddingLeft = UDim.new(0, 7),
	        PaddingRight = UDim.new(0, 7),
	        PaddingTop = UDim.new(0, 7),
	        Parent = Container,
	    })

	    Library:MakeDraggable(Holder, Label, true)

	    if not table.find(Library.DraggableElements, Holder) then
	        table.insert(Library.DraggableElements, Holder)
	    end

	    PositionDraggable(Holder, Holder.Position)

	    return Holder, Container, Label, DividerLine, LabelPadding
	end

	function Library:AddDraggableImageButton(...)
	    local Params = select(1, ...)

	    local Icon
	    local IconSize
	    local Func
	    local ExcludeScaling
	    local ExcludeDragging

	    if typeof(Params) == "table" then
	        Icon = Params.Icon
	        IconSize = Params.IconSize or 24
	        Func = Params.Callback or Params.Func
	        ExcludeScaling = Params.ExcludeScaling
	        ExcludeDragging = Params.ExcludeDragging
	    elseif typeof(Params) == "string" or typeof(Params) == "number" then
	        Icon = Params
	        IconSize = select(2, ...)
	        Func = select(3, ...)
	        ExcludeScaling = select(4, ...)
	        ExcludeDragging = select(5, ...)
	    end

	    local DraggableImageButton = {}

	    local Button = New("TextButton", {
	        BackgroundColor3 = "BackgroundColor",
	        Position = UDim2.fromOffset(6, 6),
	        Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
	        Text = "",
	        ZIndex = 1,
	        Parent = Floats,
	    })

	    local IconImage = Library:CreateIcon(nil, {
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.fromOffset(IconSize, IconSize),
	        ImageColor3 = "FontColor",
	        ZIndex = 2,
	        Parent = Button,
	    })

	    table.insert(
	        Library.Corners,
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Library.CornerRadius),
	            Parent = Button,
	        })
	    )
	    if not ExcludeScaling then
	        table.insert(
	            Library.Scales,
	            New("UIScale", {
	                Parent = Button,
	            })
	        )
	    end
	    Library:AddOutline(Button)

	    local PressPosition
	    Button.InputBegan:Connect(function(Input: InputObject)
	        if IsMouseInput(Input) then
	            PressPosition = Button.AbsolutePosition
	        end
	    end)
	    Button.Activated:Connect(function()
	        if PressPosition and (Button.AbsolutePosition - PressPosition).Magnitude > 10 then
	            return
	        end

	        Library:SafeCallback(Func, DraggableImageButton)
	    end)

	    function DraggableImageButton:SetIcon(NewIcon: string)
	        Icon = NewIcon or Icon

	        local CustomIcon = Library:GetCustomIcon(Icon)
	        assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	        IconImage = Library:ApplyIcon(IconImage, CustomIcon)
	    end

	    function DraggableImageButton:SetIconSize(NewSize: number)
	        IconSize = NewSize
	        IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
	        Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
	    end

	    if not ExcludeDragging then
	        Library:MakeDraggable(Button, Button, true)
	    end
	    DraggableImageButton:SetIcon(Icon)
	    DraggableImageButton.Button = Button

	    if not table.find(Library.DraggableElements, Button) then
	        table.insert(Library.DraggableElements, Button)
	    end

	    PositionDraggable(Button, Button.Position)

	    return DraggableImageButton
	end

	--// Watermark - Deprecated \\--
	do
	    local WatermarkLabel = Library:AddDraggableLabel("")
	    WatermarkLabel:SetVisible(false)

	    function Library:SetWatermark(Text: string)
	        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
	        WatermarkLabel:SetText(Text)
	    end

	    function Library:SetWatermarkVisibility(Visible: boolean)
	        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
	        WatermarkLabel:SetVisible(Visible)
	    end
	end

	--// Context Menu \\--
	local CurrentMenu

	local function CloseMenus(Until: any?, ShouldClose: ((Menu: any) -> boolean)?)
	    local Closed = {}

	    while CurrentMenu and CurrentMenu ~= Until and not Closed[CurrentMenu] do
	        local Menu = CurrentMenu
	        if ShouldClose and not ShouldClose(Menu) then
	            break
	        end

	        Closed[Menu] = true
	        Menu:Close()
	    end
	end

	function Library:AddContextMenu(
	    Holder: GuiObject,
	    Size: UDim2 | () -> (),
	    Offset: { [number]: number } | () -> {},
	    List: number?,
	    ActiveCallback: (Active: boolean) -> ()?,
	    IgnoreCornerRadius: boolean?,
	    SpecificCornersOnly: ("top" | "bottom" | "no_left" | "no_top_left")?, -- stupid way of doing this
	    AnimationType: ("Dropdown" | "KeyPicker" | "none")?
	)
	    local Menu
	    local HolderGui = Holder:FindFirstAncestorOfClass("ScreenGui")
	    local ParentGui = Overlay
	    if HolderGui and HolderGui ~= ScreenGui and Library.ActiveLoading and HolderGui == Library.ActiveLoading.ScreenGui then
	        ParentGui = HolderGui
	    end

	    if List then
	        Menu = New("ScrollingFrame", {
	            AutomaticCanvasSize = Enum.AutomaticSize.None,
	            AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
	            BackgroundColor3 = "BackgroundColor",
	            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
	            CanvasSize = UDim2.fromOffset(0, 0),
	            ScrollBarImageColor3 = "OutlineColor",
	            ScrollBarThickness = List == 2 and 2 or 0,
	            Size = typeof(Size) == "function" and Size() or Size,
	            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
	            Visible = false,
	            ZIndex = 1,
	            Parent = ParentGui,
	        })
	    else
	        Menu = New("Frame", {
	            BackgroundColor3 = "BackgroundColor",
	            Size = typeof(Size) == "function" and Size() or Size,
	            Visible = false,
	            ZIndex = 1,
	            Parent = ParentGui,
	        })
	    end
	    table.insert(
	        Library.Scales,
	        New("UIScale", {
	            Parent = Menu,
	        })
	    )

	    New("UIStroke", {
	        Color = "OutlineColor",
	        Parent = Menu,
	    })

	    local Corner;
	    if IgnoreCornerRadius ~= true then
	        if SpecificCornersOnly == "top" then
	            Corner = New("UICorner", {
	                TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomRightRadius = UDim.new(0, 0),
	                BottomLeftRadius = UDim.new(0, 0),
	                Parent = Menu,
	            }); table.insert(Library.SpecificCorners, Corner)
	        elseif SpecificCornersOnly == "bottom" then
	            Corner = New("UICorner", {
	                TopLeftRadius = UDim.new(0, 0),
	                TopRightRadius = UDim.new(0, 0),
	                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Menu,
	            }); table.insert(Library.SpecificCorners, Corner)
	        elseif SpecificCornersOnly == "no_left" then
	            Corner = New("UICorner", {
	                TopLeftRadius = UDim.new(0, 0),
	                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomLeftRadius = UDim.new(0, 0),
	                Parent = Menu,
	            }); table.insert(Library.SpecificCorners, Corner)
	        elseif SpecificCornersOnly == "no_top_left" then
	            Corner = New("UICorner", {
	                TopLeftRadius = UDim.new(0, 0),
	                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Menu,
	            }); table.insert(Library.SpecificCorners, Corner)
	        else
	            Corner = New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Menu,
	            }); table.insert(Library.Corners, Corner)
	        end
	    end

	    local Table = {
	        Connections = {},
	        Destroyed = false,

	        Active = false,
	        ActiveCallback = ActiveCallback,

	        Holder = Holder,
	        Menu = Menu,
	        Corner = Corner,

	        List = nil,
	        Signal = nil,

	        Size = Size,
	        AutoSizeY = List == 1,

	        OpenCloseTween = nil,
	        Animated = function()
	            if not AnimationType or AnimationType == "none" then
	                return false
	            end

	            if not (Library.Animations and Library.Animations[AnimationType] == true) then
	                return false
	            end

	            return true, Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	        end
	    }

	    if List == 1 then
	        Table.List = New("UIListLayout", {
	            Parent = Menu,
	        })
	    end

	    function Table:Open()
	        if CurrentMenu == Table then
	            return
	        end

	        local NestedParent = nil
	        local Check = CurrentMenu
	        while Check do
	            if Holder:IsDescendantOf(Check.Menu) then
	                NestedParent = Check
	                break
	            end
	            Check = Check.ParentMenu
	        end

	        CloseMenus(NestedParent)

	        Table.ParentMenu = NestedParent
	        CurrentMenu = Table
	        Table.Active = true
	        Menu.ZIndex = NestedParent and NestedParent.Menu.ZIndex + 1 or 1

	        local TargetParent = if ParentGui == Overlay then Overlay else ParentGui
	        Menu.Parent = nil
	        Menu.Parent = TargetParent

	        if typeof(Offset) == "function" then
	            Menu.Position = UDim2.fromOffset(
	                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
	                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
	            )
	        else
	            Menu.Position = UDim2.fromOffset(
	                math.floor(Holder.AbsolutePosition.X + Offset[1]),
	                math.floor(Holder.AbsolutePosition.Y + Offset[2])
	            )
	        end

	        local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

	        if typeof(ActiveCallback) == "function" then
	            Library:SafeCallback(ActiveCallback, true)
	        end

	        if Table.OpenCloseTween then
	            StopTween(Table.OpenCloseTween, true)
	            Table.OpenCloseTween = nil
	        end

	        local IsAnimated, TweenInfo = Table.Animated()
	        if IsAnimated == true then
	            local OpenSize = TargetSize
	            if Table.AutoSizeY then
	                local FullHeight = Menu.AbsoluteSize.Y

	                Menu.AutomaticSize = Enum.AutomaticSize.None
	                OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
	            end

	            Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
	            Menu.Visible = true

	            local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
	            Table.OpenCloseTween = Tween

	            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
	                if Connection then
	                    Connection:Disconnect()
	                end

	                if Table.OpenCloseTween == Tween then
	                    StopTween(Table.OpenCloseTween, true)
	                    Table.OpenCloseTween = nil

	                    if Table.AutoSizeY then
	                        Menu.AutomaticSize = Enum.AutomaticSize.Y
	                    end
	                end
	            end))

	            Tween:Play()
	        else
	            Menu.Size = TargetSize
	            Menu.Visible = true
	        end

	        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	            if typeof(Offset) == "function" then
	                Menu.Position = UDim2.fromOffset(
	                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
	                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
	                )
	            else
	                Menu.Position = UDim2.fromOffset(
	                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
	                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
	                )
	            end

	            local HolderAllowed = Table.ParentMenu ~= nil or Library:IsInsideFrame(Library.WindowContainer, Holder)
	            if not HolderAllowed then
	                for _, Surface in Library.DraggableElements do
	                    if not (Surface and Library:IsInsideFrame(Surface, Holder)) then
	                        continue
	                    end

	                    HolderAllowed = true
	                    break
	                end
	            end

	            if not HolderAllowed and Table.Active then
	                Table:Close()
	            end
	        end)
	    end

	    function Table:Close()
	        if CurrentMenu ~= Table then
	            return
	        end

	        if Table.Signal then
	            Table.Signal:Disconnect()
	            Table.Signal = nil
	        end

	        Table.Active = false
	        CurrentMenu = Table.ParentMenu
	        Table.ParentMenu = nil

	        if typeof(ActiveCallback) == "function" then
	            Library:SafeCallback(ActiveCallback, false)
	        end

	        if Table.OpenCloseTween then
	            StopTween(Table.OpenCloseTween, true)
	            Table.OpenCloseTween = nil
	        end

	        local IsAnimated, TweenInfo = Table.Animated()
	        if IsAnimated == true then
	            if Table.AutoSizeY then
	                Menu.AutomaticSize = Enum.AutomaticSize.None
	            end

	            local CurrentSize = Menu.Size
	            local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

	            local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
	            Table.OpenCloseTween = Tween

	            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
	                if Connection then
	                    Connection:Disconnect()
	                end

	                if Table.OpenCloseTween == Tween then
	                    StopTween(Table.OpenCloseTween, true)
	                    Table.OpenCloseTween = nil

	                    Menu.Visible = false
	                    if Table.AutoSizeY then
	                        Menu.AutomaticSize = Enum.AutomaticSize.Y
	                    end
	                end
	            end))

	            Tween:Play()
	        else
	            Menu.Visible = false
	        end
	    end

	    function Table:Toggle()
	        if Table.Active then
	            Table:Close()
	        else
	            Table:Open()
	        end
	    end

	    function Table:SetSize(Size)
	        Table.Size = Size
	        Menu.Size = typeof(Size) == "function" and Size() or Size
	    end

	    function Table:Destroy()
	        Table.Destroyed = true

	        if Table.Connections then
	            for _, Connection in Table.Connections do
	                Connection:Disconnect()
	            end
	        end

	        if Table.Active then
	            CloseMenus(Table)
	            Table:Close()
	        end

	        if Table.OpenCloseTween then
	            StopTween(Table.OpenCloseTween, true)
	            Table.OpenCloseTween = nil
	        end

	        local MenuIndex = table.find(Library.ContextMenus, Table)
	        if MenuIndex then
	            table.remove(Library.ContextMenus, MenuIndex)
	        end

	        if Menu then
	            Menu:Destroy()
	        end
	    end

	    table.insert(Library.ContextMenus, Table)
	    return Table
	end

	Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
	    if Library.Unloaded then
	        return
	    end

	    if IsClickInput(Input, true) then
	        local Location = Input.Position

	        CloseMenus(nil, function(Menu)
	            return not (Library:MouseIsOverFrame(Menu.Menu, Location) or Library:MouseIsOverFrame(Menu.Holder, Location))
	        end)
	    end
	end))

	--// Tooltip \\--
	local TooltipLabel = New("TextLabel", {
	    BackgroundColor3 = "BackgroundColor",
	    TextSize = 14,
	    TextWrapped = true,
	    Visible = false,
	    ZIndex = 30,
	    Parent = ScreenGui,
	})
	New("UIPadding", {
	    PaddingBottom = UDim.new(0, 2),
	    PaddingLeft = UDim.new(0, 4),
	    PaddingRight = UDim.new(0, 4),
	    PaddingTop = UDim.new(0, 2),
	    Parent = TooltipLabel,
	})
	table.insert(
	    Library.Scales,
	    New("UIScale", {
	        Parent = TooltipLabel,
	    })
	)
	New("UIStroke", {
	    Color = "OutlineColor",
	    Parent = TooltipLabel,
	})
	table.insert(
	    Library.Corners,
	    New("UICorner", {
	        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	        Parent = TooltipLabel,
	    })
	)

	local TooltipMeasureId = 0
	local LastTooltipText = ""
	local LastTooltipMaxWidth = 0

	local function UpdateTooltipSize(Force: boolean?)
	    if Library.Unloaded or not TooltipLabel.Visible then
	        return
	    end

	    local MaxWidth = math.max(
	        40,
	        (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
	    )

	    if
	        not Force
	        and TooltipLabel.Text == LastTooltipText
	        and math.abs(MaxWidth - LastTooltipMaxWidth) < 1
	        and TooltipLabel.Size.X.Offset > 0
	    then
	        return
	    end

	    TooltipMeasureId += 1
	    local MeasureId = TooltipMeasureId
	    local Text = TooltipLabel.Text

	    local X, Y = Library:GetTextBounds(Text, TooltipLabel.FontFace, TooltipLabel.TextSize, MaxWidth)
	    if MeasureId ~= TooltipMeasureId or TooltipLabel.Text ~= Text then
	        return
	    end

	    LastTooltipText = Text
	    LastTooltipMaxWidth = MaxWidth
	    TooltipLabel.Size = UDim2.fromOffset(X + 8, Y + 4)
	end

	TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	    UpdateTooltipSize(false)
	end)

	local CurrentHoverInstance
	function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
	    local TooltipTable = {
	        Disabled = false,
	        Hovering = false,
	        Signals = {},
	    }

	    local function DoHover()
	        if
	            CurrentHoverInstance == HoverInstance
	            or Library.ActiveDialog
	            or (CurrentMenu and not HoverInstance:IsDescendantOf(CurrentMenu.Menu) and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
	            or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
	            or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
	        then
	            return
	        end
	        CurrentHoverInstance = HoverInstance

	        local HolderGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
	        if HolderGui and HolderGui ~= ScreenGui and Library.ActiveLoading and HolderGui == Library.ActiveLoading.ScreenGui then
	            TooltipLabel.Parent = HolderGui
	        else
	            TooltipLabel.Parent = ScreenGui
	        end

	        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
	        TooltipLabel.Position = UDim2.fromOffset(
	            Mouse.X + (Library.ShowCustomCursor and 8 or 14),
	            Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
	        )
	        TooltipLabel.Visible = true
	        UpdateTooltipSize(true)

	        while
	            (Library.Toggled or Library.ActiveLoading)
	            and not Library.ActiveDialog
	            and Library:MouseIsOverFrame(HoverInstance, Mouse)
	            and not (CurrentMenu and not HoverInstance:IsDescendantOf(CurrentMenu.Menu) and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
	        do
	            TooltipLabel.Position = UDim2.fromOffset(
	                Mouse.X + (Library.ShowCustomCursor and 8 or 14),
	                Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
	            )

	            RunService.RenderStepped:Wait()
	        end

	        TooltipLabel.Visible = false
	        CurrentHoverInstance = nil
	    end

	    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
	        local ConnectionType = typeof(Connection)
	        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
	            table.insert(TooltipTable.Signals, Connection)
	        end

	        return Connection
	    end

	    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
	    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
	    GiveSignal(HoverInstance.MouseLeave:Connect(function()
	        if CurrentHoverInstance ~= HoverInstance then
	            return
	        end

	        TooltipLabel.Visible = false
	        CurrentHoverInstance = nil
	    end))

	    function TooltipTable:Destroy()
	        for Index = #TooltipTable.Signals, 1, -1 do
	            local Connection = table.remove(TooltipTable.Signals, Index)
	            if Connection and Connection.Connected then
	                Connection:Disconnect()
	            end
	        end

	        if CurrentHoverInstance == HoverInstance then
	            if TooltipLabel then
	                TooltipLabel.Visible = false
	            end

	            CurrentHoverInstance = nil
	        end
	    end

	    table.insert(Tooltips, TooltipLabel)
	    return TooltipTable
	end

	function Library:OnUnload(Callback)
	    table.insert(Library.UnloadSignals, Callback)
	end

	local BaseAddons, BaseGroupbox = {}, {}
	do
	    local Funcs = {}

	    function Funcs:AddKeyPicker(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.KeyPicker)

	        local ParentObj = self
	        local ToggleLabel = ParentObj.TextLabel

	        if ParentObj.Type == "Button" or ParentObj.Type == "SubButton" then
	            assert(Info.Mode == "Press", "KeyPicker on Buttons can only be applied with the 'Press' mode.")

	            ToggleLabel = ParentObj.Base
	        end

	        local KeyPicker = {
	            Connections = {},

	            Text = Info.Text,
	            Value = Info.Default, -- Key
	            Modifiers = Info.DefaultModifiers, -- Modifiers
	            DisplayValue = Info.Default, -- Picker Text

	            Blacklisted = Info.Blacklisted,
	            BlacklistedModifiers = Info.BlacklistedModifiers,
	            Whitelisted = Info.Whitelisted,
	            WhitelistedModifiers = Info.WhitelistedModifiers,

	            Toggled = false,
	            Mode = Info.Mode,
	            SyncToggleState = Info.SyncToggleState,

	            NoUI = Info.NoUI == true,
	            MenuVisible = Info.NoUI ~= true,

	            Callback = Info.Callback,
	            ChangedCallback = Info.ChangedCallback,
	            Changed = Info.Changed,
	            Clicked = Info.Clicked,

	            Type = "KeyPicker",
	            Idx = Idx,
	        }

	        if KeyPicker.Mode == "Press" then
	            assert(ParentObj.Type == "Label" or ParentObj.Type == "Button" or ParentObj.Type == "SubButton", "KeyPicker with the mode 'Press' can be only applied on Labels and Buttons.")

	            KeyPicker.SyncToggleState = false
	            Info.Modes = { "Press" }
	            Info.Mode = "Press"
	        end

	        if KeyPicker.SyncToggleState then
	            Info.Modes = { "Toggle", "Hold" }

	            if not table.find(Info.Modes, Info.Mode) then
	                Info.Mode = "Toggle"
	            end
	        end

	        local Picking = false
	        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"

	        -- Special Keys
	        local SpecialKeys = {
	            ["MB1"] = Enum.UserInputType.MouseButton1,
	            ["MB2"] = Enum.UserInputType.MouseButton2,
	            ["MB3"] = Enum.UserInputType.MouseButton3,
	        }

	        local SpecialKeysInput = {
	            [Enum.UserInputType.MouseButton1] = "MB1",
	            [Enum.UserInputType.MouseButton2] = "MB2",
	            [Enum.UserInputType.MouseButton3] = "MB3",
	        }

	        -- Modifiers
	        local Modifiers = {
	            ["LAlt"] = Enum.KeyCode.LeftAlt,
	            ["RAlt"] = Enum.KeyCode.RightAlt,

	            ["LCtrl"] = Enum.KeyCode.LeftControl,
	            ["RCtrl"] = Enum.KeyCode.RightControl,

	            ["LShift"] = Enum.KeyCode.LeftShift,
	            ["RShift"] = Enum.KeyCode.RightShift,

	            ["Tab"] = Enum.KeyCode.Tab,
	            ["CapsLock"] = Enum.KeyCode.CapsLock,
	        }

	        local ModifiersInput = {
	            [Enum.KeyCode.LeftAlt] = "LAlt",
	            [Enum.KeyCode.RightAlt] = "RAlt",

	            [Enum.KeyCode.LeftControl] = "LCtrl",
	            [Enum.KeyCode.RightControl] = "RCtrl",

	            [Enum.KeyCode.LeftShift] = "LShift",
	            [Enum.KeyCode.RightShift] = "RShift",

	            [Enum.KeyCode.Tab] = "Tab",
	            [Enum.KeyCode.CapsLock] = "CapsLock",
	        }

	        local IsModifierInput = function(Input)
	            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
	        end

	        local GetActiveModifiers = function()
	            local ActiveModifiers = {}

	            for Name, Input in Modifiers do
	                if table.find(ActiveModifiers, Name) then
	                    continue
	                end
	                if not UserInputService:IsKeyDown(Input) then
	                    continue
	                end

	                table.insert(ActiveModifiers, Name)
	            end

	            return ActiveModifiers
	        end

	        local AreModifiersHeld = function(Required)
	            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
	                return true
	            end

	            local ActiveModifiers = GetActiveModifiers()
	            local Holding = true

	            for _, Name in Required do
	                if table.find(ActiveModifiers, Name) then
	                    continue
	                end

	                Holding = false
	                break
	            end

	            return Holding
	        end

	        local IsInputDown = function(Input)
	            if not Input then
	                return false
	            end

	            if SpecialKeysInput[Input.UserInputType] ~= nil then
	                return UserInputService:IsMouseButtonPressed(Input.UserInputType)
	                    and not UserInputService:GetFocusedTextBox()
	            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
	                return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
	            else
	                return false
	            end
	        end

	        local ConvertToInputModifiers = function(CurrentModifiers)
	            local InputModifiers = {}

	            for _, name in CurrentModifiers do
	                table.insert(InputModifiers, Modifiers[name])
	            end

	            return InputModifiers
	        end

	        local VerifyModifiers = function(CurrentModifiers)
	            if typeof(CurrentModifiers) ~= "table" then
	                return {}
	            end

	            local ValidModifiers = {}

	            for _, name in CurrentModifiers do
	                if not Modifiers[name] then
	                    continue
	                end

	                table.insert(ValidModifiers, name)
	            end

	            return ValidModifiers
	        end

	        KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

	        local SlideOverflow = true
	        local LastDisplayText = nil
	        local MaxPickerWidth = 85
	        local SlidingLabel

	        local SlideForwardTween
	        local SlideBackTween
	        local HandleForwardTween = function(State)
	            if State ~= Enum.PlaybackState.Completed then
	                return
	            end

	            task.wait(1.5)
	            if SlideBackTween then
	                SlideBackTween:Play()
	            end
	        end

	        local HandleBackTween = function(State)
	            if State ~= Enum.PlaybackState.Completed then
	                return
	            end

	            task.wait(1.5)
	            if SlideForwardTween then
	                SlideForwardTween:Play()
	            end
	        end

	        local SlideForwardConn, SlideBackConn
	        local CancelSlidingTweens = function()
	            if SlideForwardConn then
	                SlideForwardConn:Disconnect()
	                SlideForwardConn = nil
	            end

	            if SlideBackConn then
	                SlideBackConn:Disconnect()
	                SlideBackConn = nil
	            end

	            if SlideForwardTween then
	                StopTween(SlideForwardTween, true)
	                SlideForwardTween = nil
	            end

	            if SlideBackTween then
	                StopTween(SlideBackTween, true)
	                SlideBackTween = nil
	            end

	            RunService.RenderStepped:Wait()
	        end

	        local Picker = New("TextButton", {
	            BackgroundColor3 = "MainColor",
	            Size = UDim2.fromOffset(21, 21),
	            Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
	            TextSize = 14,
	            TextTransparency = 0.4,
	            Parent = ToggleLabel,
	        })

	        if IsForButton and SlideOverflow then
	            Picker.ClipsDescendants = true

	            SlidingLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 1, 0),
	                Position = UDim2.new(0, 0, 0, 0),
	                Text = KeyPicker.Value,
	                TextSize = 14,
	                TextXAlignment = Enum.TextXAlignment.Center,
	                Parent = Picker,
	            })
	        end

	        New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Picker,
	        })

	        local PickerCorner = New("UICorner", {
	            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            Parent = Picker,
	        }); table.insert(Library.SpecificCorners, PickerCorner)

	        local PickerHoverTween = nil

	        local function ApplyPickerTextTransparency(Transparency: number)
	            StopTween(PickerHoverTween)
	            PickerHoverTween = nil

	            Picker.TextTransparency = Transparency
	            if SlidingLabel then
	                SlidingLabel.TextTransparency = Transparency
	            end
	        end

	        local function TweenPickerTextTransparency(Transparency: number)
	            StopTween(PickerHoverTween)

	            PickerHoverTween = TweenService:Create(Picker, Library.TweenInfo, {
	                TextTransparency = Transparency,
	            })
	            PickerHoverTween:Play()

	            if SlidingLabel then
	                TweenService:Create(SlidingLabel, Library.TweenInfo, {
	                    TextTransparency = Transparency,
	                }):Play()
	            end
	        end

	        table.insert(KeyPicker.Connections, Picker.MouseEnter:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            TweenPickerTextTransparency(0)
	        end))

	        table.insert(KeyPicker.Connections, Picker.MouseLeave:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            TweenPickerTextTransparency(0.4)
	        end))

	        if IsForButton then
	            local Holder = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 21),
	                Parent = ToggleLabel.Parent,
	            })

	            New("UIListLayout", {
	                FillDirection = Enum.FillDirection.Horizontal,
	                Padding = UDim.new(0, 6),
	                Parent = Holder,
	            })

	            New("UIFlexItem", {
	                FlexMode = Enum.UIFlexMode.Fill,
	                Parent = ToggleLabel,
	            })

	            ToggleLabel.Parent = Holder
	            Picker.Parent = Holder

	            Picker.Size = UDim2.new(0, 18, 1, 0)
	        end

	        local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
	        do
	            local Holder = New("TextButton", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 16),
	                Text = "",
	                Visible = not Info.NoUI,
	                Parent = Library.KeybindContainer,
	            })
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Holder,
	                })
	            )
	            local ButtonStroke = New("UIStroke", {
	                Color = "OutlineColor",
	                Enabled = false,
	                Parent = Holder,
	            })
	            local ButtonPadding = New("UIPadding", {
	                Parent = Holder,
	            })

	            local Label = New("TextLabel", {
	                AutomaticSize = Enum.AutomaticSize.X,
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(0, 1),
	                Text = "",
	                TextSize = 14,
	                TextTransparency = 0.5,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Parent = Holder,
	            })

	            local Checkbox = New("Frame", {
	                AnchorPoint = Vector2.new(0, 0.5),
	                BackgroundColor3 = "MainColor",
	                Position = UDim2.fromScale(0, 0.5),
	                Size = UDim2.fromOffset(14, 14),
	                SizeConstraint = Enum.SizeConstraint.RelativeYY,
	                Parent = Holder,
	            })
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Checkbox,
	                })
	            )
	            New("UIStroke", {
	                Color = "OutlineColor",
	                Parent = Checkbox,
	            })

	            local CheckImage = Library:CreateIcon(CheckIcon, {
	                ImageColor3 = "FontColor",
	                ImageTransparency = 1,
	                Position = UDim2.fromOffset(2, 2),
	                Size = UDim2.new(1, -4, 1, -4),
	                Parent = Checkbox,
	            })

	            function KeybindsToggle:Display(State)
	                if KeyPicker.Mode == "Press" then
	                    Label.TextTransparency = 0.4
	                    SetIconProperties(CheckImage, { ImageTransparency = 1 })
	                    return
	                end

	                Label.TextTransparency = State and 0 or 0.5
	                SetIconProperties(CheckImage, { ImageTransparency = State and 0 or 1 })
	            end

	            function KeybindsToggle:SetText(Text)
	                Label.Text = Text
	            end

	            function KeybindsToggle:SetVisibility(Visibility)
	                Holder.Visible = Visibility
	            end

	            function KeybindsToggle:SetNormal(Normal)
	                KeybindsToggle.Normal = Normal

	                local IsPress = KeyPicker.Mode == "Press"
	                Holder.Active = not Normal or IsPress
	                Checkbox.Visible = not Normal
	                ButtonStroke.Enabled = IsPress
	                Holder.BackgroundTransparency = IsPress and 0 or 1
	                Holder.AutomaticSize = IsPress and Enum.AutomaticSize.X or Enum.AutomaticSize.None
	                Holder.Size = IsPress and UDim2.fromOffset(0, 20) or UDim2.new(1, 0, 0, 16)
	                ButtonPadding.PaddingLeft = UDim.new(0, IsPress and 8 or 0)
	                ButtonPadding.PaddingRight = UDim.new(0, IsPress and 8 or 0)

	                Label.AutomaticSize = Enum.AutomaticSize.X
	                Label.Size = UDim2.fromScale(0, 1)
	                Label.TextXAlignment = Enum.TextXAlignment.Left
	                Label.Position = (not IsPress and not Normal) and UDim2.fromOffset(22, 0) or UDim2.fromOffset(0, 0)
	            end

	            KeyPicker.DoClick = function(...) end --// make luau lsp shut up
	            table.insert(KeyPicker.Connections, Holder.MouseButton1Click:Connect(function()
	                if KeyPicker.Mode == "Press" then
	                    KeyPicker:DoClick()
	                    return
	                end

	                if KeybindsToggle.Normal then
	                    return
	                end

	                KeyPicker.Toggled = not KeyPicker.Toggled
	                KeyPicker:DoClick()
	                KeyPicker:Update()
	            end))
	            table.insert(KeyPicker.Connections, Holder.MouseEnter:Connect(function()
	                if KeyPicker.Mode == "Press" and not ParentObj.Disabled then
	                    Label.TextTransparency = 0
	                end
	            end))
	            table.insert(KeyPicker.Connections, Holder.MouseLeave:Connect(function()
	                if KeyPicker.Mode == "Press" then
	                    Label.TextTransparency = 0.4
	                end
	            end))

	            KeybindsToggle.Holder = Holder
	            KeybindsToggle.Label = Label
	            KeybindsToggle.Checkbox = Checkbox
	            KeybindsToggle.Loaded = true
	            table.insert(Library.KeybindToggles, KeybindsToggle)
	        end

	        local ModeButtons = {}
	        local ModeCorners = {}
	        local TotalModeButtons = GetTableSize(Info.Modes) + 1
	        local MenuCornersOnly = if TotalModeButtons == 1 then "no_left" else "no_top_left"

	        local MenuTable
	        MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
	            return { Picker.AbsoluteSize.X + 1.5, 0.5 }
	        end, 1, function(Active: boolean)
	            local Half = UDim.new(0, Library.CornerRadius / 2)
	            local Zero = UDim.new(0, 0)

	            PickerCorner.TopLeftRadius = Half
	            PickerCorner.BottomLeftRadius = Half
	            PickerCorner.TopRightRadius = Active and Zero or Half
	            PickerCorner.BottomRightRadius = Active and Zero or Half

	            local MenuCorner = MenuTable and MenuTable.Corner
	            if MenuCorner then
	                if MenuCornersOnly == "no_left" then
	                    MenuCorner.TopLeftRadius = Zero
	                    MenuCorner.BottomLeftRadius = Zero
	                    MenuCorner.TopRightRadius = Half
	                    MenuCorner.BottomRightRadius = Half
	                else
	                    MenuCorner.TopLeftRadius = Zero
	                    MenuCorner.TopRightRadius = Half
	                    MenuCorner.BottomRightRadius = Half
	                    MenuCorner.BottomLeftRadius = Half
	                end
	            end

	            for _, Entry in ModeCorners do
	                local Corner = Entry.Corner
	                if Entry.Style == "single" then
	                    Corner.TopLeftRadius = Zero
	                    Corner.BottomLeftRadius = Zero
	                    Corner.TopRightRadius = Half
	                    Corner.BottomRightRadius = Half
	                elseif Entry.Style == "first" then
	                    Corner.TopLeftRadius = Zero
	                    Corner.TopRightRadius = Half
	                    Corner.BottomLeftRadius = Zero
	                    Corner.BottomRightRadius = Zero
	                elseif Entry.Style == "last" then
	                    Corner.TopLeftRadius = Zero
	                    Corner.TopRightRadius = Zero
	                    Corner.BottomLeftRadius = Half
	                    Corner.BottomRightRadius = Half
	                end
	            end
	        end, false, MenuCornersOnly, "KeyPicker")
	        KeyPicker.Menu = MenuTable

	        for Index, Mode in Info.Modes do
	            local ModeButton = {}

	            local Button = New("TextButton", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)),
	                Text = Mode,
	                TextSize = 14,
	                TextTransparency = 0.5,
	                Parent = MenuTable.Menu,
	            })

	            if Index == 1 and TotalModeButtons == 1 then
	                local Corner = New("UICorner", {
	                    TopLeftRadius = UDim.new(0, 0),
	                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                    BottomLeftRadius = UDim.new(0, 0),
	                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Button,
	                })
	                table.insert(Library.SpecificCorners, Corner)
	                table.insert(ModeCorners, { Corner = Corner, Style = "single" })
	            elseif Index == 1 then
	                local Corner = New("UICorner", {
	                    TopLeftRadius = UDim.new(0, 0),
	                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                    BottomLeftRadius = UDim.new(0, 0),
	                    BottomRightRadius = UDim.new(0, 0),
	                    Parent = Button,
	                })
	                table.insert(Library.SpecificCorners, Corner)
	                table.insert(ModeCorners, { Corner = Corner, Style = "first" })
	            elseif Index == TotalModeButtons then
	                local Corner = New("UICorner", {
	                    TopLeftRadius = UDim.new(0, 0),
	                    TopRightRadius = UDim.new(0, 0),
	                    BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Button,
	                })
	                table.insert(Library.SpecificCorners, Corner)
	                table.insert(ModeCorners, { Corner = Corner, Style = "last" })
	            end

	            function ModeButton:Select()
	                for _, Button in ModeButtons do
	                    Button:Deselect()
	                end

	                KeyPicker.Mode = Mode

	                Button.BackgroundTransparency = 0
	                Button.TextTransparency = 0

	                MenuTable:Close()
	                if KeyPicker.Update then
	                    KeyPicker:Update()
	                end
	            end

	            function ModeButton:Deselect()
	                KeyPicker.Mode = nil

	                Button.BackgroundTransparency = 1
	                Button.TextTransparency = 0.5
	            end

	            table.insert(KeyPicker.Connections, Button.MouseButton1Click:Connect(function()
	                ModeButton:Select()
	            end))

	            table.insert(KeyPicker.Connections, Button.MouseEnter:Connect(function()
	                if KeyPicker.Mode == Mode then
	                    return
	                end

	                TweenService:Create(Button, Library.TweenInfo, {
	                    BackgroundTransparency = 0.7,
	                    TextTransparency = 0.1,
	                }):Play()
	            end))

	            table.insert(KeyPicker.Connections, Button.MouseLeave:Connect(function()
	                if KeyPicker.Mode == Mode then
	                    return
	                end

	                TweenService:Create(Button, Library.TweenInfo, {
	                    BackgroundTransparency = 1,
	                    TextTransparency = 0.5,
	                }):Play()
	            end))

	            if KeyPicker.Mode == Mode then
	                ModeButton:Select()
	            end

	            ModeButtons[Mode] = ModeButton
	        end

	        do
	            local RemoveButton = New("TextButton", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                LayoutOrder = TotalModeButtons,
	                Size = UDim2.new(1, 0, 0, IsForButton and 21 or 19),
	                Text = "Remove",
	                TextSize = 14,
	                TextTransparency = 0.5,
	                Parent = MenuTable.Menu,
	            })

	            local Corner = New("UICorner", {
	                TopLeftRadius = UDim.new(0, 0),
	                TopRightRadius = UDim.new(0, 0),
	                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = RemoveButton,
	            })
	            table.insert(Library.SpecificCorners, Corner)
	            table.insert(ModeCorners, { Corner = Corner, Style = "last" })

	            table.insert(KeyPicker.Connections, RemoveButton.MouseButton1Click:Connect(function()
	                MenuTable:Close()
	                KeyPicker:SetValue({ "None", KeyPicker.Mode, {} })
	            end))

	            table.insert(KeyPicker.Connections, RemoveButton.MouseEnter:Connect(function()
	                TweenService:Create(RemoveButton, Library.TweenInfo, {
	                    BackgroundTransparency = 0.7,
	                    TextTransparency = 0.1,
	                }):Play()
	            end))

	            table.insert(KeyPicker.Connections, RemoveButton.MouseLeave:Connect(function()
	                TweenService:Create(RemoveButton, Library.TweenInfo, {
	                    BackgroundTransparency = 1,
	                    TextTransparency = 0.5,
	                }):Play()
	            end))
	        end

	        local SetPickingState = function(State, SkipUpdate: boolean?)
	            Picking = State
	            Library.IsPicking = State

	            if ParentObj then
	                ParentObj.AnyKeyPickerPicking = Picking
	            end

	            if IsForButton then
	                ToggleLabel.Visible = not Picking
	                LastDisplayText = nil
	                RunService.RenderStepped:Wait()
	            end

	            if SkipUpdate ~= true then
	                (KeyPicker :: any):Update()
	            end
	        end

	        function KeyPicker:Display(PickerText)
	            if Library.Unloaded then
	                return
	            end

	            local DisplayText = PickerText or KeyPicker.DisplayValue
	            if IsForButton and SlideOverflow then
	                local X, _Y = Library:GetTextBounds(
	                    DisplayText,
	                    Picker.FontFace,
	                    Picker.TextSize,
	                    10000
	                )

	                local OffsetScale = X + 9
	                local TextChanged = LastDisplayText ~= DisplayText
	                local LabelWidth

	                SlidingLabel.Text = DisplayText
	                LastDisplayText = DisplayText

	                if Picking then
	                    Picker.Size = UDim2.new(1, 0, 1, 0)
	                    RunService.RenderStepped:Wait()
	                    LabelWidth = Picker.AbsoluteSize.X

	                    if LabelWidth <= 0 then
	                        LabelWidth = MaxPickerWidth
	                    end
	                else
	                    LabelWidth = math.min(OffsetScale, MaxPickerWidth)
	                    Picker.Size = UDim2.new(0, LabelWidth, 1, 0)
	                end

	                if OffsetScale > LabelWidth then
	                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
	                    SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)

	                    local OverflowDistance = OffsetScale - LabelWidth - 4.5
	                    if OverflowDistance > 0 then
	                        if TextChanged or not SlideForwardTween then
	                            SlidingLabel.Position = UDim2.fromOffset(4.5, 0)
	                            CancelSlidingTweens()

	                            local Duration = math.max(OverflowDistance / 25, 0.35)
	                            local TweenInfo = TweenInfo.new(
	                                Duration,
	                                Enum.EasingStyle.Linear,
	                                Enum.EasingDirection.InOut
	                            )

	                            SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
	                                Position = UDim2.fromOffset(-OverflowDistance, 0),
	                            })

	                            SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
	                                Position = UDim2.fromOffset(4.5, 0),
	                            })

	                            SlideForwardTween:Play()

	                            if SlideForwardConn then
	                                SlideForwardConn:Disconnect()
	                            end

	                            if SlideBackConn then
	                                SlideBackConn:Disconnect()
	                            end

	                            SlideForwardConn = SlideForwardTween.Completed:Connect(HandleForwardTween)
	                            SlideBackConn = SlideBackTween.Completed:Connect(HandleBackTween)
	                        end
	                    else
	                        CancelSlidingTweens()

	                        SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
	                        SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
	                        SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
	                    end
	                else
	                    CancelSlidingTweens()

	                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
	                    SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
	                    SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
	                end
	            else
	                local X, Y = Library:GetTextBounds(
	                    DisplayText,
	                    Picker.FontFace,
	                    Picker.TextSize,
	                    ToggleLabel.AbsoluteSize.X / Library.DPIScale
	                )
	                Picker.Text = DisplayText
	                Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0) or UDim2.fromOffset(X + 9, 21)
	            end
	        end

	        function KeyPicker:Update()
	            local Disabled = ParentObj.Disabled == true

	            if Disabled and Picking then
	                SetPickingState(false, true)
	            end

	            KeyPicker:Display()

	            Picker.Active = not Disabled
	            ApplyPickerTextTransparency(Disabled and 0.8 or 0.4)

	            if Disabled then
	                if MenuTable.Active then
	                    MenuTable:Close()
	                end
	            end

	            if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
	                KeybindsToggle:SetVisibility(false)
	                return
	            end

	            local State = KeyPicker:GetState()
	            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

	            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
	                ParentObj:SetValue(State)
	                State = KeyPicker:GetState()
	            end

	            if Info.NoUI then
	                return
	            end

	            if KeybindsToggle.Loaded then
	                if ShowToggle then
	                    KeybindsToggle:SetNormal(false)
	                else
	                    KeybindsToggle:SetNormal(true)
	                end

	                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
	                KeybindsToggle:SetVisibility(KeyPicker.MenuVisible ~= false)
	                KeybindsToggle:Display(State)
	            end
	        end

	        function KeyPicker:GetState()
	            if KeyPicker.Mode == "Always" then
	                return true
	            elseif KeyPicker.Mode == "Hold" then
	                local Key = KeyPicker.Value
	                if Key == "None" then
	                    return false
	                end

	                if not AreModifiersHeld(KeyPicker.Modifiers) then
	                    return false
	                end

	                if Picking then
	                    return false
	                end

	                if SpecialKeys[Key] ~= nil then
	                    if Library.Toggled then
	                        return false
	                    end

	                    return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
	                        and not UserInputService:GetFocusedTextBox()
	                else
	                    return UserInputService:IsKeyDown(Enum.KeyCode[Key] :: any) and not UserInputService:GetFocusedTextBox()
	                end
	            else
	                return KeyPicker.Toggled
	            end
	        end

	        function KeyPicker:OnChanged(Func)
	            KeyPicker.Changed = Func
	        end

	        function KeyPicker:OnClick(Func)
	            KeyPicker.Clicked = Func
	        end

	        function KeyPicker:DoClick()
	            if Picking or ParentObj.Disabled then
	                return
	            end

	            if KeyPicker.Mode == "Press" then
	                if KeyPicker.Toggled and Info.WaitForCallback == true then
	                    return
	                end

	                KeyPicker.Toggled = true
	            end

	            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
	            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

	            if IsForButton then
	                Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
	            end

	            if Library.ToggleKeybind == KeyPicker and Library.Toggle then
	                Library:Toggle()
	            end

	            if KeyPicker.Mode == "Press" then
	                KeyPicker.Toggled = false
	            end
	        end

	        function KeyPicker:RunChanged(IsKeyValid, KeyCode)
	            if ParentObj.Disabled then
	                return
	            end

	            if IsKeyValid == nil or KeyCode == nil then
	                IsKeyValid, KeyCode = pcall(function()
	                    if KeyPicker.Value == "None" then
	                        return nil
	                    end

	                    if SpecialKeys[KeyPicker.Value] == nil then
	                        return Enum.KeyCode[KeyPicker.Value]
	                    end

	                    return SpecialKeys[KeyPicker.Value]
	                end)
	            end

	            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
	            Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
	            Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
	        end

	        function KeyPicker:SetValue(Data)
	            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

	            local IsKeyValid, KeyCode = pcall(function()
	                if Key == "None" then
	                    Key = nil
	                    return nil
	                end

	                if SpecialKeys[Key] == nil then
	                    return Enum.KeyCode[Key]
	                end

	                return SpecialKeys[Key]
	            end)

	            if Key == nil then
	                KeyPicker.Value = "None"
	            elseif IsKeyValid then
	                KeyPicker.Value = Key
	            else
	                KeyPicker.Value = "Unknown"
	            end

	            KeyPicker.Modifiers =
	                VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
	            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
	                then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
	                else KeyPicker.Value

	            if ModeButtons[Mode] then
	                ModeButtons[Mode]:Select()
	            end

	            KeyPicker:Update()
	            KeyPicker:RunChanged(IsKeyValid, KeyCode)
	        end

	        function KeyPicker:SetText(Text)
	            KeyPicker.Text = Text
	            KeybindsToggle:SetText(Text)
	            KeyPicker:Update()

	            local KeybindMenu = Library.KeybindMenu
	            if KeybindMenu and KeybindMenu.SettingsOpen then
	                KeybindMenu:RefreshSettings()
	            end
	        end

	        function KeyPicker:SetMenuVisibility(Visible: boolean)
	            assert(typeof(Visible) == "boolean", "Visible must be a boolean")

	            KeyPicker.MenuVisible = Visible
	            KeyPicker:Update()

	            local KeybindMenu = Library.KeybindMenu
	            if KeybindMenu and KeybindMenu.SettingsOpen then
	                KeybindMenu:RefreshSettings()
	            end
	        end

	        table.insert(KeyPicker.Connections, Picker.MouseButton1Click:Connect(function()
	            if Picking or Library.IsPicking or ParentObj.Disabled then
	                return
	            end

	            SetPickingState(true)

	            if IsForButton and SlideOverflow then
	                KeyPicker:Display("...")
	            else
	                Picker.Text = "..."
	                Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 21)
	            end

	            -- Wait for any input --
	            local ActiveModifiers = {}
	            local CurrentInput = nil

	            local IsValidInput = function(InputObj)
	                if InputObj.KeyCode == Enum.KeyCode.Escape then
	                    return true
	                end

	                local IsMod = IsModifierInput(InputObj)
	                local KeyName
	                if SpecialKeysInput[InputObj.UserInputType] ~= nil then
	                    KeyName = SpecialKeysInput[InputObj.UserInputType]
	                elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
	                    if IsMod then
	                        KeyName = ModifiersInput[InputObj.KeyCode]
	                    else
	                        KeyName = InputObj.KeyCode.Name
	                    end
	                end

	                if KeyName then
	                    if IsMod then
	                        if KeyPicker.WhitelistedModifiers and #KeyPicker.WhitelistedModifiers > 0 and not table.find(KeyPicker.WhitelistedModifiers, KeyName) then
	                            return false
	                        end

	                        if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
	                            return false
	                        end
	                    else
	                        if KeyPicker.Whitelisted and #KeyPicker.Whitelisted > 0 and not table.find(KeyPicker.Whitelisted, KeyName) then
	                            return false
	                        end

	                        if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
	                            return false
	                        end
	                    end
	                end

	                return true
	            end

	            -- Wait for the first valid InputBegan --
	            while true do
	                local InputObj = UserInputService.InputBegan:Wait()
	                if UserInputService:GetFocusedTextBox() ~= nil then
	                    SetPickingState(false)
	                    return
	                end

	                if IsValidInput(InputObj) then
	                    CurrentInput = InputObj
	                    break
	                end
	            end

	            -- If it's a modifier key, we wait for either its release or another input --
	            while IsModifierInput(CurrentInput) do
	                if CurrentInput.KeyCode == Enum.KeyCode.Escape then
	                    break
	                end

	                -- Display the current state including the current modifier key --
	                local ModName = ModifiersInput[CurrentInput.KeyCode]
	                if ModName then
	                    local text = if #ActiveModifiers > 0 then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..." else ModName .. " + ..."
	                    KeyPicker:Display(text)
	                end

	                local NextInput = nil
	                local Released = false

	                local BeganConn
	                local EndedConn

	                BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
	                    if UserInputService:GetFocusedTextBox() ~= nil then
	                        return
	                    end
	                    if IsValidInput(InputObj) then
	                        NextInput = InputObj
	                    end
	                end)

	                EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
	                    if InputObj.KeyCode == CurrentInput.KeyCode then
	                        Released = true
	                    end
	                end)

	                repeat
	                    task.wait()
	                until Released or NextInput or UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded

	                if BeganConn then BeganConn:Disconnect() end
	                if EndedConn then EndedConn:Disconnect() end

	                if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded then
	                    SetPickingState(false)
	                    return
	                end

	                if Released then
	                    break -- Use modifier key as bind
	                elseif NextInput then
	                    -- Add another modifier or continue to normal key
	                    local OldModName = ModifiersInput[CurrentInput.KeyCode]
	                    if OldModName and not table.find(ActiveModifiers, OldModName) then
	                        ActiveModifiers[#ActiveModifiers + 1] = OldModName
	                    end

	                    CurrentInput = NextInput
	                    if CurrentInput.KeyCode == Enum.KeyCode.Escape then
	                        break
	                    end
	                end
	            end

	            local Key = "Unknown"
	            if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
	                Key = SpecialKeysInput[CurrentInput.UserInputType]
	            elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
	                Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None" or CurrentInput.KeyCode.Name
	            end

	            ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

	            KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
	            KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

	            repeat
	                task.wait()
	            until not IsInputDown(CurrentInput) or UserInputService:GetFocusedTextBox()

	            SetPickingState(false)
	        end))

	        table.insert(KeyPicker.Connections, Picker.MouseButton2Click:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            MenuTable:Toggle()
	        end))

	        table.insert(KeyPicker.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject)
	            if Library.Unloaded then
	                return
	            end

	            local IsMouse = IsMouseClickInput(Input)
	            if
	                ParentObj.Disabled
	                or KeyPicker.Mode == "Always"
	                or KeyPicker.Value == "Unknown"
	                or KeyPicker.Value == "None"
	                or Picking
	                or Library.IsPicking
	                or UserInputService:GetFocusedTextBox()
	                or (IsMouse and Library.Toggled)
	            then
	                return
	            end

	            local Key = KeyPicker.Value
	            local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
	            local HoldingKey = false

	            if
	                Key
	                and HoldingModifiers == true
	                and (
	                    SpecialKeysInput[Input.UserInputType] == Key
	                    or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
	                )
	            then
	                HoldingKey = true
	            end

	            if HoldingKey then
	                if KeyPicker.Mode == "Toggle" then
	                    KeyPicker.Toggled = not KeyPicker.Toggled
	                    KeyPicker:DoClick()
	                elseif KeyPicker.Mode == "Press" then
	                    KeyPicker:DoClick()
	                elseif KeyPicker.Mode == "Hold" then
	                    InputChanged = Input.Changed:Connect(function()
	                        if KeyPicker:GetState() then
	                            return
	                        end

	                        KeyPicker:Update()
	                        if InputChanged and InputChanged.Connected then
	                            InputChanged:Disconnect()
	                            InputChanged = nil
	                        end
	                    end)
	                end

	                KeyPicker:Update()
	            end
	        end))

	        KeyPicker:Update()

	        if not ParentObj.Addons then
	            ParentObj.Addons = {}
	        end

	        table.insert(ParentObj.Addons, KeyPicker)

	        KeyPicker.Default = KeyPicker.Value
	        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

	        function KeyPicker:Destroy()
	            KeyPicker.Destroyed = true

	            if SlideForwardConn then
	                SlideForwardConn:Disconnect()
	                SlideForwardConn = nil
	            end

	            if SlideBackConn then
	                SlideBackConn:Disconnect()
	                SlideBackConn = nil
	            end

	            if KeyPicker.Connections then
	                for _, Connection in KeyPicker.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if KeybindsToggle and KeybindsToggle.Loaded then
	                if KeybindsToggle.Holder then
	                    KeybindsToggle.Holder:Destroy()
	                end
	                local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
	                if KTIdx then
	                    table.remove(Library.KeybindToggles, KTIdx)
	                end
	            end

	            if MenuTable then
	                MenuTable:Destroy()
	            end

	            if IsForButton and SlideOverflow then
	                if SlideForwardTween then
	                    SlideForwardTween:Destroy()
	                end

	                if SlideBackTween then
	                    SlideBackTween:Destroy()
	                end
	            end

	            if Picker then
	                Picker:Destroy()
	            end

	            if ParentObj and ParentObj.Addons then
	                local AddonIdx = table.find(ParentObj.Addons, KeyPicker)

	                if AddonIdx then
	                    table.remove(ParentObj.Addons, AddonIdx)
	                end
	            end

	            Options[Idx] = nil

	            local KeybindMenu = Library.KeybindMenu
	            if KeybindMenu and KeybindMenu.SettingsOpen then
	                KeybindMenu:RefreshSettings()
	            end
	        end

	        Options[Idx] = KeyPicker

	        local KeybindMenu = Library.KeybindMenu
	        if KeybindMenu and KeybindMenu.SettingsOpen then
	            KeybindMenu:RefreshSettings()
	        end

	        return self
	    end

	    local HueSequenceTable = {}
	    for Hue = 0, 1, 0.1 do
	        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
	    end
	    function Funcs:AddColorPicker(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.ColorPicker)

	        local ParentObj = self
	        local ToggleLabel = ParentObj.TextLabel

	        local ColorPicker = {
	            Connections = {},
	            Destroyed = false,

	            Value = Info.Default,

	            Transparency = Info.Transparency or 0,
	            Title = Info.Title,

	            Callback = Info.Callback,
	            Changed = Info.Changed,

	            Type = "ColorPicker",
	        }
	        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

	        local Holder = New("TextButton", {
	            BackgroundColor3 = ColorPicker.Value,
	            Size = UDim2.fromOffset(21, 21),
	            Text = "",
	            Parent = ToggleLabel,
	        })

	        local HolderStroke = New("UIStroke", {
	            Color = Library:GetDarkerColor(ColorPicker.Value),
	            Parent = Holder,
	        })

	        local ColorPickerCorner = New("UICorner", {
	            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            Parent = Holder,
	        }); table.insert(Library.SpecificCorners, ColorPickerCorner)

	        local HolderTransparency = New("ImageLabel", {
	            Image = CustomImageManager.GetAsset("TransparencyTexture"),
	            ImageTransparency = (1 - ColorPicker.Transparency),
	            ScaleType = Enum.ScaleType.Tile,
	            Position = UDim2.new(0, -1, 0, -1),
	            Size = UDim2.new(1, 2, 1, 2),
	            TileSize = UDim2.fromOffset(9, 9),
	            Parent = Holder,
	        })

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = HolderTransparency,
	            })
	        )

	        --// Color Menu \\--
	        local MapSize = Library.IsMobile and 140 or 200
	        local BarWidth = 16
	        local MenuWidth = MapSize + BarWidth + 6 + 12
	        if Info.Transparency then
	            MenuWidth += BarWidth + 6
	        end

	        local ColorMenu
	        local FooterCorner
	        ColorMenu = Library:AddContextMenu(
	            Holder,
	            UDim2.fromOffset(MenuWidth, 0),
	            function()
	                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
	            end,
	            1, function(Active: boolean)
	                local Half = UDim.new(0, Library.CornerRadius / 2)
	                local Zero = UDim.new(0, 0)

	                ColorPickerCorner.TopLeftRadius = Half
	                ColorPickerCorner.TopRightRadius = Half
	                ColorPickerCorner.BottomRightRadius = Active and Zero or Half
	                ColorPickerCorner.BottomLeftRadius = Active and Zero or Half

	                local MenuCorner = ColorMenu and ColorMenu.Corner
	                if MenuCorner then
	                    MenuCorner.TopLeftRadius = Zero
	                    MenuCorner.TopRightRadius = Half
	                    MenuCorner.BottomRightRadius = Half
	                    MenuCorner.BottomLeftRadius = Half
	                end

	                if FooterCorner then
	                    FooterCorner.TopLeftRadius = Zero
	                    FooterCorner.TopRightRadius = Zero
	                    FooterCorner.BottomLeftRadius = Half
	                    FooterCorner.BottomRightRadius = Half
	                end
	            end, false, "no_top_left")
	        ColorMenu.List.Padding = UDim.new(0, 0)
	        ColorPicker.ColorMenu = ColorMenu

	        --// Content Holder \\--
	        local ContentHolder = New("Frame", {
	            AutomaticSize = Enum.AutomaticSize.Y,
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            Parent = ColorMenu.Menu,
	        })
	        New("UIListLayout", {
	            Padding = UDim.new(0, 8),
	            Parent = ContentHolder,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 6),
	            PaddingLeft = UDim.new(0, 6),
	            PaddingRight = UDim.new(0, 6),
	            PaddingTop = UDim.new(0, 6),
	            Parent = ContentHolder,
	        })

	        --// Footer \\--
	        local FooterHeight = Library.IsMobile and 30 or 22

	        local FooterBackground = New("Frame", {
	            BackgroundColor3 = function()
	                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
	            end,
	            Size = UDim2.new(1, 0, 0, FooterHeight),
	            Parent = ColorMenu.Menu,
	        })
	        FooterCorner = New("UICorner", {
	            TopLeftRadius = UDim.new(0, 0),
	            TopRightRadius = UDim.new(0, 0),
	            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            Parent = FooterBackground,
	        })
	        table.insert(Library.SpecificCorners, FooterCorner)
	        Library:MakeLine(FooterBackground, {
	            Position = UDim2.fromScale(0, 0),
	            Size = UDim2.new(1, 0, 0, 1),
	        })

	        local FooterBar = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Parent = FooterBackground,
	        })
	        New("UIPadding", {
	            PaddingLeft = UDim.new(0, 6),
	            PaddingRight = UDim.new(0, Info.Resizable and (FooterHeight + 4) or 6),
	            Parent = FooterBar,
	        })

	        local FooterInfoLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Text = "",
	            TextSize = 14,
	            TextTransparency = 0.5,
	            TextTruncate = Enum.TextTruncate.AtEnd,
	            TextXAlignment = Enum.TextXAlignment.Center,
	            Parent = FooterBar,
	        })

	        local function RefreshFooterInfo()
	            FooterInfoLabel.Text = string.format(
	                "#%s • %d, %d, %d",
	                ColorPicker.Value:ToHex(),
	                math.floor(ColorPicker.Value.R * 255),
	                math.floor(ColorPicker.Value.G * 255),
	                math.floor(ColorPicker.Value.B * 255)
	            )
	        end
	        RefreshFooterInfo()

	        if typeof(ColorPicker.Title) == "string" then
	            New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 8),
	                Text = ColorPicker.Title,
	                TextSize = 14,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Parent = ContentHolder,
	            })
	        end

	        local ColorHolder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, MapSize),
	            Parent = ContentHolder,
	        })
	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            Padding = UDim.new(0, 6),
	            Parent = ColorHolder,
	        })

	        --// Sat Map
	        local SatVipMap = New("ImageButton", {
	            BackgroundColor3 = ColorPicker.Value,
	            Image = CustomImageManager.GetAsset("SaturationMap"),
	            Size = UDim2.fromOffset(MapSize, MapSize),
	            Parent = ColorHolder,
	        })

	        local SatVibCursor = New("Frame", {
	            AnchorPoint = Vector2.new(0.5, 0.5),
	            BackgroundColor3 = "WhiteColor",
	            Size = UDim2.fromOffset(6, 6),
	            Parent = SatVipMap,
	        })
	        New("UICorner", {
	            CornerRadius = UDim.new(1, 0),
	            Parent = SatVibCursor,
	        })
	        New("UIStroke", {
	            Color = "DarkColor",
	            Parent = SatVibCursor,
	        })

	        --// Hue
	        local HueSelector = New("TextButton", {
	            Size = UDim2.fromOffset(BarWidth, MapSize),
	            Text = "",
	            Parent = ColorHolder,
	        })
	        New("UIGradient", {
	            Color = ColorSequence.new(HueSequenceTable),
	            Rotation = 90,
	            Parent = HueSelector,
	        })

	        local HueCursor = New("Frame", {
	            AnchorPoint = Vector2.new(0.5, 0.5),
	            BackgroundColor3 = "WhiteColor",
	            BorderColor3 = "DarkColor",
	            BorderSizePixel = 1,
	            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
	            Size = UDim2.new(1, 2, 0, 1),
	            Parent = HueSelector,
	        })

	        --// Alpha
	        local TransparencySelector, TransparencyColor, TransparencyCursor
	        if Info.Transparency then
	            TransparencySelector = New("ImageButton", {
	                Image = CustomImageManager.GetAsset("TransparencyTexture"),
	                ScaleType = Enum.ScaleType.Tile,
	                Size = UDim2.fromOffset(BarWidth, MapSize),
	                TileSize = UDim2.fromOffset(8, 8),
	                Parent = ColorHolder,
	            })

	            TransparencyColor = New("Frame", {
	                BackgroundColor3 = ColorPicker.Value,
	                Size = UDim2.fromScale(1, 1),
	                Parent = TransparencySelector,
	            })
	            New("UIGradient", {
	                Rotation = 90,
	                Transparency = NumberSequence.new({
	                    NumberSequenceKeypoint.new(0, 0),
	                    NumberSequenceKeypoint.new(1, 1),
	                }),
	                Parent = TransparencyColor,
	            })

	            TransparencyCursor = New("Frame", {
	                AnchorPoint = Vector2.new(0.5, 0.5),
	                BackgroundColor3 = "WhiteColor",
	                BorderColor3 = "DarkColor",
	                BorderSizePixel = 1,
	                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
	                Size = UDim2.new(1, 2, 0, 1),
	                Parent = TransparencySelector,
	            })
	        end

	        --// Resizing \\--
	        local ResizeGrabber
	        if Info.Resizable then
	            local BaseMapSize = 200
	            local BaseBarWidth = BarWidth
	            local BasePadding = 6
	            local MinMapSize = 140

	            ColorPicker.MapWidth = MapSize
	            ColorPicker.MapHeight = MapSize

	            local function GetBarWidth(MapWidth)
	                return math.clamp(math.floor((MapWidth / BaseMapSize) * BaseBarWidth + 0.5), 12, 24)
	            end

	            local function GetContentWidth(MapWidth)
	                local CurrentBarWidth = GetBarWidth(MapWidth)
	                local Width = MapWidth + CurrentBarWidth + BasePadding
	                if Info.Transparency then
	                    Width += (CurrentBarWidth + BasePadding)
	                end

	                return Width + 12
	            end

	            local FixedVerticalOverhead = 6 + 6 + 8 + 20 + 8 + 20 + FooterHeight
	            if typeof(ColorPicker.Title) == "string" then
	                FixedVerticalOverhead += 8 + 8
	            end

	            local function ClampToViewport(NewWidth, NewHeight)
	                local Camera = workspace.CurrentCamera
	                if not Camera then
	                    return NewWidth, NewHeight
	                end

	                local ViewportSize = Camera.ViewportSize
	                local ScreenMargin = 12

	                local MaxWidth = ViewportSize.X - ColorMenu.Menu.AbsolutePosition.X - ScreenMargin
	                local MaxHeight = ViewportSize.Y - ColorMenu.Menu.AbsolutePosition.Y - ScreenMargin - FixedVerticalOverhead

	                while NewWidth > MinMapSize and GetContentWidth(NewWidth) > MaxWidth do
	                    NewWidth -= 4
	                end

	                if NewHeight > MaxHeight then
	                    NewHeight = math.max(MinMapSize, math.floor(MaxHeight))
	                end

	                return NewWidth, NewHeight
	            end

	            local function UpdateColorMenuSize(NewWidth, NewHeight)
	                NewWidth = math.max(MinMapSize, math.floor(NewWidth + 0.5))
	                NewHeight = math.max(MinMapSize, math.floor(NewHeight + 0.5))
	                NewWidth, NewHeight = ClampToViewport(NewWidth, NewHeight)

	                if NewWidth == ColorPicker.MapWidth and NewHeight == ColorPicker.MapHeight then
	                    return
	                end

	                local CurrentBarWidth = GetBarWidth(NewWidth)
	                local CursorSize = math.clamp(math.floor((math.min(NewWidth, NewHeight) / BaseMapSize) * 6 + 0.5), 4, 10)

	                ColorHolder.Size = UDim2.new(1, 0, 0, NewHeight)
	                SatVipMap.Size = UDim2.fromOffset(NewWidth, NewHeight)
	                SatVibCursor.Size = UDim2.fromOffset(CursorSize, CursorSize)
	                HueSelector.Size = UDim2.new(0, CurrentBarWidth, 0, NewHeight)

	                if TransparencySelector then
	                    TransparencySelector.Size = UDim2.new(0, CurrentBarWidth, 0, NewHeight)
	                end

	                ColorPicker.MapWidth = NewWidth
	                ColorPicker.MapHeight = NewHeight
	                ColorMenu:SetSize(UDim2.new(0, GetContentWidth(NewWidth), 0, 0))
	            end

	            ResizeGrabber = New("TextButton", {
	                AnchorPoint = Vector2.new(1, 0),
	                BackgroundTransparency = 1,
	                Position = UDim2.new(1, -Library.CornerRadius / 4, 0, 0),
	                Size = UDim2.fromScale(1, 1),
	                SizeConstraint = Enum.SizeConstraint.RelativeYY,
	                Text = "",
	                Parent = FooterBackground,
	            })
	            Library:CreateIcon(ResizeIcon, {
	                ImageColor3 = "FontColor",
	                ImageTransparency = 0.5,
	                Position = UDim2.fromOffset(2, 2),
	                Size = UDim2.new(1, -4, 1, -4),
	                Parent = ResizeGrabber,
	            })

	            table.insert(ColorPicker.Connections, ResizeGrabber.InputBegan:Connect(function(Input: InputObject)
	                Library.CantDragForced = true
	                local StartMouse = Vector2.new(Mouse.X, Mouse.Y)
	                local StartWidth = ColorPicker.MapWidth
	                local StartHeight = ColorPicker.MapHeight

	                while IsDragInput(Input) and not ColorPicker.Destroyed do
	                    local Delta = Vector2.new(Mouse.X, Mouse.Y) - StartMouse
	                    UpdateColorMenuSize(StartWidth + Delta.X, StartHeight + Delta.Y)

	                    RunService.RenderStepped:Wait()
	                end

	                Library.CantDragForced = false
	            end))
	        end

	        local InfoHolder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 20),
	            Parent = ContentHolder,
	        })
	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalFlex = Enum.UIFlexAlignment.Fill,
	            Padding = UDim.new(0, 8),
	            Parent = InfoHolder,
	        })

	        local HueBox = New("TextBox", {
	            BackgroundColor3 = "MainColor",
	            ClearTextOnFocus = false,
	            Size = UDim2.fromScale(1, 1),
	            Text = "#??????",
	            TextSize = 14,
	            Parent = InfoHolder,
	        })

	        local HueBoxStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = HueBox,
	        })

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = HueBox,
	            })
	        )

	        local RgbBox = New("TextBox", {
	            BackgroundColor3 = "MainColor",
	            ClearTextOnFocus = false,
	            Size = UDim2.fromScale(1, 1),
	            Text = "?, ?, ?",
	            TextSize = 14,
	            Parent = InfoHolder,
	        })

	        local RgbBoxStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = RgbBox,
	        })

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = RgbBox,
	            })
	        )

	        --// Context Menu \\--
	        local ContextMenu
	        ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
	            return { Holder.AbsoluteSize.X + 1.5, 0.5 }
	        end, 1, function(Active: boolean)
	            local Half = UDim.new(0, Library.CornerRadius / 2)
	            local Zero = UDim.new(0, 0)

	            ColorPickerCorner.TopLeftRadius = Half
	            ColorPickerCorner.BottomLeftRadius = Half
	            ColorPickerCorner.TopRightRadius = Active and Zero or Half
	            ColorPickerCorner.BottomRightRadius = Active and Zero or Half

	            local MenuCorner = ContextMenu and ContextMenu.Corner
	            if MenuCorner then
	                MenuCorner.TopLeftRadius = Zero
	                MenuCorner.TopRightRadius = Half
	                MenuCorner.BottomRightRadius = Half
	                MenuCorner.BottomLeftRadius = Half
	            end
	        end, false, "no_top_left")
	        ColorPicker.ContextMenu = ContextMenu
	        ContextMenu.List.Padding = UDim.new(0, 6)
	        do
	            local function CreateButton(Text, Func)
	                local Button = New("TextButton", {
	                    BackgroundColor3 = "MainColor",
	                    BackgroundTransparency = 1,
	                    Size = UDim2.new(1, 0, 0, 21),
	                    Text = Text,
	                    TextSize = 14,
	                    Parent = ContextMenu.Menu,
	                })

	                table.insert(ColorPicker.Connections, Button.MouseButton1Click:Connect(function()
	                    Library:SafeCallback(Func)
	                    ContextMenu:Close()
	                end))

	                table.insert(ColorPicker.Connections, Button.MouseEnter:Connect(function()
	                    TweenService:Create(Button, Library.TweenInfo, {
	                        BackgroundTransparency = 0.7,
	                    }):Play()
	                end))

	                table.insert(ColorPicker.Connections, Button.MouseLeave:Connect(function()
	                    TweenService:Create(Button, Library.TweenInfo, {
	                        BackgroundTransparency = 1,
	                    }):Play()
	                end))
	            end

	            CreateButton("Copy color", function()
	                Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
	            end)

	            ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
	            CreateButton("Paste color", function()
	                if not Library.CopiedColor then
	                    return
	                end

	                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
	            end)

	            if setclipboard then
	                CreateButton("Copy Hex", function()
	                    setclipboard(tostring(ColorPicker.Value:ToHex()))
	                end)

	                CreateButton("Copy RGB", function()
	                    setclipboard(table.concat({
	                        math.floor(ColorPicker.Value.R * 255),
	                        math.floor(ColorPicker.Value.G * 255),
	                        math.floor(ColorPicker.Value.B * 255),
	                    }, ", "))
	                end)
	            end
	        end

	        --// Copy/Paste Buttons \\--
	        local ActionHolder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 20),
	            Parent = ContentHolder,
	        })
	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalFlex = Enum.UIFlexAlignment.Fill,
	            Padding = UDim.new(0, 8),
	            Parent = ActionHolder,
	        })

	        local CopyColorButton = New("TextButton", {
	            BackgroundColor3 = "MainColor",
	            Size = UDim2.fromScale(1, 1),
	            Text = "Copy color",
	            TextSize = 14,
	            Parent = ActionHolder,
	        })
	        New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = CopyColorButton,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = CopyColorButton,
	            })
	        )

	        local PasteColorButton = New("TextButton", {
	            BackgroundColor3 = "MainColor",
	            Size = UDim2.fromScale(1, 1),
	            Text = "Paste color",
	            TextSize = 14,
	            Parent = ActionHolder,
	        })
	        New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = PasteColorButton,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = PasteColorButton,
	            })
	        )

	        local CopyColorOriginalText = CopyColorButton.Text
	        local PasteColorOriginalText = PasteColorButton.Text
	        local CopyColorResetId = 0
	        local PasteColorResetId = 0

	        table.insert(ColorPicker.Connections, CopyColorButton.MouseEnter:Connect(function()
	            TweenService:Create(CopyColorButton, Library.TweenInfo, {
	                BackgroundColor3 = Library:GetBetterColor(Library.Scheme.MainColor, 10),
	            }):Play()
	        end))

	        table.insert(ColorPicker.Connections, CopyColorButton.MouseLeave:Connect(function()
	            TweenService:Create(CopyColorButton, Library.TweenInfo, {
	                BackgroundColor3 = Library.Scheme.MainColor,
	            }):Play()
	        end))

	        table.insert(ColorPicker.Connections, PasteColorButton.MouseEnter:Connect(function()
	            TweenService:Create(PasteColorButton, Library.TweenInfo, {
	                BackgroundColor3 = Library:GetBetterColor(Library.Scheme.MainColor, 10),
	            }):Play()
	        end))

	        table.insert(ColorPicker.Connections, PasteColorButton.MouseLeave:Connect(function()
	            TweenService:Create(PasteColorButton, Library.TweenInfo, {
	                BackgroundColor3 = Library.Scheme.MainColor,
	            }):Play()
	        end))

	        table.insert(ColorPicker.Connections, CopyColorButton.MouseButton1Click:Connect(function()
	            Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }

	            CopyColorResetId += 1
	            local ThisResetId = CopyColorResetId
	            CopyColorButton.Text = "Copied color"

	            task.delay(1, function()
	                if ColorPicker.Destroyed or ThisResetId ~= CopyColorResetId then
	                    return
	                end

	                CopyColorButton.Text = CopyColorOriginalText
	            end)
	        end))

	        table.insert(ColorPicker.Connections, PasteColorButton.MouseButton1Click:Connect(function()
	            PasteColorResetId += 1
	            local ThisResetId = PasteColorResetId

	            if not Library.CopiedColor then
	                PasteColorButton.Text = "Nothing to paste"
	            else
	                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
	                PasteColorButton.Text = "Pasted color"
	            end

	            task.delay(1, function()
	                if ColorPicker.Destroyed or ThisResetId ~= PasteColorResetId then
	                    return
	                end

	                PasteColorButton.Text = PasteColorOriginalText
	            end)
	        end))

	        --// End \\--
	        function ColorPicker:SetHSVFromRGB(Color)
	            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
	        end

	        function ColorPicker:Display()
	            if Library.Unloaded then
	                return
	            end

	            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

	            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
	            if TransparencyColor then
	                TransparencyColor.BackgroundColor3 = ColorPicker.Value
	            end

	            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
	            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
	            if TransparencyCursor then
	                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
	            end

	            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
	            RgbBox.Text = table.concat({
	                math.floor(ColorPicker.Value.R * 255),
	                math.floor(ColorPicker.Value.G * 255),
	                math.floor(ColorPicker.Value.B * 255),
	            }, ", ")

	            RefreshFooterInfo()
	        end

	        local function ApplyHolderVisual(Disabled: boolean)
	            Holder.Active = not Disabled
	            HolderStroke.Transparency = Disabled and 0.5 or 0
	            Holder.BackgroundTransparency = Disabled and 0.5 or 0

	            if Disabled then
	                Holder.BackgroundColor3 = ColorPicker.Value:Lerp(Library.Scheme.BackgroundColor, 0.5)
	                HolderTransparency.ImageTransparency = math.clamp((1 - ColorPicker.Transparency) + 0.5, 0, 1)
	            else
	                Holder.BackgroundColor3 = ColorPicker.Value
	                HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
	                HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)
	            end
	        end

	        function ColorPicker:RunChanged()
	            if ParentObj.Disabled then
	                return
	            end

	            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
	            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
	        end

	        function ColorPicker:Update()
	            ColorPicker:Display()

	            local Disabled = ParentObj.Disabled == true
	            ApplyHolderVisual(Disabled)

	            if Disabled then
	                if ColorMenu.Active then
	                    ColorMenu:Close()
	                end

	                if ContextMenu.Active then
	                    ContextMenu:Close()
	                end
	            end

	            ColorPicker:RunChanged()
	        end

	        function ColorPicker:OnChanged(Func)
	            ColorPicker.Changed = Func
	        end

	        function ColorPicker:SetValue(HSV, Transparency)
	            if typeof(HSV) == "Color3" then
	                ColorPicker:SetValueRGB(HSV, Transparency)
	                return
	            end

	            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
	            ColorPicker.Transparency = Info.Transparency and Transparency or 0
	            ColorPicker:SetHSVFromRGB(Color)
	            ColorPicker:Update()
	        end

	        function ColorPicker:SetValueRGB(Color, Transparency)
	            ColorPicker.Transparency = Info.Transparency and Transparency or 0
	            ColorPicker:SetHSVFromRGB(Color)
	            ColorPicker:Update()
	        end

	        table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            ColorMenu:Toggle()
	        end))

	        table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            ContextMenu:Toggle()
	        end))

	        table.insert(ColorPicker.Connections, SatVipMap.InputBegan:Connect(function(Input: InputObject)
	            while IsDragInput(Input) and not ColorPicker.Destroyed do
	                local MinX = SatVipMap.AbsolutePosition.X
	                local MaxX = MinX + SatVipMap.AbsoluteSize.X
	                local LocationX = math.clamp(Mouse.X, MinX, MaxX)

	                local MinY = SatVipMap.AbsolutePosition.Y
	                local MaxY = MinY + SatVipMap.AbsoluteSize.Y
	                local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

	                local OldSat = ColorPicker.Sat
	                local OldVib = ColorPicker.Vib
	                ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
	                ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

	                if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
	                    ColorPicker:Update()
	                end

	                RunService.RenderStepped:Wait()
	            end
	        end))

	        table.insert(ColorPicker.Connections, HueSelector.InputBegan:Connect(function(Input: InputObject)
	            while IsDragInput(Input) and not ColorPicker.Destroyed do
	                local Min = HueSelector.AbsolutePosition.Y
	                local Max = Min + HueSelector.AbsoluteSize.Y
	                local Location = math.clamp(Mouse.Y, Min, Max)

	                local OldHue = ColorPicker.Hue
	                ColorPicker.Hue = (Location - Min) / (Max - Min)

	                if ColorPicker.Hue ~= OldHue then
	                    ColorPicker:Update()
	                end

	                RunService.RenderStepped:Wait()
	            end
	        end))

	        if TransparencySelector then
	            table.insert(ColorPicker.Connections, TransparencySelector.InputBegan:Connect(function(Input: InputObject)
	                while IsDragInput(Input) and not ColorPicker.Destroyed do
	                    local Min = TransparencySelector.AbsolutePosition.Y
	                    local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
	                    local Location = math.clamp(Mouse.Y, Min, Max)

	                    local OldTransparency = ColorPicker.Transparency
	                    ColorPicker.Transparency = (Location - Min) / (Max - Min)

	                    if ColorPicker.Transparency ~= OldTransparency then
	                        ColorPicker:Update()
	                    end

	                    RunService.RenderStepped:Wait()
	                end
	            end))
	        end

	        table.insert(ColorPicker.Connections, HueBox.FocusLost:Connect(function(Enter)
	            if not Enter then
	                return
	            end

	            local Success, Color = pcall(Color3.fromHex, HueBox.Text)
	            if Success and typeof(Color) == "Color3" then
	                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
	            end

	            ColorPicker:Update()
	        end))

	        table.insert(ColorPicker.Connections, RgbBox.FocusLost:Connect(function(Enter)
	            if not Enter then
	                return
	            end

	            local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
	            if R and G and B then
	                ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
	            end

	            ColorPicker:Update()
	        end))

	        for _, BoxPair in {
	            { HueBox, HueBoxStroke },
	            { RgbBox, RgbBoxStroke }
	        } do
	            local TextBoxInstance, Stroke = BoxPair[1], BoxPair[2]

	            table.insert(ColorPicker.Connections, TextBoxInstance.Focused:Connect(function()
	                Library.Registry[Stroke].Color = "AccentColor"
	                TweenService:Create(Stroke, Library.TweenInfo, {
	                    Color = Library.Scheme.AccentColor,
	                }):Play()
	            end))

	            table.insert(ColorPicker.Connections, TextBoxInstance.FocusLost:Connect(function()
	                Library.Registry[Stroke].Color = "OutlineColor"
	                TweenService:Create(Stroke, Library.TweenInfo, {
	                    Color = Library.Scheme.OutlineColor,
	                }):Play()
	            end))
	        end

	        ColorPicker:Update()

	        if not ParentObj.Addons then
	            ParentObj.Addons = {}
	        end

	        table.insert(ParentObj.Addons, ColorPicker)

	        ColorPicker.Default = ColorPicker.Value

	        function ColorPicker:Destroy()
	            ColorPicker.Destroyed = true

	            if ColorPicker.Connections then
	                for _, Connection in ColorPicker.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if ColorMenu then
	                ColorMenu:Destroy()
	            end

	            if ResizeGrabber then
	                ResizeGrabber:Destroy()
	            end

	            if ContextMenu then
	                ContextMenu:Destroy()
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            if ParentObj and ParentObj.Addons then
	                local AddonIdx = table.find(ParentObj.Addons, ColorPicker)

	                if AddonIdx then
	                    table.remove(ParentObj.Addons, AddonIdx)
	                end
	            end

	            Options[Idx] = nil
	        end

	        Options[Idx] = ColorPicker

	        return self
	    end

	    function Funcs:AddSettings(Info)
	        if self.Destroyed then return nil end

	        local ParentObj = self
	        if ParentObj.Settings and not ParentObj.Settings.Destroyed then
	            return ParentObj.Settings
	        end

	        Info = Library:Validate(Info, Templates.Settings)

	        local Settings = {
	            Connections = {},
	            Destroyed = false,

	            Elements = {},
	            DependencyBoxes = {},

	            Width = Info.Width,

	            Type = "Settings",
	            Parent = ParentObj,
	        }

	        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"
	        local IsForContainer = ParentObj.Type == "Input" or ParentObj.Type == "Dropdown"
	        local ParentContainer = IsForContainer and ParentObj.Container or nil

	        local Gear = New("TextButton", {
	            BackgroundColor3 = "MainColor",
	            Size = UDim2.fromOffset(18, 18),
	            Text = "",
	        })

	        New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Gear,
	        })

	        local GearCorner = New("UICorner", {
	            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            Parent = Gear,
	        }); table.insert(Library.SpecificCorners, GearCorner)

	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 3),
	            PaddingLeft = UDim.new(0, 3),
	            PaddingRight = UDim.new(0, 3),
	            PaddingTop = UDim.new(0, 3),
	            Parent = Gear,
	        })

	        local Icon = Library:CreateIcon(SettingsIcon, {
	            ImageColor3 = "FontColor",
	            ImageTransparency = 0.5,
	            Size = UDim2.fromScale(1, 1),
	            Parent = Gear,
	        })

	        if IsForButton then
	            New("UIFlexItem", {
	                FlexMode = Enum.UIFlexMode.None,
	                Parent = Gear,
	            })

	            Gear.LayoutOrder = ParentObj.Base.LayoutOrder + 1
	            Gear.Size = UDim2.new(0, 21, 1, 0)
	            Gear.Parent = ParentObj.Base.Parent
	        elseif IsForContainer then
	            local Height = ParentContainer.Size.Y.Offset
	            ParentContainer.Size = UDim2.new(1, -(Height + 6), 0, Height)

	            Gear.AnchorPoint = Vector2.new(1, 1)
	            Gear.Position = UDim2.fromScale(1, 1)
	            Gear.Size = UDim2.fromOffset(Height, Height)
	            Gear.Parent = ParentObj.Holder
	        else
	            Gear.Size = UDim2.fromOffset(21, 21)
	            Gear.Parent = ParentObj.TextLabel
	        end

	        local function GetMenuSize()
	            if typeof(Settings.Width) == "number" then
	                return UDim2.fromOffset(Settings.Width, 0)
	            end

	            if not Library.WindowContainer then
	                return UDim2.fromOffset(200, 0)
	            end

	            local Width = (Library.WindowContainer.AbsoluteSize.X / Library.DPIScale - 12) / 2 - 7
	            return UDim2.fromOffset(math.floor(Width), 0)
	        end

	        local SettingsMenu; SettingsMenu = Library:AddContextMenu(Gear, GetMenuSize, function()
	            return { 0.5, Gear.AbsoluteSize.Y + 1.5 }
	        end, 1, function(Active: boolean)
	            local Half = UDim.new(0, Library.CornerRadius / 2)
	            local Zero = UDim.new(0, 0)

	            GearCorner.TopLeftRadius = Half
	            GearCorner.TopRightRadius = Half
	            GearCorner.BottomRightRadius = Active and Zero or Half
	            GearCorner.BottomLeftRadius = Active and Zero or Half

	            local MenuCorner = SettingsMenu and SettingsMenu.Corner
	            if MenuCorner then
	                MenuCorner.TopLeftRadius = Zero
	                MenuCorner.TopRightRadius = Half
	                MenuCorner.BottomRightRadius = Half
	                MenuCorner.BottomLeftRadius = Half
	            end

	            if ParentObj.Disabled then
	                return
	            end

	            SetIconProperties(Icon, { ImageTransparency = Active and 0 or 0.5 })
	        end, false, "no_top_left")
	        Settings.Menu = SettingsMenu

	        local Container = New("Frame", {
	            AutomaticSize = Enum.AutomaticSize.Y,
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            Parent = SettingsMenu.Menu,
	        })
	        New("UIListLayout", {
	            Padding = UDim.new(0, 8),
	            Parent = Container,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 7),
	            PaddingLeft = UDim.new(0, 7),
	            PaddingRight = UDim.new(0, 7),
	            PaddingTop = UDim.new(0, 7),
	            Parent = Container,
	        })

	        Settings.Holder = Container
	        Settings.Container = Container
	        Settings.Gear = Gear

	        function Settings:Resize() end

	        function Settings:SetWidth(Width: number?)
	            if Width ~= nil then
	                assert(typeof(Width) == "number", "Width must be a number or nil")
	                assert(Width >= 0, "Width must be higher than 0")
	            end

	            Settings.Width = Width
	            SettingsMenu:SetSize(GetMenuSize)
	        end

	        function Settings:Open()
	            if ParentObj.Disabled then
	                return
	            end

	            SettingsMenu:Open()
	        end

	        function Settings:Close()
	            if not SettingsMenu.Active then
	                return
	            end

	            CloseMenus(SettingsMenu)

	            SettingsMenu:Close()
	        end

	        function Settings:Toggle()
	            if SettingsMenu.Active then
	                Settings:Close()
	            else
	                Settings:Open()
	            end
	        end

	        function Settings:Update()
	            local Disabled = ParentObj.Disabled == true

	            Gear.Active = not Disabled
	            Gear.BackgroundColor3 = Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
	            Library.Registry[Gear].BackgroundColor3 = Disabled and "BackgroundColor" or "MainColor"
	            SetIconProperties(Icon, { ImageTransparency = Disabled and 0.8 or (SettingsMenu.Active and 0 or 0.5) })

	            if Disabled then
	                Settings:Close()
	            end
	        end

	        table.insert(Settings.Connections, Gear.MouseButton1Click:Connect(function()
	            Settings:Toggle()
	        end))

	        table.insert(Settings.Connections, Gear.MouseEnter:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            TweenIcon(Icon, { ImageTransparency = 0 })
	        end))

	        table.insert(Settings.Connections, Gear.MouseLeave:Connect(function()
	            if ParentObj.Disabled then
	                return
	            end

	            TweenIcon(Icon, { ImageTransparency = SettingsMenu.Active and 0 or 0.5 })
	        end))

	        setmetatable(Settings, BaseGroupbox)

	        function Settings:Destroy()
	            Settings.Destroyed = true

	            for _, Connection in Settings.Connections do
	                Connection:Disconnect()
	            end

	            for Index = #Settings.Elements, 1, -1 do
	                local Element = Settings.Elements[Index]
	                if Element and Element.Destroy then
	                    Element:Destroy()
	                end
	            end

	            for Index = #Settings.DependencyBoxes, 1, -1 do
	                local SubDepbox = Settings.DependencyBoxes[Index]
	                if SubDepbox and SubDepbox.Destroy then
	                    SubDepbox:Destroy()
	                end
	            end

	            SettingsMenu:Destroy()

	            if ParentContainer and ParentContainer.Parent then
	                ParentContainer.Size = UDim2.new(1, 0, 0, ParentContainer.Size.Y.Offset)
	            end

	            if Gear then
	                Gear:Destroy()
	            end

	            if ParentObj.Addons then
	                local AddonIdx = table.find(ParentObj.Addons, Settings)
	                if AddonIdx then
	                    table.remove(ParentObj.Addons, AddonIdx)
	                end
	            end

	            if ParentObj.Settings == Settings then
	                ParentObj.Settings = nil
	            end
	        end

	        if not ParentObj.Addons then
	            ParentObj.Addons = {}
	        end

	        table.insert(ParentObj.Addons, Settings)
	        ParentObj.Settings = Settings

	        Settings:Update()

	        return Settings
	    end

	    BaseAddons.__index = Funcs
	    BaseAddons.__namecall = function(_, Key, ...)
	        return Funcs[Key](...)
	    end
	end

	do
	    local Funcs = {}

	    function Funcs:AddDivider(...)
	        if self.Destroyed then return nil end

	        local Params = select(1, ...)
	        local Text
	        local MarginTop = 0
	        local MarginBottom = 0

	        if typeof(Params) == "table" then
	            Text = Params.Text
	            MarginTop = Params.MarginTop or Params.Margin or 0
	            MarginBottom = Params.MarginBottom or Params.Margin or 0
	        elseif typeof(Params) == "string" then
	            Text = Params
	        end

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
	            Parent = Container,
	        })

	        local InnerHolder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 1, 0),
	            Parent = Holder,
	        })

	        New("UIPadding", {
	            PaddingTop = UDim.new(0, MarginTop),
	            PaddingBottom = UDim.new(0, MarginBottom),
	            Parent = Holder,
	        })

	        if Text then
	            local TextLabel = New("TextLabel", {
	                AutomaticSize = Enum.AutomaticSize.X,
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 0),
	                Text = Text,
	                TextSize = 14,
	                TextTransparency = 0.5,
	                TextXAlignment = Enum.TextXAlignment.Center,
	                Parent = InnerHolder,
	            })

	            local X, _ = Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X / Library.DPIScale)
	            local SizeX = X // 2 + 10

	            New("Frame", {
	                AnchorPoint = Vector2.new(0, 0.5),
	                BackgroundColor3 = "MainColor",
	                BorderColor3 = "OutlineColor",
	                BorderSizePixel = 1,
	                Position = UDim2.fromScale(0, 0.5),
	                Size = UDim2.new(0.5, -SizeX, 0, 2),
	                Parent = InnerHolder,
	            })
	            New("Frame", {
	                AnchorPoint = Vector2.new(1, 0.5),
	                BackgroundColor3 = "MainColor",
	                BorderColor3 = "OutlineColor",
	                BorderSizePixel = 1,
	                Position = UDim2.fromScale(1, 0.5),
	                Size = UDim2.new(0.5, -SizeX, 0, 2),
	                Parent = InnerHolder,
	            })
	        else
	            New("Frame", {
	                AnchorPoint = Vector2.new(0, 0.5),
	                BackgroundColor3 = "MainColor",
	                BorderColor3 = "OutlineColor",
	                BorderSizePixel = 1,
	                Position = UDim2.fromScale(0, 0.5),
	                Size = UDim2.new(1, 0, 0, 2),
	                Parent = InnerHolder,
	            })
	        end

	        Groupbox:Resize()

	        local Divider = {
	            Connections = {},
	            Destroyed = false,

	            Holder = Holder,
	            Text = Text,
	            MarginTop = MarginTop,
	            MarginBottom = MarginBottom,
	            Type = "Divider",

	            Parent = Groupbox,
	        }

	        function Divider:SetVisible(Value)
	            Holder.Visible = Value == true
	            Groupbox:Resize()
	        end

	        function Divider:Destroy()
	            Divider.Destroyed = true

	            if Divider.Connections then
	                for _, Connection in Divider.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Divider)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	        end

	        table.insert(Groupbox.Elements, Divider)
	        return Divider
	    end

	    function Funcs:AddLabel(...)
	        if self.Destroyed then return nil end

	        local Data = {}
	        local Addons = {}

	        local First = select(1, ...)
	        local Second = select(2, ...)

	        if typeof(First) == "table" or typeof(Second) == "table" then
	            local Params = typeof(First) == "table" and First or Second

	            Data.Text = Params.Text or ""
	            Data.DoesWrap = Params.DoesWrap or false
	            Data.Size = Params.Size or 14
	            Data.Visible = if typeof(Params.Visible) == "boolean" then Params.Visible else true
	            Data.Idx = typeof(Second) == "table" and First or nil
	        else
	            Data.Text = First or ""
	            Data.DoesWrap = Second or false
	            Data.Size = 14
	            Data.Visible = true
	            Data.Idx = select(3, ...) or nil
	        end

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Label = {
	            Connections = {},
	            Destroyed = false,

	            Text = Data.Text,
	            DoesWrap = Data.DoesWrap,

	            Addons = Addons,

	            Visible = Data.Visible,
	            Type = "Label",

	            Parent = Groupbox,
	        }

	        local TextLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 18),
	            Text = Label.Text,
	            TextSize = Data.Size,
	            TextWrapped = Label.DoesWrap,
	            TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
	            Visible = Label.Visible,
	            Parent = Container,
	        })

	        function Label:Display()
	            if not Label.DoesWrap then
	                return
	            end

	            local Width = TextLabel.AbsoluteSize.X / Library.DPIScale
	            if Width <= 0 then return end

	            local _, Y = Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
	            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
	        end

	        function Label:SetVisible(Visible: boolean)
	            Label.Visible = Visible

	            TextLabel.Visible = Label.Visible
	            Groupbox:Resize()
	        end

	        function Label:SetText(Text: string)
	            Label.Text = Text
	            TextLabel.Text = Text

	            Label:Display()
	            Groupbox:Resize()
	        end

	        if Label.DoesWrap then
	            Label:Display()

	            local Last = TextLabel.AbsoluteSize
	            table.insert(Label.Connections, TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	                if TextLabel.AbsoluteSize == Last then
	                    return
	                end

	                Label:Display()
	                Last = TextLabel.AbsoluteSize

	                Groupbox:Resize()
	            end))
	        else
	            New("UIListLayout", {
	                FillDirection = Enum.FillDirection.Horizontal,
	                HorizontalAlignment = Enum.HorizontalAlignment.Right,
	                VerticalAlignment = Enum.VerticalAlignment.Center,
	                Padding = UDim.new(0, 6),
	                Parent = TextLabel,
	            })
	        end

	        Groupbox:Resize()

	        Label.TextLabel = TextLabel
	        Label.Container = Container
	        if not Data.DoesWrap then
	            setmetatable(Label, BaseAddons)
	        end

	        Label.Holder = TextLabel
	        table.insert(Groupbox.Elements, Label)

	        if Data.Idx then
	            Labels[Data.Idx] = Label
	        else
	            table.insert(Labels, Label)
	        end

	        function Label:Destroy()
	            Label.Destroyed = true

	            if Label.Connections then
	                for _, Connection in Label.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Label.Addons then
	                for Index = #Label.Addons, 1, -1 do
	                    local Addon = table.remove(Label.Addons, Index)
	                    if Addon and Addon.Destroy then
	                        Addon:Destroy()
	                    end
	                end
	            end

	            if TextLabel then
	                TextLabel:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Label)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()

	            if Data.Idx then
	                Labels[Data.Idx] = nil
	            else
	                local LblIdx = table.find(Labels, Label)

	                if LblIdx then
	                    table.remove(Labels, LblIdx)
	                end
	            end
	        end

	        return Label
	    end

	    function Funcs:AddButton(...)
	        if self.Destroyed then return nil end

	        local function GetInfo(...)
	            local Info = {}

	            local First = select(1, ...)
	            local Second = select(2, ...)

	            if typeof(First) == "table" or typeof(Second) == "table" then
	                local Params = typeof(First) == "table" and First or Second

	                Info.Text = Params.Text or ""
	                Info.Func = Params.Func or Params.Callback or function() end
	                Info.DoubleClick = Params.DoubleClick
	                Info.Icon = Params.Icon or Params.IconName

	                Info.Tooltip = Params.Tooltip
	                Info.DisabledTooltip = Params.DisabledTooltip

	                Info.Risky = Params.Risky or false
	                Info.Disabled = Params.Disabled or false
	                Info.Visible = if typeof(Params.Visible) == "boolean" then Params.Visible else true
	                Info.Idx = typeof(Second) == "table" and First or nil
	            else
	                Info.Text = First or ""
	                Info.Func = Second or function() end
	                Info.DoubleClick = false
	                Info.Icon = nil

	                Info.Tooltip = nil
	                Info.DisabledTooltip = nil

	                Info.Risky = false
	                Info.Disabled = false
	                Info.Visible = true
	                Info.Idx = select(3, ...) or nil
	            end

	            return Info
	        end
	        local Info = GetInfo(...)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Button = {
	            Connections = {},
	            Destroyed = false,

	            Text = Info.Text,
	            Func = Info.Func,
	            DoubleClick = Info.DoubleClick,
	            Icon = Info.Icon,

	            Tooltip = Info.Tooltip,
	            DisabledTooltip = Info.DisabledTooltip,
	            TooltipTable = nil,

	            Risky = Info.Risky,
	            Disabled = Info.Disabled,
	            Visible = Info.Visible,
	            Locked = false,

	            Base = nil,
	            Stroke = nil,
	            Content = nil,
	            Label = nil,
	            IconImage = nil,

	            Addons = {},

	            Tween = nil,
	            Type = "Button",

	            Parent = Groupbox,
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 21),
	            Parent = Container,
	        })

	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalFlex = Enum.UIFlexAlignment.Fill,
	            Padding = UDim.new(0, 6),
	            Parent = Holder,
	        })

	        local function ApplyButtonIcon(Button, IconName)
	            local Content = Button.Content
	            if not Content then
	                return
	            end

	            local ParsedIcon = Library:GetCustomIcon(IconName)
	            if ParsedIcon then
	                Button.IconImage = if Button.IconImage then Library:ApplyIcon(Button.IconImage, ParsedIcon) else Library:CreateIcon(ParsedIcon, {
	                    LayoutOrder = 0,
	                    Size = UDim2.fromOffset(14, 14),
	                    Parent = Content,
	                })

	                Button.IconImage.Visible = true
	                SetIconProperties(Button.IconImage, {
	                    ImageColor3 = if Button.Risky then "RedColor" elseif ParsedIcon.Custom then "WhiteColor" else "FontColor",
	                    ImageTransparency = Button.Disabled and 0.8 or 0.4,
	                })
	            elseif Button.IconImage then
	                Button.IconImage.Visible = false
	            end
	        end

	        local function CreateButton(Button)
	            local Base = New("TextButton", {
	                Active = not Button.Disabled,
	                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
	                LayoutOrder = Button.Type == "SubButton" and 2 or 0,
	                Size = UDim2.fromScale(1, 1),
	                Text = "",
	                Visible = Button.Visible,
	                Parent = Holder,
	            })

	            local Stroke = New("UIStroke", {
	                Color = "OutlineColor",
	                Transparency = Button.Disabled and 0.5 or 0,
	                Parent = Base,
	            })

	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Base,
	                })
	            )

	            local Content = New("Frame", {
	                AnchorPoint = Vector2.new(0.5, 0.5),
	                AutomaticSize = Enum.AutomaticSize.X,
	                BackgroundTransparency = 1,
	                Position = UDim2.fromScale(0.5, 0.5),
	                Size = UDim2.fromOffset(0, 16),
	                Parent = Base,
	            })
	            New("UIListLayout", {
	                FillDirection = Enum.FillDirection.Horizontal,
	                HorizontalAlignment = Enum.HorizontalAlignment.Center,
	                VerticalAlignment = Enum.VerticalAlignment.Center,
	                Padding = UDim.new(0, 6),
	                Parent = Content,
	            })
	            New("UIPadding", {
	                PaddingLeft = UDim.new(0, 8),
	                PaddingRight = UDim.new(0, 8),
	                Parent = Content,
	            })

	            Button.Content = Content
	            Button.Label = New("TextLabel", {
	                AutomaticSize = Enum.AutomaticSize.X,
	                BackgroundTransparency = 1,
	                LayoutOrder = 1,
	                Size = UDim2.fromOffset(0, 16),
	                Text = Button.Text,
	                TextSize = 14,
	                TextTransparency = Button.Disabled and 0.8 or 0.4,
	                Visible = Button.Text ~= "",
	                Parent = Content,
	            })

	            if Button.Risky then
	                Button.Label.TextColor3 = Library.Scheme.RedColor
	                Library.Registry[Button.Label].TextColor3 = "RedColor"
	            end

	            ApplyButtonIcon(Button, Button.Icon)

	            return Base, Stroke
	        end

	        local function InitEvents(Button)
	            table.insert(Button.Connections, Button.Base.MouseEnter:Connect(function()
	                if Button.Disabled then
	                    return
	                end

	                Button.Tween = TweenService:Create(Button.Label, Library.TweenInfo, {
	                    TextTransparency = 0,
	                })
	                Button.Tween:Play()

	                if Button.IconImage and Button.IconImage.Visible then
	                    TweenIcon(Button.IconImage, { ImageTransparency = 0 })
	                end
	            end))
	            table.insert(Button.Connections, Button.Base.MouseLeave:Connect(function()
	                if Button.Disabled then
	                    return
	                end

	                Button.Tween = TweenService:Create(Button.Label, Library.TweenInfo, {
	                    TextTransparency = 0.4,
	                })
	                Button.Tween:Play()

	                if Button.IconImage and Button.IconImage.Visible then
	                    TweenIcon(Button.IconImage, { ImageTransparency = 0.4 })
	                end
	            end))

	            table.insert(Button.Connections, Button.Base.MouseButton1Click:Connect(function()
	                if Button.Disabled or Button.Locked then
	                    return
	                end

	                if Button.DoubleClick then
	                    Button.Locked = true

	                    local IconWasVisible = false
	                    if Button.IconImage then
	                        IconWasVisible = Button.IconImage.Visible
	                        Button.IconImage.Visible = false
	                    end

	                    Button.Label.Text = "Are you sure?"
	                    Button.Label.Visible = true
	                    Button.Label.TextColor3 = Library.Scheme.AccentColor
	                    Library.Registry[Button.Label].TextColor3 = "AccentColor"

	                    local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

	                    Button.Label.Text = Button.Text
	                    Button.Label.Visible = Button.Text ~= ""
	                    Button.Label.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
	                    Library.Registry[Button.Label].TextColor3 = Button.Risky and "RedColor" or "FontColor"

	                    if Button.IconImage then
	                        Button.IconImage.Visible = IconWasVisible
	                    end

	                    if Clicked then
	                        Library:SafeCallback(Button.Func)
	                    end

	                    RunService.RenderStepped:Wait()
	                    Button.Locked = false
	                    return
	                end

	                Library:SafeCallback(Button.Func)
	            end))
	        end

	        Button.Base, Button.Stroke = CreateButton(Button)
	        InitEvents(Button)

	        function Button:AddButton(...)
	            local Info = GetInfo(...)

	            local SubButton = {
	                Connections = {},
	                Destroyed = false,

	                Text = Info.Text,
	                Func = Info.Func,
	                DoubleClick = Info.DoubleClick,
	                Icon = Info.Icon,

	                Tooltip = Info.Tooltip,
	                DisabledTooltip = Info.DisabledTooltip,
	                TooltipTable = nil,

	                Risky = Info.Risky,
	                Disabled = Info.Disabled,
	                Visible = Info.Visible,
	                Locked = false,

	                Base = nil,
	                Stroke = nil,
	                Content = nil,
	                Label = nil,
	                IconImage = nil,

	                Addons = {},

	                Tween = nil,
	                Type = "SubButton",
	            }

	            Button.SubButton = SubButton
	            SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
	            InitEvents(SubButton)

	            function SubButton:UpdateColors()
	                if Library.Unloaded then
	                    return
	                end

	                StopTween(SubButton.Tween)

	                SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
	                SubButton.Label.TextTransparency = SubButton.Disabled and 0.8 or 0.4
	                SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

	                if SubButton.IconImage and SubButton.IconImage.Visible then
	                    SetIconProperties(SubButton.IconImage, { ImageTransparency = SubButton.Disabled and 0.8 or 0.4 })
	                end

	                Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
	                    or "MainColor"
	            end

	            function SubButton:SetDisabled(Disabled: boolean)
	                SubButton.Disabled = Disabled

	                if SubButton.TooltipTable then
	                    SubButton.TooltipTable.Disabled = SubButton.Disabled
	                end

	                SubButton.Base.Active = not SubButton.Disabled
	                SubButton:UpdateColors()
	                Library:UpdateAddons(SubButton)
	            end

	            function SubButton:SetVisible(Visible: boolean)
	                SubButton.Visible = Visible

	                SubButton.Base.Visible = SubButton.Visible
	                Groupbox:Resize()
	            end

	            function SubButton:SetText(Text: string)
	                SubButton.Text = Text
	                SubButton.Label.Text = Text
	                SubButton.Label.Visible = Text ~= ""
	            end

	            function SubButton:SetIcon(Icon: string?)
	                SubButton.Icon = Icon
	                ApplyButtonIcon(SubButton, Icon)
	            end

	            if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
	                SubButton.TooltipTable =
	                    Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
	                SubButton.TooltipTable.Disabled = SubButton.Disabled
	            end

	            SubButton:UpdateColors()

	            if Info.Idx then
	                Buttons[Info.Idx] = SubButton
	            else
	                table.insert(Buttons, SubButton)
	            end

	            SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker
	            SubButton.AddSettings = BaseAddons.__index.AddSettings

	            function SubButton:Destroy()
	                SubButton.Destroyed = true

	                if SubButton.Connections then
	                    for _, Connection in SubButton.Connections do
	                        Connection:Disconnect()
	                    end
	                end

	                if SubButton.Addons then
	                    for Index = #SubButton.Addons, 1, -1 do
	                        local Addon = table.remove(SubButton.Addons, Index)
	                        if Addon and Addon.Destroy then
	                            Addon:Destroy()
	                        end
	                    end
	                end

	                if SubButton.TooltipTable then
	                    SubButton.TooltipTable:Destroy()
	                end

	                if SubButton.Tween then
	                    SubButton.Tween:Destroy()
	                end

	                if SubButton.Base then
	                    SubButton.Base:Destroy()
	                end

	                if Info.Idx then
	                    Buttons[Info.Idx] = nil
	                else
	                    local BIdx = table.find(Buttons, SubButton)

	                    if BIdx then
	                        table.remove(Buttons, BIdx)
	                    end
	                end
	            end

	            return SubButton
	        end

	        function Button:UpdateColors()
	            if Library.Unloaded then
	                return
	            end

	            StopTween(Button.Tween)

	            Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
	            Button.Label.TextTransparency = Button.Disabled and 0.8 or 0.4
	            Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

	            if Button.IconImage and Button.IconImage.Visible then
	                SetIconProperties(Button.IconImage, { ImageTransparency = Button.Disabled and 0.8 or 0.4 })
	            end

	            Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
	        end

	        function Button:SetDisabled(Disabled: boolean)
	            Button.Disabled = Disabled

	            if Button.TooltipTable then
	                Button.TooltipTable.Disabled = Button.Disabled
	            end

	            Button.Base.Active = not Button.Disabled
	            Button:UpdateColors()
	            Library:UpdateAddons(Button)
	        end

	        function Button:SetVisible(Visible: boolean)
	            Button.Visible = Visible

	            Holder.Visible = Button.Visible
	            Groupbox:Resize()
	        end

	        function Button:SetText(Text: string)
	            Button.Text = Text
	            Button.Label.Text = Text
	            Button.Label.Visible = Text ~= ""
	        end

	        function Button:SetIcon(Icon: string?)
	            Button.Icon = Icon
	            ApplyButtonIcon(Button, Icon)
	        end

	        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
	            Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
	            Button.TooltipTable.Disabled = Button.Disabled
	        end

	        Button:UpdateColors()
	        Groupbox:Resize()

	        Button.Holder = Holder
	        table.insert(Groupbox.Elements, Button)

	        if Info.Idx then
	            Buttons[Info.Idx] = Button
	        else
	            table.insert(Buttons, Button)
	        end

	        Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker
	        Button.AddSettings = BaseAddons.__index.AddSettings

	        function Button:Destroy()
	            Button.Destroyed = true

	            if Button.Connections then
	                for _, Connection in Button.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Button.Addons then
	                for Index = #Button.Addons, 1, -1 do
	                    local Addon = table.remove(Button.Addons, Index)
	                    if Addon and Addon.Destroy then
	                        Addon:Destroy()
	                    end
	                end
	            end

	            if Button.TooltipTable then
	                Button.TooltipTable:Destroy()
	            end

	            if Button.Tween then
	                Button.Tween:Destroy()
	            end

	            if Button.SubButton then
	                Button.SubButton:Destroy()
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Button)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()

	            if Info.Idx then
	                Buttons[Info.Idx] = nil
	            else
	                local BIdx = table.find(Buttons, Button)

	                if BIdx then
	                    table.remove(Buttons, BIdx)
	                end
	            end
	        end

	        return Button
	    end

	    function Funcs:AddCheckbox(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.Toggle)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Toggle = {
	            Connections = {},
	            Destroyed = false,

	            Text = Info.Text,
	            Value = Info.Default,

	            Tooltip = Info.Tooltip,
	            DisabledTooltip = Info.DisabledTooltip,
	            TooltipTable = nil,

	            Callback = Info.Callback,
	            Changed = Info.Changed,

	            Risky = Info.Risky,
	            Disabled = Info.Disabled,
	            Visible = Info.Visible,

	            Addons = {},
	            AnyKeyPickerPicking = false,

	            Variant = "Checkbox",
	            Type = "Toggle",

	            Parent = Groupbox,
	        }

	        local Button = New("TextButton", {
	            Active = not Toggle.Disabled,
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 18),
	            Text = "",
	            Visible = Toggle.Visible,
	            Parent = Container,
	        })

	        local Label = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Position = UDim2.fromOffset(26, 0),
	            Size = UDim2.new(1, -26, 1, 0),
	            Text = Toggle.Text,
	            TextSize = 14,
	            TextTransparency = 0.4,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            Parent = Button,
	        })

	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalAlignment = Enum.HorizontalAlignment.Right,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Padding = UDim.new(0, 6),
	            Parent = Label,
	        })

	        local Checkbox = New("Frame", {
	            BackgroundColor3 = "MainColor",
	            Size = UDim2.fromScale(1, 1),
	            SizeConstraint = Enum.SizeConstraint.RelativeYY,
	            Parent = Button,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Checkbox,
	            })
	        )

	        local CheckboxStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Checkbox,
	        })

	        local CheckImage = Library:CreateIcon(CheckIcon, {
	            ImageColor3 = "FontColor",
	            ImageTransparency = 1,
	            Position = UDim2.fromOffset(2, 2),
	            Size = UDim2.new(1, -4, 1, -4),
	            Parent = Checkbox,
	        })

	        function Toggle:UpdateColors()
	            Toggle:Display()
	        end

	        function Toggle:Display()
	            if Library.Unloaded then
	                return
	            end

	            CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

	            if Toggle.Disabled then
	                Label.TextTransparency = 0.8
	                SetIconProperties(CheckImage, { ImageTransparency = Toggle.Value and 0.8 or 1 })

	                Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
	                Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

	                return
	            end

	            TweenService:Create(Label, Library.TweenInfo, {
	                TextTransparency = Toggle.Value and 0 or 0.4,
	            }):Play()
	            TweenIcon(CheckImage, { ImageTransparency = Toggle.Value and 0 or 1 })

	            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
	            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
	        end

	        function Toggle:OnChanged(Func)
	            Toggle.Changed = Func
	        end

	        function Toggle:RunChanged()
	            if Toggle.Disabled then
	                return
	            end

	            Library:SafeCallback(Toggle.Callback, Toggle.Value)
	            Library:SafeCallback(Toggle.Changed, Toggle.Value)
	        end

	        function Toggle:SetValue(Value)
	            Toggle.Value = Value
	            Toggle:Display()

	            for _, Addon in Toggle.Addons do
	                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
	                    Addon.Toggled = Toggle.Value
	                    Addon:Update()
	                end
	            end

	            if not Toggle.Disabled then
	                Library:UpdateDependencyBoxes()
	            end

	            if not Toggle.AnyKeyPickerPicking then
	                Toggle:RunChanged()
	            end
	        end

	        function Toggle:SetDisabled(Disabled: boolean)
	            Toggle.Disabled = Disabled

	            if Toggle.TooltipTable then
	                Toggle.TooltipTable.Disabled = Toggle.Disabled
	            end

	            Library:UpdateAddons(Toggle)

	            Button.Active = not Toggle.Disabled
	            Toggle:Display()

	            Library:UpdateDependencyBoxes()
	        end

	        function Toggle:SetVisible(Visible: boolean)
	            Toggle.Visible = Visible

	            Button.Visible = Toggle.Visible
	            Groupbox:Resize()
	        end

	        function Toggle:SetText(Text: string)
	            Toggle.Text = Text
	            Label.Text = Text
	        end

	        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
	            if Toggle.Disabled then
	                return
	            end

	            Toggle:SetValue(not Toggle.Value)
	        end))

	        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
	            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
	            Toggle.TooltipTable.Disabled = Toggle.Disabled
	        end

	        if Toggle.Risky then
	            Label.TextColor3 = Library.Scheme.RedColor
	            Library.Registry[Label].TextColor3 = "RedColor"
	        end

	        Toggle:Display()
	        Groupbox:Resize()

	        Toggle.TextLabel = Label
	        Toggle.Container = Container
	        setmetatable(Toggle, BaseAddons)

	        Toggle.Holder = Button
	        table.insert(Groupbox.Elements, Toggle)

	        Toggle.Default = Toggle.Value

	        Toggles[Idx] = Toggle

	        function Toggle:Destroy()
	            Toggle.Destroyed = true

	            if Toggle.Connections then
	                for _, Connection in Toggle.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Toggle.TooltipTable then
	                Toggle.TooltipTable:Destroy()
	            end

	            if Button then
	                Button:Destroy()
	            end

	            if Toggle.Addons then
	                for Index = #Toggle.Addons, 1, -1 do
	                    local Addon = table.remove(Toggle.Addons, Index)
	                    if Addon and Addon.Destroy then
	                        Addon:Destroy()
	                    end
	                end
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Toggle)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Toggles[Idx] = nil
	        end

	        return Toggle
	    end

	    function Funcs:AddToggle(Idx, Info)
	        if self.Destroyed then return nil end

	        if Library.ForceCheckbox then
	            return Funcs.AddCheckbox(self, Idx, Info)
	        end

	        Info = Library:Validate(Info, Templates.Toggle)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Toggle = {
	            Connections = {},
	            Destroyed = false,

	            Text = Info.Text,
	            Value = Info.Default,

	            Tooltip = Info.Tooltip,
	            DisabledTooltip = Info.DisabledTooltip,
	            TooltipTable = nil,

	            Callback = Info.Callback,
	            Changed = Info.Changed,

	            Risky = Info.Risky,
	            Disabled = Info.Disabled,
	            Visible = Info.Visible,

	            Addons = {},
	            AnyKeyPickerPicking = false,

	            Variant = "Switch",
	            Type = "Toggle",

	            Parent = Groupbox,
	        }

	        local Button = New("TextButton", {
	            Active = not Toggle.Disabled,
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 18),
	            Text = "",
	            Visible = Toggle.Visible,
	            Parent = Container,
	        })

	        local Label = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, -38, 1, 0),
	            Text = Toggle.Text,
	            TextSize = 14,
	            TextTransparency = 0.4,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            Parent = Button,
	        })

	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalAlignment = Enum.HorizontalAlignment.Right,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Padding = UDim.new(0, 6),
	            Parent = Label,
	        })

	        local Switch = New("Frame", {
	            AnchorPoint = Vector2.new(1, 0),
	            BackgroundColor3 = "MainColor",
	            Position = UDim2.fromScale(1, 0),
	            Size = UDim2.fromOffset(32, 18),
	            Parent = Button,
	        })
	        New("UICorner", {
	            CornerRadius = UDim.new(1, 0),
	            Parent = Switch,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 2),
	            PaddingLeft = UDim.new(0, 2),
	            PaddingRight = UDim.new(0, 2),
	            PaddingTop = UDim.new(0, 2),
	            Parent = Switch,
	        })
	        local SwitchStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Switch,
	        })

	        local Ball = New("Frame", {
	            BackgroundColor3 = "FontColor",
	            Size = UDim2.fromScale(1, 1),
	            SizeConstraint = Enum.SizeConstraint.RelativeYY,
	            Parent = Switch,
	        })
	        New("UICorner", {
	            CornerRadius = UDim.new(1, 0),
	            Parent = Ball,
	        })

	        function Toggle:UpdateColors()
	            Toggle:Display()
	        end

	        function Toggle:Display()
	            if Library.Unloaded then
	                return
	            end

	            local Offset = Toggle.Value and 1 or 0

	            Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
	            SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

	            Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
	            SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

	            Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
	            Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

	            if Toggle.Disabled then
	                Label.TextTransparency = 0.8
	                Ball.AnchorPoint = Vector2.new(Offset, 0)
	                Ball.Position = UDim2.fromScale(Offset, 0)

	                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
	                Library.Registry[Ball].BackgroundColor3 = function()
	                    return Library:GetDarkerColor(Library.Scheme.FontColor)
	                end

	                return
	            end

	            TweenService:Create(Label, Library.TweenInfo, {
	                TextTransparency = Toggle.Value and 0 or 0.4,
	            }):Play()
	            TweenService:Create(Ball, Library.TweenInfo, {
	                AnchorPoint = Vector2.new(Offset, 0),
	                Position = UDim2.fromScale(Offset, 0),
	            }):Play()

	            Ball.BackgroundColor3 = Library.Scheme.FontColor
	            Library.Registry[Ball].BackgroundColor3 = "FontColor"
	        end

	        function Toggle:OnChanged(Func)
	            Toggle.Changed = Func
	        end

	        function Toggle:RunChanged()
	            if Toggle.Disabled then
	                return
	            end

	            Library:SafeCallback(Toggle.Callback, Toggle.Value)
	            Library:SafeCallback(Toggle.Changed, Toggle.Value)
	        end

	        function Toggle:SetValue(Value)
	            Toggle.Value = Value
	            Toggle:Display()

	            for _, Addon in Toggle.Addons do
	                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
	                    Addon.Toggled = Toggle.Value
	                    Addon:Update()
	                end
	            end

	            if not Toggle.Disabled then
	                Library:UpdateDependencyBoxes()
	            end

	            if not Toggle.AnyKeyPickerPicking then
	                Toggle:RunChanged()
	            end
	        end

	        function Toggle:SetDisabled(Disabled: boolean)
	            Toggle.Disabled = Disabled

	            if Toggle.TooltipTable then
	                Toggle.TooltipTable.Disabled = Toggle.Disabled
	            end

	            Library:UpdateAddons(Toggle)

	            Button.Active = not Toggle.Disabled
	            Toggle:Display()

	            Library:UpdateDependencyBoxes()
	        end

	        function Toggle:SetVisible(Visible: boolean)
	            Toggle.Visible = Visible

	            Button.Visible = Toggle.Visible
	            Groupbox:Resize()
	        end

	        function Toggle:SetText(Text: string)
	            Toggle.Text = Text
	            Label.Text = Text
	        end

	        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
	            if Toggle.Disabled then
	                return
	            end

	            Toggle:SetValue(not Toggle.Value)
	        end))

	        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
	            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
	            Toggle.TooltipTable.Disabled = Toggle.Disabled
	        end

	        if Toggle.Risky then
	            Label.TextColor3 = Library.Scheme.RedColor
	            Library.Registry[Label].TextColor3 = "RedColor"
	        end

	        Toggle:Display()
	        Groupbox:Resize()

	        Toggle.TextLabel = Label
	        Toggle.Container = Container
	        setmetatable(Toggle, BaseAddons)

	        Toggle.Holder = Button
	        table.insert(Groupbox.Elements, Toggle)

	        Toggle.Default = Toggle.Value

	        Toggles[Idx] = Toggle

	        function Toggle:Destroy()
	            Toggle.Destroyed = true

	            if Toggle.Connections then
	                for _, Connection in Toggle.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Toggle.TooltipTable then
	                Toggle.TooltipTable:Destroy()
	            end

	            if Button then
	                Button:Destroy()
	            end

	            if Toggle.Addons then
	                for Index = #Toggle.Addons, 1, -1 do
	                    local Addon = table.remove(Toggle.Addons, Index)
	                    if Addon and Addon.Destroy then
	                        Addon:Destroy()
	                    end
	                end
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Toggle)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Toggles[Idx] = nil
	        end

	        return Toggle
	    end

	    function Funcs:AddInput(Idx, Info)
	        if self.Destroyed then return nil end

	        if typeof(Info) == "table" and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true) then
	            Info.Finished = true
	        end

	        Info = Library:Validate(Info, Templates.Input)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Input = {
	            Connections = {},
	            Destroyed = false,

	            Text = Info.Text,
	            Value = Info.Default,

	            Finished = Info.Finished,
	            Numeric = Info.Numeric,
	            ClearTextOnFocus = Info.ClearTextOnFocus,
	            ClearTextOnBlur = Info.ClearTextOnBlur,
	            Placeholder = Info.Placeholder,
	            AllowEmpty = Info.AllowEmpty,
	            EmptyReset = Info.EmptyReset,

	            Tooltip = Info.Tooltip,
	            DisabledTooltip = Info.DisabledTooltip,
	            TooltipTable = nil,

	            Callback = Info.Callback,
	            Changed = Info.Changed,
	            VerifyValue = Info.VerifyValue,

	            Disabled = Info.Disabled,
	            Visible = Info.Visible,

	            Addons = {},

	            Holder = nil,
	            Label = nil,
	            Container = nil,

	            Type = "Input",
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 39),
	            Visible = Input.Visible,
	            Parent = Container,
	        })

	        local Label = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 14),
	            Text = Input.Text,
	            TextSize = 14,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            Parent = Holder,
	        })

	        local Box = New("TextBox", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = "MainColor",
	            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
	            PlaceholderText = Input.Placeholder,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.new(1, 0, 0, 21),
	            Text = Input.Value,
	            TextEditable = not Input.Disabled,
	            TextScaled = true,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            Parent = Holder,
	        })

	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 3),
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 8),
	            PaddingTop = UDim.new(0, 4),
	            Parent = Box,
	        })

	        local BoxStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Box,
	        })

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Box,
	            })
	        )

	        function Input:UpdateColors()
	            if Library.Unloaded then
	                return
	            end

	            Label.TextTransparency = Input.Disabled and 0.8 or 0
	            Box.TextTransparency = Input.Disabled and 0.8 or 0
	            BoxStroke.Transparency = Input.Disabled and 0.5 or 0

	            Box.BackgroundColor3 = Input.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
	            Library.Registry[Box].BackgroundColor3 = Input.Disabled and "BackgroundColor" or "MainColor"
	        end

	        function Input:OnChanged(Func)
	            Input.Changed = Func
	        end

	        function Input:RunChanged()
	            if Input.Disabled then
	                return
	            end

	            Library:SafeCallback(Input.Callback, Input.Value)
	            Library:SafeCallback(Input.Changed, Input.Value)
	        end

	        function Input:SetValue(Text)
	            if not Input.AllowEmpty and Trim(Text) == "" then
	                Text = Input.EmptyReset
	            end

	            if Info.MaxLength and #Text > Info.MaxLength then
	                Text = Text:sub(1, Info.MaxLength)
	            end

	            if Input.Numeric then
	                if #tostring(Text) > 0 and not tonumber(Text) then
	                    Text = Input.Value
	                end
	            end

	            if typeof(Info.VerifyValue) == "function" and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true) then
	                Text = Input.EmptyReset
	            end

	            Input.Value = Text
	            Box.Text = Text

	            Input:RunChanged()
	        end

	        function Input:SetDisabled(Disabled: boolean)
	            Input.Disabled = Disabled

	            if Input.TooltipTable then
	                Input.TooltipTable.Disabled = Input.Disabled
	            end

	            Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
	            Box.TextEditable = not Input.Disabled
	            Input:UpdateColors()

	            Library:UpdateAddons(Input)
	        end

	        function Input:SetVisible(Visible: boolean)
	            Input.Visible = Visible

	            Holder.Visible = Input.Visible
	            Groupbox:Resize()
	        end

	        function Input:SetText(Text: string)
	            Input.Text = Text
	            Label.Text = Text
	        end

	        if Input.Finished then
	            table.insert(Input.Connections, Box.FocusLost:Connect(function(Enter)
	                if not Enter then
	                    if Input.ClearTextOnBlur then
	                        Box.Text = Input.Value
	                    end

	                    return
	                end

	                Input:SetValue(Box.Text)
	            end))
	        else
	            table.insert(Input.Connections, Box:GetPropertyChangedSignal("Text"):Connect(function()
	                if Box.Text == Input.Value then return end

	                Input:SetValue(Box.Text)
	            end))
	        end

	        table.insert(Input.Connections, Box.Focused:Connect(function()
	            if Input.Disabled then
	                return
	            end

	            Library.Registry[BoxStroke].Color = "AccentColor"
	            TweenService:Create(BoxStroke, Library.TweenInfo, {
	                Color = Library.Scheme.AccentColor,
	            }):Play()
	        end))

	        table.insert(Input.Connections, Box.FocusLost:Connect(function()
	            if Input.Disabled then
	                return
	            end

	            Library.Registry[BoxStroke].Color = "OutlineColor"
	            TweenService:Create(BoxStroke, Library.TweenInfo, {
	                Color = Library.Scheme.OutlineColor,
	            }):Play()
	        end))

	        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
	            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
	            Input.TooltipTable.Disabled = Input.Disabled
	        end

	        Groupbox:Resize()

	        Input.Holder = Holder
	        Input.Label = Label
	        Input.Container = Box

	        Input.AddSettings = BaseAddons.__index.AddSettings
	        table.insert(Groupbox.Elements, Input)

	        Input.Default = Input.Value
	        if typeof(Info.VerifyValue) == "function" and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true) then
	            Input:SetValue(Input.EmptyReset)
	            Input.Default = Input.EmptyReset
	        end

	        Input:UpdateColors()
	        Options[Idx] = Input

	        function Input:Destroy()
	            Input.Destroyed = true

	            if Input.Connections then
	                for _, Connection in Input.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Input.Addons then
	                for Index = #Input.Addons, 1, -1 do
	                    local Addon = table.remove(Input.Addons, Index)
	                    if Addon and Addon.Destroy then
	                        Addon:Destroy()
	                    end
	                end
	            end

	            if Input.TooltipTable then
	                Input.TooltipTable:Destroy()
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Input)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Input
	    end

	    function Funcs:AddSlider(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.Slider)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Slider = {
	            Connections = {},
	            Destroyed = false,

	            Text = Info.Text,
	            Value = Info.Default,

	            Min = Info.Min,
	            Max = Info.Max,

	            Prefix = Info.Prefix,
	            Suffix = Info.Suffix,
	            Compact = Info.Compact,
	            Rounding = Info.Rounding,
	            HideMax = Info.HideMax,

	            Tooltip = Info.Tooltip,
	            DisabledTooltip = Info.DisabledTooltip,
	            TooltipTable = nil,

	            Callback = Info.Callback,
	            Changed = Info.Changed,

	            Disabled = Info.Disabled,
	            Visible = Info.Visible,

	            AllowRightClickInput = Info.AllowRightClickInput,

	            Type = "Slider",
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
	            Visible = Slider.Visible,
	            Parent = Container,
	        })

	        local SliderLabel
	        if not Info.Compact then
	            SliderLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 14),
	                Text = Slider.Text,
	                TextSize = 14,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Parent = Holder,
	            })
	        end

	        local Bar = New("TextButton", {
	            Active = not Slider.Disabled,
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = "MainColor",
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.new(1, 0, 0, 15),
	            Text = "",
	            Parent = Holder,
	        })

	        New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Bar,
	        })

	        local DisplayLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Text = "",
	            TextSize = 14,
	            ZIndex = Bar.ZIndex + 2,
	            Parent = Bar,
	        })
	        New("UIStroke", {
	            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	            Color = GetTextStrokeColor,
	            LineJoinMode = Enum.LineJoinMode.Miter,
	            Parent = DisplayLabel,
	        })

	        local InputTextBox
	        if Info.AllowRightClickInput then
	            InputTextBox = New("TextBox", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Text = "",
	                TextSize = 14,
	                ZIndex = Bar.ZIndex + 3,
	                Visible = false,
	                ClearTextOnFocus = false,
	                Parent = Bar,
	            })
	            New("UIStroke", {
	                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	                Color = GetTextStrokeColor,
	                LineJoinMode = Enum.LineJoinMode.Miter,
	                Parent = InputTextBox,
	            })
	        end

	        local Fill = New("Frame", {
	            BackgroundColor3 = "AccentColor",
	            Size = UDim2.fromScale(0.5, 1),
	            ZIndex = Bar.ZIndex + 1,
	            Parent = Bar,
	        })

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Bar,
	            })
	        )

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Fill,
	            })
	        )

	        function Slider:UpdateColors()
	            if Library.Unloaded then
	                return
	            end

	            if SliderLabel then
	                SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
	            end
	            DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

	            if Info.AllowRightClickInput then
	                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
	            end

	            Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
	            Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
	        end

	        function Slider:Display()
	            if Library.Unloaded then
	                return
	            end

	            local CustomDisplayText = nil
	            if Info.FormatDisplayValue then
	                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
	            end

	            if CustomDisplayText then
	                DisplayLabel.Text = tostring(CustomDisplayText)
	            else
	                if Info.Compact then
	                    DisplayLabel.Text =
	                        string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
	                elseif Info.HideMax then
	                    DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
	                else
	                    DisplayLabel.Text = string.format(
	                        "%s%s%s/%s%s%s",
	                        Slider.Prefix,
	                        Slider.Value,
	                        Slider.Suffix,
	                        Slider.Prefix,
	                        Slider.Max,
	                        Slider.Suffix
	                    )
	                end
	            end

	            local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
	            Fill.Size = UDim2.fromScale(X, 1)
	        end

	        function Slider:OnChanged(Func)
	            Slider.Changed = Func
	        end

	        function Slider:SetMax(Value)
	            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

	            Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
	            Slider.Max = Value
	            Slider:Display()
	        end

	        function Slider:SetMin(Value)
	            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

	            Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
	            Slider.Min = Value
	            Slider:Display()
	        end

	        function Slider:RunChanged()
	            if Slider.Disabled then
	                return
	            end

	            Library:SafeCallback(Slider.Callback, Slider.Value)
	            Library:SafeCallback(Slider.Changed, Slider.Value)
	        end

	        function Slider:SetValue(Str)
	            local Num = tonumber(Str)
	            if not Num or Num == Slider.Value then
	                return
	            end

	            Num = math.clamp(Num, Slider.Min, Slider.Max)

	            Slider.Value = Num
	            Slider:Display()

	            Slider:RunChanged()
	        end

	        function Slider:SetDisabled(Disabled: boolean)
	            Slider.Disabled = Disabled

	            if Slider.TooltipTable then
	                Slider.TooltipTable.Disabled = Slider.Disabled
	            end

	            Bar.Active = not Slider.Disabled
	            Slider:UpdateColors()
	        end

	        function Slider:SetVisible(Visible: boolean)
	            Slider.Visible = Visible

	            Holder.Visible = Slider.Visible
	            Groupbox:Resize()
	        end

	        function Slider:SetText(Text: string)
	            Slider.Text = Text
	            if SliderLabel then
	                SliderLabel.Text = Text
	                return
	            end
	            Slider:Display()
	        end

	        function Slider:SetPrefix(Prefix: string)
	            Slider.Prefix = Prefix
	            Slider:Display()
	        end

	        function Slider:SetSuffix(Suffix: string)
	            Slider.Suffix = Suffix
	            Slider:Display()
	        end

	        if Info.AllowRightClickInput then
	            local LastValidText = ""
	            table.insert(Slider.Connections, InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	                local Text = InputTextBox.Text
	                local AsNum = tonumber(Text)

	                if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
	                    InputTextBox.Text = LastValidText
	                else
	                    if Slider.Rounding == 0 and Text:find("%.") then
	                        InputTextBox.Text = LastValidText
	                        return
	                    end

	                    local DecimalPos = Text:find("%.")
	                    if DecimalPos and Slider.Rounding > 0 then
	                        local Decimals = #Text - DecimalPos
	                        if Decimals > Slider.Rounding then
	                            InputTextBox.Text = LastValidText
	                            return
	                        end
	                    end

	                    LastValidText = Text
	                end
	            end))

	            table.insert(Slider.Connections, InputTextBox.FocusLost:Connect(function()
	                InputTextBox.Visible = false
	                DisplayLabel.Visible = true

	                local Num = tonumber(InputTextBox.Text)
	                if not Num then
	                    return
	                end

	                Num = Round(Num, Slider.Rounding)
	                Slider:SetValue(Num)
	            end))
	        end

	        local LastTap = 0
	        table.insert(Slider.Connections, Bar.InputBegan:Connect(function(Input: InputObject)
	            local ValidInput = IsClickInput(Input) or Input.UserInputType == Enum.UserInputType.MouseButton2
	            if not ValidInput or Slider.Disabled then
	                return
	            end

	            if Info.AllowRightClickInput then
	                local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
	                local IsDoubleTap = false

	                if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
	                    if tick() - LastTap < 0.3 then
	                        IsDoubleTap = true
	                    end

	                    LastTap = tick()
	                end

	                if IsRightClick or IsDoubleTap then
	                    InputTextBox.Text = tostring(Slider.Value)
	                    InputTextBox.Visible = true
	                    DisplayLabel.Visible = false

	                    task.spawn(InputTextBox.CaptureFocus, InputTextBox)
	                    return
	                end
	            end

	            if not IsClickInput(Input) then
	                return
	            end

	            if Library.ActiveTab then
	                for _, Side in Library.ActiveTab.Sides do
	                    Side.ScrollingEnabled = false
	                end
	            end

	            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
	                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
	            end

	            while IsDragInput(Input) and not Slider.Destroyed do
	                local Location = Mouse.X
	                local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

	                local OldValue = Slider.Value
	                Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

	                Slider:Display()
	                if Slider.Value ~= OldValue then
	                    Slider:RunChanged()
	                end

	                RunService.RenderStepped:Wait()
	            end

	            if Library.ActiveTab then
	                for _, Side in Library.ActiveTab.Sides do
	                    Side.ScrollingEnabled = true
	                end
	            end

	            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
	                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
	            end
	        end))

	        if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
	            Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
	            Slider.TooltipTable.Disabled = Slider.Disabled
	        end

	        Slider:UpdateColors()
	        Slider:Display()
	        Groupbox:Resize()

	        Slider.Holder = Holder
	        table.insert(Groupbox.Elements, Slider)

	        Slider.Default = Slider.Value

	        Options[Idx] = Slider

	        function Slider:Destroy()
	            Slider.Destroyed = true

	            if Slider.Connections then
	                for _, Connection in Slider.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Slider.TooltipTable then
	                Slider.TooltipTable:Destroy()
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Slider)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Slider
	    end

	    function Funcs:AddDropdown(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.Dropdown)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        if Info.SpecialType == "Player" then
	            Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
	            Info.AllowNull = true
	        elseif Info.SpecialType == "Team" then
	            Info.Values = GetTeams()
	            Info.AllowNull = true
	        end

	        local Dropdown = {
	            Connections = {},
	            Destroyed = false,

	            Text = typeof(Info.Text) == "string" and Info.Text or nil,

	            Value = Info.Multi and {} or nil,
	            Values = Info.Values,
	            DisabledValues = Info.DisabledValues,
	            ValueImages = Info.ValueImages,

	            Multi = Info.Multi,
	            DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,
	            KeepDisabledValuePosition = Info.KeepDisabledValuePosition == true,

	            SpecialType = Info.SpecialType,
	            ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
	            EnablePlayerImages = Info.EnablePlayerImages,

	            Tooltip = Info.Tooltip,
	            DisabledTooltip = Info.DisabledTooltip,
	            TooltipTable = nil,

	            Callback = Info.Callback,
	            Changed = Info.Changed,

	            Disabled = Info.Disabled,
	            Visible = Info.Visible,

	            Addons = {},

	            Holder = nil,
	            Label = nil,
	            Container = nil,

	            Type = "Dropdown",
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
	            Visible = Dropdown.Visible,
	            Parent = Container,
	        })

	        local Label = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 14),
	            Text = Dropdown.Text,
	            TextSize = 14,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            Visible = not not Info.Text,
	            ZIndex = 3,
	            Parent = Holder,
	        })

	        local DisplayContainer = New("TextButton", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = "MainColor",
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.new(1, 0, 0, 21),
	            Text = "",
	            TextTransparency = 1,
	            ZIndex = 2,
	            Parent = Holder,
	        })

	        New("UIPadding", {
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 4),
	            Parent = DisplayContainer,
	        })

	        local DisplayStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = DisplayContainer,
	        })

	        local DropdownCorner = New("UICorner", {
	            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
	            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
	            Parent = DisplayContainer,
	        }); table.insert(Library.SpecificCorners, DropdownCorner)

	        local DisplayImage = Library:CreateIcon(nil, {
	            Position = UDim2.fromOffset(-4, 3),
	            Size = UDim2.fromOffset(16, 16),
	            ImageTransparency = 1,
	            ZIndex = 2,
	            Parent = DisplayContainer,
	        })

	        local DisplayButton = New("TextButton", {
	            Active = not Dropdown.Disabled,
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 21),
	            Text = "---",
	            TextSize = 14,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            ZIndex = 2,
	            Parent = DisplayContainer,
	        })

	        local ArrowImage = Library:CreateIcon(ArrowIcon, {
	            AnchorPoint = Vector2.new(1, 0.5),
	            ImageColor3 = "FontColor",
	            ImageTransparency = 0.5,
	            Position = UDim2.fromScale(1, 0.5),
	            Size = UDim2.fromOffset(16, 16),
	            Parent = DisplayContainer,
	        })

	        local SearchBox
	        if Info.Searchable then
	            SearchBox = New("TextBox", {
	                BackgroundTransparency = 1,
	                PlaceholderText = "Search...",
	                Position = UDim2.fromOffset(-8, 0),
	                Size = UDim2.new(1, -12, 1, 0),
	                TextSize = 14,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Visible = false,
	                Parent = DisplayButton,
	            })
	            New("UIPadding", {
	                PaddingLeft = UDim.new(0, 8),
	                Parent = SearchBox,
	            })

	            table.insert(Dropdown.Connections, SearchBox.Focused:Connect(function()
	                Library.Registry[DisplayStroke].Color = "AccentColor"
	                TweenService:Create(DisplayStroke, Library.TweenInfo, {
	                    Color = Library.Scheme.AccentColor,
	                }):Play()
	            end))

	            table.insert(Dropdown.Connections, SearchBox.FocusLost:Connect(function()
	                Library.Registry[DisplayStroke].Color = "OutlineColor"
	                TweenService:Create(DisplayStroke, Library.TweenInfo, {
	                    Color = Library.Scheme.OutlineColor,
	                }):Play()
	            end))
	        end

	        local GetValueImage = function(Value, RawValue)
	            if not Value then
	                return nil
	            end

	            local ValueImage = nil
	            if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
	                local PlayerValue = Value
	                if typeof(PlayerValue) ~= "Instance" and RawValue ~= nil then
	                    PlayerValue = RawValue
	                end

	                if typeof(PlayerValue) == "Instance" and PlayerValue:IsA("Player") then
	                    ValueImage = { Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(PlayerValue.UserId)) }
	                end
	            end

	            if Dropdown.ValueImages then
	                local IconRef = Dropdown.ValueImages[Value]
	                if IconRef == nil and RawValue ~= nil then
	                    IconRef = Dropdown.ValueImages[RawValue]
	                end

	                if IconRef then
	                    ValueImage = Library:GetCustomIcon(IconRef)
	                end
	            end

	            return ValueImage
	        end

	        local MenuTable
	        MenuTable = Library:AddContextMenu(
	            DisplayContainer,
	            function()
	                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
	            end,
	            function()
	                return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
	            end,
	            2,
	            function(Active: boolean)
	                DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

	                SetIconProperties(ArrowImage, { ImageTransparency = Active and 0 or 0.5, Rotation = Active and 180 or 0 })

	                if SearchBox then
	                    SearchBox.Text = ""
	                    SearchBox.Visible = Active
	                end

	                local Half = UDim.new(0, Library.CornerRadius / 2)
	                local Zero = UDim.new(0, 0)

	                DropdownCorner.TopLeftRadius = Half
	                DropdownCorner.TopRightRadius = Half
	                DropdownCorner.BottomRightRadius = Active and Zero or Half
	                DropdownCorner.BottomLeftRadius = Active and Zero or Half

	                local MenuCorner = MenuTable and MenuTable.Corner
	                if MenuCorner then
	                    MenuCorner.TopLeftRadius = Zero
	                    MenuCorner.TopRightRadius = Zero
	                    MenuCorner.BottomRightRadius = Half
	                    MenuCorner.BottomLeftRadius = Half
	                end
	            end,
	            false,
	            "bottom",
	            "Dropdown"
	        )
	        Dropdown.Menu = MenuTable

	        local ItemHeight = 21
	        local PoolSize = math.max(1, Info.MaxVisibleDropdownItems + 2)
	        local Pool = {}
	        local FilteredEntries = {}

	        function Dropdown:RecalculateListSize(Count)
	            local ItemCount = Count or #FilteredEntries
	            local Y = math.clamp(ItemCount * ItemHeight, 0, Info.MaxVisibleDropdownItems * ItemHeight)

	            MenuTable.Menu.CanvasSize = UDim2.fromOffset(0, ItemCount * ItemHeight)

	            MenuTable:SetSize(function()
	                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), Y)
	            end)
	        end

	        function Dropdown:UpdateColors()
	            if Library.Unloaded then
	                return
	            end

	            Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
	            DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
	            SetIconProperties(DisplayImage, { ImageTransparency = Dropdown.Disabled and 0.8 or 0 })
	            SetIconProperties(ArrowImage, { ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5 })
	        end

	        function Dropdown:Display()
	            if Library.Unloaded then
	                return
	            end

	            local Str = ""
	            local ValueImage = nil
	            local IsDictionary = not IsSequentialArray(Dropdown.Values)

	            if Info.Multi then
	                for Key, RawValue in Dropdown.Values do
	                    local Value = IsDictionary and Key or RawValue

	                    if Dropdown.Value[Value] then
	                        if not ValueImage then
	                            ValueImage = GetValueImage(Value, RawValue)
	                        end

	                        Str = Str
	                            .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(RawValue)) or tostring(RawValue))
	                            .. ", "
	                    end
	                end

	                Str = Str:sub(1, #Str - 2)
	            else
	                local DisplayValue = Dropdown.Value
	                if IsDictionary and Dropdown.Value ~= nil then
	                    DisplayValue = Dropdown.Values[Dropdown.Value]
	                end

	                ValueImage = GetValueImage(Dropdown.Value, DisplayValue)
	                Str = DisplayValue and tostring(DisplayValue) or ""

	                if Str ~= "" and Info.FormatDisplayValue then
	                    Str = tostring(Info.FormatDisplayValue(Str))
	                end
	            end

	            if #Str > 25 then
	                Str = Str:sub(1, 22) .. "..."
	            end

	            DisplayButton.Text = (Str == "" and "---" or Str)

	            DisplayImage = Library:ApplyIcon(DisplayImage, ValueImage)
	            SetIconProperties(DisplayImage, { ImageTransparency = if ValueImage then 0 else 1 })

	            DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
	            DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
	        end

	        function Dropdown:OnChanged(Func)
	            Dropdown.Changed = Func
	        end

	        function Dropdown:GetActiveValues(ReturnCount)
	            local Table = {}

	            if Info.Multi then
	                for Value, _ in Dropdown.Value do
	                    table.insert(Table, Value)
	                end
	            else
	                if Dropdown.Value then
	                    table.insert(Table, Dropdown.Value)
	                end
	            end

	            return ReturnCount == true and GetTableSize(Table) or Table
	        end

	        local DragSelecting = false
	        local DragStartIndex = nil
	        local DragPrevMin = nil
	        local DragPrevMax = nil
	        local DragLastIndex = nil
	        local DragInitialValues = {}
	        local DragInputEndedConn = nil
	        local DragInputChangedConn = nil

	        local function RecomputeFilteredEntries()
	            local Values = Dropdown.Values
	            local DisabledValues = Dropdown.DisabledValues
	            local IsDictionary = not IsSequentialArray(Values)

	            --// Fuzzy-match dropdown values the same way the sidebar search
	            --// does, so e.g. "clr" can find "Clear Inventory" in a list \\--
	            local SearchQuery = SearchBox and NormalizeSearch(LowerText(SearchBox.Text)) or ""
	            local IsSearching = SearchQuery ~= ""

	            local EnabledList, DisabledList = {}, {}
	            local Pending = {}

	            for Key, RawValue in Values do
	                local Value = IsDictionary and Key or RawValue

	                local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(RawValue) or RawValue)

	                local MatchScore = 0
	                if IsSearching then
	                    local Matched, Score = FuzzyScore(LowerText(FormattedValue), SearchQuery)
	                    if not Matched then
	                        continue
	                    end
	                    MatchScore = Score
	                end

	                local IsDisabled = table.find(DisabledValues, Value) ~= nil
	                    or (RawValue ~= nil and RawValue ~= Value and table.find(DisabledValues, RawValue) ~= nil)

	                local Entry = {
	                    Value = Value,
	                    RawValue = RawValue,
	                    FormattedValue = FormattedValue,
	                    IsDisabled = IsDisabled,
	                    ValueImage = GetValueImage(Value, RawValue),
	                    SortKey = Key,
	                    MatchScore = MatchScore,
	                    Order = #Pending + 1,
	                }

	                table.insert(Pending, Entry)
	            end

	            if IsSearching then
	                --// Best matches first; ties fall back to original order \\--
	                table.sort(Pending, function(A, B)
	                    if A.MatchScore ~= B.MatchScore then
	                        return A.MatchScore > B.MatchScore
	                    end
	                    return A.Order < B.Order
	                end)
	            elseif not IsDictionary then
	                table.sort(Pending, function(A, B)
	                    return A.SortKey < B.SortKey
	                end)
	            end

	            table.clear(FilteredEntries)

	            if Dropdown.KeepDisabledValuePosition then
	                for _, Entry in Pending do
	                    table.insert(FilteredEntries, Entry)
	                end
	                return
	            end

	            for _, Entry in Pending do
	                if Entry.IsDisabled then
	                    table.insert(DisabledList, Entry)
	                else
	                    table.insert(EnabledList, Entry)
	                end
	            end

	            for _, Entry in EnabledList do
	                table.insert(FilteredEntries, Entry)
	            end
	            for _, Entry in DisabledList do
	                table.insert(FilteredEntries, Entry)
	            end
	        end

	        local function GetFirstVisibleIndex()
	            local Total = #FilteredEntries
	            if Total <= PoolSize then
	                return 1
	            end

	            local MaxFirst = Total - PoolSize + 1
	            local ScrollY = MenuTable.Menu.CanvasPosition.Y / Library.DPIScale
	            local Index = math.floor(ScrollY / ItemHeight) + 1
	            return math.clamp(Index, 1, MaxFirst)
	        end

	        function Dropdown:RefreshPool()
	            local Total = #FilteredEntries
	            local First = GetFirstVisibleIndex()

	            for SlotIndex, Row in Pool do
	                local DataIndex = First + SlotIndex - 1
	                local Entry = FilteredEntries[DataIndex]

	                Row.Entry = Entry
	                Row.Index = Entry and DataIndex or nil

	                if not Entry then
	                    Row.Container.Visible = false
	                    continue
	                end

	                Row.Container.Visible = true
	                Row.Container.Position = UDim2.fromOffset(0, (DataIndex - 1) * ItemHeight)

	                local IsLast = DataIndex == Total
	                Row.Corner.BottomRightRadius = IsLast and UDim.new(0, Library.CornerRadius / 2) or UDim.new(0, 0)
	                Row.Corner.BottomLeftRadius = IsLast and UDim.new(0, Library.CornerRadius / 2) or UDim.new(0, 0)

	                Row.Button.Text = Entry.FormattedValue

	                if Entry.ValueImage then
	                    Row.Image = Library:ApplyIcon(Row.Image, Entry.ValueImage)
	                    Row.Image.Visible = true
	                    Row.Button.Size = UDim2.new(1, -18, 0, ItemHeight)
	                    Row.Button.Position = UDim2.fromOffset(18, 0)
	                else
	                    Row.Image.Visible = false
	                    Row.Button.Size = UDim2.new(1, 0, 0, ItemHeight)
	                    Row.Button.Position = UDim2.fromOffset(0, 0)
	                end

	                Row:UpdateButton()
	            end
	        end

	        function Dropdown:RunChanged()
	            if Dropdown.Disabled then
	                return
	            end

	            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
	            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
	        end

	        local function StopDragSelect()
	            DragSelecting = false
	            DragStartIndex = nil
	            DragPrevMin = nil
	            DragPrevMax = nil
	            DragLastIndex = nil
	            table.clear(DragInitialValues)

	            if DragInputEndedConn then
	                DragInputEndedConn:Disconnect()
	                DragInputEndedConn = nil
	            end

	            if DragInputChangedConn then
	                DragInputChangedConn:Disconnect()
	                DragInputChangedConn = nil
	            end
	        end

	        local DragActiveCount = 0

	        local function ApplyDragIndex(Index, InRange)
	            local Entry = FilteredEntries[Index]
	            if not Entry or Entry.IsDisabled then
	                return
	            end

	            local Try = DragInitialValues[Entry.Value]
	            if InRange then
	                Try = not Try
	            end

	            local WantActive = Try and true or false
	            local IsActive = Dropdown.Value[Entry.Value] and true or false
	            if WantActive == IsActive then
	                return
	            end

	            if not WantActive and DragActiveCount == 1 and not Info.AllowNull then
	                return
	            end

	            Dropdown.Value[Entry.Value] = WantActive and true or nil
	            DragActiveCount += WantActive and 1 or -1
	        end

	        local function ApplyDragRange(From, To, InRange)
	            for Index = From, To do
	                ApplyDragIndex(Index, InRange)
	            end
	        end

	        local function UpdateDrag(CurrentIndex)
	            if CurrentIndex == nil or CurrentIndex == DragLastIndex then
	                return
	            end

	            DragLastIndex = CurrentIndex

	            local Min = math.min(DragStartIndex, CurrentIndex)
	            local Max = math.max(DragStartIndex, CurrentIndex)
	            DragActiveCount = Dropdown:GetActiveValues(true)

	            if DragPrevMin == nil then
	                ApplyDragRange(Min, Max, true)
	            else
	                if DragPrevMin < Min then
	                    ApplyDragRange(DragPrevMin, Min - 1, false)
	                end
	                if DragPrevMax > Max then
	                    ApplyDragRange(Max + 1, DragPrevMax, false)
	                end
	                if Min < DragPrevMin then
	                    ApplyDragRange(Min, DragPrevMin - 1, true)
	                end
	                if Max > DragPrevMax then
	                    ApplyDragRange(DragPrevMax + 1, Max, true)
	                end
	            end

	            DragPrevMin = Min
	            DragPrevMax = Max

	            for _, OtherRow in Pool do
	                OtherRow:UpdateButton()
	            end
	        end

	        local function CreatePoolRow()
	            local Row = {
	                Entry = nil,
	                Index = nil
	            }

	            local Container = New("Frame", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, ItemHeight),
	                Visible = false,
	                Parent = MenuTable.Menu,
	            })

	            local Corner = New("UICorner", {
	                TopLeftRadius = UDim.new(0, 0),
	                TopRightRadius = UDim.new(0, 0),
	                BottomRightRadius = UDim.new(0, 0),
	                BottomLeftRadius = UDim.new(0, 0),
	                Parent = Container,
	            }); table.insert(Library.SpecificCorners, Corner)

	            local Image = Library:CreateIcon(nil, {
	                ImageTransparency = 0.5,
	                Size = UDim2.fromOffset(16, 16),
	                Position = UDim2.fromOffset(4, 3),
	                Visible = false,
	                Parent = Container,
	            })

	            local Button = New("TextButton", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, ItemHeight),
	                Text = "",
	                TextSize = 14,
	                TextTransparency = 0.5,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Parent = Container,
	            })
	            New("UIPadding", {
	                PaddingLeft = UDim.new(0, 7),
	                PaddingRight = UDim.new(0, 7),
	                Parent = Button,
	            })

	            Row.Container = Container
	            Row.Corner = Corner
	            Row.Image = Image
	            Row.Button = Button

	            function Row:UpdateButton()
	                local Entry = Row.Entry
	                if not Entry then
	                    return
	                end

	                local Selected
	                if Info.Multi then
	                    Selected = Dropdown.Value[Entry.Value]
	                else
	                    Selected = Dropdown.Value == Entry.Value
	                end

	                Row.Selected = Selected and true or false

	                Container.BackgroundTransparency = Selected and 0 or 1
	                Button.TextTransparency = Entry.IsDisabled and 0.8 or Selected and 0 or 0.5

	                if Entry.ValueImage then
	                    SetIconProperties(Row.Image, { ImageTransparency = Entry.IsDisabled and 0.8 or Selected and 0 or 0.5 })
	                end
	            end

	            table.insert(Dropdown.Connections, Button.MouseButton1Click:Connect(function()
	                local Entry = Row.Entry
	                if not Entry or Entry.IsDisabled or DragSelecting then
	                    return
	                end

	                local Selected
	                if Info.Multi then
	                    Selected = Dropdown.Value[Entry.Value]
	                else
	                    Selected = Dropdown.Value == Entry.Value
	                end

	                local Try = not Selected
	                if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
	                    Selected = Try
	                    if Info.Multi then
	                        Dropdown.Value[Entry.Value] = Selected and true or nil
	                    else
	                        Dropdown.Value = Selected and Entry.Value or nil
	                    end

	                    for _, OtherRow in Pool do
	                        OtherRow:UpdateButton()
	                    end
	                end

	                Row:UpdateButton()
	                Dropdown:Display()

	                Library:UpdateDependencyBoxes()
	                Dropdown:RunChanged()
	            end))

	            table.insert(Dropdown.Connections, Button.MouseEnter:Connect(function()
	                local Entry = Row.Entry
	                if not Entry or Entry.IsDisabled then
	                    return
	                end

	                if Row.Selected then
	                    return
	                end

	                TweenService:Create(Container, Library.TweenInfo, {
	                    BackgroundTransparency = 0.85,
	                }):Play()
	                TweenService:Create(Button, Library.TweenInfo, {
	                    TextTransparency = 0.25,
	                }):Play()

	                TweenIcon(Row.Image, { ImageTransparency = 0.25 })
	            end))

	            table.insert(Dropdown.Connections, Button.MouseLeave:Connect(function()
	                local Entry = Row.Entry
	                if not Entry or Entry.IsDisabled then
	                    return
	                end

	                if Row.Selected then
	                    return
	                end

	                TweenService:Create(Container, Library.TweenInfo, {
	                    BackgroundTransparency = 1,
	                }):Play()
	                TweenService:Create(Button, Library.TweenInfo, {
	                    TextTransparency = 0.5,
	                }):Play()

	                TweenIcon(Row.Image, { ImageTransparency = 0.5 })
	            end))

	            table.insert(Dropdown.Connections, Button.InputBegan:Connect(function(StartInput)
	                if not (Info.Multi and Dropdown.DragSelect and not Library.IsMobile) then
	                    return
	                end

	                local Entry = Row.Entry
	                if not Entry or Entry.IsDisabled then
	                    return
	                end

	                if not IsMouseInput(StartInput) then
	                    return
	                end

	                DragSelecting = true
	                DragStartIndex = Row.Index
	                table.clear(DragInitialValues)

	                for _, FilteredEntry in FilteredEntries do
	                    DragInitialValues[FilteredEntry.Value] = Dropdown.Value[FilteredEntry.Value]
	                end

	                UpdateDrag(Row.Index)

	                if DragInputEndedConn then DragInputEndedConn:Disconnect() end
	                if DragInputChangedConn then DragInputChangedConn:Disconnect() end

	                DragInputChangedConn = Library:GiveSignal(UserInputService.InputChanged:Connect(function(ChangeInput)
	                    if not IsMovementInput(ChangeInput) and ChangeInput ~= StartInput then
	                        return
	                    end

	                    local Pos = ChangeInput.Position
	                    for _, OtherRow in Pool do
	                        if OtherRow.Entry and Library:MouseIsOverFrame(OtherRow.Button, Pos) then
	                            UpdateDrag(OtherRow.Index)
	                            break
	                        end
	                    end
	                end))

	                DragInputEndedConn = Library:GiveSignal(UserInputService.InputEnded:Connect(function(EndInput)
	                    if EndInput ~= StartInput and not (IsMouseInput(EndInput) and EndInput.UserInputType == StartInput.UserInputType) then
	                        return
	                    end

	                    Dropdown:Display()
	                    Library:UpdateDependencyBoxes()
	                    Dropdown:RunChanged()

	                    StopDragSelect()
	                end))

	                table.insert(Dropdown.Connections, DragInputEndedConn)
	                table.insert(Dropdown.Connections, DragInputChangedConn)
	            end))

	            return Row
	        end

	        function Dropdown:BuildDropdownList()
	            StopDragSelect()

	            RecomputeFilteredEntries()

	            MenuTable.Menu.CanvasPosition = Vector2.new(0, 0)

	            Dropdown:RefreshPool()
	            Dropdown:RecalculateListSize(#FilteredEntries)
	        end

	        for _ = 1, PoolSize do
	            table.insert(Pool, CreatePoolRow())
	        end

	        table.insert(Dropdown.Connections, MenuTable.Menu:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	            Dropdown:RefreshPool()
	        end))

	        local function ValueExists(Val)
	            if IsSequentialArray(Dropdown.Values) then
	                for _, Existing in Dropdown.Values do
	                    if Existing == Val then
	                        return true
	                    end
	                end

	                return false
	            end

	            return Dropdown.Values[Val] ~= nil
	        end

	        function Dropdown:SetValue(Value)
	            if Info.Multi then
	                if typeof(Value) == "string" then
	                    Value = if Value == "" then {} else { [Value] = true }
	                end

	                local Table = {}

	                for Val, Active in Value or {} do
	                    if typeof(Active) ~= "boolean" then
	                        Table[Active] = true
	                    elseif Active and ValueExists(Val) then
	                        Table[Val] = true
	                    end
	                end

	                Dropdown.Value = Table
	            else
	                if ValueExists(Value) then
	                    Dropdown.Value = Value
	                elseif not Value then
	                    Dropdown.Value = nil
	                end
	            end

	            Dropdown:Display()
	            for _, Row in Pool do
	                Row:UpdateButton()
	            end

	            if not Dropdown.Disabled then
	                Library:UpdateDependencyBoxes()
	            end

	            Dropdown:RunChanged()
	        end

	        function Dropdown:SetValues(Values)
	            Dropdown.Values = Values

	            local Changed = false
	            if Info.Multi then
	                for Val in Dropdown.Value do
	                    if not ValueExists(Val) then
	                        Dropdown.Value[Val] = nil
	                        Changed = true
	                    end
	                end

	            elseif Dropdown.Value ~= nil and not ValueExists(Dropdown.Value) then
	                Dropdown.Value = nil
	                Changed = true
	            end

	            Dropdown:BuildDropdownList()
	            Dropdown:Display()

	            if Changed and not Dropdown.Disabled then
	                Library:UpdateDependencyBoxes()
	            end

	            if Changed then
	                Dropdown:RunChanged()
	            end
	        end

	        function Dropdown:AddValues(Values)
	            if typeof(Values) ~= "table" and typeof(Values) ~= "string" then
	                return
	            end

	            local IsDictionary = not IsSequentialArray(Dropdown.Values)
	            if IsDictionary then
	                if typeof(Values) == "string" then
	                    Dropdown.Values[Values] = Values

	                elseif IsSequentialArray(Values) then
	                    for _, Val in Values do
	                        Dropdown.Values[Val] = Val
	                    end

	                else
	                    for Key, Val in Values do
	                        Dropdown.Values[Key] = Val
	                    end
	                end
	            else
	                if typeof(Values) == "table" then
	                    for _, Val in Values do
	                        table.insert(Dropdown.Values, Val)
	                    end
	                else
	                    table.insert(Dropdown.Values, Values)
	                end
	            end

	            Dropdown:BuildDropdownList()
	        end

	        function Dropdown:SetDisabledValues(DisabledValues)
	            Dropdown.DisabledValues = DisabledValues
	            Dropdown:BuildDropdownList()
	        end

	        function Dropdown:AddDisabledValues(DisabledValues)
	            if typeof(DisabledValues) == "table" then
	                for _, val in DisabledValues do
	                    table.insert(Dropdown.DisabledValues, val)
	                end
	            elseif typeof(DisabledValues) == "string" then
	                table.insert(Dropdown.DisabledValues, DisabledValues)
	            else
	                return
	            end

	            Dropdown:BuildDropdownList()
	        end

	        function Dropdown:SetValueImages(ValueImages)
	            if typeof(ValueImages) ~= "table" then
	                return
	            end

	            Dropdown.ValueImages = ValueImages
	            Dropdown:BuildDropdownList()
	        end

	        function Dropdown:AddValueImages(ValueImages)
	            if typeof(ValueImages) ~= "table" then
	                return
	            end

	            for key, val in ValueImages do
	                Dropdown.ValueImages[key] = val
	            end

	            Dropdown:BuildDropdownList()
	        end

	        function Dropdown:SetDisabled(Disabled: boolean)
	            Dropdown.Disabled = Disabled

	            if Dropdown.TooltipTable then
	                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
	            end

	            MenuTable:Close()
	            DisplayButton.Active = not Dropdown.Disabled
	            Dropdown:UpdateColors()
	            Library:UpdateAddons(Dropdown)

	            Library:UpdateDependencyBoxes()
	        end

	        function Dropdown:SetVisible(Visible: boolean)
	            Dropdown.Visible = Visible

	            Holder.Visible = Dropdown.Visible
	            Groupbox:Resize()
	        end

	        function Dropdown:SetText(Text: string)
	            Dropdown.Text = Text
	            Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

	            Label.Text = Text and Text or ""
	            Label.Visible = not not Text
	        end

	        function Dropdown:SetDragSelect(Value: boolean)
	            if not Info.Multi or Library.IsMobile then
	                Value = false
	            end

	            Dropdown.DragSelect = Value == true
	            Dropdown:BuildDropdownList()
	        end

	        local ToggleDropdown = function()
	            if Dropdown.Disabled then
	                return
	            end

	            MenuTable:Toggle()
	        end

	        table.insert(Dropdown.Connections, DisplayContainer.MouseButton1Click:Connect(ToggleDropdown))
	        table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

	        if SearchBox then
	            table.insert(Dropdown.Connections, SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList))
	        end

	        local Defaults = (function()
	            local Resolved = {}
	            local Default = Info.Default
	            if Default == nil then
	                return Resolved
	            end

	            local IsDictionary = not IsSequentialArray(Dropdown.Values)
	            local function ResolveOne(Candidate)
	                if IsDictionary then
	                    return Dropdown.Values[Candidate] ~= nil and Candidate or nil
	                end

	                for _, Existing in Dropdown.Values do
	                    if Existing == Candidate then
	                        return Existing
	                    end
	                end

	                return nil
	            end

	            local DefaultType = typeof(Default)
	            if DefaultType == "string" then
	                local Value = ResolveOne(Default)
	                if Value ~= nil then
	                    table.insert(Resolved, Value)
	                end

	            elseif DefaultType == "table" then
	                for _, Candidate in Default do
	                    local Value = ResolveOne(Candidate)
	                    if Value ~= nil then
	                        table.insert(Resolved, Value)
	                    end
	                end

	            elseif Dropdown.Values[Default] ~= nil then
	                table.insert(Resolved, IsDictionary and Default or Dropdown.Values[Default])
	            end

	            return Resolved
	        end)()

	        for _, SelectValue in Defaults do
	            if Info.Multi then
	                Dropdown.Value[SelectValue] = true
	            else
	                Dropdown.Value = SelectValue
	                break
	            end
	        end

	        if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
	            Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
	            Dropdown.TooltipTable.Disabled = Dropdown.Disabled
	        end

	        Dropdown:UpdateColors()
	        Dropdown:Display()
	        Dropdown:BuildDropdownList()
	        Groupbox:Resize()

	        Dropdown.Holder = Holder
	        Dropdown.Label = Label
	        Dropdown.Container = DisplayContainer

	        Dropdown.AddSettings = BaseAddons.__index.AddSettings
	        table.insert(Groupbox.Elements, Dropdown)

	        Dropdown.Default = Defaults
	        Dropdown.DefaultValues = Dropdown.Values

	        Options[Idx] = Dropdown

	        function Dropdown:Destroy()
	            Dropdown.Destroyed = true

	            StopDragSelect()

	            if Dropdown.Connections then
	                for _, Connection in Dropdown.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Dropdown.Addons then
	                for Index = #Dropdown.Addons, 1, -1 do
	                    local Addon = table.remove(Dropdown.Addons, Index)
	                    if Addon and Addon.Destroy then
	                        Addon:Destroy()
	                    end
	                end
	            end

	            if Dropdown.TooltipTable then
	                Dropdown.TooltipTable:Destroy()
	            end

	            if MenuTable then
	                MenuTable:Destroy()
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Dropdown)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Dropdown
	    end

	    function Funcs:AddViewport(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.Viewport)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Dragging, Pinching = false, false
	        local LastMousePos, LastPinchDist = nil, 0

	        local ViewportObject = Info.Object
	        if Info.Clone and typeof(Info.Object) == "Instance" then
	            if Info.Object.Archivable then
	                ViewportObject = ViewportObject:Clone()
	            else
	                Info.Object.Archivable = true
	                ViewportObject = ViewportObject:Clone()
	                Info.Object.Archivable = false
	            end
	        end

	        local Viewport = {
	            Connections = {},
	            Destroyed = false,

	            Object = ViewportObject :: PVInstance,
	            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
	            Interactive = Info.Interactive,
	            AutoFocus = Info.AutoFocus,
	            Visible = Info.Visible,
	            Type = "Viewport",
	        }

	        assert(
	            typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
	            "Instance must be a BasePart or Model."
	        )

	        assert(
	            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
	            "Camera must be a valid Camera instance."
	        )

	        local function GetModelSize(model)
	            if model:IsA("BasePart") then
	                return model.Size
	            end

	            return select(2, model:GetBoundingBox())
	        end

	        local function FocusCamera()
	            local ModelSize = GetModelSize(Viewport.Object)
	            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
	            local CameraDistance = MaxExtent * 2
	            local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

	            Viewport.Camera.CFrame = CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
	        end

	        local function GetPivotPosition()
	            return (Viewport.Object :: PVInstance):GetPivot().Position
	        end

	        local function OrbitCamera(Yaw: number, Pitch: number)
	            local Position = GetPivotPosition()
	            local Camera = Viewport.Camera

	            local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), Yaw)
	            Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

	            local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, Pitch)
	            local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

	            if PitchedCFrame.UpVector.Y > 0.1 then
	                Camera.CFrame = PitchedCFrame
	            end
	        end

	        local function ZoomCamera(Amount: number)
	            Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * Amount
	        end

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, Info.Height),
	            Visible = Viewport.Visible,
	            Parent = Container,
	        })

	        local Box = New("Frame", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = "MainColor",
	            BorderColor3 = "OutlineColor",
	            BorderSizePixel = 1,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.fromScale(1, 1),
	            Parent = Holder,
	        })

	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 3),
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 8),
	            PaddingTop = UDim.new(0, 4),
	            Parent = Box,
	        })

	        local ViewportFrame = New("ViewportFrame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Parent = Box,
	            CurrentCamera = Viewport.Camera,
	            Active = Viewport.Interactive,
	        })

	        table.insert(Viewport.Connections, ViewportFrame.MouseEnter:Connect(function()
	            if not Viewport.Interactive then
	                return
	            end

	            for _, Side in Groupbox.Tab.Sides do
	                Side.ScrollingEnabled = false
	            end
	        end))

	        table.insert(Viewport.Connections, ViewportFrame.MouseLeave:Connect(function()
	            if not Viewport.Interactive then
	                return
	            end

	            for _, Side in Groupbox.Tab.Sides do
	                Side.ScrollingEnabled = true
	            end
	        end))

	        table.insert(Viewport.Connections, ViewportFrame.InputBegan:Connect(function(input)
	            if not Viewport.Interactive then
	                return
	            end

	            if input.UserInputType == Enum.UserInputType.MouseButton2 or (input.UserInputType == Enum.UserInputType.Touch and not Pinching) then
	                Dragging = true
	                LastMousePos = input.Position
	            end
	        end))

	        table.insert(Viewport.Connections, UserInputService.InputEnded:Connect(function(input)
	            if Library.Unloaded then
	                return
	            end

	            if not Viewport.Interactive then
	                return
	            end

	            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
	                Dragging = false
	            end
	        end))

	        table.insert(Viewport.Connections, UserInputService.InputChanged:Connect(function(input)
	            if Library.Unloaded then
	                return
	            end

	            if not Viewport.Interactive or not Dragging or Pinching then
	                return
	            end

	            if
	                input.UserInputType == Enum.UserInputType.MouseMovement
	                or input.UserInputType == Enum.UserInputType.Touch
	            then
	                local MouseDelta = input.Position - LastMousePos
	                LastMousePos = input.Position

	                OrbitCamera(-MouseDelta.X * 0.01, -MouseDelta.Y * 0.01)
	            end
	        end))

	        table.insert(Viewport.Connections, ViewportFrame.InputChanged:Connect(function(input)
	            if not Viewport.Interactive then
	                return
	            end

	            if input.UserInputType == Enum.UserInputType.MouseWheel then
	                ZoomCamera(input.Position.Z * 2)
	            end
	        end))

	        table.insert(Viewport.Connections, UserInputService.TouchPinch:Connect(function(touchPositions, _, _, state)
	            if Library.Unloaded then
	                return
	            end

	            if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
	                return
	            end

	            if state == Enum.UserInputState.Begin then
	                Pinching = true
	                Dragging = false
	                LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
	            elseif state == Enum.UserInputState.Change then
	                local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
	                local delta = (currentDist - LastPinchDist) * 0.1
	                LastPinchDist = currentDist
	                ZoomCamera(delta)
	            elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
	                Pinching = false
	            end
	        end))

	        ;(Viewport.Object :: PVInstance).Parent = ViewportFrame
	        if Viewport.AutoFocus then
	            FocusCamera()
	        end

	        function Viewport:SetObject(Object: Instance, Clone: boolean?)
	            assert(Object, "Object cannot be nil.")

	            if Clone then
	                Object = Object:Clone()
	            end

	            if Viewport.Object then
	                Viewport.Object:Destroy()
	            end

	            Viewport.Object = Object
	            ;(Viewport.Object :: PVInstance).Parent = ViewportFrame

	            Groupbox:Resize()
	        end

	        function Viewport:SetHeight(Height: number)
	            assert(Height > 0, "Height must be greater than 0.")

	            Holder.Size = UDim2.new(1, 0, 0, Height)
	            Groupbox:Resize()
	        end

	        function Viewport:Focus()
	            if not Viewport.Object then
	                return
	            end

	            FocusCamera()
	        end

	        function Viewport:SetCamera(Camera: Instance)
	            assert(
	                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
	                "Camera must be a valid Camera instance."
	            )

	            Viewport.Camera = Camera
	            ViewportFrame.CurrentCamera = Camera
	        end

	        function Viewport:SetCameraCFrame(NewCFrame: CFrame)
	            assert(typeof(NewCFrame) == "CFrame", "CFrame must be a valid CFrame.")

	            Viewport.Camera.CFrame = NewCFrame
	        end

	        function Viewport:GetCameraCFrame(): CFrame
	            return Viewport.Camera.CFrame
	        end

	        function Viewport:Rotate(Yaw: number, Pitch: number?)
	            if not Viewport.Object then
	                return
	            end

	            OrbitCamera(math.rad(Yaw or 0), math.rad(Pitch or 0))
	        end

	        function Viewport:Zoom(Amount: number)
	            assert(typeof(Amount) == "number", "Amount must be a number.")

	            ZoomCamera(Amount)
	        end

	        function Viewport:LookAt(Target: Vector3?)
	            if not Target and not Viewport.Object then
	                return
	            end

	            Viewport.Camera.CFrame = CFrame.lookAt(Viewport.Camera.CFrame.Position, Target or GetPivotPosition())
	        end

	        function Viewport:SetDistance(Distance: number)
	            assert(typeof(Distance) == "number" and Distance > 0, "Distance must be greater than 0.")
	            if not Viewport.Object then
	                return
	            end

	            local Position = GetPivotPosition()
	            local Offset = Viewport.Camera.CFrame.Position - Position
	            local Direction = Offset.Magnitude > 0 and Offset.Unit or -Viewport.Camera.CFrame.LookVector

	            Viewport.Camera.CFrame = CFrame.lookAt(Position + Direction * Distance, Position)
	        end

	        function Viewport:GetDistance(): number
	            if not Viewport.Object then
	                return 0
	            end

	            return (Viewport.Camera.CFrame.Position - GetPivotPosition()).Magnitude
	        end

	        function Viewport:SetFieldOfView(FieldOfView: number)
	            assert(typeof(FieldOfView) == "number", "FieldOfView must be a number.")

	            Viewport.Camera.FieldOfView = math.clamp(FieldOfView, 1, 120)
	        end

	        function Viewport:SetInteractive(Interactive: boolean)
	            Viewport.Interactive = Interactive
	            ViewportFrame.Active = Interactive
	        end

	        function Viewport:SetVisible(Visible: boolean)
	            Viewport.Visible = Visible

	            Holder.Visible = Viewport.Visible
	            Groupbox:Resize()
	        end

	        Groupbox:Resize()

	        Viewport.Holder = Holder
	        table.insert(Groupbox.Elements, Viewport)

	        Options[Idx] = Viewport

	        function Viewport:Destroy()
	            Viewport.Destroyed = true

	            if Viewport.Connections then
	                for _, Connection in Viewport.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Viewport)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Viewport
	    end

	    function Funcs:AddImage(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.Image)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Image = {
	            Connections = {},
	            Destroyed = false,

	            Image = Info.Image,
	            Color = Info.Color,
	            RectOffset = Info.RectOffset,
	            RectSize = Info.RectSize,
	            Height = Info.Height,
	            ScaleType = Info.ScaleType,
	            Transparency = Info.Transparency,
	            BackgroundTransparency = Info.BackgroundTransparency,

	            Visible = Info.Visible,
	            Type = "Image",
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, Info.Height),
	            Visible = Image.Visible,
	            Parent = Container,
	        })

	        local Box = New("Frame", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = "MainColor",
	            BackgroundTransparency = Image.BackgroundTransparency,
	            ClipsDescendants = true,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.fromScale(1, 1),
	            Parent = Holder,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                Parent = Box,
	            })
	        )
	        New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = Box,
	        })

	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 3),
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 8),
	            PaddingTop = UDim.new(0, 4),
	            Parent = Box,
	        })

	        local Icon = Library:GetCustomIcon(Image.Image)
	        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	        local ImageLabel = New("ImageLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            ImageTransparency = Image.Transparency,
	            ImageColor3 = Image.Color,
	            ScaleType = Image.ScaleType,
	            Parent = Box,
	        })
	        FillInstance(ImageContent(Icon), ImageLabel)

	        function Image:SetHeight(Height: number)
	            assert(Height > 0, "Height must be greater than 0.")

	            Image.Height = Height
	            Holder.Size = UDim2.new(1, 0, 0, Height)
	            Groupbox:Resize()
	        end

	        function Image:SetImage(NewImage: string)
	            assert(typeof(NewImage) == "string", "Image must be a string.")

	            local Icon = Library:GetCustomIcon(NewImage)
	            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	            Image.RectOffset = Icon.ImageRectOffset
	            Image.RectSize = Icon.ImageRectSize

	            FillInstance(ImageContent(Icon), ImageLabel)
	            Image.Image = Icon.Url
	        end

	        function Image:SetColor(Color: Color3)
	            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

	            ImageLabel.ImageColor3 = Color
	            Image.Color = Color
	        end

	        function Image:SetRectOffset(RectOffset: Vector2)
	            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

	            ImageLabel.ImageRectOffset = RectOffset
	            Image.RectOffset = RectOffset
	        end

	        function Image:SetRectSize(RectSize: Vector2)
	            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

	            ImageLabel.ImageRectSize = RectSize
	            Image.RectSize = RectSize
	        end

	        function Image:SetScaleType(ScaleType: Enum.ScaleType)
	            assert(
	                typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
	                "ScaleType must be a valid Enum.ScaleType."
	            )

	            ImageLabel.ScaleType = ScaleType
	            Image.ScaleType = ScaleType
	        end

	        function Image:SetTransparency(Transparency: number)
	            assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
	            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

	            ImageLabel.ImageTransparency = Transparency
	            Image.Transparency = Transparency
	        end

	        function Image:SetVisible(Visible: boolean)
	            Image.Visible = Visible

	            Holder.Visible = Image.Visible
	            Groupbox:Resize()
	        end

	        Groupbox:Resize()

	        Image.Holder = Holder
	        table.insert(Groupbox.Elements, Image)

	        Options[Idx] = Image

	        function Image:Destroy()
	            Image.Destroyed = true

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Image)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Image
	    end

	    function Funcs:AddVideo(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.Video)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local Video = {
	            Connections = {},
	            Destroyed = false,

	            Video = Info.Video,
	            Looped = Info.Looped,
	            Playing = Info.Playing,
	            Volume = Info.Volume,
	            Height = Info.Height,
	            Visible = Info.Visible,

	            Type = "Video",
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, Info.Height),
	            Visible = Video.Visible,
	            Parent = Container,
	        })

	        local Box = New("Frame", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = "MainColor",
	            BorderColor3 = "OutlineColor",
	            BorderSizePixel = 1,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.fromScale(1, 1),
	            Parent = Holder,
	        })

	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 3),
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 8),
	            PaddingTop = UDim.new(0, 4),
	            Parent = Box,
	        })

	        local VideoFrameInstance = New("VideoFrame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Video = Video.Video,
	            Looped = Video.Looped,
	            Volume = Video.Volume,
	            Parent = Box,
	        })

	        VideoFrameInstance.Playing = Video.Playing

	        function Video:SetHeight(Height: number)
	            assert(Height > 0, "Height must be greater than 0.")

	            Video.Height = Height
	            Holder.Size = UDim2.new(1, 0, 0, Height)
	            Groupbox:Resize()
	        end

	        function Video:SetVideo(NewVideo: string)
	            assert(typeof(NewVideo) == "string", "Video must be a string.")

	            VideoFrameInstance.Video = NewVideo
	            Video.Video = NewVideo
	        end

	        function Video:SetLooped(Looped: boolean)
	            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

	            VideoFrameInstance.Looped = Looped
	            Video.Looped = Looped
	        end

	        function Video:SetVolume(Volume: number)
	            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

	            VideoFrameInstance.Volume = Volume
	            Video.Volume = Volume
	        end

	        function Video:SetPlaying(Playing: boolean)
	            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

	            VideoFrameInstance.Playing = Playing
	            Video.Playing = Playing
	        end

	        function Video:Play()
	            VideoFrameInstance.Playing = true
	            Video.Playing = true
	        end

	        function Video:Pause()
	            VideoFrameInstance.Playing = false
	            Video.Playing = false
	        end

	        function Video:SetVisible(Visible: boolean)
	            Video.Visible = Visible

	            Holder.Visible = Video.Visible
	            Groupbox:Resize()
	        end

	        Groupbox:Resize()

	        Video.Holder = Holder
	        Video.VideoFrame = VideoFrameInstance
	        table.insert(Groupbox.Elements, Video)

	        Options[Idx] = Video

	        function Video:Destroy()
	            Video.Destroyed = true

	            if Video.Connections then
	                for _, Connection in Video.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Video)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Video
	    end

	    function Funcs:AddUIPassthrough(Idx, Info)
	        if self.Destroyed then return nil end

	        Info = Library:Validate(Info, Templates.UIPassthrough)

	        local Groupbox = self
	        local Container = Groupbox.Container

	        assert(Info.Instance, "Instance must be provided.")
	        assert(
	            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
	            "Instance must inherit from GuiBase2d."
	        )
	        assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

	        local Passthrough = {
	            Connections = {},
	            Destroyed = false,

	            Instance = Info.Instance,
	            Height = Info.Height,
	            Visible = Info.Visible,

	            Type = "UIPassthrough",
	        }

	        local Holder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, Info.Height),
	            Visible = Passthrough.Visible,
	            Parent = Container,
	        })

	        Passthrough.Instance.Parent = Holder

	        Groupbox:Resize()

	        function Passthrough:SetHeight(Height: number)
	            assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

	            Passthrough.Height = Height
	            Holder.Size = UDim2.new(1, 0, 0, Height)
	            Groupbox:Resize()
	        end

	        function Passthrough:SetInstance(Instance: Instance)
	            assert(Instance, "Instance must be provided.")
	            assert(
	                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
	                "Instance must inherit from GuiBase2d."
	            )

	            if Passthrough.Instance then
	                Passthrough.Instance.Parent = nil
	            end

	            Passthrough.Instance = Instance
	            Passthrough.Instance.Parent = Holder
	        end

	        function Passthrough:SetVisible(Visible: boolean)
	            Passthrough.Visible = Visible

	            Holder.Visible = Passthrough.Visible
	            Groupbox:Resize()
	        end

	        Passthrough.Holder = Holder
	        table.insert(Groupbox.Elements, Passthrough)

	        Options[Idx] = Passthrough

	        function Passthrough:Destroy()
	            Passthrough.Destroyed = true

	            if Passthrough.Connections then
	                for _, Connection in Passthrough.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Holder then
	                Holder:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.Elements, Passthrough)
	            if ElemIdx then
	                table.remove(Groupbox.Elements, ElemIdx)
	            end

	            Groupbox:Resize()
	            Options[Idx] = nil
	        end

	        return Passthrough
	    end

	    function Funcs:AddDependencyBox()
	        if self.Destroyed then return nil end

	        local Groupbox = self
	        local Container = Groupbox.Container

	        local DepboxContainer
	        local DepboxList

	        do
	            DepboxContainer = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Visible = false,
	                Parent = Container,
	            })

	            DepboxList = New("UIListLayout", {
	                Padding = UDim.new(0, 8),
	                Parent = DepboxContainer,
	            })
	        end

	        local Depbox = {
	            Connections = {},
	            Destroyed = false,

	            Visible = false,
	            Dependencies = {},

	            Holder = DepboxContainer,
	            Container = DepboxContainer,

	            Elements = {},
	            DependencyBoxes = {}
	        }

	        function Depbox:Resize()
	            DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
	            Groupbox:Resize()
	        end

	        function Depbox:Update(CancelSearch)
	            for _, Dependency in Depbox.Dependencies do
	                local Element = Dependency[1]
	                local Value = Dependency[2]

	                if Element.Disabled then
	                    DepboxContainer.Visible = false
	                    Depbox.Visible = false
	                    return
	                end

	                if Element.Type == "Toggle" and Element.Value ~= Value then
	                    DepboxContainer.Visible = false
	                    Depbox.Visible = false
	                    return
	                elseif Element.Type == "Dropdown" then
	                    if typeof(Element.Value) == "table" then
	                        if not Element.Value[Value] then
	                            DepboxContainer.Visible = false
	                            Depbox.Visible = false
	                            return
	                        end
	                    else
	                        if Element.Value ~= Value then
	                            DepboxContainer.Visible = false
	                            Depbox.Visible = false
	                            return
	                        end
	                    end
	                end
	            end

	            Depbox.Visible = true
	            DepboxContainer.Visible = true
	            if not Library.Searching then
	                task.defer(function()
	                    Depbox:Resize()
	                end)
	            elseif not CancelSearch then
	                Library:UpdateSearch(Library.SearchText)
	            end
	        end

	        table.insert(Depbox.Connections, DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	            if not Depbox.Visible then
	                return
	            end

	            Depbox:Resize()
	        end))

	        function Depbox:SetupDependencies(Dependencies)
	            for _, Dependency in Dependencies do
	                assert(typeof(Dependency) == "table", "Dependency should be a table.")
	                assert(Dependency[1] ~= nil, "Dependency is missing element.")
	                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
	            end

	            Depbox.Dependencies = Dependencies
	            Depbox:Update()
	        end

	        table.insert(Depbox.Connections, DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
	            Depbox:Resize()
	        end))

	        setmetatable(Depbox, BaseGroupbox)

	        table.insert(Groupbox.DependencyBoxes, Depbox)
	        table.insert(Library.DependencyBoxes, Depbox)

	        function Depbox:Destroy()
	            Depbox.Destroyed = true

	            if Depbox.Connections then
	                for _, Connection in Depbox.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            for _, Element in Depbox.Elements do
	                if Element.Destroy then
	                    Element:Destroy()
	                end
	            end

	            for _, SubDepbox in Depbox.DependencyBoxes do
	                if SubDepbox.Destroy then
	                    SubDepbox:Destroy()
	                end
	            end

	            if DepboxContainer then
	                DepboxContainer:Destroy()
	            end

	            local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
	            if ElemIdx then
	                table.remove(Groupbox.DependencyBoxes, ElemIdx)
	            end

	            local LibIdx = table.find(Library.DependencyBoxes, Depbox)
	            if LibIdx then
	                table.remove(Library.DependencyBoxes, LibIdx)
	            end
	        end

	        return Depbox
	    end

	    function Funcs:AddDependencyGroupbox()
	        if self.Destroyed then return nil end

	        local Groupbox = self
	        local Tab = Groupbox.Tab
	        local BoxHolder = Groupbox.BoxHolder

	        local DepGroupboxContainer
	        local DepGroupboxList

	        do
	            DepGroupboxContainer = New("Frame", {
	                BackgroundColor3 = "BackgroundColor",
	                Size = UDim2.fromScale(1, 0),
	                Visible = false,
	                Parent = BoxHolder,
	            })
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius),
	                    Parent = DepGroupboxContainer,
	                })
	            )
	            Library:AddOutline(DepGroupboxContainer)

	            DepGroupboxList = New("UIListLayout", {
	                Padding = UDim.new(0, 8),
	                Parent = DepGroupboxContainer,
	            })
	            New("UIPadding", {
	                PaddingBottom = UDim.new(0, 7),
	                PaddingLeft = UDim.new(0, 7),
	                PaddingRight = UDim.new(0, 7),
	                PaddingTop = UDim.new(0, 7),
	                Parent = DepGroupboxContainer,
	            })
	        end

	        local DepGroupbox = {
	            Connections = {},
	            Destroyed = false,

	            Visible = false,
	            Dependencies = {},

	            BoxHolder = BoxHolder,
	            Holder = DepGroupboxContainer,
	            Container = DepGroupboxContainer,

	            Tab = Tab,
	            Elements = {},
	            DependencyBoxes = {},
	        }

	        function DepGroupbox:Resize()
	            DepGroupboxContainer.Size = UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
	            if Groupbox.RefreshBoxHolderLayout then
	                Groupbox.RefreshBoxHolderLayout()
	            end
	        end

	        function DepGroupbox:Update(CancelSearch)
	            for _, Dependency in DepGroupbox.Dependencies do
	                local Element = Dependency[1]
	                local Value = Dependency[2]

	                if Element.Disabled then
	                    DepGroupboxContainer.Visible = false
	                    DepGroupbox.Visible = false
	                    return
	                end

	                if Element.Type == "Toggle" and Element.Value ~= Value then
	                    DepGroupboxContainer.Visible = false
	                    DepGroupbox.Visible = false
	                    return
	                elseif Element.Type == "Dropdown" then
	                    if typeof(Element.Value) == "table" then
	                        if not Element.Value[Value] then
	                            DepGroupboxContainer.Visible = false
	                            DepGroupbox.Visible = false
	                            return
	                        end
	                    else
	                        if Element.Value ~= Value then
	                            DepGroupboxContainer.Visible = false
	                            DepGroupbox.Visible = false
	                            return
	                        end
	                    end
	                end
	            end

	            DepGroupbox.Visible = true
	            if not Library.Searching then
	                DepGroupboxContainer.Visible = true
	                DepGroupbox:Resize()
	            elseif not CancelSearch then
	                Library:UpdateSearch(Library.SearchText)
	            end
	        end

	        function DepGroupbox:SetupDependencies(Dependencies)
	            for _, Dependency in Dependencies do
	                assert(typeof(Dependency) == "table", "Dependency should be a table.")
	                assert(Dependency[1] ~= nil, "Dependency is missing element.")
	                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
	            end

	            DepGroupbox.Dependencies = Dependencies
	            DepGroupbox:Update()
	        end

	        setmetatable(DepGroupbox, BaseGroupbox)

	        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
	        table.insert(Library.DependencyBoxes, DepGroupbox :: any)

	        function DepGroupbox:Destroy()
	            DepGroupbox.Destroyed = true

	            if DepGroupbox.Connections then
	                for _, Connection in DepGroupbox.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            for _, Element in DepGroupbox.Elements do
	                if Element.Destroy then
	                    Element:Destroy()
	                end
	            end

	            for _, SubDepbox in DepGroupbox.DependencyBoxes do
	                if SubDepbox.Destroy then
	                    SubDepbox:Destroy()
	                end
	            end

	            if DepGroupboxContainer then
	                DepGroupboxContainer:Destroy()
	            end

	            local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
	            if ElemIdx then
	                table.remove(Tab.DependencyGroupboxes, ElemIdx)
	            end

	            local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
	            if LibIdx then
	                table.remove(Library.DependencyBoxes, LibIdx)
	            end
	        end

	        return DepGroupbox
	    end

	    BaseGroupbox.__index = Funcs
	    BaseGroupbox.__namecall = function(_, Key, ...)
	        return Funcs[Key](...)
	    end
	end

	function Library:SetFont(FontFace)
	    if typeof(FontFace) == "EnumItem" then
	        FontFace = Font.fromEnum(FontFace :: any)
	    end

	    Library.Scheme.Font = FontFace
	    Library:UpdateColorsUsingRegistry()

	    for _, Label in Labels do
	        if Label.DoesWrap then
	            Label:Display()
	            Label.Parent:Resize()
	        end
	    end

	    if Library.Window and Library.Window.RefreshTitleSize then
	        Library.Window:RefreshTitleSize()
	    end
	end

	function Library:SetBackgroundImage(Image: string | number)
	    assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))

	    Library.Scheme.BackgroundImage = Image
	    if Library.Window then
	        Library.Window:SetBackgroundImage(Image)
	    end

	    Library:UpdateColorsUsingRegistry()
	end

	function Library:UpdateNotificationPositions(Snap: boolean?)
	    local IsLeft = Library.NotifySide:lower() == "left"
	    local XScale = IsLeft and 0 or 1
	    local RunningY = 0

	    for _, FakeBackground in NotifyOrder do
	        local Data = Library.Notifications[FakeBackground]
	        if not (Data and FakeBackground.Parent) then continue end

	        local Target = UDim2.new(XScale, 0, 0, RunningY)
	        if Snap or not Data.PositionInitialized then
	            FakeBackground.Position = Target
	            Data.PositionInitialized = true

	        elseif FakeBackground.Position ~= Target then
	            TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
	                Position = Target,
	            }):Play()
	        end

	        RunningY = RunningY + FakeBackground.AbsoluteSize.Y / Library.DPIScale + 8
	    end
	end

	function Library:SetNotifySide(Side: string)
	    Library.NotifySide = Side

	    local IsLeft = Side:lower() == "left"
	    if IsLeft then
	        NotificationArea.AnchorPoint = Vector2.new(0, 0)
	        NotificationArea.Position = UDim2.fromOffset(6, 6)
	    else
	        NotificationArea.AnchorPoint = Vector2.new(1, 0)
	        NotificationArea.Position = UDim2.new(1, -6, 0, 6)
	    end

	    for FakeBackground in Library.Notifications do
	        if not (FakeBackground and FakeBackground.Parent) then continue end
	        FakeBackground.AnchorPoint = if IsLeft then Vector2.new(0, 0) else Vector2.new(1, 0)
	    end

	    if Library.UpdateNotificationPositions then
	        Library:UpdateNotificationPositions(true)
	    end
	end

	function Library:Notify(...)
	    local Data = {}
	    local Info = select(1, ...)

	    if typeof(Info) == "table" then
	        Data.Title = tostring(Info.Title)
	        Data.TitleColor = Info.TitleColor

	        Data.Description = tostring(Info.Description)
	        Data.DescriptionColor = Info.DescriptionColor

	        Data.Time = Info.Time or 5
	        Data.SoundId = Info.SoundId
	        Data.Steps = Info.Steps
	        Data.Persist = Info.Persist

	        Data.Callback = typeof(Info.Callback) == "function" and Info.Callback or nil
	        Data.Closable = Info.Closable == true

	        Data.Icon = Info.Icon
	        Data.BigIcon = Info.BigIcon
	        Data.IconColor = Info.IconColor

	        Data.Volume = tonumber(Info.Volume) or 3
	    else
	        Data.Description = tostring(Info)
	        Data.Time = select(2, ...) or 5
	        Data.SoundId = select(3, ...)
	        Data.Volume = select(4, ...) or 3
	    end
	    Data.Destroyed = false

	    local DeletedInstance = false
	    local DeleteConnection = nil
	    if typeof(Data.Time) == "Instance" then
	        DeleteConnection = Data.Time.Destroying:Connect(function()
	            DeletedInstance = true

	            DeleteConnection:Disconnect()
	            DeleteConnection = nil
	        end)
	    end

	    local FakeBackground = New("Frame", {
	        AnchorPoint = Library.NotifySide:lower() == "left" and Vector2.new(0, 0) or Vector2.new(1, 0),
	        AutomaticSize = Enum.AutomaticSize.Y,
	        BackgroundTransparency = 1,
	        Size = UDim2.fromOffset(0, 0),
	        Visible = false,
	        Parent = NotificationArea,
	    })

	    local Holder = New("Frame", {
	        AutomaticSize = Enum.AutomaticSize.Y,
	        BackgroundColor3 = "MainColor",
	        Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, 0) or UDim2.new(1, 8, 0, 0),
	        Size = UDim2.new(1, 0, 0, 0),
	        ZIndex = 5,
	        Parent = FakeBackground,
	    })
	    table.insert(
	        Library.Corners,
	        New("UICorner", {
	            CornerRadius = UDim.new(0, Library.CornerRadius),
	            Parent = Holder,
	        })
	    )
	    Library:AddOutline(Holder)

	    local ContentHolder = New("Frame", {
	        AutomaticSize = Enum.AutomaticSize.Y,
	        BackgroundTransparency = 1,
	        Size = UDim2.new(1, 0, 0, 0),
	        Parent = Holder,
	    })
	    New("UIListLayout", {
	        Padding = UDim.new(0, 4),
	        Parent = ContentHolder,
	    })
	    New("UIPadding", {
	        PaddingBottom = UDim.new(0, 8),
	        PaddingLeft = UDim.new(0, 8),
	        PaddingRight = UDim.new(0, 8),
	        PaddingTop = UDim.new(0, 8),
	        Parent = ContentHolder,
	    })

	    local CloseButton
	    if Data.Closable then
	        CloseButton = Library:CreateIcon(CloseIcon, {
	            AnchorPoint = Vector2.new(1, 0),
	            ImageColor3 = "FontColor",
	            ImageTransparency = 0.5,
	            Position = UDim2.new(1, -8, 0, 8),
	            Size = UDim2.fromOffset(14, 14),
	            ZIndex = 6,
	            Parent = Holder,
	        }, true)

	        CloseButton.MouseEnter:Connect(function()
	            TweenIcon(CloseButton, { ImageTransparency = 0 })
	        end)
	        CloseButton.MouseLeave:Connect(function()
	            TweenIcon(CloseButton, { ImageTransparency = 0.5 })
	        end)
	        CloseButton.MouseButton1Click:Connect(function()
	            Data:Destroy("user")
	        end)
	    end

	    local ContentContainer = New("Frame", {
	        BackgroundTransparency = 1,
	        AutomaticSize = Enum.AutomaticSize.XY,
	        Size = UDim2.fromOffset(0, 0),
	        Parent = ContentHolder,
	    })

	    if Data.BigIcon then
	        New("UIListLayout", {
	            Padding = UDim.new(0, 8),
	            FillDirection = Enum.FillDirection.Horizontal,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Parent = ContentContainer,
	        })
	    end

	    local BigIconLabel
	    if Data.BigIcon then
	        local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
	        if ParsedIcon then
	            BigIconLabel = Library:CreateIcon(ParsedIcon, {
	                Size = UDim2.fromOffset(24, 24),
	                ImageColor3 = Data.IconColor or "AccentColor",
	                Parent = ContentContainer,
	            })
	        end
	    end

	    local TextContainer = New("Frame", {
	        BackgroundTransparency = 1,
	        AutomaticSize = Enum.AutomaticSize.XY,
	        Size = UDim2.fromOffset(0, 0),
	        Parent = ContentContainer,
	    })
	    New("UIListLayout", {
	        Padding = UDim.new(0, 4),
	        Parent = TextContainer,
	    })

	    local TitleContainer
	    if Data.Title then
	        TitleContainer = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromOffset(0, 0),
	            Parent = TextContainer,
	        })
	    end

	    local IconLabel
	    if Data.Icon and TitleContainer then
	        local ParsedIcon = Library:GetCustomIcon(Data.Icon)
	        if ParsedIcon then
	            IconLabel = Library:CreateIcon(ParsedIcon, {
	                AnchorPoint = Vector2.new(0, 0.5),
	                Position = UDim2.new(0, 0, 0.5, 1),
	                Size = UDim2.fromOffset(15, 15),
	                ImageColor3 = Data.IconColor or "FontColor",
	                Parent = TitleContainer,
	            })
	        end
	    end

	    local Title
	    local Desc
	    local TitleX = 0
	    local DescX = 0

	    local TimerFill

	    if Data.Title then
	        Title = New("TextLabel", {
	            AutomaticSize = Enum.AutomaticSize.None,
	            BackgroundTransparency = 1,
	            AnchorPoint = Vector2.new(0, 0.5),
	            Position = UDim2.new(0, (IconLabel and 21 or 0), 0.5, 0),
	            Size = UDim2.fromScale(0, 0),
	            Text = Data.Title,
	            TextColor3 = Data.TitleColor or "FontColor",
	            TextSize = 15,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            TextYAlignment = Enum.TextYAlignment.Center,
	            TextWrapped = true,
	            Parent = TitleContainer,
	        })
	    end

	    if Data.Description then
	        Desc = New("TextLabel", {
	            AutomaticSize = Enum.AutomaticSize.None,
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(0, 0),
	            Text = Data.Description,
	            TextColor3 = Data.DescriptionColor or "FontColor",
	            TextSize = 14,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            TextWrapped = true,
	            Parent = TextContainer,
	        })
	    end

	    function Data:Resize()
	        local ExtraWidth = BigIconLabel and 32 or 0
	        local IconWidth = IconLabel and 21 or 0
	        local CloseWidth = Data.Closable and 20 or 0
	        local MaxTextWidth = math.max(
	            40,
	            (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - CloseWidth
	        )

	        if Title then
	            local X, Y = Library:GetTextBounds(Title.Text, Title.FontFace, Title.TextSize, MaxTextWidth - IconWidth)
	            Title.Size = UDim2.fromOffset(X, Y)
	            TitleX = X + IconWidth
	            TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
	        end

	        if Desc then
	            local X, Y = Library:GetTextBounds(Desc.Text, Desc.FontFace, Desc.TextSize, MaxTextWidth)
	            Desc.Size = UDim2.fromOffset(X, Y)
	            DescX = X
	        end

	        FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth + CloseWidth, 0)

	        if Library.Notifications[FakeBackground] then
	            task.defer(function()
	                if Data.Destroyed or not FakeBackground.Parent then
	                    return
	                end

	                if FakeBackground.AbsoluteSize.Y <= 0 then
	                    task.defer(function()
	                        if Data.Destroyed or not FakeBackground.Parent then
	                            return
	                        end

	                        Library:UpdateNotificationPositions(true)
	                    end)
	                    return
	                end

	                Library:UpdateNotificationPositions(true)
	            end)
	        end
	    end

	    function Data:ChangeTitle(Text)
	        if Title then
	            Data.Title = tostring(Text)
	            Title.Text = Data.Title
	            Data:Resize()
	        end
	    end

	    function Data:ChangeDescription(Text)
	        if Desc then
	            Data.Description = tostring(Text)
	            Desc.Text = Data.Description
	            Data:Resize()
	        end
	    end

	    function Data:ChangeStep(NewStep)
	        if TimerFill and Data.Steps then
	            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
	            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
	        end
	    end

	    function Data:Destroy(Reason)
	        if Data.Destroyed then
	            return
	        end

	        Reason = Reason or "script"
	        Data.Destroyed = true

	        if Data.Callback then
	            pcall(Data.Callback, Reason)
	        end

	        if typeof(Data.Time) == "Instance" then
	            pcall(Data.Time.Destroy, Data.Time)
	        end

	        if DeleteConnection then
	            DeleteConnection:Disconnect()
	        end

	        if FakeBackground then
	            local Idx = table.find(NotifyOrder, FakeBackground)
	            if Idx then
	                table.remove(NotifyOrder, Idx)
	            end
	        end

	        Library:UpdateNotificationPositions()

	        TweenService
	            :Create(Holder, Library.NotifyTweenInfo, {
	                Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
	            })
	            :Play()

	        task.delay(Library.NotifyTweenInfo.Time, function()
	            Library.Notifications[FakeBackground] = nil
	            FakeBackground:Destroy()
	        end)
	    end

	    local TimerHolder = New("Frame", {
	        BackgroundTransparency = 1,
	        Size = UDim2.new(1, 0, 0, 7),
	        Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
	        Parent = ContentHolder,
	    })
	    local TimerBar = New("Frame", {
	        BackgroundColor3 = "BackgroundColor",
	        BorderColor3 = "OutlineColor",
	        BorderSizePixel = 1,
	        Position = UDim2.fromOffset(0, 3),
	        Size = UDim2.new(1, 0, 0, 2),
	        Parent = TimerHolder,
	    })
	    TimerFill = New("Frame", {
	        BackgroundColor3 = "AccentColor",
	        Size = UDim2.fromScale(1, 1),
	        Parent = TimerBar,
	    })

	    if typeof(Data.Time) == "Instance" then
	        TimerFill.Size = UDim2.fromScale(0, 1)
	    end
	    if Data.SoundId then
	        local SoundId = Data.SoundId
	        if typeof(SoundId) == "number" then
	            SoundId = string.format("rbxassetid://%d", SoundId)
	        end

	        New("Sound", {
	            SoundId = SoundId,
	            Volume = tonumber(Data.Volume) or 3,
	            PlayOnRemove = true,
	            Parent = SoundService,
	        }):Destroy()
	    end

	    Data.Holder = Holder

	    table.insert(NotifyOrder, FakeBackground)
	    Library.Notifications[FakeBackground] = Data

	    Data:Resize()

	    FakeBackground.Visible = true
	    TweenService:Create(Holder, Library.NotifyTweenInfo, {
	        Position = UDim2.fromOffset(0, 0),
	    }):Play()

	    task.defer(function()
	        if not Data.Destroyed then
	            Library:UpdateNotificationPositions(true)
	        end
	    end)

	    task.delay(Library.NotifyTweenInfo.Time, function()
	        if Data.Persist then
	            return
	        elseif typeof(Data.Time) == "Instance" then
	            repeat
	                task.wait()
	            until DeletedInstance or Data.Destroyed
	        else
	            TweenService
	                :Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
	                    Size = UDim2.fromScale(0, 1),
	                })
	                :Play()
	            task.wait(Data.Time)
	        end

	        Data:Destroy("timer")
	    end)

	    return Data
	end

	function Library:CreateWindow(WindowInfo)
	    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
	    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
	    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
	        repeat
	            ViewportSize = workspace.CurrentCamera.ViewportSize
	            task.wait()
	        until ViewportSize.X > 5 and ViewportSize.Y > 5
	    end

	    local MaxX = ViewportSize.X - 64
	    local MaxY = ViewportSize.Y - 64

	    Library.OriginalMinSize =
	        Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
	    Library.MinSize = Vector2.new(math.min(WindowInfo.MinContainerWidth, MaxX), Library.OriginalMinSize.Y)

	    WindowInfo.Size = UDim2.fromOffset(
	        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
	        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
	    )
	    if typeof(WindowInfo.Font) == "EnumItem" then
	        WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
	    end
	    WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)

	    local TabButtonsStyle = WindowInfo.TabButtonsStyle

	    --// Old Naming \\--
	    if WindowInfo.Compact ~= nil then
	        WindowInfo.SidebarCompacted = WindowInfo.Compact
	    end
	    if WindowInfo.SidebarMinWidth ~= nil then
	        WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
	    end
	    WindowInfo.MinSidebarWidth = math.max(64 + TabButtonsStyle.Padding * 2, WindowInfo.MinSidebarWidth)
	    WindowInfo.SidebarCompactWidth = math.max(40 + TabButtonsStyle.Padding * 2, WindowInfo.SidebarCompactWidth)
	    WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
	    WindowInfo.CompactWidthActivation = math.max(40 + TabButtonsStyle.Padding * 2, WindowInfo.CompactWidthActivation)
	    WindowInfo.SnapDistance = math.max(0, WindowInfo.SnapDistance)
	    WindowInfo.SnapMargin = math.max(0, WindowInfo.SnapMargin)

	    Library.CornerRadius = WindowInfo.CornerRadius
	    Library:SetNotifySide(WindowInfo.NotifySide)
	    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
	    Library.Scheme.Font = WindowInfo.Font
	    Library.ToggleKeybind = WindowInfo.ToggleKeybind
	    Library.GlobalSearch = WindowInfo.GlobalSearch

	    Library.Animations = WindowInfo.Animations
	    Library.TabTransitionInfo = TweenInfo.new(
	        math.max(0, WindowInfo.TabTransitionTime or 0.22),
	        Enum.EasingStyle.Quad,
	        Enum.EasingDirection.Out
	    )
	    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
	    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

	    local IsDefaultSearchbarSize = WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
	    local MainFrame
	    local DividerLine
	    local TitleHolder
	    local WindowTitle
	    local WindowIcon
	    local RightWrapper
	    local SearchBox
	    local CurrentTabInfo
	    local CurrentTabLabel
	    local CurrentTabDescription
	    local ResizeButton
	    local Tabs
	    local Container
	    local BackgroundImage
	    local HasBackgroundImage = false
	    local BottomBackground
	    local BottomBackgroundCorner
	    local FooterLabel
	    local TopBar
	    local WindowSnapConfig = {
	        Enabled = WindowInfo.Snapping,
	        Distance = WindowInfo.SnapDistance,
	        Margin = WindowInfo.SnapMargin,
	        AvoidCoreGui = WindowInfo.SnapAvoidCoreGui,
	    }

	    local InitialLeftWidth = math.ceil(WindowInfo.Size.X.Offset * 0.3)
	    local IsCompact = WindowInfo.SidebarCompacted
	    local LastExpandedWidth = InitialLeftWidth
	    local RefreshWindowTitleSize

	    do
	        local KeybindFrame, KeybindContainer, _, KeybindDivider, KeybindLabelPadding = Library:AddDraggableMenu("Keybinds")
	        KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
	        KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
	        KeybindFrame.Visible = false
	        KeybindLabelPadding.PaddingRight = UDim.new(0, 34)

	        local HeaderButtons = New("Frame", {
	            AnchorPoint = Vector2.new(1, 0.5),
	            AutomaticSize = Enum.AutomaticSize.X,
	            BackgroundTransparency = 1,
	            Position = UDim2.new(1, -8, 0, 17),
	            Size = UDim2.fromOffset(0, 22),
	            ZIndex = 2,
	            Parent = KeybindFrame,
	        })
	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalAlignment = Enum.HorizontalAlignment.Right,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Padding = UDim.new(0, 4),
	            Parent = HeaderButtons,
	        })

	        local SettingsButton = Library:CreateIcon(SettingsIcon, {
	            ImageColor3 = "FontColor",
	            LayoutOrder = 1,
	            Size = UDim2.fromOffset(18, 18),
	            Visible = false,
	            ZIndex = 2,
	            Parent = HeaderButtons,
	        }, true)

	        local CollapseButton = Library:CreateIcon(ArrowIcon, {
	            ImageColor3 = "FontColor",
	            LayoutOrder = 2,
	            Rotation = 180,
	            Size = UDim2.fromOffset(18, 18),
	            ZIndex = 2,
	            Parent = HeaderButtons,
	        }, true)

	        local SettingsFrame, SettingsContainer, _, _, SettingsLabelPadding = Library:AddDraggableMenu("Visible Keybinds")
	        SettingsFrame.Visible = false
	        SettingsLabelPadding.PaddingRight = UDim.new(0, 34)

	        local CloseSettingsButton = Library:CreateIcon(CloseIcon, {
	            AnchorPoint = Vector2.new(1, 0.5),
	            ImageColor3 = "FontColor",
	            Position = UDim2.new(1, -8, 0, 17),
	            Size = UDim2.fromOffset(18, 18),
	            ZIndex = 2,
	            Parent = SettingsFrame,
	        }, true)

	        local KeybindMenu = {
	            VisibilityControl = false,
	            Collapsed = false,
	            SettingsOpen = false,
	            Frame = KeybindFrame,
	            Container = KeybindContainer,
	            SettingsFrame = SettingsFrame,
	            SettingsContainer = SettingsContainer,
	        }

	        function KeybindMenu:RefreshSettings()
	            for _, Child in SettingsContainer:GetChildren() do
	                if Child:IsA("GuiObject") and not Child:IsA("UIListLayout") and not Child:IsA("UIPadding") then
	                    Child:Destroy()
	                end
	            end

	            for Idx, Option in Options do
	                if Option.Type ~= "KeyPicker" or Option.NoUI == true then
	                    continue
	                end

	                local Holder = New("TextButton", {
	                    BackgroundTransparency = 1,
	                    Size = UDim2.new(1, 0, 0, 16),
	                    Text = "",
	                    Parent = SettingsContainer,
	                })

	                local Visible = Option.MenuVisible ~= false
	                New("TextLabel", {
	                    AutomaticSize = Enum.AutomaticSize.X,
	                    BackgroundTransparency = 1,
	                    Position = UDim2.fromOffset(22, 0),
	                    Size = UDim2.fromScale(0, 1),
	                    Text = ("[%s] %s (%s)"):format(
	                        Option.DisplayValue or Option.Value or "None",
	                        Option.Text or tostring(Idx),
	                        Option.Mode or "Toggle"
	                    ),
	                    TextSize = 14,
	                    TextTransparency = Visible and 0 or 0.5,
	                    Parent = Holder,
	                })

	                local Checkbox = New("Frame", {
	                    AnchorPoint = Vector2.new(0, 0.5),
	                    BackgroundColor3 = "MainColor",
	                    Position = UDim2.fromScale(0, 0.5),
	                    Size = UDim2.fromOffset(14, 14),
	                    Parent = Holder,
	                })
	                table.insert(
	                    Library.Corners,
	                    New("UICorner", {
	                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                        Parent = Checkbox,
	                    })
	                )
	                New("UIStroke", {
	                    Color = "OutlineColor",
	                    Parent = Checkbox,
	                })

	                Library:CreateIcon(CheckIcon, {
	                    ImageColor3 = "FontColor",
	                    ImageTransparency = Visible and 0 or 1,
	                    Position = UDim2.fromOffset(2, 2),
	                    Size = UDim2.new(1, -4, 1, -4),
	                    Parent = Checkbox,
	                })

	                Holder.MouseButton1Click:Connect(function()
	                    local Picker = Options[Idx]
	                    if not (Picker and Picker.Type == "KeyPicker" and Picker.SetMenuVisibility) then
	                        return
	                    end

	                    Picker:SetMenuVisibility(Picker.MenuVisible == false)
	                end)
	            end
	        end

	        function KeybindMenu:SetCollapsed(Collapsed: boolean)
	            Collapsed = Collapsed == true
	            KeybindMenu.Collapsed = Collapsed

	            KeybindContainer.Visible = not Collapsed
	            KeybindDivider.Visible = not Collapsed

	            if Collapsed then
	                local Width = math.max(160, KeybindFrame.AbsoluteSize.X / Library.DPIScale)
	                KeybindFrame.AutomaticSize = Enum.AutomaticSize.None
	                KeybindFrame.Size = UDim2.fromOffset(Width, 34)
	                CollapseButton.Rotation = 0
	            else
	                KeybindFrame.AutomaticSize = Enum.AutomaticSize.XY
	                KeybindFrame.Size = UDim2.fromOffset(0, 0)
	                CollapseButton.Rotation = 180
	            end
	        end

	        function KeybindMenu:ToggleCollapsed()
	            KeybindMenu:SetCollapsed(not KeybindMenu.Collapsed)
	        end

	        function KeybindMenu:SetSettingsOpen(Open: boolean)
	            Open = Open == true
	            if Open and not KeybindMenu.VisibilityControl then
	                return
	            end

	            KeybindMenu.SettingsOpen = Open
	            SettingsFrame.Visible = Open

	            if Open then
	                KeybindMenu:RefreshSettings()

	                local Bounds = Floats.AbsoluteSize
	                local Pos = KeybindFrame.AbsolutePosition - Floats.AbsolutePosition
	                local Size = KeybindFrame.AbsoluteSize
	                local SettingsSize = SettingsFrame.AbsoluteSize

	                local X = Pos.X + Size.X + 8
	                if X + SettingsSize.X > Bounds.X then
	                    X = Pos.X - SettingsSize.X - 8
	                end

	                SettingsFrame.Position = UDim2.fromOffset(
	                    math.clamp(X, 0, math.max(0, Bounds.X - SettingsSize.X)),
	                    math.clamp(Pos.Y, 0, math.max(0, Bounds.Y - SettingsSize.Y))
	                )
	            end
	        end

	        function KeybindMenu:ToggleSettings()
	            KeybindMenu:SetSettingsOpen(not KeybindMenu.SettingsOpen)
	        end

	        function KeybindMenu:SetVisibilityControl(Enabled: boolean)
	            Enabled = Enabled == true
	            KeybindMenu.VisibilityControl = Enabled
	            SettingsButton.Visible = Enabled
	            KeybindLabelPadding.PaddingRight = UDim.new(0, Enabled and 56 or 34)

	            if not Enabled then
	                KeybindMenu:SetSettingsOpen(false)
	            end
	        end

	        function KeybindMenu:Destroy()
	            local DraggableIndex = table.find(Library.DraggableElements, SettingsFrame)
	            if DraggableIndex then
	                table.remove(Library.DraggableElements, DraggableIndex)
	            end

	            SettingsFrame:Destroy()
	            KeybindMenu.SettingsFrame = nil
	            KeybindMenu.SettingsContainer = nil
	            KeybindMenu.SettingsOpen = false
	            Library.KeybindMenu = nil
	        end

	        SettingsButton.MouseButton1Click:Connect(function()
	            KeybindMenu:ToggleSettings()
	        end)
	        CollapseButton.MouseButton1Click:Connect(function()
	            KeybindMenu:ToggleCollapsed()
	        end)
	        CloseSettingsButton.MouseButton1Click:Connect(function()
	            KeybindMenu:SetSettingsOpen(false)
	        end)

	        Library.KeybindFrame = KeybindFrame
	        Library.KeybindContainer = KeybindContainer
	        Library.KeybindMenu = KeybindMenu

	        MainFrame = New("TextButton", {
	            BackgroundColor3 = function()
	                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
	            end,
	            Name = "Main",
	            Text = "",
	            Position = WindowInfo.Position,
	            Size = WindowInfo.Size,
	            Visible = false,
	            Parent = ScreenGui,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                Parent = MainFrame,
	            })
	        )
	        table.insert(
	            Library.Scales,
	            New("UIScale", {
	                Parent = MainFrame,
	            })
	        )
	        Library:AddOutline(MainFrame)
	        Library:MakeLine(MainFrame, {
	            Position = UDim2.fromOffset(0, 48),
	            Size = UDim2.new(1, 0, 0, 1),
	        })

	        DividerLine = New("Frame", {
	            BackgroundColor3 = "OutlineColor",
	            Position = UDim2.fromOffset(InitialLeftWidth, 0),
	            Size = UDim2.new(0, 1, 1, -21),
	            Parent = MainFrame,
	            ZIndex = 2
	        })

	        local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
	        HasBackgroundImage = BackgroundIcon ~= nil
	        BackgroundImage = New("ImageLabel", {
	            Active = false,
	            Position = UDim2.fromScale(0, 0),
	            Size = UDim2.fromScale(1, 1),
	            ScaleType = Enum.ScaleType.Stretch,
	            ZIndex = Overlay.ZIndex + 1,
	            BackgroundTransparency = 1,
	            ImageTransparency = 0.75,
	            Visible = false,
	            Parent = ScreenGui,
	        })
	        FillInstance(ImageContent(BackgroundIcon), BackgroundImage)

	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                Parent = BackgroundImage,
	            })
	        )

	        Library:GiveSignal(RunService.RenderStepped:Connect(function()
	            if not (BackgroundImage and MainFrame) then
	                return
	            end

	            local ShouldShow = HasBackgroundImage and MainFrame.Visible
	            BackgroundImage.Visible = ShouldShow

	            if not ShouldShow then
	                return
	            end

	            BackgroundImage.Position = UDim2.fromOffset(
	                MainFrame.AbsolutePosition.X,
	                MainFrame.AbsolutePosition.Y
	            )
	            BackgroundImage.Size = UDim2.fromOffset(
	                MainFrame.AbsoluteSize.X,
	                MainFrame.AbsoluteSize.Y
	            )
	        end))

	        if WindowInfo.Center then
	            MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
	        end

	        --// Top Bar \\-
	        TopBar = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 48),
	            Parent = MainFrame,
	        })
	        Library:MakeDraggable(MainFrame, TopBar, false, true, WindowSnapConfig)

	        --// Title \\--
	        TitleHolder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(0, InitialLeftWidth, 1, 0),
	            Parent = TopBar,
	        })
	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalAlignment = Enum.HorizontalAlignment.Center,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Padding = UDim.new(0, 6),
	            Parent = TitleHolder,
	        })

	        if WindowInfo.Icon then
	            WindowIcon = Library:CreateIcon(Library:GetCustomIcon(WindowInfo.Icon), {
	                Size = WindowInfo.IconSize,
	                Parent = TitleHolder,
	            })
	        else
	            WindowIcon = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = WindowInfo.IconSize,
	                Text = WindowInfo.Title:sub(1, 1),
	                TextScaled = true,
	                Visible = false,
	                Parent = TitleHolder,
	            })
	        end

	        WindowTitle = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromOffset(0, 0),
	            Text = WindowInfo.Title,
	            TextSize = 20,
	            TextTruncate = Enum.TextTruncate.AtEnd,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            TextYAlignment = Enum.TextYAlignment.Center,
	            Parent = TitleHolder,
	        })

	        RefreshWindowTitleSize = function()
	            local IconWidth = 0
	            if WindowIcon and WindowIcon.Visible then
	                IconWidth = WindowIcon.Size.X.Offset + 6
	            end

	            local MaxWidth = math.max(0, (TitleHolder.AbsoluteSize.X / Library.DPIScale) - IconWidth - 12)
	            local NaturalWidth = Library:GetTextBounds(WindowTitle.Text, Library.Scheme.Font, WindowTitle.TextSize)
	            WindowTitle.Size = UDim2.new(0, math.min(NaturalWidth, MaxWidth), 1, 0)
	        end
	        RefreshWindowTitleSize()

	        --// Top Right Bar \\--
	        RightWrapper = New("Frame", {
	            AnchorPoint = Vector2.new(1, 0.5),
	            BackgroundTransparency = 1,
	            Position = UDim2.new(1, -49, 0.5, 0),
	            Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, -16),
	            Parent = TopBar,
	        })

	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalAlignment = Enum.HorizontalAlignment.Left,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Padding = UDim.new(0, 8),
	            Parent = RightWrapper,
	        })

	        CurrentTabInfo = New("Frame", {
	            Size = UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.5, 1),
	            Visible = false,
	            BackgroundTransparency = 1,
	            Parent = RightWrapper,
	        })

	        New("UIFlexItem", {
	            FlexMode = Enum.UIFlexMode.Grow,
	            Parent = CurrentTabInfo,
	        })

	        New("UIListLayout", {
	            FillDirection = Enum.FillDirection.Vertical,
	            HorizontalAlignment = Enum.HorizontalAlignment.Left,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            Parent = CurrentTabInfo,
	        })

	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 8),
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 8),
	            PaddingTop = UDim.new(0, 8),
	            Parent = CurrentTabInfo,
	        })

	        CurrentTabLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            Text = "",
	            TextSize = 14,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            Parent = CurrentTabInfo,
	        })

	        CurrentTabDescription = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            Text = "",
	            TextWrapped = true,
	            TextSize = 14,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            TextTransparency = 0.5,
	            Parent = CurrentTabInfo,
	        })

	        SearchBox = New("TextBox", {
	            BackgroundColor3 = "MainColor",
	            PlaceholderText = "Search",
	            Size = WindowInfo.SearchbarSize,
	            TextScaled = true,
	            Visible = not (WindowInfo.DisableSearch or false),
	            Parent = RightWrapper,
	        })
	        New("UIFlexItem", {
	            FlexMode = Enum.UIFlexMode.Shrink,
	            Parent = SearchBox,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                Parent = SearchBox,
	            })
	        )
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 8),
	            PaddingLeft = UDim.new(0, 8),
	            PaddingRight = UDim.new(0, 8),
	            PaddingTop = UDim.new(0, 8),
	            Parent = SearchBox,
	        })
	        local SearchBoxStroke = New("UIStroke", {
	            Color = "OutlineColor",
	            Parent = SearchBox,
	        })

	        Library:GiveSignal(SearchBox.Focused:Connect(function()
	            Library.Registry[SearchBoxStroke].Color = "AccentColor"
	            TweenService:Create(SearchBoxStroke, Library.TweenInfo, {
	                Color = Library.Scheme.AccentColor,
	            }):Play()
	        end))

	        Library:GiveSignal(SearchBox.FocusLost:Connect(function()
	            Library.Registry[SearchBoxStroke].Color = "OutlineColor"
	            TweenService:Create(SearchBoxStroke, Library.TweenInfo, {
	                Color = Library.Scheme.OutlineColor,
	            }):Play()
	        end))

	        local SearchIcon = Library:GetIcon("search")
	        if SearchIcon then
	            Library:CreateIcon(SearchIcon, {
	                ImageColor3 = "FontColor",
	                ImageTransparency = 0.5,
	                Size = UDim2.fromScale(1, 1),
	                SizeConstraint = Enum.SizeConstraint.RelativeYY,
	                Parent = SearchBox,
	            })
	        end

	        if MoveIcon then
	            Library:CreateIcon(MoveIcon, {
	                AnchorPoint = Vector2.new(1, 0.5),
	                ImageColor3 = "OutlineColor",
	                Position = UDim2.new(1, -10, 0.5, 0),
	                Size = UDim2.fromOffset(28, 28),
	                SizeConstraint = Enum.SizeConstraint.RelativeYY,
	                Parent = TopBar,
	            })
	        end

	        --// Bottom Bar \\--
	        local BottomClip = New("Frame", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundTransparency = 1,
	            ClipsDescendants = true,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.new(1, 0, 0, 20),
	            ZIndex = 3,
	            Parent = MainFrame,
	        })

	        BottomBackground = New("Frame", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundColor3 = function()
	                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
	            end,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.new(1, 0, 0, math.max(20, WindowInfo.CornerRadius * 2)),
	            ZIndex = 3,
	            Parent = BottomClip,
	        })
	        Library:MakeLine(MainFrame, {
	            AnchorPoint = Vector2.new(0, 1),
	            Position = UDim2.new(0, 0, 1, -20),
	            Size = UDim2.new(1, 0, 0, 1),
	            ZIndex = 3,
	        })

	        local BottomBar = New("Frame", {
	            AnchorPoint = Vector2.new(0, 1),
	            BackgroundTransparency = 1,
	            Position = UDim2.fromScale(0, 1),
	            Size = UDim2.new(1, 0, 0, 20),
	            ZIndex = 4,
	            Parent = MainFrame,
	        })
	        BottomBackgroundCorner = New("UICorner", {
	            TopLeftRadius = UDim.new(0, 0),
	            TopRightRadius = UDim.new(0, 0),
	            BottomLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
	            BottomRightRadius = UDim.new(0, WindowInfo.CornerRadius),
	            Parent = BottomBackground,
	        })

	        --// Footer \\-
	        FooterLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Text = WindowInfo.Footer,
	            TextSize = 14,
	            TextTransparency = 0.5,
	            Parent = BottomBar,
	        })

	        --// Resize Button \\--
	        if WindowInfo.Resizable then
	            ResizeButton = New("TextButton", {
	                AnchorPoint = Vector2.new(1, 0),
	                BackgroundTransparency = 1,
	                Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
	                Size = UDim2.fromScale(1, 1),
	                SizeConstraint = Enum.SizeConstraint.RelativeYY,
	                Text = "",
	                Parent = BottomBar,
	            })

	            Library:MakeResizable(MainFrame, ResizeButton, function()
	                for _, Tab in Library.Tabs do
	                    Tab:Resize(true)
	                end
	            end)
	        end

	        Library:CreateIcon(ResizeIcon, {
	            ImageColor3 = "FontColor",
	            ImageTransparency = 0.5,
	            Position = UDim2.fromOffset(2, 2),
	            Size = UDim2.new(1, -4, 1, -4),
	            Parent = ResizeButton,
	        })

	        --// Tabs \\--
	        Tabs = New("ScrollingFrame", {
	            AutomaticCanvasSize = Enum.AutomaticSize.Y,
	            BackgroundColor3 = "BackgroundColor",
	            CanvasSize = UDim2.fromScale(0, 0),
	            Position = UDim2.fromOffset(0, 49),
	            ScrollBarImageTransparency = 1,
	            ScrollBarThickness = 0,
	            Size = UDim2.new(0, InitialLeftWidth, 1, -70),
	            Parent = MainFrame,
	        })
	        New("UIListLayout", {
	            Padding = UDim.new(0, TabButtonsStyle.Gap),
	            Parent = Tabs,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, TabButtonsStyle.Padding),
	            PaddingLeft = UDim.new(0, TabButtonsStyle.Padding),
	            PaddingRight = UDim.new(0, TabButtonsStyle.Padding),
	            PaddingTop = UDim.new(0, TabButtonsStyle.Padding),
	            Parent = Tabs,
	        })

	        --// Container \\--
	        Container = New("Frame", {
	            AnchorPoint = Vector2.new(1, 0),
	            BackgroundColor3 = function()
	                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
	            end,
	            ClipsDescendants = true,
	            Name = "Container",
	            Position = UDim2.new(1, 0, 0, 49),
	            Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
	            Parent = MainFrame,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 0),
	            PaddingLeft = UDim.new(0, 6),
	            PaddingRight = UDim.new(0, 6),
	            PaddingTop = UDim.new(0, 0),
	            Parent = Container,
	        })

	        Library.WindowContainer = Container
	    end

	    --// Window Table \\--
	    local Window = {}
	    local Fading = false

	    local function SetUICorner(UICorner, Corner, HalfValue)
	        local Current = UICorner[Corner]
	        if Current.Offset == 0 and Current.Scale == 0 then
	            return
	        end

	        UICorner[Corner] = HalfValue
	    end

	    function Window:ChangeTitle(title)
	        assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

	        WindowTitle.Text = title
	        WindowInfo.Title = title
	        RefreshWindowTitleSize()
	    end

	    function Window:RefreshTitleSize()
	        RefreshWindowTitleSize()
	    end

	    function Window:SetBackgroundImage(Image: string)
	        local ValidIcon = false

	        if typeof(Image) == "string" then
	            local BackgroundIcon = Library:GetCustomIcon(Image)

	            if BackgroundIcon then
	                ValidIcon = true

	                FillInstance(ImageContent(BackgroundIcon), BackgroundImage)
	            elseif Image:match("http://") or Image:match("https://") then
	                local RawFileName = Image:match("(.+)%..+$")
	                local _, Domain = Image:match("^(https?://)([^/]+)");

	                if RawFileName and Domain then
	                    local Extention = string.sub(Image, #RawFileName + 1, #Image)
	                    local FileNamePos = RawFileName:gsub("\\", "/"):find("/[^/]*$")
	                    local FileName = FileNamePos and Image:sub(FileNamePos + 1) or nil

	                    if FileName then
	                        ValidIcon = true

	                        local AssetName = Domain .. FileName
	                        if #AssetName > 255 then
	                            local NewLength = 255 - #Domain - #Extention
	                            if NewLength < 0 then
	                                AssetName = Domain .. Extention
	                            else
	                                AssetName = Domain .. string.sub(FileName:sub(1, #FileName - #Extention), 1, NewLength) .. Extention
	                            end
	                        end

	                        if CustomImageManagerAssets[FileName] == nil then
	                            CustomImageManager.AddAsset(FileName, 0, Image)
	                        else
	                            CustomImageManager.DownloadAsset(FileName, true)
	                        end

	                        FillInstance(ImageContent({ Url = CustomImageManager.GetAsset(FileName) }), BackgroundImage)
	                    end
	                end
	            end
	        end

	        if not ValidIcon then
	            FillInstance(ImageContent(nil), BackgroundImage)
	        end

	        HasBackgroundImage = ValidIcon
	        WindowInfo.BackgroundImage = Image
	    end

	    function Window:SetFooter(Footer: string)
	        assert(typeof(Footer) == "string", "Expected string for footer got: " .. typeof(Footer))

	        FooterLabel.Text = Footer
	        WindowInfo.Footer = Footer
	    end

	    function Window:SetAlwaysOnTop(Enabled: boolean)
	        WindowInfo.AlwaysOnTop = Enabled == true
	        SetAlwaysOnTop(Library.ScreenGui, WindowInfo.AlwaysOnTop)
	    end

	    function Window:SetSnapping(Enabled: boolean, Distance: number?, Margin: number?, AvoidCoreGui: boolean?)
	        WindowInfo.Snapping = Enabled == true
	        WindowSnapConfig.Enabled = WindowInfo.Snapping

	        if Distance then
	            WindowInfo.SnapDistance = math.max(0, Distance)
	            WindowSnapConfig.Distance = WindowInfo.SnapDistance
	        end

	        if Margin then
	            WindowInfo.SnapMargin = math.max(0, Margin)
	            WindowSnapConfig.Margin = WindowInfo.SnapMargin
	        end

	        if AvoidCoreGui ~= nil then
	            WindowInfo.SnapAvoidCoreGui = AvoidCoreGui == true
	            WindowSnapConfig.AvoidCoreGui = WindowInfo.SnapAvoidCoreGui
	        end
	    end

	    function Window:SetCornerRadius(Radius: number)
	        assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
	        Radius = math.min(Radius, 20)

	        local RadiusHalf = UDim.new(0, Radius / 2)
	        local RadiusUDim = UDim.new(0, Radius)
	        local HalfCurrent = Library.CornerRadius / 2

	        for _, UICorner in Library.Corners do
	            if math.abs(UICorner.CornerRadius.Offset - HalfCurrent) < 0.001 then
	                UICorner.CornerRadius = RadiusHalf
	            else
	                UICorner.CornerRadius = RadiusUDim
	            end
	        end

	        for _, UICorner in Library.SpecificCorners do
	            SetUICorner(UICorner, "TopRightRadius", RadiusHalf)
	            SetUICorner(UICorner, "TopLeftRadius", RadiusHalf)
	            SetUICorner(UICorner, "BottomRightRadius", RadiusHalf)
	            SetUICorner(UICorner, "BottomLeftRadius", RadiusHalf)
	        end

	        Library.CornerRadius = Radius
	        WindowInfo.CornerRadius = Radius

	        if ResizeButton then
	            ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
	        end
	        if BottomBackgroundCorner then
	            BottomBackground.Size = UDim2.new(1, 0, 0, math.max(20, Radius * 2))
	            BottomBackgroundCorner.BottomLeftRadius = RadiusUDim
	            BottomBackgroundCorner.BottomRightRadius = RadiusUDim
	        end

	        for _, Menu in Library.ContextMenus do
	            if Menu.Destroyed then
	                continue
	            end

	            if typeof(Menu.ActiveCallback) ~= "function" then
	                continue
	            end

	            if not Menu.Active then
	                local HolderActive = false
	                for _, Other in Library.ContextMenus do
	                    if Other == Menu then 
	                        continue
	                    end
	   
	                    if Other.Active and Other.Holder == Menu.Holder then
	                        HolderActive = true
	                        break
	                    end
	                end

	                if HolderActive then
	                    continue
	                end

	                Menu.ActiveCallback(false)
	                continue
	            end

	            Menu.ActiveCallback(true)
	        end

	        for _, Option in Options do
	            if Option.Type == "Dropdown" and Option.RefreshPool then
	                Option:RefreshPool()
	            end
	        end

	        for _, Tab in Library.Tabs do
	            if Tab.IsKeyTab then
	                continue
	            end

	            for _, Tabbox in Tab.Tabboxes do
	                Tabbox:UpdateCorners()
	            end
	        end
	    end

	    function Window:SetAnimations(Animations: { [string]: boolean }?, TabTransitionTime: number?, TabSwipeOffset: number?, TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?)
	        if typeof(Animations) == "table" then
	            WindowInfo.Animations = Animations
	            Library.Animations = Animations
	        end

	        if typeof(TabTransitionTime) == "number" then
	            local TweenInfo = TweenInfo.new(
	                math.max(0, TabTransitionTime or 0.22),
	                Enum.EasingStyle.Quad,
	                Enum.EasingDirection.Out
	            )

	            WindowInfo.TabTransitionInfo = TweenInfo
	            Library.TabTransitionInfo = TweenInfo
	        end

	        if typeof(TabSwipeOffset) == "number" then
	            TabSwipeOffset = math.max(1, TabSwipeOffset)

	            WindowInfo.TabSwipeOffset = TabSwipeOffset
	            Library.TabSwipeOffset = TabSwipeOffset
	        end

	        if typeof(TabSwipeFrom) == "string" then
	            TabSwipeFrom = string.lower(TabSwipeFrom)

	            WindowInfo.TabSwipeFrom = TabSwipeFrom
	            Library.TabSwipeFrom = TabSwipeFrom
	        end
	    end

	    local function ApplyCompact()
	        IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
	        if WindowInfo.DisableCompactingSnap then
	            IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
	        end

	        WindowTitle.Visible = not IsCompact
	        if not WindowInfo.Icon then
	            WindowIcon.Visible = IsCompact
	        end

	        for _, Button in Library.TabButtons do
	            if not Button.Icon then
	                continue
	            end

	            Button.Label.Visible = not IsCompact
	            Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
	            Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
	            Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
	            Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
	            Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
	        end
	    end

	    function Window:IsSidebarCompacted()
	        return IsCompact
	    end

	    function Window:SetCompact(State)
	        Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
	    end

	    function Window:GetSidebarWidth()
	        return Tabs.Size.X.Offset
	    end

	    function Window:SetSidebarWidth(Width)
	        Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

	        DividerLine.Position = UDim2.fromOffset(Width, 0)

	        TitleHolder.Size = UDim2.new(0, Width, 1, 0)
	        RightWrapper.Size = UDim2.new(1, -Width - 57 - 1, 1, -16)
	        Tabs.Size = UDim2.new(0, Width, 1, -70)
	        Container.Size = UDim2.new(1, -Width - 1, 1, -70)

	        if WindowInfo.EnableCompacting then
	            ApplyCompact()
	        end
	    
	        RefreshWindowTitleSize()
	        if not IsCompact then
	            LastExpandedWidth = Width
	        end
	    end

	    function Window:ShowTabInfo(Name, Description)
	        CurrentTabLabel.Text = Name
	        CurrentTabDescription.Text = Description

	        if IsDefaultSearchbarSize then
	            SearchBox.Size = UDim2.fromScale(0.5, 1)
	        end
	        CurrentTabInfo.Visible = true
	    end

	    function Window:HideTabInfo()
	        CurrentTabInfo.Visible = false
	        if IsDefaultSearchbarSize then
	            SearchBox.Size = UDim2.fromScale(1, 1)
	        end
	    end

	    function Window:AddTab(...)
	        local Name = nil
	        local Icon = nil
	        local Description = nil
	        local Tooltip = nil
	        local Order = nil

	        if select("#", ...) == 1 and typeof(...) == "table" then
	            local Info = select(1, ...)
	            Name = Info.Name or "Tab"
	            Icon = Info.Icon
	            Description = Info.Description
	            Tooltip = Info.Tooltip
	            Order = Info.Order
	        else
	            Name = select(1, ...)
	            Icon = select(2, ...)
	            Description = select(3, ...)
	            Order = select(4, ...)
	        end

	        if not tonumber(Order) then
	            Order = #Tabs:GetChildren()
	        end

	        local TabButton: TextButton
	        local TabIndicator
	        local TabLabel
	        local TabIcon

	        local TabContainer
	        local TabLeft
	        local TabRight

	        Icon = Library:GetCustomIcon(Icon)
	        do
	            TabButton = New("TextButton", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 40),
	                Text = "",
	                LayoutOrder = Order,
	                Parent = Tabs,
	            })
	            New("UICorner", {
	                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
	                Parent = TabButton,
	            })

	            if TabButtonsStyle.Indicator then
	                TabIndicator = New("Frame", {
	                    AnchorPoint = Vector2.new(1, 0.5),
	                    BackgroundColor3 = "AccentColor",
	                    BackgroundTransparency = 1,
	                    Position = UDim2.new(0, -2, 0.5, 0),
	                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
	                    Parent = TabButton,
	                })

	                New("UICorner", {
	                    CornerRadius = UDim.new(1, 0),
	                    Parent = TabIndicator,
	                })
	            end

	            local ButtonHolder = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Parent = TabButton,
	            })
	            local ButtonPadding = New("UIPadding", {
	                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
	                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
	                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
	                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
	                Parent = ButtonHolder,
	            })
	            TabLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Position = UDim2.fromOffset(30, 0),
	                Size = UDim2.new(1, -30, 1, 0),
	                Text = Name,
	                TextSize = 16,
	                TextTransparency = 0.5,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Visible = not IsCompact,
	                Parent = ButtonHolder,
	            })

	            if Icon then
	                TabIcon = Library:CreateIcon(Icon, {
	                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
	                    ImageTransparency = 0.5,
	                    Size = UDim2.fromScale(1, 1),
	                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
	                    Parent = ButtonHolder,
	                })
	            end

	            table.insert(Library.TabButtons, {
	                Label = TabLabel,
	                Padding = ButtonPadding,
	                Icon = TabIcon,
	            })

	            --// Tab Container \\--
	            TabContainer = New("Frame", {
	                BackgroundTransparency = 1,
	                Position = UDim2.fromScale(0, 0),
	                Size = UDim2.fromScale(1, 1),
	                Visible = false,
	                Parent = Container,
	            })

	            TabLeft = New("ScrollingFrame", {
	                AutomaticCanvasSize = Enum.AutomaticSize.Y,
	                BackgroundTransparency = 1,
	                CanvasSize = UDim2.fromScale(0, 0),
	                ScrollBarImageTransparency = 1,
	                ScrollBarThickness = 0,
	                Size = UDim2.new(0.5, -3, 1, 0),
	                Parent = TabContainer,
	            })
	            New("UIListLayout", {
	                Padding = UDim.new(0, 2),
	                Parent = TabLeft,
	            })
	            New("UIPadding", {
	                PaddingBottom = UDim.new(0, 2),
	                PaddingLeft = UDim.new(0, 2),
	                PaddingRight = UDim.new(0, 2),
	                PaddingTop = UDim.new(0, 2),
	                Parent = TabLeft,
	            })
	            do
	                New("Frame", {
	                    BackgroundTransparency = 1,
	                    LayoutOrder = -1,
	                    Parent = TabLeft,
	                })
	                New("Frame", {
	                    BackgroundTransparency = 1,
	                    LayoutOrder = 1,
	                    Parent = TabLeft,
	                })
	            end

	            TabRight = New("ScrollingFrame", {
	                AnchorPoint = Vector2.new(1, 0),
	                AutomaticCanvasSize = Enum.AutomaticSize.Y,
	                BackgroundTransparency = 1,
	                CanvasSize = UDim2.fromScale(0, 0),
	                Position = UDim2.fromScale(1, 0),
	                ScrollBarImageTransparency = 1,
	                ScrollBarThickness = 0,
	                Size = UDim2.new(0.5, -3, 1, 0),
	                Parent = TabContainer,
	            })
	            New("UIListLayout", {
	                Padding = UDim.new(0, 2),
	                Parent = TabRight,
	            })
	            New("UIPadding", {
	                PaddingBottom = UDim.new(0, 2),
	                PaddingLeft = UDim.new(0, 2),
	                PaddingRight = UDim.new(0, 2),
	                PaddingTop = UDim.new(0, 2),
	                Parent = TabRight,
	            })
	            do
	                New("Frame", {
	                    BackgroundTransparency = 1,
	                    LayoutOrder = -1,
	                    Parent = TabRight,
	                })
	                New("Frame", {
	                    BackgroundTransparency = 1,
	                    LayoutOrder = 1,
	                    Parent = TabRight,
	                })
	            end
	        end

	        --// Tab Table \\--
	        local Tab = {
	            Name = Name,
	            Description = Description,

	            Tooltip = Tooltip,
	            TooltipTable = nil,

	            Connections = {},
	            Destroyed = false,

	            Window = Window,
	            Button = TabButton,
	            Container = TabContainer,
	            Sides = {
	                TabLeft,
	                TabRight,
	            },
	            WarningBox = {
	                IsNormal = false,
	                LockSize = false,
	                Visible = false,
	                Title = "WARNING",
	                Text = "",
	            },

	            Groupboxes = {},
	            Tabboxes = {},
	            DependencyGroupboxes = {},
	        }

	        --// Warning Box \\--
	        local WarningBoxHolder = New("Frame", {
	            AutomaticSize = Enum.AutomaticSize.Y,
	            BackgroundTransparency = 1,
	            Position = UDim2.fromOffset(0, 7),
	            Size = UDim2.fromScale(1, 0),
	            Visible = false,
	            Parent = TabContainer,
	        })

	        local WarningBox
	        local WarningBoxOutline
	        local WarningBoxShadowOutline
	        local WarningBoxScrollingFrame
	        local WarningTitle
	        local WarningStroke
	        local WarningText
	        do
	            WarningBox = New("Frame", {
	                BackgroundColor3 = Color3.fromRGB(127, 0, 0),
	                Position = UDim2.fromOffset(2, 0),
	                Size = UDim2.new(1, -5, 0, 0),
	                Parent = WarningBoxHolder,
	            })
	            Library:AddToRegistry(WarningBox, {
	                BackgroundColor3 = function()
	                    return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
	                end
	            })
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                    Parent = WarningBox,
	                })
	            )
	            WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)
	            Library:AddToRegistry(WarningBoxOutline, {
	                Color = function()
	                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
	                end
	            })
	            Library:AddToRegistry(WarningBoxShadowOutline, {
	                Color = function()
	                    return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
	                end
	            })

	            WarningBoxScrollingFrame = New("ScrollingFrame", {
	                BackgroundTransparency = 1,
	                BorderSizePixel = 0,
	                Size = UDim2.fromScale(1, 1),
	                CanvasSize = UDim2.new(0, 0, 0, 0),
	                ScrollBarThickness = 3,
	                ScrollingDirection = Enum.ScrollingDirection.Y,
	                Parent = WarningBox,
	            })
	            New("UIPadding", {
	                PaddingBottom = UDim.new(0, 4),
	                PaddingLeft = UDim.new(0, 6),
	                PaddingRight = UDim.new(0, 6),
	                PaddingTop = UDim.new(0, 4),
	                Parent = WarningBoxScrollingFrame,
	            })

	            WarningTitle = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, -4, 0, 14),
	                Text = "",
	                TextColor3 = Color3.fromRGB(255, 50, 50),
	                TextSize = 14,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Parent = WarningBoxScrollingFrame,
	            })
	            Library:AddToRegistry(WarningTitle, {
	                TextColor3 = function()
	                    return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
	                end
	            })

	            WarningStroke = New("UIStroke", {
	                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	                Color = Color3.fromRGB(169, 0, 0),
	                LineJoinMode = Enum.LineJoinMode.Miter,
	                Parent = WarningTitle,
	            })
	            Library:AddToRegistry(WarningStroke, {
	                Color = function()
	                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
	                end
	            })

	            WarningText = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Position = UDim2.fromOffset(0, 16),
	                Size = UDim2.new(1, -4, 0, 0),
	                Text = "",
	                TextSize = 14,
	                TextWrapped = true,
	                Parent = WarningBoxScrollingFrame,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                TextYAlignment = Enum.TextYAlignment.Top,
	            })

	            New("UIStroke", {
	                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	                Color = GetTextStrokeColor,
	                LineJoinMode = Enum.LineJoinMode.Miter,
	                Parent = WarningText,
	            })
	        end

	        --// Tab Handlers \\--
	        function Tab:UpdateWarningBox(Info)
	            if typeof(Info.IsNormal) == "boolean" then
	                Tab.WarningBox.IsNormal = Info.IsNormal
	            end
	            if typeof(Info.LockSize) == "boolean" then
	                Tab.WarningBox.LockSize = Info.LockSize
	            end
	            if typeof(Info.Visible) == "boolean" then
	                Tab.WarningBox.Visible = Info.Visible
	            end
	            if typeof(Info.Title) == "string" then
	                Tab.WarningBox.Title = Info.Title
	            end
	            if typeof(Info.Text) == "string" then
	                Tab.WarningBox.Text = Info.Text
	            end

	            WarningBoxHolder.Visible = Tab.WarningBox.Visible
	            WarningTitle.Text = Tab.WarningBox.Title
	            WarningText.Text = Tab.WarningBox.Text
	            Tab:Resize(true)

	            WarningBox.BackgroundColor3 = Library.Registry[WarningBox].BackgroundColor3()
	            WarningBoxShadowOutline.Color = Library.Registry[WarningBoxShadowOutline].Color()
	            WarningBoxOutline.Color = Library.Registry[WarningBoxOutline].Color()
	            WarningTitle.TextColor3 = Library.Registry[WarningTitle].TextColor3()
	            WarningStroke.Color = Library.Registry[WarningStroke].Color()
	        end

	        function Tab:RefreshSides()
	            local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
	            for _, Side in Tab.Sides do
	                Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
	                Side.Size = UDim2.new(0.5, -3, 1, -Offset)
	            end
	        end

	        function Tab:Resize(ResizeWarningBox: boolean?)
	            if ResizeWarningBox then
	                local MaximumSize = math.floor((TabContainer.AbsoluteSize.Y / Library.DPIScale) / 3.25)
	                local _, YText = Library:GetTextBounds(
	                    WarningText.Text,
	                    Library.Scheme.Font,
	                    WarningText.TextSize,
	                    WarningText.AbsoluteSize.X / Library.DPIScale
	                )

	                local YBox = 24 + YText
	                if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
	                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
	                    YBox = MaximumSize
	                else
	                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
	                end

	                WarningText.Size = UDim2.new(1, -4, 0, YText)
	                WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
	            end

	            Tab:RefreshSides()
	        end

	        local function AddTabbox(self, Info)
	            Info = Library:Validate(Info, Templates.Tabbox)
	            local ParentObj = self
	            local IsNested = ParentObj.Type == "Groupbox" or ParentObj.Type == "SubTab"

	            if typeof(Info.Side) == "string" then
	                local lowerSide = string.lower(Info.Side)
	                if not SideIndex[lowerSide] then
	                    error(string.format("Invalid side: %s", Info.Side))
	                end

	                Info.Side = SideIndex[lowerSide]
	            end

	            local BoxHolder = New("Frame", {
	                AutomaticSize = Enum.AutomaticSize.Y,
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 0),
	                Parent = if IsNested then ParentObj.Container else (Info.Side == 1 and TabLeft or TabRight),
	            })
	            New("UIListLayout", {
	                Padding = UDim.new(0, 6),
	                Parent = BoxHolder,
	            })
	            New("UIPadding", {
	                PaddingBottom = UDim.new(0, 4),
	                PaddingTop = UDim.new(0, 4),
	                Parent = BoxHolder,
	            })

	            local TabboxHolder
	            local TabboxButtons

	            do
	                TabboxHolder = New("Frame", {
	                    BackgroundColor3 = "BackgroundColor",
	                    Size = UDim2.fromScale(1, 0),
	                    Parent = BoxHolder,
	                })
	                table.insert(
	                    Library.Corners,
	                    New("UICorner", {
	                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                        Parent = TabboxHolder,
	                    })
	                )
	                Library:AddOutline(TabboxHolder)

	                TabboxButtons = New("Frame", {
	                    BackgroundTransparency = 1,
	                    Size = UDim2.new(1, 0, 0, 34),
	                    Parent = TabboxHolder,
	                })
	                New("UIListLayout", {
	                    FillDirection = Enum.FillDirection.Horizontal,
	                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
	                    Parent = TabboxButtons,
	                })
	            end

	            local TotalTabs = 0
	            local FirstTab
	            local LastTab

	            local Tabbox: any = {
	                Type = "Tabbox",

	                Connections = {},
	                Destroyed = false,

	                Visible = true,
	                ActiveTab = nil,
	                MaxHeight = Info.MaxHeight,

	                BoxHolder = BoxHolder,
	                Holder = TabboxHolder,
	                Tabs = {},

	                ParentBox = if IsNested then ParentObj else nil,
	            }

	            function Tabbox:UpdateCorners()
	                for _, Tab in Tabbox.Tabs do
	                    Tab:UpdateCorners()
	                end
	            end

	            function Tabbox:Resize()
	                if Tabbox.ActiveTab then
	                    Tabbox.ActiveTab:Resize()
	                end
	            end

	            function Tabbox:SetMaxHeight(MaxHeight: number?)
	                if MaxHeight ~= nil then
	                    assert(typeof(MaxHeight) == "number", "MaxHeight must be a number or nil")
	                    assert(MaxHeight > 0, "MaxHeight must be higher than 0")
	                end

	                Tabbox.MaxHeight = MaxHeight
	                Tabbox:Resize()
	            end

	            function Tabbox:AddTab(Name, IconName, MaxHeight)
	                TotalTabs = TotalTabs + 1
	                local TabIndex = TotalTabs

	                LastTab = TabIndex
	                if not FirstTab then
	                    FirstTab = TabIndex
	                end

	                local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
	                local TabStoringIndex = IsNameEmpty and tostring(TabIndex) or Name

	                local Button = New("TextButton", {
	                    BackgroundColor3 = "MainColor",
	                    BackgroundTransparency = 0,
	                    Size = UDim2.fromOffset(0, 34),
	                    Text = "",
	                    Parent = TabboxButtons,
	                })

	                local ButtonCorner = New("UICorner", {
	                    TopLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
	                    TopRightRadius = UDim.new(0, WindowInfo.CornerRadius),
	                    BottomRightRadius = UDim.new(0, 0),
	                    BottomLeftRadius = UDim.new(0, 0),
	                    Parent = Button,
	                }); table.insert(Library.SpecificCorners, ButtonCorner)

	                local ButtonContent = New("Frame", {
	                    AnchorPoint = Vector2.new(0.5, 0.5),
	                    AutomaticSize = Enum.AutomaticSize.X,
	                    BackgroundTransparency = 1,
	                    Position = UDim2.fromScale(0.5, 0.5),
	                    Size = UDim2.fromOffset(0, 16),
	                    Parent = Button,
	                })
	                New("UIListLayout", {
	                    FillDirection = Enum.FillDirection.Horizontal,
	                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
	                    VerticalAlignment = Enum.VerticalAlignment.Center,
	                    Padding = UDim.new(0, 8),
	                    Parent = ButtonContent,
	                })

	                local ButtonIcon
	                local BoxIcon = Library:GetCustomIcon(IconName)
	                if BoxIcon then
	                    ButtonIcon = Library:CreateIcon(BoxIcon, {
	                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
	                        ImageTransparency = 0.5,
	                        Size = IsNameEmpty and UDim2.fromOffset(16, 16) or UDim2.fromOffset(18, 18),
	                        Parent = ButtonContent,
	                    })
	                end

	                local ButtonLabel
	                if not IsNameEmpty then
	                    ButtonLabel = New("TextLabel", {
	                        AutomaticSize = Enum.AutomaticSize.X,
	                        BackgroundTransparency = 1,
	                        Size = UDim2.fromOffset(0, 16),
	                        Text = Name,
	                        TextSize = 15,
	                        TextTransparency = 0.5,
	                        Parent = ButtonContent,
	                    })
	                end

	                local Line = Library:MakeLine(Button, {
	                    AnchorPoint = Vector2.new(0, 1),
	                    Position = UDim2.new(0, 0, 1, 1),
	                    Size = UDim2.new(1, 0, 0, 1),
	                })

	                local Container = New("ScrollingFrame", {
	                    AutomaticCanvasSize = Enum.AutomaticSize.None,
	                    BackgroundTransparency = 1,
	                    BorderSizePixel = 0,
	                    CanvasSize = UDim2.fromOffset(0, 0),
	                    Position = UDim2.fromOffset(0, 35),
	                    ScrollBarImageTransparency = 1,
	                    ScrollBarThickness = 0,
	                    ScrollingEnabled = false,
	                    Size = UDim2.new(1, 0, 1, -35),
	                    Visible = false,
	                    Parent = TabboxHolder,
	                })
	                local List = New("UIListLayout", {
	                    Padding = UDim.new(0, 8),
	                    Parent = Container,
	                })
	                New("UIPadding", {
	                    PaddingBottom = UDim.new(0, 7),
	                    PaddingLeft = UDim.new(0, 7),
	                    PaddingRight = UDim.new(0, 7),
	                    PaddingTop = UDim.new(0, 7),
	                    Parent = Container,
	                })

	                local Tab = {
	                    Type = "SubTab",
	                    Name = Name,
	                    MaxHeight = MaxHeight,

	                    Connections = {},
	                    Destroyed = false,

	                    ButtonHolder = Button,
	                    Container = Container,
	                    ButtonCorner = ButtonCorner,

	                    Tab = Tab,
	                    Tabbox = Tabbox,

	                    Elements = {},
	                    DependencyBoxes = {},
	                }

	                function Tab:Show()
	                    if Tabbox.ActiveTab then
	                        Tabbox.ActiveTab:Hide()
	                    end

	                    Button.BackgroundTransparency = 1

	                    if ButtonLabel then
	                        ButtonLabel.TextTransparency = 0
	                    end
	                    if ButtonIcon then
	                        SetIconProperties(ButtonIcon, { ImageTransparency = 0 })
	                    end

	                    Line.Visible = false

	                    Container.Visible = true

	                    Tabbox.ActiveTab = Tab
	                    Tab:Resize()
	                    Tabbox:RefreshPopOutPlaceholder()
	                end

	                function Tab:Hide()
	                    Button.BackgroundTransparency = 0

	                    if ButtonLabel then
	                        ButtonLabel.TextTransparency = 0.5
	                    end
	                    if ButtonIcon then
	                        SetIconProperties(ButtonIcon, { ImageTransparency = 0.5 })
	                    end
	                    Line.Visible = true
	                    Container.Visible = false

	                    Tabbox.ActiveTab = nil
	                end

	                function Tab:Resize()
	                    if Tabbox.ActiveTab ~= Tab then
	                        return
	                    end

	                    local ContentSize = (List.AbsoluteContentSize.Y / Library.DPIScale) + 14
	                    local FrameSize = ContentSize
	                    local TabMaxHeight = Tab.MaxHeight or Tabbox.MaxHeight
	                    if Tabbox.PoppedOut then
	                        FrameSize = math.min(ContentSize, GetPopOutBodyMaxHeight(Tabbox, 35))
	                    elseif typeof(TabMaxHeight) == "number" then
	                        FrameSize = math.min(ContentSize, math.max(TabMaxHeight - 35, 0))
	                    end

	                    local NeedsScroll = ContentSize > FrameSize + 1
	                    Container.CanvasSize = UDim2.fromOffset(0, if NeedsScroll then ContentSize else 0)
	                    Container.ScrollingEnabled = NeedsScroll
	                    TabboxHolder.Size = UDim2.new(1, 0, 0, FrameSize + 35)

	                    if IsNested then
	                        ParentObj:Resize()
	                    end
	                end

	                function Tab:SetMaxHeight(NewMaxHeight: number?)
	                    if NewMaxHeight ~= nil then
	                        assert(typeof(NewMaxHeight) == "number", "MaxHeight must be a number or nil")
	                        assert(NewMaxHeight > 0, "MaxHeight must be higher than 0")
	                    end

	                    Tab.MaxHeight = NewMaxHeight
	                    Tab:Resize()
	                end

	                function Tab:UpdateCorners()
	                    local Radius = WindowInfo.CornerRadius

	                    ButtonCorner.TopLeftRadius = UDim.new(0, TabIndex == FirstTab and Radius or 0)
	                    ButtonCorner.TopRightRadius = UDim.new(0, TabIndex == LastTab and Radius or 0)
	                end

	                function Tab:Destroy()
	                    Tab.Destroyed = true

	                    if Tab.Connections then
	                        for _, Connection in Tab.Connections do
	                            Connection:Disconnect()
	                        end
	                    end

	                    for _, Element in Tab.Elements do
	                        if Element.Destroy then
	                            Element:Destroy()
	                        end
	                    end

	                    for _, SubDepbox in Tab.DependencyBoxes do
	                        if SubDepbox.Destroy then
	                            SubDepbox:Destroy()
	                        end
	                    end

	                    if Container then
	                        Container:Destroy()
	                    end

	                    if Button then
	                        Button:Destroy()
	                    end
	                end

	                --// Execution \\--
	                if not Tabbox.ActiveTab then
	                    Tab:Show()
	                end

	                Button.MouseButton1Click:Connect(Tab.Show)

	                Tab.AddTabbox = AddTabbox
	                setmetatable(Tab, BaseGroupbox)

	                Tabbox.Tabs[TabStoringIndex] = Tab
	                Tabbox:UpdateCorners()

	                return Tab, TabStoringIndex
	            end

	            Library:MakeBoxPopOut(Tabbox, {
	                Enabled = Info.PopOut ~= false,
	                MaxPopOutHeight = Info.MaxPopOutHeight,
	                PopOutWidth = Info.PopOutWidth,

	                Header = TabboxButtons,
	                Children = function()
	                    return { TabboxHolder }
	                end,

	                After = function()
	                    if Tabbox.ActiveTab then
	                        Tabbox.ActiveTab:Resize()
	                    end
	                    if IsNested then
	                        ParentObj:Resize()
	                    end
	                end,
	            })

	            function Tabbox:Destroy()
	                if Tabbox.PoppedOut then
	                    Tabbox:SetPoppedOut(false)
	                end

	                Tabbox.Destroyed = true

	                if Tabbox.Connections then
	                    for _, Connection in Tabbox.Connections do
	                        Connection:Disconnect()
	                    end
	                end

	                for _, Tab in Tabbox.Tabs do
	                    if Tab.Destroy then
	                        Tab:Destroy()
	                    end
	                end

	                if TabboxHolder then
	                    TabboxHolder:Destroy()
	                end

	                if BoxHolder then
	                    BoxHolder:Destroy()
	                end
	            end

	            if Info.Name then
	                Tab.Tabboxes[Info.Name] = Tabbox
	            else
	                table.insert(Tab.Tabboxes, Tabbox)
	            end

	            return Tabbox
	        end

	        Tab.AddTabbox = AddTabbox

	        --// Deprecated - Use Tab:AddTabbox instead.
	        function Tab:AddLeftTabbox(Name)
	            return Tab:AddTabbox({ Side = 1, Name = Name })
	        end

	        --// Deprecated - Use Tab:AddTabbox instead.
	        function Tab:AddRightTabbox(Name)
	            return Tab:AddTabbox({ Side = 2, Name = Name })
	        end

	        function Tab:AddGroupbox(Info)
	            Info = Library:Validate(Info, Templates.Groupbox)

	            if typeof(Info.Side) == "string" then
	                local lowerSide = string.lower(Info.Side)
	                if not SideIndex[lowerSide] then
	                    error(string.format("Invalid side: %s", Info.Side))
	                end

	                Info.Side = SideIndex[lowerSide]
	            end

	            local BoxHolder = New("Frame", {
	                AutomaticSize = Enum.AutomaticSize.Y,
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 0),
	                Parent = (Info.Side == 1) and TabLeft or TabRight,
	            })
	            local BoxHolderList = New("UIListLayout", {
	                Padding = UDim.new(0, 6),
	                Parent = BoxHolder,
	            })
	            New("UIPadding", {
	                PaddingBottom = UDim.new(0, 4),
	                PaddingTop = UDim.new(0, 4),
	                Parent = BoxHolder,
	            })

	            local GroupboxHolder

	            local GroupboxTop
	            local GroupboxLabel
	            local GroupboxDescription

	            local GroupboxContainer
	            local GroupboxList

	            local GroupboxCollapseArrow
	            local GroupboxLine

	            do
	                GroupboxHolder = New("Frame", {
	                    BackgroundColor3 = "BackgroundColor",
	                    Size = UDim2.fromScale(1, 0),
	                    Parent = BoxHolder,
	                })
	                table.insert(
	                    Library.Corners,
	                    New("UICorner", {
	                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                        Parent = GroupboxHolder,
	                    })
	                )
	                New("UIListLayout", {
	                    Parent = GroupboxHolder,
	                })
	                Library:AddOutline(GroupboxHolder)

	                GroupboxTop = New("Frame", {
	                    AutomaticSize = Enum.AutomaticSize.Y,
	                    BackgroundTransparency = 1,
	                    Size = UDim2.fromScale(1, 0),
	                    Parent = GroupboxHolder,
	                })
	                New("UIPadding", {
	                    PaddingBottom = UDim.new(0, 6),
	                    PaddingLeft = UDim.new(0, 6),
	                    PaddingRight = UDim.new(0, 6),
	                    PaddingTop = UDim.new(0, 6),
	                    Parent = GroupboxTop,
	                })

	                local BoxIcon = Library:GetCustomIcon(Info.IconName)
	                if BoxIcon then
	                    Library:CreateIcon(BoxIcon, {
	                        AnchorPoint = Vector2.new(0, 0.5),
	                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
	                        Position = UDim2.fromScale(0, 0.5),
	                        Size = UDim2.fromOffset(22, 22),
	                        Parent = GroupboxTop,
	                    })
	                end

	                local RightInset = if Info.DisableCollapsing ~= true then 22 else 0
	                local TextsFrame = New("Frame", {
	                    AutomaticSize = Enum.AutomaticSize.Y,
	                    BackgroundTransparency = 1,
	                    Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
	                    Size = UDim2.new(1, -RightInset - (BoxIcon and 24 or 0), 0, 0),
	                    Parent = GroupboxTop,
	                })
	                New("UIListLayout", {
	                    Parent = TextsFrame,
	                })
	                New("UIPadding", {
	                    PaddingBottom = UDim.new(0, 3),
	                    PaddingLeft = UDim.new(0, 6),
	                    PaddingRight = UDim.new(0, 6),
	                    PaddingTop = UDim.new(0, 3),
	                    Parent = TextsFrame,
	                })

	                GroupboxLabel = New("TextLabel", {
	                    AutomaticSize = Enum.AutomaticSize.Y,
	                    BackgroundTransparency = 1,
	                    Size = UDim2.fromScale(1, 0),
	                    Text = Info.Name,
	                    TextSize = 15,
	                    TextWrapped = true,
	                    TextXAlignment = Enum.TextXAlignment.Left,
	                    Parent = TextsFrame,
	                })
	                New("UIPadding", {
	                    PaddingBottom = UDim.new(0, 1),
	                    Parent = GroupboxLabel,
	                })

	                GroupboxDescription = New("TextLabel", {
	                    AutomaticSize = Enum.AutomaticSize.Y,
	                    BackgroundTransparency = 1,
	                    Size = UDim2.fromScale(1, 0),
	                    Text = Info.Description or "",
	                    TextSize = 14,
	                    TextTransparency = 0.5,
	                    TextWrapped = true,
	                    TextXAlignment = Enum.TextXAlignment.Left,
	                    Visible = (Info.Description ~= nil),
	                    Parent = TextsFrame,
	                })

	                GroupboxCollapseArrow = Library:CreateIcon(ArrowIcon, {
	                    Visible = Info.DisableCollapsing ~= true,
	                    AnchorPoint = Vector2.new(1, 0.5),
	                    ImageColor3 = "WhiteColor",
	                    Position = UDim2.fromScale(1, 0.5),
	                    Rotation = 180,
	                    Size = UDim2.fromOffset(22, 22),
	                    Parent = GroupboxTop,
	                }, true)

	                GroupboxLine = Library:MakeLine(GroupboxHolder, {
	                    LayoutOrder = 1,
	                    Size = UDim2.new(1, 0, 0, 1),
	                })

	                GroupboxContainer = New("ScrollingFrame", {
	                    AutomaticCanvasSize = Enum.AutomaticSize.None,
	                    BackgroundTransparency = 1,
	                    BorderSizePixel = 0,
	                    CanvasSize = UDim2.fromOffset(0, 0),
	                    LayoutOrder = 2,
	                    ScrollBarImageTransparency = 1,
	                    ScrollBarThickness = 0,
	                    ScrollingEnabled = false,
	                    Size = UDim2.fromScale(1, 0),
	                    Parent = GroupboxHolder,
	                })

	                GroupboxList = New("UIListLayout", {
	                    Padding = UDim.new(0, 8),
	                    Parent = GroupboxContainer,
	                })
	                New("UIPadding", {
	                    PaddingBottom = UDim.new(0, 7),
	                    PaddingLeft = UDim.new(0, 7),
	                    PaddingRight = UDim.new(0, 7),
	                    PaddingTop = UDim.new(0, 7),
	                    Parent = GroupboxContainer,
	                })
	            end

	            local Groupbox: any = {
	                Type = "Groupbox",

	                Name = Info.Name,
	                Description = Info.Description,

	                Connections = {},
	                Destroyed = false,

	                Visible = true,
	                Collapsed = false,
	                MaxHeight = Info.MaxHeight,

	                BoxHolder = BoxHolder,
	                Holder = GroupboxHolder,
	                Container = GroupboxContainer,

	                Tab = Tab,
	                DependencyBoxes = {},
	                Elements = {}
	            }

	            local ResizeTween
	            local CollapseArrowTween

	            local function RefreshBoxHolderLayout()
	                BoxHolder.AutomaticSize = Enum.AutomaticSize.None
	                BoxHolder.Size = UDim2.new(1, 0, 0, BoxHolderList.AbsoluteContentSize.Y / Library.DPIScale + 8)
	                BoxHolder.AutomaticSize = Enum.AutomaticSize.Y
	            end
	            Groupbox.RefreshBoxHolderLayout = RefreshBoxHolderLayout

	            function Groupbox:Resize()
	                if ResizeTween then
	                    StopTween(ResizeTween, true)
	                    ResizeTween = nil
	                end

	                local TopSize = (GroupboxTop.AbsoluteSize.Y / Library.DPIScale)
	                local ContentSize = (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 14
	                local ContainerSize = ContentSize
	                if Groupbox.PoppedOut then
	                    ContainerSize = math.min(ContainerSize, GetPopOutBodyMaxHeight(Groupbox, TopSize + 1))
	                elseif typeof(Groupbox.MaxHeight) == "number" then
	                    ContainerSize = math.min(ContainerSize, math.max(Groupbox.MaxHeight - TopSize - 1, 0))
	                end

	                local NeedsScroll = ContentSize > ContainerSize + 1
	                GroupboxContainer.CanvasSize = UDim2.fromOffset(0, if NeedsScroll then ContentSize else 0)
	                GroupboxContainer.ScrollingEnabled = NeedsScroll

	                local TargetSize = UDim2.new(1, 0, 0, if Groupbox.Collapsed then TopSize else (TopSize + 1 + ContainerSize))
	                GroupboxContainer.Size = UDim2.new(1, 0, 0, ContainerSize)
	                GroupboxLine.Visible = not Groupbox.Collapsed

	                if Library.Animations and Library.Animations.Groupbox then
	                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	                    local Tween = TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
	                    ResizeTween = Tween

	                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
	                        if Connection then
	                            Connection:Disconnect()
	                        end

	                        if ResizeTween == Tween then
	                            StopTween(ResizeTween, true)
	                            ResizeTween = nil
	                        end

	                        RefreshBoxHolderLayout()
	                    end))

	                    Tween:Play()
	                else
	                    GroupboxHolder.Size = TargetSize
	                    RefreshBoxHolderLayout()
	                end
	            end

	            table.insert(Groupbox.Connections, GroupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	                if Groupbox.Visible == false or Groupbox.Destroyed then
	                    return
	                end

	                Groupbox:Resize()
	            end))

	            function Groupbox:SetDescription(Description: string | nil)
	                GroupboxDescription.Text = Description or ""
	                GroupboxDescription.Visible = (Description ~= nil)

	                Groupbox:Resize()
	            end

	            function Groupbox:SetCollapsed(Collapsed: boolean)
	                if Info.DisableCollapsing == true then return end
	                Groupbox.Collapsed = Collapsed

	                if CollapseArrowTween then
	                    StopTween(CollapseArrowTween, true)
	                    CollapseArrowTween = nil
	                end

	                local TargetRotation = if Collapsed then 0 else 180

	                GroupboxContainer.Visible = not Collapsed
	                if Library.Animations and Library.Animations.Groupbox then
	                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	                    local Tween = TweenService:Create(GroupboxCollapseArrow, TweenInfo, { Rotation = TargetRotation })
	                    CollapseArrowTween = Tween

	                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Connect(function()
	                        if Connection then
	                            Connection:Disconnect()
	                        end

	                        if CollapseArrowTween == Tween then
	                            StopTween(CollapseArrowTween, true)
	                            CollapseArrowTween = nil
	                        end
	                    end))

	                    Tween:Play()
	                else
	                    GroupboxCollapseArrow.Rotation = TargetRotation
	                end

	                Groupbox:Resize()
	            end

	            function Groupbox:ToggleCollapsed()
	                if Info.DisableCollapsing == true then return end
	                Groupbox:SetCollapsed(not Groupbox.Collapsed)
	            end

	            function Groupbox:SetMaxHeight(MaxHeight: number?)
	                if MaxHeight ~= nil then
	                    assert(typeof(MaxHeight) == "number", "MaxHeight must be a number or nil")
	                    assert(MaxHeight > 0, "MaxHeight must be higher than 0")
	                end

	                Groupbox.MaxHeight = MaxHeight
	                Groupbox:Resize()
	            end

	            Library:MakeBoxPopOut(Groupbox, {
	                Enabled = Info.PopOut ~= false,
	                MaxPopOutHeight = Info.MaxPopOutHeight,
	                PopOutWidth = Info.PopOutWidth,

	                Header = GroupboxTop,
	                Children = function()
	                    local Children = {}
	                    for _, Child in BoxHolder:GetChildren() do
	                        if Child:IsA("GuiObject") and Child ~= Groupbox.PopOutPlaceholder then
	                            table.insert(Children, Child)
	                        end
	                    end
	                    return Children
	                end,

	                Before = function()
	                    GroupboxCollapseArrow.Visible = false
	                end,
	                After = function()
	                    GroupboxCollapseArrow.Visible = Info.DisableCollapsing ~= true
	                    Groupbox:Resize()
	                end
	            })

	            function Groupbox:Destroy()
	                if Groupbox.PoppedOut then
	                    Groupbox:SetPoppedOut(false)
	                end

	                Groupbox.Destroyed = true

	                if ResizeTween then
	                    StopTween(ResizeTween, true)
	                    ResizeTween = nil
	                end

	                if CollapseArrowTween then
	                    StopTween(CollapseArrowTween, true)
	                    CollapseArrowTween = nil
	                end

	                if Groupbox.Connections then
	                    for _, Connection in Groupbox.Connections do
	                        Connection:Disconnect()
	                    end
	                end

	                for _, Element in Groupbox.Elements do
	                    if Element.Destroy then
	                        Element:Destroy()
	                    end
	                end
	                table.clear(Groupbox.Elements)

	                for _, SubDepbox in Groupbox.DependencyBoxes do
	                    if SubDepbox.Destroy then
	                        SubDepbox:Destroy()
	                    end
	                end
	                table.clear(Groupbox.DependencyBoxes)

	                if GroupboxHolder then
	                    GroupboxHolder:Destroy()
	                end

	                if BoxHolder then
	                    BoxHolder:Destroy()
	                end
	            end

	            function Groupbox:SetVisible(Visible: boolean)
	                Groupbox.Visible = Visible
	                BoxHolder.Visible = Visible
	                SyncPopOutVisibility(Groupbox)

	                if Visible == true and Library.Searching then
	                    Library:UpdateSearch(Library.SearchText)
	                end
	            end

	            function Groupbox:Show()
	                Groupbox:SetVisible(true)
	            end

	            function Groupbox:Hide()
	                Groupbox:SetVisible(false)
	            end

	            if Info.DisableCollapsing ~= true then
	                GroupboxCollapseArrow.MouseButton1Click:Connect(function()
	                    Groupbox:ToggleCollapsed()
	                end)
	            end

	            Groupbox.AddTabbox = AddTabbox
	            setmetatable(Groupbox, BaseGroupbox)

	            Groupbox:Resize()
	            Tab.Groupboxes[Info.Name] = Groupbox

	            if Info.Visible == false then
	                Groupbox:Hide()
	            end

	            if Info.DisableCollapsing ~= true and Info.Collapsed == true then
	                Groupbox:SetCollapsed(true)
	            end

	            return Groupbox
	        end

	        --// Deprecated - Use Tab:AddGroupbox instead.
	        function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
	            return Tab:AddGroupbox({ Side = 1, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
	        end

	        --// Deprecated - Use Tab:AddGroupbox instead.
	        function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
	            return Tab:AddGroupbox({ Side = 2, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
	        end

	        function Tab:Hover(Hovering)
	            if Library.ActiveTab == Tab then
	                return
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = Hovering and 0.25 or 0.5,
	            }):Play()
	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = Hovering and 0.25 or 0.5 })
	            end
	        end

	        function Tab:Show()
	            if Library.ActiveTab == Tab then
	                return
	            end

	            if Library.ActiveTab then
	                Library.ActiveTab:Hide()
	            end

	            TweenService:Create(TabButton, Library.TweenInfo, {
	                BackgroundTransparency = 0,
	            }):Play()
	            if TabIndicator then
	                TweenService:Create(TabIndicator, Library.TweenInfo, {
	                    BackgroundTransparency = 0,
	                }):Play()
	            end
	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = 0,
	            }):Play()
	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = 0 })
	            end

	            if Description then
	                Window:ShowTabInfo(Name, Description)
	            end

	            Library:PlayTabAnimation(Tab, true)
	            Tab:RefreshSides()

	            Library.ActiveTab = Tab

	            if Library.Searching then
	                Library:UpdateSearch(Library.SearchText)
	            end
	        end

	        function Tab:Hide()
	            TweenService:Create(TabButton, Library.TweenInfo, {
	                BackgroundTransparency = 1,
	            }):Play()

	            if TabIndicator then
	                TweenService:Create(TabIndicator, Library.TweenInfo, {
	                    BackgroundTransparency = 1,
	                }):Play()
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = 0.5,
	            }):Play()

	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = 0.5 })
	            end

	            Library:PlayTabAnimation(Tab, false)
	            Window:HideTabInfo()

	            Library.PreviousTab = Tab
	            Library.ActiveTab = nil
	        end

	        function Tab:SetVisible(Visible: boolean)
	            TabButton.Visible = Visible

	            if not Visible and Library.ActiveTab == Tab then
	                Tab:Hide()
	            end
	        end

	        function Tab:SetOrder(NewOrder: number)
	            Order = NewOrder
	            TabButton.LayoutOrder = Order
	        end

	        function Tab:SetTooltip(Text: string?)
	            Tab.Tooltip = Text

	            if Tab.TooltipTable then
	                Tab.TooltipTable:Destroy()
	                Tab.TooltipTable = nil
	            end

	            if typeof(Text) == "string" then
	                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
	            end
	        end

	        function Tab:Destroy()
	            Tab.Destroyed = true

	            if Tab.Connections then
	                for _, Connection in Tab.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Tab.TooltipTable then
	                Tab.TooltipTable:Destroy()
	                Tab.TooltipTable = nil
	            end

	            for _, Groupbox in Tab.Groupboxes do
	                if Groupbox.Destroy then
	                    Groupbox:Destroy()
	                end
	            end
	            table.clear(Tab.Groupboxes)

	            for _, Tabbox in Tab.Tabboxes do
	                if Tabbox.Destroy then
	                    Tabbox:Destroy()
	                end
	            end
	            table.clear(Tab.Tabboxes)

	            for _, DepGroupbox in Tab.DependencyGroupboxes do
	                if DepGroupbox.Destroy then
	                    DepGroupbox:Destroy()
	                end
	            end

	            if TabContainer then
	                TabContainer:Destroy()
	            end

	            if TabButton then
	                for Index, Entry in Library.TabButtons do
	                    if typeof(Entry) == "table" and Entry.Button == TabButton then
	                        table.remove(Library.TabButtons, Index)
	                        break
	                    end
	                end

	                TabButton:Destroy()
	            end

	            Library.Tabs[Name] = nil
	        end

	        --// Execution \\--
	        if typeof(Tooltip) == "string" then
	            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
	        end

	        if not Library.ActiveTab then
	            Tab:Show()
	        end

	        TabButton.MouseEnter:Connect(function()
	            Tab:Hover(true)
	        end)
	        TabButton.MouseLeave:Connect(function()
	            Tab:Hover(false)
	        end)
	        TabButton.MouseButton1Click:Connect(Tab.Show)

	        Library.Tabs[Name] = Tab

	        return Tab
	    end

	    function Window:AddKeyTab(...)
	        local Name = nil
	        local Icon = nil
	        local Description = nil
	        local Tooltip = nil
	        local Order = nil

	        if select("#", ...) == 1 and typeof(...) == "table" then
	            local Info = select(1, ...)
	            Name = Info.Name or "Tab"
	            Icon = Info.Icon
	            Description = Info.Description
	            Tooltip = Info.Tooltip
	            Order = Info.Order
	        else
	            Name = select(1, ...) or "Tab"
	            Icon = select(2, ...)
	            Description = select(3, ...)
	            Order = select(4, ...)
	        end

	        if not tonumber(Order) then
	            Order = #Tabs:GetChildren()
	        end

	        Icon = Icon or "key"

	        local TabButton: TextButton
	        local TabIndicator
	        local TabLabel
	        local TabIcon

	        local TabContainer

	        Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
	        do
	            TabButton = New("TextButton", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 40),
	                Text = "",
	                LayoutOrder = Order,
	                Parent = Tabs,
	            })
	            New("UICorner", {
	                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
	                Parent = TabButton,
	            })

	            if TabButtonsStyle.Indicator then
	                TabIndicator = New("Frame", {
	                    AnchorPoint = Vector2.new(1, 0.5),
	                    BackgroundColor3 = "AccentColor",
	                    BackgroundTransparency = 1,
	                    Position = UDim2.new(0, -2, 0.5, 0),
	                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
	                    Parent = TabButton,
	                })

	                New("UICorner", {
	                    CornerRadius = UDim.new(1, 0),
	                    Parent = TabIndicator,
	                })
	            end

	            local ButtonHolder = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Parent = TabButton,
	            })
	            local ButtonPadding = New("UIPadding", {
	                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
	                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
	                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
	                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
	                Parent = ButtonHolder,
	            })

	            TabLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Position = UDim2.fromOffset(30, 0),
	                Size = UDim2.new(1, -30, 1, 0),
	                Text = Name,
	                TextSize = 16,
	                TextTransparency = 0.5,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Visible = not IsCompact,
	                Parent = ButtonHolder,
	            })

	            if Icon then
	                TabIcon = Library:CreateIcon(Icon, {
	                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
	                    ImageTransparency = 0.5,
	                    Size = UDim2.fromScale(1, 1),
	                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
	                    Parent = ButtonHolder,
	                })
	            end

	            table.insert(Library.TabButtons, {
	                Label = TabLabel,
	                Padding = ButtonPadding,
	                Icon = TabIcon,
	            })

	            --// Tab Container \\--
	            TabContainer = New("ScrollingFrame", {
	                AutomaticCanvasSize = Enum.AutomaticSize.Y,
	                BackgroundTransparency = 1,
	                CanvasSize = UDim2.fromScale(0, 0),
	                ScrollBarThickness = 0,
	                Position = UDim2.fromScale(0, 0),
	                Size = UDim2.fromScale(1, 1),
	                Visible = false,
	                Parent = Container,
	            })
	            New("UIListLayout", {
	                HorizontalAlignment = Enum.HorizontalAlignment.Center,
	                Padding = UDim.new(0, 8),
	                VerticalAlignment = Enum.VerticalAlignment.Center,
	                Parent = TabContainer,
	            })
	            New("UIPadding", {
	                PaddingLeft = UDim.new(0, 1),
	                PaddingRight = UDim.new(0, 1),
	                Parent = TabContainer,
	            })
	        end

	        --// Tab Table \\--
	        local Tab = {
	            Description = Description,
	            IsKeyTab = true,

	            Tooltip = Tooltip,
	            TooltipTable = nil,

	            Elements = {},

	            Window = Window,
	            Button = TabButton,
	            Container = TabContainer
	        }

	        function Tab:AddKeyBox(Callback)
	            assert(typeof(Callback) == "function", "Callback must be a function")

	            local Holder = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.new(0.75, 0, 0, 21),
	                Parent = TabContainer,
	            })

	            local Box = New("TextBox", {
	                BackgroundColor3 = "MainColor",
	                PlaceholderText = "Key",
	                Size = UDim2.new(1, -71, 1, 0),
	                TextSize = 14,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Parent = Holder,
	            })
	            New("UIPadding", {
	                PaddingLeft = UDim.new(0, 8),
	                PaddingRight = UDim.new(0, 8),
	                Parent = Box,
	            })
	            local BoxStroke = New("UIStroke", {
	                Color = "OutlineColor",
	                Parent = Box,
	            })
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Box,
	                })
	            )

	            Box.Focused:Connect(function()
	                Library.Registry[BoxStroke].Color = "AccentColor"
	                TweenService:Create(BoxStroke, Library.TweenInfo, {
	                    Color = Library.Scheme.AccentColor,
	                }):Play()
	            end)

	            Box.FocusLost:Connect(function()
	                Library.Registry[BoxStroke].Color = "OutlineColor"
	                TweenService:Create(BoxStroke, Library.TweenInfo, {
	                    Color = Library.Scheme.OutlineColor,
	                }):Play()
	            end)

	            local Button = New("TextButton", {
	                AnchorPoint = Vector2.new(1, 0),
	                BackgroundColor3 = "MainColor",
	                Position = UDim2.fromScale(1, 0),
	                Size = UDim2.new(0, 63, 1, 0),
	                Text = "Execute",
	                TextSize = 14,
	                TextTransparency = 0.4,
	                Parent = Holder,
	            })
	            New("UIStroke", {
	                Color = "OutlineColor",
	                Parent = Button,
	            })
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
	                    Parent = Button,
	                })
	            )

	            Button.MouseEnter:Connect(function()
	                TweenService:Create(Button, Library.TweenInfo, {
	                    TextTransparency = 0,
	                }):Play()
	            end)

	            Button.MouseLeave:Connect(function()
	                TweenService:Create(Button, Library.TweenInfo, {
	                    TextTransparency = 0.4,
	                }):Play()
	            end)

	            Button.InputBegan:Connect(function(Input)
	                if not IsClickInput(Input) then
	                    return
	                end

	                if not Library:MouseIsOverFrame(Button, Input.Position) then
	                    return
	                end

	                Callback(Box.Text)
	            end)
	        end

	        function Tab:Destroy()
	            if TabContainer then
	                TabContainer:Destroy()
	            end

	            if TabButton then
	                for Index, Entry in Library.TabButtons do
	                    if typeof(Entry) == "table" and Entry.Button == TabButton then
	                        table.remove(Library.TabButtons, Index)
	                        break
	                    end
	                end

	                TabButton:Destroy()
	            end

	            Library.Tabs[Name] = nil
	        end

	        function Tab:SetOrder(NewOrder: number)
	            Order = NewOrder
	            TabButton.LayoutOrder = Order
	        end

	        function Tab:RefreshSides() end
	        function Tab:Resize() end
	        function Tab:UpdateCorners() end

	        function Tab:Hover(Hovering)
	            if Library.ActiveTab == Tab then
	                return
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = Hovering and 0.25 or 0.5,
	            }):Play()
	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = Hovering and 0.25 or 0.5 })
	            end
	        end

	        function Tab:Show()
	            if Library.ActiveTab == Tab then
	                return
	            end

	            if Library.ActiveTab then
	                Library.ActiveTab:Hide()
	            end

	            TweenService:Create(TabButton, Library.TweenInfo, {
	                BackgroundTransparency = 0,
	            }):Play()

	            if TabIndicator then
	                TweenService:Create(TabIndicator, Library.TweenInfo, {
	                    BackgroundTransparency = 0,
	                }):Play()
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = 0,
	            }):Play()

	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = 0 })
	            end

	            Library:PlayTabAnimation(Tab, true)

	            if Description then
	                Window:ShowTabInfo(Name, Description)
	            end

	            Tab:RefreshSides()

	            Library.ActiveTab = Tab

	            if Library.Searching then
	                Library:UpdateSearch(Library.SearchText)
	            end
	        end

	        function Tab:Hide()
	            TweenService:Create(TabButton, Library.TweenInfo, {
	                BackgroundTransparency = 1,
	            }):Play()

	            if TabIndicator then
	                TweenService:Create(TabIndicator, Library.TweenInfo, {
	                    BackgroundTransparency = 1,
	                }):Play()
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = 0.5,
	            }):Play()

	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = 0.5 })
	            end

	            Library:PlayTabAnimation(Tab, false)
	            Window:HideTabInfo()

	            Library.PreviousTab = Tab
	            Library.ActiveTab = nil
	        end

	        function Tab:SetVisible(Visible: boolean)
	            TabButton.Visible = Visible

	            if not Visible and Library.ActiveTab == Tab then
	                Tab:Hide()
	            end
	        end

	        function Tab:SetTooltip(Text: string?)
	            Tab.Tooltip = Text

	            if Tab.TooltipTable then
	                Tab.TooltipTable:Destroy()
	                Tab.TooltipTable = nil
	            end

	            if typeof(Text) == "string" then
	                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
	            end
	        end

	        --// Execution \\--
	        if typeof(Tooltip) == "string" then
	            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
	        end

	        if not Library.ActiveTab then
	            Tab:Show()
	        end

	        TabButton.MouseEnter:Connect(function()
	            Tab:Hover(true)
	        end)
	        TabButton.MouseLeave:Connect(function()
	            Tab:Hover(false)
	        end)
	        TabButton.MouseButton1Click:Connect(Tab.Show)

	        Tab.Container = TabContainer
	        setmetatable(Tab, BaseGroupbox)

	        Library.Tabs[Name] = Tab

	        return Tab
	    end

	    function Window:AddCustomTab(...)
	        local Name = nil
	        local Icon = nil
	        local Description = nil
	        local Tooltip = nil
	        local Order = nil

	        if select("#", ...) == 1 and typeof(...) == "table" then
	            local Info = select(1, ...)
	            Name = Info.Name or "Tab"
	            Icon = Info.Icon
	            Description = Info.Description
	            Tooltip = Info.Tooltip
	            Order = Info.Order
	        else
	            Name = select(1, ...) or "Tab"
	            Icon = select(2, ...)
	            Description = select(3, ...)
	            Order = select(4, ...)
	        end

	        if not tonumber(Order) then
	            Order = #Tabs:GetChildren()
	        end

	        local TabButton: TextButton
	        local TabIndicator
	        local TabLabel
	        local TabIcon

	        local TabContainer

	        Icon = Library:GetCustomIcon(Icon)
	        do
	            TabButton = New("TextButton", {
	                BackgroundColor3 = "MainColor",
	                BackgroundTransparency = 1,
	                Size = UDim2.new(1, 0, 0, 40),
	                Text = "",
	                LayoutOrder = Order,
	                Parent = Tabs,
	            })
	            New("UICorner", {
	                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
	                Parent = TabButton,
	            })

	            if TabButtonsStyle.Indicator then
	                TabIndicator = New("Frame", {
	                    AnchorPoint = Vector2.new(1, 0.5),
	                    BackgroundColor3 = "AccentColor",
	                    BackgroundTransparency = 1,
	                    Position = UDim2.new(0, -2, 0.5, 0),
	                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
	                    Parent = TabButton,
	                })

	                New("UICorner", {
	                    CornerRadius = UDim.new(1, 0),
	                    Parent = TabIndicator,
	                })
	            end

	            local ButtonHolder = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Parent = TabButton,
	            })
	            local ButtonPadding = New("UIPadding", {
	                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
	                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
	                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
	                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
	                Parent = ButtonHolder,
	            })

	            TabLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Position = UDim2.fromOffset(30, 0),
	                Size = UDim2.new(1, -30, 1, 0),
	                Text = Name,
	                TextSize = 16,
	                TextTransparency = 0.5,
	                TextXAlignment = Enum.TextXAlignment.Left,
	                Visible = not IsCompact,
	                Parent = ButtonHolder,
	            })

	            if Icon then
	                TabIcon = Library:CreateIcon(Icon, {
	                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
	                    ImageTransparency = 0.5,
	                    Size = UDim2.fromScale(1, 1),
	                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
	                    Parent = ButtonHolder,
	                })
	            end

	            table.insert(Library.TabButtons, {
	                Label = TabLabel,
	                Padding = ButtonPadding,
	                Icon = TabIcon,
	            })

	            --// Tab Container \\--
	            TabContainer = New("Frame", {
	                BackgroundTransparency = 1,
	                Position = UDim2.fromScale(0, 0),
	                Size = UDim2.fromScale(1, 1),
	                Visible = false,
	                Parent = Container,
	            })
	        end

	        --// Tab Table \\--
	        local Tab = {
	            Name = Name,
	            Description = Description,
	            IsCustomTab = true,

	            Tooltip = Tooltip,
	            TooltipTable = nil,

	            Connections = {},
	            Destroyed = false,

	            Window = Window,
	            Button = TabButton,
	            Container = TabContainer,
	            Sides = {},

	            Groupboxes = {},
	            Tabboxes = {},
	            DependencyGroupboxes = {},
	        }

	        function Tab:RefreshSides() end
	        function Tab:Resize() end
	        function Tab:UpdateCorners() end

	        function Tab:Hover(Hovering)
	            if Library.ActiveTab == Tab then
	                return
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = Hovering and 0.25 or 0.5,
	            }):Play()
	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = Hovering and 0.25 or 0.5 })
	            end
	        end

	        function Tab:Show()
	            if Library.ActiveTab == Tab then
	                return
	            end

	            if Library.ActiveTab then
	                Library.ActiveTab:Hide()
	            end

	            TweenService:Create(TabButton, Library.TweenInfo, {
	                BackgroundTransparency = 0,
	            }):Play()

	            if TabIndicator then
	                TweenService:Create(TabIndicator, Library.TweenInfo, {
	                    BackgroundTransparency = 0,
	                }):Play()
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = 0,
	            }):Play()

	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = 0 })
	            end

	            Library:PlayTabAnimation(Tab, true)

	            if Description then
	                Window:ShowTabInfo(Name, Description)
	            end

	            Library.ActiveTab = Tab

	            if Library.Searching then
	                Library:UpdateSearch(Library.SearchText)
	            end
	        end

	        function Tab:Hide()
	            TweenService:Create(TabButton, Library.TweenInfo, {
	                BackgroundTransparency = 1,
	            }):Play()

	            if TabIndicator then
	                TweenService:Create(TabIndicator, Library.TweenInfo, {
	                    BackgroundTransparency = 1,
	                }):Play()
	            end

	            TweenService:Create(TabLabel, Library.TweenInfo, {
	                TextTransparency = 0.5,
	            }):Play()

	            if TabIcon then
	                TweenIcon(TabIcon, { ImageTransparency = 0.5 })
	            end

	            Library:PlayTabAnimation(Tab, false)
	            Window:HideTabInfo()

	            Library.PreviousTab = Tab
	            Library.ActiveTab = nil
	        end

	        function Tab:SetVisible(Visible: boolean)
	            TabButton.Visible = Visible

	            if not Visible and Library.ActiveTab == Tab then
	                Tab:Hide()
	            end
	        end

	        function Tab:SetOrder(NewOrder: number)
	            Order = NewOrder
	            TabButton.LayoutOrder = Order
	        end

	        function Tab:SetTooltip(Text: string?)
	            Tab.Tooltip = Text

	            if Tab.TooltipTable then
	                Tab.TooltipTable:Destroy()
	                Tab.TooltipTable = nil
	            end

	            if typeof(Text) == "string" then
	                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
	            end
	        end

	        function Tab:Destroy()
	            Tab.Destroyed = true

	            if Tab.Connections then
	                for _, Connection in Tab.Connections do
	                    Connection:Disconnect()
	                end
	            end

	            if Tab.TooltipTable then
	                Tab.TooltipTable:Destroy()
	                Tab.TooltipTable = nil
	            end

	            if Library.ActiveTab == Tab then
	                Tab:Hide()
	            end

	            if TabContainer then
	                TabContainer:Destroy()
	            end

	            if TabButton then
	                for Index, Entry in Library.TabButtons do
	                    if typeof(Entry) == "table" and Entry.Button == TabButton then
	                        table.remove(Library.TabButtons, Index)
	                        break
	                    end
	                end

	                TabButton:Destroy()
	            end

	            Library.Tabs[Name] = nil
	        end

	        --// Execution \\--
	        if typeof(Tooltip) == "string" then
	            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
	        end

	        if not Library.ActiveTab then
	            Tab:Show()
	        end

	        table.insert(Tab.Connections, TabButton.MouseEnter:Connect(function()
	            Tab:Hover(true)
	        end))
	        table.insert(Tab.Connections, TabButton.MouseLeave:Connect(function()
	            Tab:Hover(false)
	        end))
	        table.insert(Tab.Connections, TabButton.MouseButton1Click:Connect(Tab.Show))

	        Library.Tabs[Name] = Tab

	        return TabContainer, Tab
	    end

	    function Window:AddDialog(Idx, Info)
	        Info = Library:Validate(Info, Templates.Dialog)

	        local DialogFrame
	        local DialogOverlay
	        local DialogContainer
	        local ButtonsHolder
	        local FooterButtonsList = {}

	        DialogOverlay = New("TextButton", {
	            AutoButtonColor = false,
	            BackgroundColor3 = "DarkColor",
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 1),
	            Text = "",
	            Active = false,
	            ZIndex = 9000,
	            Visible = true,
	            Parent = MainFrame,
	        })
	        TweenService:Create(DialogOverlay, Library.TweenInfo, {
	            BackgroundTransparency = 0.5,
	        }):Play()

	        DialogFrame = New("TextButton", {
	            AnchorPoint = Vector2.new(0.5, 0.5),
	            BackgroundColor3 = "BackgroundColor",
	            Position = UDim2.fromScale(0.5, 0.5),
	            Size = UDim2.fromOffset(300, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            Text = "",
	            AutoButtonColor = false,
	            ZIndex = 1,
	            Parent = DialogOverlay,
	        })
	        table.insert(
	            Library.Corners,
	            New("UICorner", {
	                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
	                Parent = DialogFrame,
	            })
	        )
	        Library:AddOutline(DialogFrame)

	        local InnerContainer = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            ZIndex = 2,
	            Parent = DialogFrame,
	        })
	        local DialogScale = New("UIScale", {
	            Scale = 0.95,
	            Parent = DialogFrame,
	        })
	        TweenService:Create(DialogScale, Library.TweenInfo, {
	            Scale = 1
	        }):Play()
	        local _InnerPadding = New("UIPadding", {
	            PaddingBottom = UDim.new(0, 15),
	            PaddingLeft = UDim.new(0, 15),
	            PaddingRight = UDim.new(0, 15),
	            PaddingTop = UDim.new(0, 15),
	            Parent = InnerContainer,
	        })
	        local _InnerLayout = New("UIListLayout", {
	            Padding = UDim.new(0, 10),
	            SortOrder = Enum.SortOrder.LayoutOrder,
	            Parent = InnerContainer,
	        })

	        local HeaderContainer = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            LayoutOrder = 1,
	            ZIndex = 2,
	            Parent = InnerContainer,
	        })
	        New("UIListLayout", {
	            Padding = UDim.new(0, 6),
	            SortOrder = Enum.SortOrder.LayoutOrder,
	            Parent = HeaderContainer,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 5),
	            Parent = HeaderContainer,
	        })

	        local TitleRow = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 20),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            LayoutOrder = 1,
	            ZIndex = 2,
	            Parent = HeaderContainer,
	        })
	        New("UIListLayout", {
	            Padding = UDim.new(0, 6),
	            FillDirection = Enum.FillDirection.Horizontal,
	            VerticalAlignment = Enum.VerticalAlignment.Center,
	            SortOrder = Enum.SortOrder.LayoutOrder,
	            Parent = TitleRow,
	        })

	        if Info.Icon then
	            local ParsedIcon = Library:GetCustomIcon(Info.Icon)
	            if ParsedIcon then
	                Library:CreateIcon(ParsedIcon, {
	                    Size = UDim2.fromOffset(16, 16),
	                    ImageColor3 = Info.TitleColor or "FontColor",
	                    LayoutOrder = 1,
	                    ZIndex = 2,
	                    Parent = TitleRow,
	                })
	            end
	        end

	        local TitleLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 18),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            Text = Info.Title,
	            TextSize = 18,
	            TextColor3 = Info.TitleColor or "FontColor",
	            TextXAlignment = Enum.TextXAlignment.Left,
	            LayoutOrder = 2,
	            ZIndex = 2,
	            Parent = TitleRow,
	        })

	        local DescriptionLabel = New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 14),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            Text = Info.Description,
	            TextSize = 14,
	            TextTransparency = Info.DescriptionColor and 0 or 0.2,
	            TextXAlignment = Enum.TextXAlignment.Left,
	            TextColor3 = Info.DescriptionColor or "FontColor",
	            TextWrapped = true,
	            LayoutOrder = 2,
	            ZIndex = 2,
	            Parent = HeaderContainer,
	        })

	        DialogContainer = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.fromScale(1, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            LayoutOrder = 4,
	            ZIndex = 2,
	            Parent = InnerContainer,
	        })
	        local _DialogContainerLayout = New("UIListLayout", {
	            Padding = UDim.new(0, 8),
	            SortOrder = Enum.SortOrder.LayoutOrder,
	            Parent = DialogContainer,
	        })
	        New("UIPadding", {
	            PaddingBottom = UDim.new(0, 5),
	            Parent = DialogContainer,
	        })

	        local _Sep2 = New("Frame", {
	            BackgroundColor3 = "OutlineColor",
	            BackgroundTransparency = 0,
	            BorderSizePixel = 0,
	            Size = UDim2.new(1, 0, 0, 1),
	            LayoutOrder = 5,
	            ZIndex = 2,
	            Parent = InnerContainer,
	        })

	        ButtonsHolder = New("Frame", {
	            BackgroundTransparency = 1,
	            Size = UDim2.new(1, 0, 0, 0),
	            AutomaticSize = Enum.AutomaticSize.Y,
	            LayoutOrder = 6,
	            ZIndex = 2,
	            Parent = InnerContainer,
	        })
	        New("UIListLayout", {
	            Padding = UDim.new(0, 8),
	            FillDirection = Enum.FillDirection.Horizontal,
	            HorizontalAlignment = Enum.HorizontalAlignment.Right,
	            Wraps = true,
	            SortOrder = Enum.SortOrder.LayoutOrder,
	            Parent = ButtonsHolder,
	        })
	        New("UIPadding", {
	            PaddingTop = UDim.new(0, 5),
	            Parent = ButtonsHolder,
	        })

	        local Dialog = {
	            Destroyed = false,
	            Elements = {},
	            Container = DialogContainer,
	            OutsideClickDismiss = Info.OutsideClickDismiss,
	        }

	        function Dialog:Resize()
	            local MaxWidth = (MainFrame.AbsoluteSize.X / Library.DPIScale) * 0.75
	            local MinWidth = 400

	            local TotalButtonWidth = 0
	            local ButtonCount = 0
	            local HasButtons = false

	            for _, BtnWrap in FooterButtonsList do
	                HasButtons = true
	                ButtonCount = ButtonCount + 1
	                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
	            end

	            local TargetWidth = MinWidth
	            if HasButtons then
	                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
	                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
	            end

	            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

	            local _DescX, DescY = Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
	            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

	            local HasElements = false
	            for _, v in DialogContainer:GetChildren() do
	                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
	                    HasElements = true
	                    break
	                end
	            end
	            DialogContainer.Visible = HasElements

	            ButtonsHolder.Visible = HasButtons
	            _Sep2.Visible = HasButtons
	        end

	        function Dialog:SetTitle(Title)
	            TitleLabel.Text = Title
	            Dialog:Resize()
	        end

	        function Dialog:SetDescription(Description)
	            DescriptionLabel.Text = Description
	            Dialog:Resize()
	        end

	        function Dialog:Dismiss()
	            if Dialog.Destroyed then
	                return
	            end

	            Dialog.Destroyed = true

	            if Library.ActiveDialog == Dialog then
	                Library.ActiveDialog = nil
	            end

	            for Index = #Dialog.Elements, 1, -1 do
	                local Element = Dialog.Elements[Index]
	                if Element and Element.Destroy then
	                    Element:Destroy()
	                end
	            end
	            table.clear(Dialog.Elements)

	            local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
	            TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
	            CloseTween:Play()

	            task.delay(Library.TweenInfo.Time, function()
	                DialogOverlay:Destroy()
	            end)
	            Library.Dialogues[Idx] = nil
	        end

	        DialogOverlay.MouseButton1Click:Connect(function()
	            if Info.OutsideClickDismiss then
	                Dialog:Dismiss()
	            end
	        end)

	        function Dialog:RemoveFooterButton(ButtonIdx)
	            if FooterButtonsList[ButtonIdx] then
	                FooterButtonsList[ButtonIdx].Container:Destroy()
	                FooterButtonsList[ButtonIdx] = nil
	            end
	        end

	        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
	            if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
	                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
	            end
	        end

	        function Dialog:SetButtonOrder(ButtonIdx, Order)
	            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
	                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
	            end
	        end

	        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
	            Dialog:RemoveFooterButton(ButtonIdx)

	            local WaitTime = ButtonInfo.WaitTime or 0

	            local ButtonContainer = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromOffset(0, 26),
	                LayoutOrder = ButtonInfo.Order or 0,
	                ZIndex = 2,
	                Parent = ButtonsHolder,
	            })

	            local BtnColor = "MainColor"
	            local BtnOutline = "OutlineColor"
	            local Variant = ButtonInfo.Variant or "Primary"

	            if Variant == "Primary" then
	                BtnColor = "FontColor"
	                BtnOutline = "FontColor"
	            elseif Variant == "Secondary" then
	                BtnColor = "MainColor"
	                BtnOutline = "OutlineColor"
	            elseif Variant == "Destructive" then
	                BtnColor = "DestructiveColor"
	                BtnOutline = "DestructiveColor"
	            elseif Variant == "Ghost" then
	                BtnColor = "BackgroundColor"
	                BtnOutline = "BackgroundColor"
	            end

	            local TextBtn = New("TextButton", {
	                BackgroundColor3 = BtnColor,
	                BorderColor3 = BtnOutline,
	                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
	                Size = UDim2.fromOffset(0, 26),
	                Text = "",
	                AutoButtonColor = false,
	                ZIndex = 2,
	                Parent = ButtonContainer,
	            })
	            Library:AddOutline(TextBtn)
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius),
	                    Parent = TextBtn
	                })
	            )

	            local _BtnPadding = New("UIPadding", {
	                PaddingLeft = UDim.new(0, 15),
	                PaddingRight = UDim.new(0, 15),
	                Parent = TextBtn,
	            })

	            local TextColor = Library.Scheme.FontColor
	            if Variant == "Primary" then
	                TextColor = Library.Scheme.BackgroundColor
	            elseif Variant == "Destructive" then
	                TextColor = Color3.new(1, 1, 1)
	            end

	            local BtnLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Text = ButtonInfo.Title or ButtonIdx,
	                TextColor3 = TextColor,
	                TextTransparency = WaitTime > 0 and 0.5 or 0,
	                TextSize = 14,
	                ZIndex = 2,
	                Parent = TextBtn,
	            })

	            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
	            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
	            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

	            local ProgressBar
	            if WaitTime > 0 then
	                ProgressBar = New("Frame", {
	                    BackgroundColor3 = "AccentColor",
	                    BorderSizePixel = 0,
	                    Position = UDim2.new(0, 0, 1, -2),
	                    Size = UDim2.new(0, 0, 0, 2),
	                    ZIndex = 2,
	                    Parent = TextBtn,
	                })
	                table.insert(
	                    Library.Corners,
	                    New("UICorner", {
	                        CornerRadius = UDim.new(0, Library.CornerRadius),
	                        Parent = ProgressBar
	                    })
	                )
	            end

	            local IsActive = WaitTime <= 0

	            local ButtonWrap = {
	                Container = ButtonContainer,
	                SetDisabled = function(self, Disabled)
	                    IsActive = not Disabled
	                    if Disabled then
	                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
	                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
	                    else
	                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
	                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
	                    end
	                end
	            }

	            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
	            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

	            TextBtn.MouseEnter:Connect(function()
	                if not IsActive then return end
	                TweenService:Create(TextBtn, Library.TweenInfo, {
	                    BackgroundColor3 = HoverColor
	                }):Play()
	            end)
	            TextBtn.MouseLeave:Connect(function()
	                if not IsActive then return end
	                TweenService:Create(TextBtn, Library.TweenInfo, {
	                    BackgroundColor3 = ActiveColor
	                }):Play()
	            end)

	            TextBtn.MouseButton1Click:Connect(function()
	                if not IsActive then return end
	                if ButtonInfo.Callback then
	                    ButtonInfo.Callback(Dialog)
	                end
	                if Info.AutoDismiss then
	                    Dialog:Dismiss()
	                end
	            end)

	            if WaitTime > 0 then
	                TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
	                    Size = UDim2.new(1, 0, 0, 2)
	                }):Play()

	                task.delay(WaitTime, function()
	                    ButtonWrap:SetDisabled(false)
	                    if ProgressBar then
	                        TweenService:Create(ProgressBar, Library.TweenInfo, {
	                            BackgroundTransparency = 1
	                        }):Play()
	                    end
	                end)
	            end

	            FooterButtonsList[ButtonIdx] = ButtonWrap
	        end

	        for BIdx, BInfo in Info.FooterButtons do
	            if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
	            Dialog:AddFooterButton(BIdx, BInfo)
	        end

	        setmetatable(Dialog, BaseGroupbox)
	        Library.Dialogues[Idx] = Dialog

	        Dialog:Resize()

	        Library.ActiveDialog = Dialog
	        return Dialog
	    end

	    local GuiProperties = { "BackgroundTransparency" }
	    local ImageProperties = { "BackgroundTransparency", "ImageTransparency" }
	    local TextProperties = { "BackgroundTransparency", "TextTransparency" }
	    local StrokeProperties = { "Transparency" }

	    local function FadeInstance(Desc, Properties)
	        local Cache = TransparencyCache[Desc]
	        if not Cache then
	            Cache = {}
	            TransparencyCache[Desc] = Cache
	        end

	        for _, Prop in Properties do
	            if not Library.Toggled then
	                Cache[Prop] = Desc[Prop]
	            end

	            if Cache[Prop] ~= nil and Cache[Prop] ~= 1 then
	                TweenService:Create(Desc, Library.WindowAnimationInfo, {
	                    [Prop] = Library.Toggled and Cache[Prop] or 1,
	                }):Play()
	            end
	        end
	    end

	    function Window:Toggle(Value: boolean?)
	        if Fading then
	            return
	        end

	        if Library.ActiveLoading then
	            if Value == true then
	                return
	            end

	            if not Library.Toggled then
	                return
	            end
	        end

	        if typeof(Value) == "boolean" then
	            Library.Toggled = Value
	        else
	            Library.Toggled = not Library.Toggled
	        end

	        if Library.Animations and Library.Animations.ToggleWindow == true then
	            local FadeTime = Library.WindowAnimationInfo.Time
	            Fading = true

	            if Library.Toggled then
	                MainFrame.Visible = true
	            end

	            if Library.Toggled then
	                FadeInstance(MainFrame, { "BackgroundTransparency" })
	                task.wait(FadeTime / 2)
	            else
	                task.delay(FadeTime / 2, FadeInstance, MainFrame, { "BackgroundTransparency" })
	            end

	            for _, Instance in MainFrame:GetDescendants() do
	                if Instance == TopBar then
	                    continue
	                end

	                if Instance:IsA("GuiObject") then
	                    local ClassName = Instance.ClassName
	                    if ClassName == "ImageLabel" or ClassName == "ImageButton" then
	                        FadeInstance(Instance, ImageProperties)
	                    elseif ClassName == "TextLabel" or ClassName == "TextBox" or ClassName == "TextButton" then
	                        FadeInstance(Instance, TextProperties)
	                    else
	                        FadeInstance(Instance, GuiProperties)
	                    end
	                elseif Instance.ClassName == "UIStroke" then
	                    FadeInstance(Instance, StrokeProperties)
	                end
	            end

	            task.delay(FadeTime, function()
	                MainFrame.Visible = Library.Toggled
	                Fading = false
	            end)
	        else
	            MainFrame.Visible = Library.Toggled
	        end

	        if WindowInfo.UnlockMouseWhileOpen then
	            ModalElement.Modal = Library.Toggled
	        end

	        if Library.Toggled and not Library.IsMobile then
	            local ShowCursorBinding = Library.ShowCursorBinding
	            Library.OriginalMouseIconEnabled = UserInputService.MouseIconEnabled

	            pcall(function() RunService:UnbindFromRenderStep(ShowCursorBinding) end)
	            RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
	                UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

	                Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
	                Cursor.Visible = Library.ShowCustomCursor

	                if Library.Unloaded == true or not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
	                    RestoreMouseIcon()
	                end
	            end)
	        elseif not Library.Toggled then
	            RestoreMouseIcon()
	            TooltipLabel.Visible = false

	            CloseMenus()
	        end
	    end

	    function Library:Toggle(Value: boolean?)
	        return Window:Toggle(Value)
	    end

	    if WindowInfo.EnableSidebarResize then
	        local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth) * WindowInfo.SidebarCollapseThreshold
	        local StartPos, StartWidth
	        local Dragging = false
	        local Changed

	        local SidebarGrabber = New("TextButton", {
	            AnchorPoint = Vector2.new(0.5, 0),
	            BackgroundTransparency = 1,
	            Position = UDim2.fromScale(0.5, 0),
	            Size = UDim2.new(0, 8, 1, 0),
	            Text = "",
	            Parent = DividerLine,
	        })
	        SidebarGrabber.MouseEnter:Connect(function()
	            TweenService:Create(DividerLine, Library.TweenInfo, {
	                BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
	            }):Play()
	        end)
	        SidebarGrabber.MouseLeave:Connect(function()
	            if Dragging then
	                return
	            end
	            TweenService:Create(DividerLine, Library.TweenInfo, {
	                BackgroundColor3 = Library.Scheme.OutlineColor,
	            }):Play()
	        end)

	        SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
	            if not IsClickInput(Input) then
	                return
	            end

	            Library.CantDragForced = true

	            StartPos = Input.Position
	            StartWidth = Window:GetSidebarWidth()
	            Dragging = true

	            Changed = Input.Changed:Connect(function()
	                if Input.UserInputState ~= Enum.UserInputState.End then
	                    return
	                end

	                Library.CantDragForced = false
	                TweenService:Create(DividerLine, Library.TweenInfo, {
	                    BackgroundColor3 = Library.Scheme.OutlineColor,
	                }):Play()

	                Dragging = false
	                if Changed and Changed.Connected then
	                    Changed:Disconnect()
	                    Changed = nil
	                end
	            end)
	        end)

	        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
	            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
	                Dragging = false
	                if Changed and Changed.Connected then
	                    Changed:Disconnect()
	                    Changed = nil
	                end

	                return
	            end

	            if Dragging and IsHoverInput(Input) then
	                local Delta = Input.Position - StartPos
	                local Width = StartWidth + Delta.X

	                if WindowInfo.DisableCompactingSnap then
	                    Window:SetSidebarWidth(Width)
	                    return
	                end

	                if Width > Threshold then
	                    Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
	                else
	                    Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
	                end
	            end
	        end))
	    end

	    Window:SetAlwaysOnTop(WindowInfo.AlwaysOnTop)
	    if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
	        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
	    end
	    if WindowInfo.AutoShow and not Library.ActiveLoading then
	        task.spawn(Library.Toggle)
	    end

	    if Library.IsMobile then
	        local ToggleButton = Library:AddDraggableButton("Toggle", function()
	            Library:Toggle()
	        end, true)

	        local LockButton = Library:AddDraggableButton("Lock", function(self)
	            Library.CantDragForced = not Library.CantDragForced
	            self:SetText(Library.CantDragForced and "Unlock" or "Lock")
	        end, true)

	        if WindowInfo.MobileButtonsSide == "Right" then
	            ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)
	            ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)

	            LockButton.Button.AnchorPoint = Vector2.new(1, 0)
	            LockButton.Button.Position = UDim2.new(1, -(ToggleButton.Button.Size.X.Offset + 12), 0, 6)
	        else
	            ToggleButton.Button.AnchorPoint = Vector2.new(0, 0)
	            ToggleButton.Button.Position = UDim2.fromOffset(6, 6)

	            LockButton.Button.AnchorPoint = Vector2.new(0, 0)
	            LockButton.Button.Position = UDim2.fromOffset(ToggleButton.Button.Size.X.Offset + 12, 6)
	        end

	        if WindowInfo.ShowMobileButtons == false then
	            ToggleButton.Button.Visible = false
	            LockButton.Button.Visible = false
	        end
	    end

	    --// Execution \\--
	    Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	        Library:UpdateSearch(SearchBox.Text)
	    end))

	    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
	        if Library.Unloaded then
	            return
	        end

	        if Input.KeyCode == Enum.KeyCode.Escape then
	            -- Releasing focus from a text input takes priority and never toggles the window --
	            local FocusedBox = UserInputService:GetFocusedTextBox()
	            if FocusedBox then
	                FocusedBox:ReleaseFocus()
	                return
	            end

	            -- Dismiss the topmost dialog before closing any open menu --
	            if Library.ActiveDialog and Library.ActiveDialog.OutsideClickDismiss ~= false then
	                Library.ActiveDialog:Dismiss()
	                return
	            end

	            if CurrentMenu then
	                CurrentMenu:Close()
	                return
	            end

	            return
	        end

	        if UserInputService:GetFocusedTextBox() then
	            return
	        end

	        if Input.KeyCode == Library.ToggleKeybind then
	            Library:Toggle()
	        end
	    end))

	    Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
	        Library.IsRobloxFocused = true
	    end))
	    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
	        Library.IsRobloxFocused = false
	    end))

	    Window.MainFrame = MainFrame
	    Library.Window = Window

	    return Window
	end

	function Library:CreateLoading(LoadingInfo)
	    if Library.ActiveLoading then
	        warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
	        return Library.ActiveLoading
	    end

	    LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

	    local Loading = {
	        CurrentStep = LoadingInfo.CurrentStep,
	        TotalSteps = LoadingInfo.TotalSteps,

	        ShowSidebar = LoadingInfo.ShowSidebar,
	        AutoResizeHeight = LoadingInfo.AutoResizeHeight,
	        AlwaysOnTop = LoadingInfo.AlwaysOnTop,

	        IsError = false,
	        Destroyed = false,

	        WindowWidth = LoadingInfo.WindowWidth,
	        WindowHeight = LoadingInfo.WindowHeight,
	        BaseWindowHeight = LoadingInfo.WindowHeight,
	        WindowErrorHeight = LoadingInfo.WindowHeight,

	        ContentWidth = LoadingInfo.ContentWidth,
	        SidebarWidth = LoadingInfo.SidebarWidth,
	    }

	    --// ScreenGui \\--
	    local ScreenGui = New("ScreenGui", {
	        Name = "ObsidianLoading",
	        DisplayOrder = 999,
	        ResetOnSpawn = false
	    })
	    ParentUI(ScreenGui)
	    Loading.ScreenGui = ScreenGui
	    SetAlwaysOnTop(ScreenGui, LoadingInfo.AlwaysOnTop)

	    ScreenGui.DescendantRemoving:Connect(function(Instance)
	        task.defer(function()
	            if Instance.Parent and Instance:IsDescendantOf(ScreenGui) then
	                return
	            end

	            Library:RemoveFromRegistry(Instance)
	        end)
	    end)

	    --// Main Frame \\--
	    local MainFrame = New("TextButton", {
	        Name = "Main",
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        BackgroundColor3 = function()
	            return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
	        end,
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.fromOffset(Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth, Loading.WindowHeight),
	        ClipsDescendants = true,
	        Text = "",
	        AutoButtonColor = false,
	        Parent = ScreenGui,
	    })
	    Library:AddOutline(MainFrame)
	    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame }))

	    local MainScale = New("UIScale", {
	        Scale = Library.IsMobile and 0.8 or 1,
	        Parent = MainFrame
	    })
	    table.insert(Library.Scales, MainScale)
	    Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

	    --// Layout Containers \\--
	    local Container = New("Frame", {
	        Name = "Content",
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(0, 0),
	        Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
	        Parent = MainFrame,
	    })

	    local SideBar = New("Frame", {
	        Name = "SideBar",
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(Loading.ContentWidth, 0),
	        Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
	        ClipsDescendants = true,
	        Visible = Loading.ShowSidebar,
	        Parent = MainFrame,
	    })
	    local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
	    table.insert(Library.Corners, SidebarCorner)

	    Library:AddOutline(SideBar)

	    local SidebarDivider = New("Frame", {
	        BackgroundColor3 = "OutlineColor",
	        BorderSizePixel = 0,
	        Position = UDim2.fromOffset(0, 0),
	        Size = UDim2.new(0, 1, 1, 0),
	        Visible = Loading.ShowSidebar,
	        Parent = SideBar,
	    })

	    --// Top Bar \\--
	    local TopBar = New("Frame", {
	        Name = "TopBar",
	        BackgroundTransparency = 1,
	        Size = UDim2.new(1, 0, 0, 48),
	        ZIndex = 2,
	        Parent = Container,
	    })
	    Library:MakeDraggable(MainFrame, TopBar, true, true)

	    local TitleHolder = New("Frame", {
	        BackgroundTransparency = 1,
	        Size = UDim2.new(1, 0, 1, 0),
	        Parent = TopBar,
	    })
	    New("UIListLayout", {
	        FillDirection = Enum.FillDirection.Horizontal,
	        HorizontalAlignment = Enum.HorizontalAlignment.Left,
	        VerticalAlignment = Enum.VerticalAlignment.Center,
	        Padding = UDim.new(0, 6),
	        Parent = TitleHolder,
	    })
	    New("UIPadding", {
	        PaddingLeft = UDim.new(0, 12),
	        Parent = TitleHolder,
	    })

	    if LoadingInfo.Icon then
	        Library:CreateIcon(Library:GetCustomIcon(LoadingInfo.Icon), {
	            Size = LoadingInfo.IconSize,
	            Parent = TitleHolder,
	        })
	    else
	        New("TextLabel", {
	            BackgroundTransparency = 1,
	            Size = LoadingInfo.IconSize,
	            Text = LoadingInfo.Title:sub(1, 1),
	            TextScaled = true,
	            Visible = false,
	            Parent = TitleHolder,
	        })
	    end

	    local LoadingIconWidth = LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0
	    local LoadingMaxWidth = math.max(0, (TitleHolder.AbsoluteSize.X / Library.DPIScale) - LoadingIconWidth - 12)
	    local LoadingTitleWidth = math.min(
	        Library:GetTextBounds(LoadingInfo.Title, Library.Scheme.Font, 20),
	        LoadingMaxWidth
	    )
	    local _WindowTitle = New("TextLabel", {
	        BackgroundTransparency = 1,
	        Size = UDim2.new(0, LoadingTitleWidth, 1, 0),
	        Text = LoadingInfo.Title,
	        TextSize = 20,
	        TextTruncate = Enum.TextTruncate.AtEnd,
	        TextXAlignment = Enum.TextXAlignment.Left,
	        TextYAlignment = Enum.TextYAlignment.Center,
	        Parent = TitleHolder,
	    })

	    Library:MakeLine(Container, {
	        Position = UDim2.fromOffset(0, 48),
	        Size = UDim2.new(1, 0, 0, 1),
	    })

	    --// Loading Content Elements \\--
	    local InnerContent = New("Frame", {
	        Name = "InnerContent",
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(0, 49),
	        Size = UDim2.new(1, 0, 1, -49),
	        Parent = Container,
	    })

	    New("UIListLayout", {
	        FillDirection = Enum.FillDirection.Vertical,
	        HorizontalAlignment = Enum.HorizontalAlignment.Center,
	        VerticalAlignment = Enum.VerticalAlignment.Center,
	        Padding = UDim.new(0, 12),
	        Parent = InnerContent,
	    })

	    local IconHolder = New("Frame", {
	        Name = "IconHolder",
	        BackgroundTransparency = 1,
	        Size = UDim2.fromOffset(64, 64),
	        Parent = InnerContent,
	    })

	    local LoadingIcon = Library:CreateIcon(Library:GetCustomIcon(LoadingInfo.LoadingIcon), {
	        Name = "LoaderIcon",
	        AnchorPoint = Vector2.new(0.5, 0.5),
	        Position = UDim2.fromScale(0.5, 0.5),
	        Size = UDim2.fromScale(1, 1),
	        ImageColor3 = LoadingInfo.LoadingIconColor or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
	        Parent = IconHolder,
	    })

	    local RotationTween
	    if LoadingInfo.LoadingIconTweenTime > 0 then
	        RotationTween = TweenService:Create(
	            LoadingIcon,
	            TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
	            { Rotation = 360 }
	        )
	        RotationTween:Play()
	    end

	    local MessageLabel = New("TextLabel", {
	        BackgroundTransparency = 1,
	        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
	        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
	        Text = "",
	        TextSize = 18,
	        TextWrapped = Loading.AutoResizeHeight,
	        Parent = InnerContent,
	    })

	    local DescriptionLabel = New("TextLabel", {
	        BackgroundTransparency = 1,
	        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
	        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
	        Text = "",
	        TextSize = 14,
	        TextTransparency = 0.5,
	        TextWrapped = Loading.AutoResizeHeight,
	        Parent = InnerContent,
	    })

	    --// Progress Bar \\--
	    local SliderBar = New("Frame", {
	        BackgroundColor3 = "MainColor",
	        Size = UDim2.new(0.7, 0, 0, 15),
	        Parent = InnerContent,
	    })
	    Library:AddOutline(SliderBar)
	    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar }))

	    local SliderFill = New("Frame", {
	        BackgroundColor3 = "AccentColor",
	        BorderSizePixel = 0,
	        Size = UDim2.fromScale(0, 1),
	        Parent = SliderBar,
	    })
	    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill }))

	    local ProgressLabel = New("TextLabel", {
	        BackgroundTransparency = 1,
	        Size = UDim2.fromScale(1, 1),
	        Text = "",
	        TextSize = 14,
	        ZIndex = 2,
	        Parent = SliderBar,
	    })
	    New("UIStroke", {
	        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	        Color = GetTextStrokeColor,
	        LineJoinMode = Enum.LineJoinMode.Miter,
	        Parent = ProgressLabel,
	    })

	    --// Sidebar Object \\--
	    local SidebarScrolling = New("ScrollingFrame", {
	        BackgroundTransparency = 1,
	        BorderSizePixel = 0,
	        CanvasSize = UDim2.new(0, 0, 0, 0),
	        Size = UDim2.fromScale(1, 1),
	        ScrollBarThickness = 2,
	        ScrollBarImageColor3 = "OutlineColor",
	        Parent = SideBar,
	    })
	    local SidebarList = New("UIListLayout", {
	        Padding = UDim.new(0, 8),
	        SortOrder = Enum.SortOrder.LayoutOrder,
	        Parent = SidebarScrolling,
	    })
	    New("UIPadding", {
	        PaddingBottom = UDim.new(0, 12),
	        PaddingLeft = UDim.new(0, 12),
	        PaddingRight = UDim.new(0, 12),
	        PaddingTop = UDim.new(0, 12),
	        Parent = SidebarScrolling,
	    })

	    local SidebarObject = {
	        Elements = {},
	        DependencyBoxes = {},
	        Tabboxes = {},

	        BoxHolder = SidebarScrolling,
	        Container = SidebarScrolling,

	        Resize = function(self)
	            SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
	        end,
	        Tab = {
	            Elements = {},
	            DependencyBoxes = {},
	            DependencyGroupboxes = {},
	            Tabboxes = {},
	        },
	    }

	    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	        SidebarObject:Resize()
	    end)

	    setmetatable(SidebarObject, BaseGroupbox)
	    Loading.Sidebar = SidebarObject

	    --// Error Frame \\--
	    local ErrorFrame = New("Frame", {
	        Name = "Error",
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(0, 49),
	        Size = UDim2.new(1, 0, 1, -49),
	        ClipsDescendants = true,
	        Visible = false,
	        Parent = Container,
	    })

	    local _ErrorTitle = New("TextLabel", {
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(15, 15),
	        Size = UDim2.new(1, -30, 0, 18),
	        Text = "Error",
	        TextColor3 = "RedColor",
	        TextSize = 18,
	        TextXAlignment = Enum.TextXAlignment.Left,
	        Parent = ErrorFrame,
	    })

	    local ErrorLabel = New("TextLabel", {
	        BackgroundTransparency = 1,
	        Position = UDim2.fromOffset(15, 39),
	        Size = UDim2.new(1, -30, 1, -90),
	        Text = "Error Message",
	        TextSize = 14,
	        TextTransparency = 0.2,
	        TextWrapped = true,
	        TextXAlignment = Enum.TextXAlignment.Left,
	        TextYAlignment = Enum.TextYAlignment.Top,
	        Parent = ErrorFrame,
	    })

	    local ErrorButtonsDivider = New("Frame", {
	        BackgroundColor3 = "OutlineColor",
	        BackgroundTransparency = 0,
	        BorderSizePixel = 0,
	        AnchorPoint = Vector2.new(0.5, 0),
	        Position = UDim2.new(0.5, 0, 1, -48),
	        Size = UDim2.new(1, -30, 0, 1),
	        Visible = false,
	        Parent = ErrorFrame,
	    })

	    local ErrorButtonsHolder = New("Frame", {
	        AnchorPoint = Vector2.new(0.5, 1),
	        BackgroundTransparency = 1,
	        Position = UDim2.new(0.5, 0, 1, 0),
	        Size = UDim2.new(1, 0, 0, 42),
	        Visible = false,
	        Parent = ErrorFrame,
	    })
	    New("UIListLayout", {
	        Padding = UDim.new(0, 8),
	        FillDirection = Enum.FillDirection.Horizontal,
	        HorizontalAlignment = Enum.HorizontalAlignment.Right,
	        VerticalAlignment = Enum.VerticalAlignment.Center,
	        SortOrder = Enum.SortOrder.LayoutOrder,
	        Parent = ErrorButtonsHolder,
	    })
	    New("UIPadding", {
	        PaddingTop = UDim.new(0, 5),
	        PaddingBottom = UDim.new(0, 15),
	        PaddingRight = UDim.new(0, 15),
	        Parent = ErrorButtonsHolder,
	    })

	    function Loading:UpdateLayout()
	        if Loading.IsError then
	            Loading:RecalculateErrorHeight()
	        end

	        local ShowSidebar = Loading.ShowSidebar
	        local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
	        local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight

	        if ShowSidebar then
	            SideBar.Visible = true
	            SidebarDivider.Visible = true
	        end

	        TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
	        TweenService:Create(SideBar, Library.TweenInfo, { Position = UDim2.fromOffset(Loading.ContentWidth, 0), Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0) }):Play()
	        TweenService:Create(Container, Library.TweenInfo, { Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }):Play()

	        if not ShowSidebar then
	            task.delay(Library.TweenInfo.Time, function()
	                if not Loading.ShowSidebar then
	                    SideBar.Visible = false
	                    SidebarDivider.Visible = false
	                end
	            end)
	        end
	    end

	    --// Content Page \\--
	    function Loading:RecalculateLoadingHeight()
	        if not Loading.AutoResizeHeight then
	            return
	        end

	        local RequiredHeight =
	              49 -- TopBar
	            + 48 -- Padding
	            + InnerContent.UIListLayout.AbsoluteContentSize.Y

	        Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
	    end

	    function Loading:SetMessage(Text)
	        MessageLabel.Text = Text

	        if Loading.AutoResizeHeight then
	            Loading:RecalculateLoadingHeight()
	            Loading:UpdateLayout()
	        end
	    end

	    function Loading:SetDescription(Text)
	        DescriptionLabel.Text = Text

	        if Loading.AutoResizeHeight then
	            Loading:RecalculateLoadingHeight()
	            Loading:UpdateLayout()
	        end
	    end

	    function Loading:SetLoadingIcon(Icon)
	        local IconData = Library:GetCustomIcon(Icon)
	        assert(IconData, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	        local Replacement = Library:ApplyIcon(LoadingIcon, IconData)
	        if Replacement ~= LoadingIcon then
	            LoadingIcon = Replacement
	            Loading:SetLoadingIconTweenTime(LoadingInfo.LoadingIconTweenTime)
	        end
	    end

	    function Loading:SetLoadingIconTweenTime(TweenTime)
	        LoadingInfo.LoadingIconTweenTime = TweenTime

	        if RotationTween then
	            StopTween(RotationTween, true)
	            RotationTween = nil
	        end

	        if TweenTime > 0 then
	            RotationTween = TweenService:Create(
	                LoadingIcon,
	                TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
	                { Rotation = 360 }
	            )
	            RotationTween:Play()
	        else
	            LoadingIcon.Rotation = 0
	        end
	    end

	    function Loading:SetLoadingIconColor(Color)
	        SetIconProperties(LoadingIcon, { ImageColor3 = Color })
	    end

	    function Loading:SetCurrentStep(Step)
	        Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

	        local Progress = Loading.CurrentStep / Loading.TotalSteps
	        TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

	        ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
	    end

	    function Loading:SetTotalSteps(Steps)
	        Loading.TotalSteps = Steps
	        Loading:SetCurrentStep(Loading.CurrentStep)
	    end

	    --// Size \\--
	    function Loading:SetWindowHeight(Height)
	        Loading.WindowHeight = Height
	        Loading:UpdateLayout()
	    end

	    function Loading:SetWindowWidth(Width)
	        Loading.WindowWidth = Width
	        Loading:UpdateLayout()
	    end

	    function Loading:SetContentWidth(Width)
	        Loading.ContentWidth = Width
	        Loading:UpdateLayout()
	    end

	    function Loading:SetSidebarWidth(Width)
	        Loading.SidebarWidth = Width
	        Loading:UpdateLayout()
	    end

	    --// Sidebar \\--
	    function Loading:ShowSidebarPage(Bool)
	        Loading.ShowSidebar = Bool
	        Loading:UpdateLayout()
	    end

	    --// Error Page \\--
	    function Loading:ShowErrorPage(Enabled)
	        Loading.IsError = Enabled
	        InnerContent.Visible = not Enabled
	        ErrorFrame.Visible = Enabled

	        if Loading.ShowSidebar then
	            Loading:ShowSidebarPage(not Enabled)
	        else
	            Loading:UpdateLayout()
	        end
	    end

	    function Loading:RecalculateErrorHeight()
	        local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth) - 30
	        local _, ErrorY = Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

	        ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

	        local HasButtons = ErrorButtonsHolder.Visible
	        local RequiredHeight =
	              49                        -- TopBar
	            + 15                        -- Padding Top
	            + 18                        -- Title Height
	            + 6                         -- Padding between Title and Label
	            + ErrorY                    -- Label Height
	            + 15                        -- Padding between Label and Buttons
	            + (HasButtons and 48 or 0)  -- Buttons Area

	        Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
	    end

	    function Loading:SetErrorMessage(Text)
	        ErrorLabel.Text = Text
	        Loading:UpdateLayout()
	    end

	    function Loading:SetErrorButtons(Buttons)
	        assert(typeof(Buttons) == "table", "Buttons must be a table")

	        for _, button in ErrorButtonsHolder:GetChildren() do
	            if button:IsA("Frame") then
	                button:Destroy()
	            end
	        end

	        local HasButtons = GetTableSize(Buttons) > 0
	        ErrorButtonsHolder.Visible = HasButtons
	        ErrorButtonsDivider.Visible = HasButtons

	        for Idx, ButtonInfo in Buttons do
	            local ButtonContainer = New("Frame", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromOffset(0, 26),
	                Parent = ErrorButtonsHolder,
	            })

	            local BtnColor = "MainColor"
	            local BtnOutline = "OutlineColor"
	            local Variant = ButtonInfo.Variant or "Primary"

	            if Variant == "Primary" then
	                BtnColor = "FontColor"
	                BtnOutline = "FontColor"
	            elseif Variant == "Secondary" then
	                BtnColor = "MainColor"
	                BtnOutline = "OutlineColor"
	            elseif Variant == "Destructive" then
	                BtnColor = "DestructiveColor"
	                BtnOutline = "DestructiveColor"
	            elseif Variant == "Ghost" then
	                BtnColor = "BackgroundColor"
	                BtnOutline = "BackgroundColor"
	            end

	            local TextBtn = New("TextButton", {
	                BackgroundColor3 = BtnColor,
	                BorderColor3 = BtnOutline,
	                Size = UDim2.fromOffset(0, 26),
	                Text = "",
	                AutoButtonColor = false,
	                Parent = ButtonContainer,
	            })
	            Library:AddOutline(TextBtn)
	            table.insert(
	                Library.Corners,
	                New("UICorner", {
	                    CornerRadius = UDim.new(0, Library.CornerRadius),
	                    Parent = TextBtn
	                })
	            )

	            New("UIPadding", {
	                PaddingLeft = UDim.new(0, 15),
	                PaddingRight = UDim.new(0, 15),
	                Parent = TextBtn,
	            })

	            local TextColor = Library.Scheme.FontColor
	            if Variant == "Primary" then
	                TextColor = Library.Scheme.BackgroundColor
	            elseif Variant == "Destructive" then
	                TextColor = Color3.new(1, 1, 1)
	            end

	            local BtnLabel = New("TextLabel", {
	                BackgroundTransparency = 1,
	                Size = UDim2.fromScale(1, 1),
	                Text = ButtonInfo.Title or Idx,
	                TextColor3 = TextColor,
	                TextSize = 14,
	                Parent = TextBtn,
	            })

	            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
	            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
	            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

	            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
	            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

	            TextBtn.MouseEnter:Connect(function()
	                TweenService:Create(TextBtn, Library.TweenInfo, {
	                    BackgroundColor3 = HoverColor
	                }):Play()
	            end)
	            TextBtn.MouseLeave:Connect(function()
	                TweenService:Create(TextBtn, Library.TweenInfo, {
	                    BackgroundColor3 = ActiveColor
	                }):Play()
	            end)

	            TextBtn.MouseButton1Click:Connect(function()
	                if ButtonInfo.Callback then
	                    ButtonInfo.Callback(Loading)
	                end
	            end)
	        end

	        Loading:UpdateLayout()
	    end

	    --// Destroy/Continue \\--
	    function Loading:Destroy()
	        if RotationTween then
	            StopTween(RotationTween, true)
	            RotationTween = nil
	        end

	        ScreenGui:Destroy()
	        Loading.Destroyed = true
	        Library.ActiveLoading = nil

	        if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
	            Library:Toggle(true)
	        end
	    end

	    Loading.Continue = Loading.Destroy;

	    if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
	        Library:Toggle(false)
	    end

	    Loading:SetCurrentStep(Loading.CurrentStep)

	    Library.ActiveLoading = Loading
	    return Loading
	end

	local function OnPlayerChange()
	    if Library.Unloaded then
	        return
	    end

	    local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
	    for _, Dropdown in Options do
	        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
	            Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
	        end
	    end
	end

	local function OnTeamChange()
	    if Library.Unloaded then
	        return
	    end

	    local TeamList = GetTeams()
	    for _, Dropdown in Options do
	        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
	            Dropdown:SetValues(TeamList)
	        end
	    end
	end

	Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
	Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

	Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
	Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

	function Library:Unload()
	    Library.Unloaded = true

	    --// Disconnect connections
	    for Index = #Library.Signals, 1, -1 do
	        local Connection = table.remove(Library.Signals, Index)

	        if Connection and Connection.Connected then
	            Connection:Disconnect()
	        end
	    end

	    --// Run Unload Callbacks
	    for _ = 1, #Library.UnloadSignals do
	        local Callback = table.remove(Library.UnloadSignals, 1)

	        if Callback then
	            Library:SafeCallback(Callback)
	        end
	    end

	    --// Destroy elements
	    for Index = #Library.Tabs, 1, -1 do
	        local Tab = table.remove(Library.Tabs, Index)

	        if Tab and Tab.Destroy then
	            Library:SafeCallback(Tab.Destroy, Tab)
	        end
	    end

	    for Index = #Tooltips, 1, -1 do
	        local Tooltip = table.remove(Tooltips, Index)

	        if Tooltip and Tooltip.Destroy then
	            Library:SafeCallback(Tooltip.Destroy, Tooltip)
	        end
	    end

	    if Library.ActiveLoading then
	        Library.ActiveLoading:Destroy()
	    end

	    if Library.KeybindMenu then
	        Library.KeybindMenu:Destroy()
	    end

	    if ScreenGui then
	        ScreenGui:Destroy()
	    end

	    --// Clear tables
	    table.clear(Library.Registry)

	    table.clear(Options)
	    table.clear(Toggles)
	    table.clear(Buttons)
	    table.clear(Labels)
	    table.clear(Tooltips)

	    table.clear(Library.Tabs)
	    table.clear(Library.TabButtons)

	    table.clear(Library.Scales)
	    table.clear(Library.ScalesOffset)

	    table.clear(Library.Corners)
	    table.clear(Library.SpecificCorners)
	    table.clear(Library.ContextMenus)

	    table.clear(Library.Notifications)
	    table.clear(Library.Dialogues)
	    table.clear(Library.DraggableElements)
	    table.clear(Library.KeybindToggles)
	    table.clear(Library.DependencyBoxes)

	    table.clear(TransparencyCache)
	    table.clear(ActiveTabTweens)

	    Library.Toggle = function(...) end
	    Library.ScreenGui = nil
	    Library.Floats = nil
	    Library.Overlay = nil
	    Library.WindowContainer = nil
	    Library.KeybindFrame = nil
	    Library.KeybindContainer = nil
	    Library.KeybindMenu = nil

	    getgenv().Library = nil
	end

	getgenv().Library = Library
	return Library

end)()

local color = {}
local uipallet = {}
do
	function color.Dark(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
	end

	function color.Light(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
	end

	function vape:Color(h)
		local s = 0.74 + (0.26 * math.min(h / 0.045, 1))

		if h > 0.577 then
			s = 1 - (0.48 * math.min((h - 0.577) / 0.088, 1))
		end

		if h > 0.674 then
			s = 0.52 + (0.48 * math.min((h - 0.674) / 0.149, 1))
		end

		if h > 0.869 then
			s = 1 - (0.26 * math.min((h - 0.869) / 0.131, 1))
		end

		return h, s, 1
	end

	function vape:TextColor(h, s, v)
		if v >= 0.7 and (s < 0.6 or h > 0.04 and h < 0.56) then
			return Color3.new(0.19, 0.19, 0.19)
		end

		return Color3.new(1, 1, 1)
	end
end

local function getfontbounds(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end

	return textService:GetTextBoundsAsync(fontsize)
end

do
	local vapeAssets = {
		['newvape/assets/new/add.png'] = 'rbxassetid://121642387707174',
		['newvape/assets/new/aim.png'] = 'rbxassetid://122207028123421',
		['newvape/assets/new/allowedicon.png'] = 'rbxassetid://112336790299036',
		['newvape/assets/new/allowediconmini.png'] = 'rbxassetid://90142384730147',
		['newvape/assets/new/back.png'] = 'rbxassetid://80523803497740',
		['newvape/assets/new/backmini.png'] = 'rbxassetid://85859225495272',
		['newvape/assets/new/bind.png'] = 'rbxassetid://81399857677684',
		['newvape/assets/new/bindbkg.png'] = 'rbxassetid://101996225428926',
		['newvape/assets/new/blatant.png'] = 'rbxassetid://126929923309265',
		['newvape/assets/new/blur.png'] = 'rbxassetid://79246816170155',
		['newvape/assets/new/blurnoti.png'] = 'rbxassetid://124705876663719',
		['newvape/assets/new/close.png'] = 'rbxassetid://121816018671466',
		['newvape/assets/new/closemini.png'] = 'rbxassetid://108320409341289',
		['newvape/assets/new/closetiny.png'] = 'rbxassetid://71393233149714',
		['newvape/assets/new/colorpreview.png'] = 'rbxassetid://140438628568318',
		['newvape/assets/new/combat.png'] = 'rbxassetid://94762732349053',
		['newvape/assets/new/customtheme.png'] = 'rbxassetid://91756736022800',
		['newvape/assets/new/discord.png'] = 'rbxassetid://99871463341003',
		['newvape/assets/new/downexpand.png'] = 'rbxassetid://94197751291504',
		['newvape/assets/new/downexpandslider.png'] = 'rbxassetid://90289944682645',
		['newvape/assets/new/edit.png'] = 'rbxassetid://105801951237137',
		['newvape/assets/new/editlarge.png'] = 'rbxassetid://119233876755282',
		['newvape/assets/new/expandarrow.png'] = 'rbxassetid://86360332526471',
		['newvape/assets/new/friends.png'] = 'rbxassetid://92957214042038',
		['newvape/assets/new/inventory.png'] = 'rbxassetid://93264756888499',
		['newvape/assets/new/legit_mode_icon.png'] = 'rbxassetid://102858626075156',
		['newvape/assets/new/legit_switch.png'] = 'rbxassetid://127508881124779',
		['newvape/assets/new/min.png'] = 'rbxassetid://82175054487146',
		['newvape/assets/new/noti_alert.png'] = 'rbxassetid://82356478726846',
		['newvape/assets/new/noti_info.png'] = 'rbxassetid://102614825645099',
		['newvape/assets/new/noti_warning.png'] = 'rbxassetid://119631730212167',
		['newvape/assets/new/notification.png'] = 'rbxassetid://90300780458781',
		['newvape/assets/new/npcs.png'] = 'rbxassetid://104434365485227',
		['newvape/assets/new/overlaydots.png'] = 'rbxassetid://78012624671930',
		['newvape/assets/new/overlays.png'] = 'rbxassetid://136535637407545',
		['newvape/assets/new/overlayslarge.png'] = 'rbxassetid://127574141208160',
		['newvape/assets/new/pin.png'] = 'rbxassetid://92459145800579',
		['newvape/assets/new/players.png'] = 'rbxassetid://105137446428129',
		['newvape/assets/new/profiles.png'] = 'rbxassetid://126051451865127',
		['newvape/assets/new/radar.png'] = 'rbxassetid://97983828696086',
		['newvape/assets/new/rainbow_1.png'] = 'rbxassetid://101329996188554',
		['newvape/assets/new/rainbow_2.png'] = 'rbxassetid://72739074644654',
		['newvape/assets/new/rainbow_3.png'] = 'rbxassetid://100716555253397',
		['newvape/assets/new/rainbow_4.png'] = 'rbxassetid://133424174227092',
		['newvape/assets/new/range.png'] = 'rbxassetid://107794917650053',
		['newvape/assets/new/rangeindicator.png'] = 'rbxassetid://107038094175283',
		['newvape/assets/new/render.png'] = 'rbxassetid://125472576898654',
		['newvape/assets/new/search.png'] = 'rbxassetid://115611852955611',
		['newvape/assets/new/settingdots.png'] = 'rbxassetid://130896840048276',
		['newvape/assets/new/settings.png'] = 'rbxassetid://73820177347303',
		['newvape/assets/new/settingsmini.png'] = 'rbxassetid://115732118290997',
		['newvape/assets/new/targetinfo.png'] = 'rbxassetid://121604266095276',
		['newvape/assets/new/textgui.png'] = 'rbxassetid://99438663817412',
		['newvape/assets/new/theme.png'] = 'rbxassetid://111525258317113',
		['newvape/assets/new/utility.png'] = 'rbxassetid://108303206513893',
		['newvape/assets/new/vape.png'] = 'rbxassetid://92153855792786',
		['newvape/assets/new/vapelogo.png'] = 'rbxassetid://126205920310261',
		['newvape/assets/new/vapelogomini.png'] = 'rbxassetid://109041903452149',
		['newvape/assets/new/v4.png'] = 'rbxassetid://102549752760489',
		['newvape/assets/new/v4mini.png'] = 'rbxassetid://115213099001611',
		['newvape/assets/new/world.png'] = 'rbxassetid://118917453153459'
	}

	local function createDownloader(text)
		if vape.Loaded ~= true then
			local downloader = vape.Downloader
			if not downloader then
				downloader = Instance.new('TextLabel')
				downloader.BackgroundTransparency = 1
				downloader.FontFace = uipallet.Font
				downloader.Size = UDim2.new(1, 0, 0, 40)
				downloader.TextColor3 = Color3.new(1, 1, 1)
				downloader.TextSize = 20
				downloader.TextStrokeTransparency = 0
				downloader.Parent = vape.gui
				vape.Downloader = downloader
			end

			downloader.Text = 'Downloading '..text
		end
	end

	local function downloadFile(path, callback)
		if not isfile(path) then
			createDownloader(path)

			local success, data = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
			end)

			if not success or data == '404: Not Found' then
				error(data)
			end

			if path:find('.lua') then
				data = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..data
			end

			writefile(path, data)
		end

		return (callback or readfile)(path)
	end

	getvapeasset = not inputService.TouchEnabled and getcustomasset and function(path)
		return downloadFile(path, getcustomasset)
	end or function(path)
		return vapeAssets[path] or ''
	end
end

local tween = setmetatable({}, {
	__index = function()
		return {}
	end
})

do
	function tween:Tween(obj, info, goal, index)
		index = self[index or 'tweens']
		if index[obj] then
			index[obj]:Cancel()
			index[obj] = nil
		end

		if obj.Parent and (obj:IsA('UIStroke') or obj.Visible) then
			index[obj] = tweenService:Create(obj, info, goal)
			index[obj].Completed:Once(function()
				if index then
					index[obj] = nil
					index = nil
				end
			end)

			index[obj]:Play()
		else
			for prop, value in goal do
				obj[prop] = value
			end
		end
	end

	function tween:Cancel(obj, index)
		index = self[index or 'tweens']

		if index[obj] then
			index[obj]:Cancel()
			index[obj] = nil
		end
	end
end

uipallet = {
	Main = Color3.fromRGB(26, 25, 26),
	Text = Color3.fromRGB(200, 200, 200),
	Font = Font.fromEnum(Enum.Font.Arial),
	FontSemiBold = Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.SemiBold),
	Tween = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
}

do
	local data = isfile('newvape/profiles/color.txt') and loadJson('newvape/profiles/color.txt')
	if data then
		uipallet.Main = data.Main and Color3.fromRGB(unpack(data.Main)) or uipallet.Main
		uipallet.Text = data.Text and Color3.fromRGB(unpack(data.Text)) or uipallet.Text
		uipallet.Font = data.Font and Font.new(
			data.Font:find('rbxasset') and data.Font
			or string.format('rbxasset://fonts/families/%s.json', data.Font)
		) or uipallet.Font
		uipallet.FontSemiBold = Font.new(uipallet.Font.Family, Enum.FontWeight.SemiBold)
	end

	fontsize.Font = uipallet.Font
end

-- the Obsidian scheme replaces the Vape palette, so a theme change reaches the modules
if Library and Library.Scheme then
	uipallet.Main = Library.Scheme.MainColor
	uipallet.Text = Library.Scheme.FontColor
	uipallet.Accent = Library.Scheme.AccentColor
	uipallet.Outline = Library.Scheme.OutlineColor
	if Library.Scheme.Font then uipallet.Font = Library.Scheme.Font end
	if Library.Scheme.Font then uipallet.FontSemiBold = Library.Scheme.Font end
end

vape.Libraries = {
	color = color,
	getfontbounds = getfontbounds,
	getvapeasset = getvapeasset,
	tween = tween,
	uipallet = uipallet
}

local function addBlur(parent, notif, old)
	local blur
	if old then
		blur = Instance.new('ImageLabel')
		blur.Name = 'Blur'
		blur.Size = UDim2.new(1, 89, 1, 52)
		blur.Position = UDim2.fromOffset(-48, -31)
		blur.BackgroundTransparency = 1
		blur.Image = getvapeasset('newvape/assets/new/'..(notif and 'blurnoti' or 'blur')..'.png')
		blur.ScaleType = Enum.ScaleType.Slice
		blur.SliceCenter = Rect.new(52, 31, 261, 502)
		blur.Parent = parent
	else
		blur = Instance.new('UIShadow')
		blur.BlurRadius = UDim.new(0, 13)
		blur.Transparency = 0.25
		blur.Parent = parent
	end

	return blur
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addCloseButton(parent, mini, offset)
	local close = Instance.new('ImageButton')
	close.AutoButtonColor = false
	close.BackgroundColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.Image = getvapeasset('newvape/assets/new/'..(mini and 'closemini' or 'close')..'.png')
	close.ImageColor3 = color.Light(uipallet.Text, 0.2)
	close.ImageTransparency = 0.5
	close.Name = 'Close'
	close.Position = offset or (mini and UDim2.new(1, -28, 0, 11) or UDim2.new(1, -35, 0, 9))
	close.Size = mini and UDim2.fromOffset(20, 20) or UDim2.fromOffset(24, 24)
	close.Parent = parent
	addCorner(close, UDim.new(1, 0))

	close.MouseEnter:Connect(function()
		close.ImageTransparency = 0.3
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 0.6
		})
	end)

	close.MouseLeave:Connect(function()
		close.ImageTransparency = 0.5
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 1
		})
	end)

	return close
end

local function addDragHandler(gui, window)
	gui.InputBegan:Connect(function(input)
		if window and not window.Visible then return end

		if
			(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
			and (input.Position.Y - gui.AbsolutePosition.Y < 40 or window)
		then
			local dragPosition = Vector2.new(
				gui.AbsolutePosition.X - input.Position.X,
				gui.AbsolutePosition.Y - input.Position.Y + guiService:GetGuiInset().Y
			) / scale.Scale

			local releaseConnection
			local moveConnection = inputService.InputChanged:Connect(function(newInput)
				if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = newInput.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end

					gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
				end
			end)

			releaseConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					moveConnection:Disconnect()
					releaseConnection:Disconnect()
				end
			end)
		end
	end)
end

local function addMaid(obj)
	obj.Connections = {}

	function obj:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'thread' then
			table.insert(self.Connections, {
				Disconnect = function()
					if coroutine.status(callback) ~= 'dead' then
						task.cancel(callback)
					end
				end
			})
		elseif type(callback) == 'function' then
			table.insert(self.Connections, {
				Disconnect = callback
			})
		else
			table.insert(self.Connections, callback)
		end
	end
end

local function addTooltip(gui, text, customText, visCheck)
	if not text then return end

	local function tooltipMoved(x, y)
		if visCheck and visCheck() then
			return
		end

		local isRight = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
		tooltip.Position = UDim2.fromOffset(
			(isRight and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
			((y + 11) - (tooltip.Size.Y.Offset / 2)) / scale.Scale
		)

		tooltip.Visible = toolblur.Enabled
	end

	local function callback()
		local newText = customText()
		tooltip.Text = newText
		local tooltipSize = getfontbounds(tooltip.ContentText, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
	end

	gui.MouseEnter:Connect(function(x, y)
		if visCheck and visCheck() then
			return
		end

		tooltip.Text = text
		local tooltipSize = getfontbounds(tooltip.ContentText, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
		tooltipMoved(x, y)

		if customText then
			vape.CurrentTooltip = callback
			callback()
		end
	end)
	gui.MouseMoved:Connect(tooltipMoved)
	gui.MouseLeave:Connect(function()
		if visCheck and visCheck() then
			return
		end

		tooltip.Visible = false
		vape.CurrentTooltip = nil
	end)
end

local function createSignal()
	local signal = {
		Connections = {}
	}

	function signal:Connect(callback)
		table.insert(self.Connections, callback)

		return {
			Disconnect = function()
				local index = table.find(signal.Connections, callback)
				if index then
					table.remove(signal.Connections, index)
				end
			end
		}
	end

	function signal:Fire(...)
		for _, callback in self.Connections do
			task.spawn(callback, ...)
		end
	end

	return signal
end

local function checkKeybinds(compare, target, key)
	if type(target) == 'table' then
		if table.find(target, key) then
			for _, key in target do
				if not table.find(compare, key) then
					return false
				end
			end

			return true
		end
	end

	return false
end

local function getPlayerFromText(text)
	if text ~= '' then
		for _, plr in playersService:GetPlayers() do
			if plr.Name:sub(1, #text):lower() == text:lower() then
				return plr.Name
			end
		end
	end
end

local function getTableSize(dict)
	local size = 0
	for _ in dict do
		size += 1
	end

	return size
end

local function loopClean(obj)
	for index, value in obj do
		if type(value) == 'table' then
			loopClean(value)
		end

		obj[index] = nil
	end
end

local function randomString()
	local array = {}
	for i = 1, math.random(10, 100) do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function removeTags(text)
	text = text:gsub('<br%s*/>', '\n')
	return text:gsub('<[^<>]->', '')
end

function vape:BlurCheck()
	if self.ThreadFix then
		setthreadidentity(8)
		runService:SetRobloxGuiFocused((clickgui.Visible or guiService:GetErrorType() ~= Enum.ConnectionError.OK) and self.Blur.Enabled)
	end
end

function vape:CreateCategory(props)
	return components.Category(props)
end

function vape:CreateCategoryList(props)
	return components.CategoryList(props)
end

function vape:CreateNotification(title, text, duration, type)
	if not self.Notifications.Enabled then
		return
	end

	task.delay(0, function()
		if self.ThreadFix then
			setthreadidentity(8)
		end

		local index = #notifications:GetChildren() + 1
		local notification = Instance.new('ImageLabel')
		notification.BackgroundTransparency = 1
		notification.Position = UDim2.new(1, 0, 1, -(29 + (78 * index)))
		notification.Image = getvapeasset('newvape/assets/new/notification.png')
		notification.ScaleType = Enum.ScaleType.Slice
		notification.SliceCenter = Rect.new(7, 7, 9, 9)
		notification.ZIndex = 5
		notification.Parent = notifications
		addBlur(notification, true, true)
		local iconshadow = Instance.new('ImageLabel')
		iconshadow.BackgroundTransparency = 1
		iconshadow.Image = getvapeasset('newvape/assets/new/noti_'..(type or 'info')..'.png')
		iconshadow.ImageColor3 = Color3.new()
		iconshadow.ImageTransparency = 0.5
		iconshadow.Position = UDim2.fromOffset(-5, -8)
		iconshadow.Size = UDim2.fromOffset(60, 60)
		iconshadow.ZIndex = 5
		iconshadow.Parent = notification
		local icon = iconshadow:Clone()
		icon.ImageColor3 = Color3.new(1, 1, 1)
		icon.ImageTransparency = 0
		icon.Position = UDim2.fromOffset(-1, -1)
		icon.Parent = iconshadow
		local label = Instance.new('TextLabel')
		label.BackgroundTransparency = 1
		label.FontFace = uipallet.FontSemiBold
		label.Position = UDim2.fromOffset(46, 16)
		label.RichText = true
		label.Size = UDim2.new(1, -56, 0, 20)
		label.Text = "<stroke joins='round' thickness='0.3' transparency='0.5'>"..title..'</stroke>'
		label.TextColor3 = type == 'alert' and Color3.fromRGB(250, 50, 56) or Color3.new(1, 1, 1)
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.ZIndex = 5
		label.Parent = notification
		local textshadow = label:Clone()
		textshadow.FontFace = uipallet.Font
		textshadow.Position = UDim2.fromOffset(47, 44)
		textshadow.RichText = false
		textshadow.Text = removeTags(text)
		textshadow.TextColor3 = Color3.new()
		textshadow.TextTransparency = 0.5
		textshadow.Parent = notification
		notification.Size = UDim2.fromOffset(math.max(getfontbounds(textshadow.Text, 14, uipallet.Font).X + 80, 266), 75)
		local textlabel = textshadow:Clone()
		textlabel.Position = UDim2.fromOffset(-1, -1)
		textlabel.RichText = true
		textlabel.Text = text
		textlabel.TextColor3 = Color3.fromRGB(170, 170, 170)
		textlabel.TextTransparency = 0
		textlabel.Parent = textshadow
		local progress = Instance.new('Frame')
		progress.BackgroundColor3 =
			type == 'alert' and Color3.fromRGB(250, 50, 56)
			or type == 'warning' and Color3.fromRGB(236, 129, 44)
			or Color3.new(1, 1, 1)
		progress.BorderSizePixel = 0
		progress.Position = UDim2.new(0, 3, 1, -4)
		progress.Size = UDim2.new(1, -13, 0, 1)
		progress.ZIndex = 5
		progress.Parent = notification

		if tween.Tween then
			tween:Tween(notification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
				AnchorPoint = Vector2.new(1, 0)
			}, 'tweenstwo')

			tween:Tween(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
				Size = UDim2.fromOffset(0, 1)
			})
		end

		task.delay(duration, function()
			if tween.Tween then
				tween:Tween(notification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
					AnchorPoint = Vector2.new(0, 0)
				}, 'tweenstwo')
			end

			task.wait(0.2)
			notification:ClearAllChildren()
			notification:Destroy()
		end)
	end)
end

function vape:CreateOverlay(props)
	return components.Overlay(props)
end

function vape:Load(skipgui, profile)
	local guiData = {Categories = {}}
	local oldProfile = self.Profile
	local canSave = true
	local toggleCount = 0

	if isfile('newvape/profiles/'..game.GameId..'.gui.txt') then
		guiData = loadJson('newvape/profiles/'..game.GameId..'.gui.txt')
		if not guiData then
			guiData = {Categories = {}}
			self:CreateNotification('Vape', 'Failed to load GUI settings.', 10, 'alert')
			canSave = false
		end

		if guiData.v ~= 1 then
			guiData.Categories.Main = nil
		end

		self.Profile = profile or guiData.Profile or 'default'
		if self.ProfileLabel then
			self.ProfileLabel.Text = #self.Profile > 10 and self.Profile:sub(1, 10)..'...' or self.Profile
			self.ProfileLabel.Size = UDim2.fromOffset(getfontbounds(self.ProfileLabel.Text, self.ProfileLabel.TextSize, self.ProfileLabel.Font).X + 16, 24)
		end

		if not skipgui then
			for name, data in guiData.Categories do
				local category = self.Categories[name]
				if category then
					category:Load(data)
				end
			end
		end
	end

	if not self.Categories.Profiles:GetValue('default') then
		self.Categories.Profiles:ChangeValue('default', true)
	end

	if isfile('newvape/profiles/'..self.Profile..self.Place..'.txt') then
		local mainData = loadJson('newvape/profiles/'..self.Profile..self.Place..'.txt')
		if not mainData then
			mainData = {Categories = {}, Modules = {}, Legit = {}}
			self:CreateNotification('Vape', 'Failed to load '..self.Profile..' profile.', 10, 'alert')
			canSave = false
		end

		if mainData.v ~= 1 then
			for _, data in mainData.Modules do
				data.Bind = {Keys = data.Bind}
				data.Visible = true
			end
		end

		for name, data in mainData.Categories do
			local category = self.Categories[name]
			if category then
				category:Load(data)
			end
		end

		for name, data in mainData.Modules do
			local module = self.Modules[name]
			if module then
				module:Load(data)
				toggleCount += module.Enabled and 1 or 0
			end
		end

		for name, data in mainData.Legit do
			local module = self.Legit.Modules[name]
			if module then
				module:Load(data)
			end
		end

		self:UpdateTextGUI(true)
	else
		self:Save()
	end

	if self.Profile ~= oldProfile and skipgui then
		self:CreateNotification('Profile swap to <font color="#FFAA00">'..self.Profile..'</font>', toggleCount..' modules enabled', 3)
	end

	if self.Downloader then
		self.Downloader:Destroy()
		self.Downloader = nil
	end

	self.Loaded = canSave

	if inputService.TouchEnabled and not skipgui then
		local button = Instance.new('TextButton')
		button.BackgroundColor3 = Color3.new()
		button.BackgroundTransparency = 0.2
		button.Position = UDim2.new(1, -90, 0, 4)
		button.Size = UDim2.fromOffset(32, 32)
		button.Text = ''
		button.Parent = gui
		local image = Instance.new('ImageLabel')
		image.BackgroundTransparency = 1
		image.Image = getvapeasset('newvape/assets/new/vape.png')
		image.Position = UDim2.fromOffset(6, 6)
		image.Size = UDim2.fromOffset(20, 20)
		image.Parent = button
		addCorner(button, UDim.new(1, 0))

		button.MouseButton1Click:Connect(function()
			self.GUIBind.Triggered:Fire(true)
		end)
	end

	return toggleData
end

function vape:LoadOptions(obj, data)
	for name, componentData in data do
		local component = obj.Options[name]

		if component then
			component:Load(componentData)
		end
	end
end

function vape:LoadGUI()
	--[[
		ObsidianCompat — Vape component surface on top of Obsidian.

		Inlined into vape:LoadGUI() right after --Init and before init.lua, so every
		`components.X(props, children, api)` call resolves to an adapter below.
		`components` is a base.lua local; this file only fills it.

		Save shapes are a wire format (AGENTS.md §4.4 / §4.5) and are not negotiable:
		Toggle {Enabled} · Slider {Value, Max} · Dropdown {Value} · TwoSlider {ValueMin, ValueMax}
		ColorSlider {Hue, Sat, Value, Opacity, Rainbow} · Bind {Keys, Mobile, Hold} · TextBox {Value}
		Targets {Players, NPCs, Walls} · Button / Divider nothing.
	]]

	local adapters = {}

	local function isArray(values)
		if type(values) ~= 'table' then
			return false
		end

		local count = 0
		for _ in values do
			count = count + 1
		end

		return count == #values
	end

	local function toList(values)
		if type(values) ~= 'table' then
			return {}
		end

		local list = {}
		local array = isArray(values)
		if array then
			for key, value in values do
				if type(key) == 'number' and key >= 1 and key <= #values then
					table.insert(list, value)
				end
			end
		else
			for key, value in values do
				if value == true then
					table.insert(list, tostring(key))
				else
					table.insert(list, tostring(value))
				end
			end
		end

		return list
	end

	local function toSet(values)
		local set = {}
		local list = toList(values)
		for _, value in list do
			set[value] = true
		end

		return set
	end

	local function toKeys(values)
		if type(values) == 'table' then
			local keys = toList(values)
			if #keys > 0 then
				return keys
			end

			return nil
		end

		if type(values) == 'string' and values ~= '' and values ~= 'None' then
			return {values}
		end

		return {}
	end

	local function selection(value, options)
		if value == nil then
			return nil
		end

		if options.Multi then
			local set = type(value) == 'table' and toSet(value) or {[value] = true}
			return next(set) ~= nil and set or {}
		end

		if type(value) == 'table' then
			local list = toList(value)
			return list[1]
		end

		return value
	end

	local function notify(title, text, duration, kind)
		vape:CreateNotification(title, text, duration or 5, kind)
	end

	local function defaultColor(value)
		if typeof(value) == 'Color3' then
			return value
		end

		local number = type(value) == 'number' and value or 500
		return Color3.fromHSV((number % 1000) / 1000, 0.5, 0.9)
	end

	--[[ options ]]

	adapters.Toggle = function(props, api)
		local option = {
			Connections = {},
			Enabled = props.Default == true,
			Name = props.Name,
			Options = {},
			Type = 'Toggle'
		}

		option.Object = api.Groupbox:AddToggle(props.Name, {
			Callback = function(state)
				option.Enabled = state

				if props.Callback then
					props.Callback(state)
				end
			end,
			Default = option.Enabled,
			Text = props.Text or props.Name,
			Tooltip = props.Tooltip
		})
		option.Object.Value = option.Enabled

		function option.Toggle(self)
			self.Object:SetValue(not self.Object.Value)
		end

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.Enabled = self.Object.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' or type(data.Enabled) ~= 'boolean' then
				return
			end

			self.Object:SetValue(data.Enabled)
		end

		option.Object.Value = option.Enabled

		return option
	end

	adapters.Slider = function(props, api)
		local option = {
			Connections = {},
			Name = props.Name,
			Options = {},
			Type = 'Slider',
			Value = props.Default
		}

		option.Object = api.Groupbox:AddSlider(props.Name, {
			Callback = function(value)
				option.Value = value

				if props.Callback then
					props.Callback(value)
				end
			end,
			Default = props.Default,
			Max = props.Max,
			Min = props.Min,
			Prefix = props.Prefix,
			Rounding = props.Rounding or 0,
			Suffix = props.Suffix,
			Text = props.Text or props.Name,
			Tooltip = props.Tooltip
		})
		option.Object.Value = option.Value

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.Max = self.Object.Max or props.Max
			data.Value = self.Object.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			if type(data.Max) == 'number' and data.Max ~= option.Object.Max then
				option.Object.Max = data.Max
				if option.Object.SetMax then
					option.Object:SetMax(data.Max)
				end
			end

			if type(data.Value) == 'number' then
				option.Object:SetValue(data.Value)
			end
		end

		return option
	end

	adapters.Dropdown = function(props, api)
		local list = toList(props.Values or props.List)
		local multi = props.Multi == true
		local option = {
			Connections = {},
			List = list,
			Name = props.Name,
			Options = {},
			Type = 'Dropdown',
			Value = props.Default
		}

		if multi then
			option.Value = type(props.Default) == 'table' and toSet(props.Default) or {}
		elseif props.Default == nil then
			option.Value = list[1]
		end

		option.Object = api.Groupbox:AddDropdown(props.Name, {
			AllowNull = props.AllowNull,
			Callback = function(value)
				if multi then
					option.Value = type(value) == 'table' and value or {}
				else
					option.Value = value
				end

				if props.Callback then
					props.Callback(option.Value)
				end
			end,
			Default = selection(props.Default, {Multi = multi}),
			Multi = multi,
			Text = props.Text or props.Name,
			Tooltip = props.Tooltip,
			Values = list
		})
		option.Object.Value = option.Value

		function option.Change(self, values)
			local newList = toList(values)

			self.List = newList
			table.clear(self.Options)
			for _, value in newList do
				self.Options[value] = value
			end

			self.Object:SetValues(newList)
		end

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.Value = self.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' or data.Value == nil then
				return
			end

			self.Object:SetValue(selection(data.Value, {Multi = multi}))
		end

		for _, value in list do
			option.Options[value] = value
		end

		return option
	end

	adapters.TextBox = function(props, api)
		local option = {
			Connections = {},
			Name = props.Name,
			Options = {},
			Type = 'TextBox',
			Value = props.Default or ''
		}

		option.Object = api.Groupbox:AddInput(props.Name, {
			Callback = function(value)
				option.Value = value

				if props.Callback then
					props.Callback(value)
				end
			end,
			Default = option.Value,
			Finished = props.Finished,
			Placeholder = props.Placeholder,
			Text = props.Text or props.Name,
			Tooltip = props.Tooltip
		})
		option.Object.Value = option.Value

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.Value = self.Object.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' or data.Value == nil then
				return
			end

			option.Object:SetValue(data.Value)
		end

		return option
	end

	adapters.Button = function(props, api)
		local option = {
			Connections = {},
			Name = props.Name,
			Options = {},
			Type = 'Button'
		}

		option.Object = api.Groupbox:AddButton(props.Name, {
			Callback = function()
				if props.Callback then
					props.Callback()
				end
			end,
			Text = props.Text or props.Name,
			Tooltip = props.Tooltip
		})

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save() end

		function option.Load() end

		return option
	end

	adapters.Divider = function(props, api)
		local option = {
			Connections = {},
			Name = props.Name,
			Options = {},
			Type = 'Divider'
		}

		local text = props.Text or props.Name
		if api.Groupbox.AddDivider then
			option.Object = api.Groupbox:AddDivider(text)
		else
			option.Object = api.Groupbox:AddLabel(text)
		end

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save() end

		function option.Load() end

		return option
	end

	adapters.Bind = function(props, api)
		local option = {
			Connections = {},
			Hold = props.Hold == true,
			Keys = toKeys(props.Default),
			Mobile = props.Mobile == true,
			Name = props.Name,
			Options = {},
			Triggered = createSignal(),
			Type = 'Bind'
		}

		local label = api.Groupbox:AddLabel(props.Name)
		local mode = props.Mode or (option.Hold and 'Hold' or 'Toggle')

		option.Object = label:AddKeyPicker(props.Name, {
			Callback = function(state)
				option.Triggered:Fire(state == true)
			end,
			Default = option.Keys[1] or 'None',
			Mode = mode,
			SyncToggleState = props.SyncToggleState,
			Text = props.Text or props.Name
		})

		option.Hold = mode == 'Hold'

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.Hold = self.Hold
			data.Keys = toKeys(self.Keys)
			data.Mobile = self.Mobile
		end

		function option.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			if data.Keys ~= nil then
				option.Keys = toKeys(data.Keys)
				option.Object:SetValue({option.Keys[1] or 'None', option.Object.Mode or mode})
			end

			if type(data.Mobile) == 'boolean' then
				option.Mobile = data.Mobile
			end

			if type(data.Hold) == 'boolean' then
				option.Hold = data.Hold
				if option.Object.SetMode then
					option.Object:SetMode(option.Hold and 'Hold' or 'Toggle')
				end
			end
		end

		return option
	end

	adapters.ColorSlider = function(props, api)
		local color = defaultColor(props.Default)
		local hue, sat, value = color:ToHSV()

		local option = {
			Connections = {},
			Hue = hue,
			Name = props.Name,
			Opacity = props.Transparency or 0,
			Options = {},
			Rainbow = props.Rainbow == true,
			Sat = sat,
			Type = 'ColorSlider',
			Value = value
		}

		local label = api.Groupbox:AddLabel(props.Name, true)

		option.Object = label:AddColorPicker(props.Name, {
			Callback = function(selection, transparency)
				local h, s, v = selection:ToHSV()

				option.Hue = h
				option.Sat = s
				option.Value = v
				option.Opacity = transparency or option.Opacity
				option.Rainbow = false

				if props.Callback then
					props.Callback(h, s, v, option.Opacity)
				end
			end,
			Default = color,
			Text = props.Text or props.Name,
			Tooltip = props.Tooltip,
			Transparency = option.Opacity
		})

		function option.SetValue(self, h, s, v)
			self.Hue = h
			self.Sat = s
			self.Value = v

			if self.Object then
				self.Object:SetValue(Color3.fromHSV(h, s, v))
			end
		end

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.Hue = self.Hue
			data.Opacity = self.Opacity
			data.Rainbow = self.Rainbow
			data.Sat = self.Sat
			data.Value = self.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			local h = type(data.Hue) == 'number' and data.Hue or option.Hue
			local s = type(data.Sat) == 'number' and data.Sat or option.Sat
			local v = type(data.Value) == 'number' and data.Value or option.Value

			option.Opacity = type(data.Opacity) == 'number' and data.Opacity or option.Opacity
			option.Rainbow = data.Rainbow == true
			option:SetValue(h, s, v)

			if props.Callback then
				props.Callback(h, s, v, option.Opacity)
			end
		end

		return option
	end

	adapters.Targets = function(props, api)
		local option = {
			Connections = {},
			Name = 'Targets',
			Options = {},
			Type = 'Targets'
		}

		local children = {}

		for _, kind in {'Players', 'NPCs', 'Walls'} do
			children[kind] = adapters.Toggle({
				Callback = function(state)
					if props[kind .. 'Callback'] then
						props[kind .. 'Callback'](state)
					end
					if props.Callback then
						props.Callback(kind, state)
					end
				end,
				Default = props[kind] == true,
				Name = kind,
				Text = kind
			}, api)
		end

		local first = children.Players
		option.Object = first.Object
		option.Enabled = first.Enabled

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.NPCs = children.NPCs.Object.Value
			data.Players = children.Players.Object.Value
			data.Walls = children.Walls.Object.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			for _, kind in {'Players', 'NPCs', 'Walls'} do
				if type(data[kind]) == 'boolean' then
					children[kind].Object:SetValue(data[kind])
				end
			end
		end

		return option
	end

	adapters.TwoSlider = function(props, api)
		local option = {
			Connections = {},
			Name = props.Name,
			Options = {},
			Type = 'TwoSlider',
			ValueMax = props.DefaultMax or props.Max,
			ValueMin = props.DefaultMin or props.Min
		}

		local childProps = {
			Max = props.Max,
			Min = props.Min,
			Prefix = props.Prefix,
			Rounding = props.Rounding,
			Suffix = props.Suffix,
			Tooltip = props.Tooltip
		}

		local minimum = {}
		for key, value in childProps do
			minimum[key] = value
		end
		minimum.Default = option.ValueMin
		minimum.Name = props.Name .. 'Min'
		minimum.Text = (props.Text or props.Name) .. ' Min'
		minimum.Callback = function(value)
			option.ValueMin = value
			if props.Callback then
				props.Callback(option.ValueMin, option.ValueMax)
			end
		end

		local maximum = {}
		for key, value in childProps do
			maximum[key] = value
		end
		maximum.Default = option.ValueMax
		maximum.Name = props.Name .. 'Max'
		maximum.Text = (props.Text or props.Name) .. ' Max'
		maximum.Callback = function(value)
			option.ValueMax = value
			if props.Callback then
				props.Callback(option.ValueMin, option.ValueMax)
			end
		end

		option.Min = adapters.Slider(minimum, api)
		option.Max = adapters.Slider(maximum, api)
		option.Object = option.Min.Object
		option.Enabled = option.Min.Enabled

		function option.Clean(self, callback)
			self.Connections[#self.Connections + 1] = callback
		end

		function option.Save(self, data)
			data.ValueMax = self.Max.Object.Value
			data.ValueMin = self.Min.Object.Value
		end

		function option.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			if type(data.ValueMin) == 'number' then
				option.Min.Object:SetValue(data.ValueMin)
			end

			if type(data.ValueMax) == 'number' then
				option.Max.Object:SetValue(data.ValueMax)
			end
		end

		return option
	end

	--[[ containers ]]

	local OPTION_CREATORS = {
		Bind = 'CreateBind',
		Button = 'CreateButton',
		ColorSlider = 'CreateColorSlider',
		Divider = 'CreateDivider',
		Dropdown = 'CreateDropdown',
		Slider = 'CreateSlider',
		Targets = 'CreateTargets',
		TextBox = 'CreateTextBox',
		Toggle = 'CreateToggle',
		TwoSlider = 'CreateTwoSlider'
	}

	-- the profile expects `Options` to be keyed by option name, each entry holding
	-- whatever that option's own Save wrote ({Enabled}, {Value, Max}, {Hue, ...})
	local function optionsToData(host)
		local data = {}

		for name, option in pairs(host.Options) do
			if option.Save then
				local entry = {}

				option:Save(entry)
				data[name] = entry
			end
		end

		return data
	end

	local function optionsFromData(host, data)
		for name, entry in pairs(data) do
			local option = host.Options[name]

			if option and option.Load and type(entry) == 'table' then
				option:Load(entry)
			end
		end
	end

	local function addOption(host, kind, props)
		local name = props.Name or props.Text or kind

		if props.Type == 'Bind' then
			kind = 'Bind'
		elseif props.Type == 'ColorSlider' then
			kind = 'ColorSlider'
		end

		local create = adapters[kind]
		if not create then
			notify('Vape', 'Unknown option type ' .. tostring(kind), 5, 'warning')
			return nil
		end

		local option = create(props, {Groupbox = host.Groupbox})
		if option and option ~= true then
			option.Type = option.Type or kind
			host.Options[name] = option
		end

		return option
	end

	local function installCreators(target)
		for kind, method in OPTION_CREATORS do
			target[method] = function(self, props)
				return addOption(self, kind, props or {})
			end
		end
	end

	adapters.CreateModule = function(category, props)
		vape:Remove(props.Name)

		local module = {
			Category = category,
			Connections = {},
			Enabled = false,
			ExtraText = props.ExtraText,
			Index = props.Index or 1,
			Name = props.Name,
			Options = {},
			Type = 'Module',
			Visible = props.Visible ~= false
		}

		module.Object = category.Groupbox:AddToggle(props.Name, {
			Callback = function(state)
				if module.Enabled == state then
					return
				end

				module.Enabled = state

				local connections = module.Connections
				module.Connections = {}

				for _, connection in connections do
					pcall(function()
						connection:Disconnect()
					end)
				end

				if props.Function then
					task.spawn(props.Function, state)
				end

				if props.Callback then
					props.Callback(state)
				end
			end,
			Default = false,
			Text = props.Name,
			Tooltip = props.Tooltip
		})

		module.OptionsGroupbox = category.Groupbox:AddDependencyBox()
		module.OptionsGroupbox:SetupDependencies({
			{module.Object, true}
		})

		local dependency = {Groupbox = module.OptionsGroupbox, Options = module.Options}

		for kind, method in OPTION_CREATORS do
			module[method] = function(self, optionProps)
				return addOption(dependency, kind, optionProps or {})
			end
		end

		function module.Toggle(self)
			self.Object:SetValue(not self.Object.Value)
		end

		function module.Clean(self, connection)
			self.Connections[#self.Connections + 1] = connection
		end

		function module.Save(self, data)
			self.Options.Bind = self.Options.Bind or {
				Clean = function() end,
				Load = function() end,
				Save = function(_, values)
					values.Hold = false
					values.Keys = {}
					values.Mobile = false
				end
			}

			local bind = self.Options.Bind
			bind:Save(data)

			data.Enabled = self.Object.Value
			data.Options = optionsToData(self)
			data.Visible = self.Visible
		end

		function module.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			if type(data.Visible) == 'boolean' then
				module.Visible = data.Visible
			end

			if type(data.Options) == 'table' then
				optionsFromData(module, data.Options)
			end

			if module.Options.Bind and type(data.Bind) == 'table' then
				module.Options.Bind:Load(data.Bind)
			end

			if type(data.Enabled) == 'boolean' and data.Enabled ~= module.Object.Value then
				module.Object:SetValue(data.Enabled)
			end
		end

		vape.Modules[module.Name] = module

		return module
	end

	adapters.CreateCategory = function(props)
		local category = {
			Connections = {},
			Groupbox = nil,
			Modules = {},
			Name = props.Name,
			Options = {},
			Tab = props.Tab,
			Type = 'Category'
		}

		local side = props.Side or 'Left'
		category.Groupbox = props.Tab:AddGroupbox({
			Name = props.Text or props.Name,
			Side = side
		})

		function category.CreateModule(self, moduleProps)
			local module = adapters.CreateModule(self, moduleProps)
			table.insert(self.Modules, module)

			return module
		end

		function category.Clean(self, connection)
			self.Connections[#self.Connections + 1] = connection
		end

		function category.Save(self, data)
			data.Name = self.Name
			data.Options = optionsToData(self)
		end

		function category.Load(self, data)
			if type(data) ~= 'table' or type(data.Options) ~= 'table' then
				return
			end

			optionsFromData(category, data.Options)
		end

		installCreators(category)
		vape.Categories[category.Name] = category

		return category
	end

	adapters.CreatePane = function(props)
		local pane = {
			Groupbox = nil,
			Name = props.Name,
			Options = {},
			Tab = props.Tab,
			Type = 'Pane'
		}

		pane.Groupbox = props.Tab:AddGroupbox({
			Name = props.Text or props.Name,
			Side = props.Side or 'Left'
		})

		installCreators(pane)
		vape.Categories[pane.Name] = pane

		return pane
	end

	adapters.CreateCategoryList = function(props)
		local component = {
			Groupbox = nil,
			List = {},
			ListEnabled = {},
			Name = props.Name,
			Options = {},
			Type = 'TextList',
			Update = Instance.new('BindableEvent')
		}

		component.Groupbox = props.Tab and props.Tab:AddGroupbox({
			Name = props.Text or props.Name,
			Side = props.Side or 'Right'
		}) or {}

		component.ListObject = component.Groupbox and component.Groupbox:AddDropdown(props.Name .. 'List', {
			Callback = function(value)
				if component.Refreshing then
					return
				end

				component.ListEnabled = toList(value)

				if props.Callback then
					props.Callback(component.ListEnabled)
				end

				component.Update:Fire()
			end,
			Multi = true,
			SpecialType = props.SpecialType or 'Player',
			Text = props.Text or props.Name,
			Values = {}
		}) or nil

		if component.Groupbox and props.Options then
			for key, option in props.Options do
				local name = option.Name or option.Text or key
				local copy = {}
				for field, value in option do
					copy[field] = value
				end
				copy.Name = name

				addOption(component, option.Type or 'Toggle', copy)

				if component.Options[name] == nil then
					component.Options[key] = copy
				end
			end
		end

		function component.GetValue(self, name)
			if not name then
				return self.ListEnabled[1], self.ListEnabled[1] ~= nil
			end

			for _, value in self.ListEnabled do
				if value == name then
					return value, true
				end
			end

			return nil, false
		end

		function component.ChangeValue(self, name, skipGUI)
			local found
			for index, value in self.ListEnabled do
				if value == name then
					found = index
					break
				end
			end

			if found then
				if props.AllowNull or #self.ListEnabled > 1 then
					table.remove(self.ListEnabled, found)
				end
			else
				table.insert(self.ListEnabled, name)
			end

			self.ListEnabled = toList(self.ListEnabled)

			if not skipGUI and self.ListObject then
				self.ListObject:SetValue(toSet(self.ListEnabled))
			end

			self.Update:Fire()
		end

		function component.Save(self, data)
			data.ListEnabled = toList(self.ListEnabled)

			for key, option in self.Options do
				option:Save(data)
			end
		end

		function component.Load(self, data)
			if type(data) ~= 'table' then
				return
			end

			component.Refreshing = true

			component.ListEnabled = toList(data.ListEnabled)

			if component.ListObject then
				component.ListObject:SetValue(toSet(component.ListEnabled))
			end

			for name, option in self.Options do
				local value = data[name]

				if value == nil then
					for key, candidate in data do
						if type(candidate) == 'table' and (candidate.Name == name or key == option.Name) then
							value = candidate
							break
						end
					end
				end

				if value ~= nil then
					option:Load(value)
				end
			end

			component.Refreshing = nil
			component.Update:Fire()
		end

		local wrapper = {}
		local passthrough = {'AddButton', 'AddDivider', 'AddDropdown', 'AddInput', 'AddLabel', 'AddSlider', 'AddToggle'}
		for _, method in passthrough do
			wrapper[method] = function(_, ...)
				return component.Groupbox[method](component.Groupbox, ...)
			end
		end

		for kind, method in OPTION_CREATORS do
			component[method] = function(self, optionProps)
				return addOption({Groupbox = wrapper, Options = self.Options}, kind, optionProps or {})
			end
		end
		vape.Categories[component.Name] = component

		return component
	end

	-- base.lua's vape:CreateCategory / CreateCategoryList / CreateOverlay call
	-- components.Category(...) / CategoryList(...) / Overlay(...), so the adapter
	-- factories are exposed under those names too
	adapters.Category = function(props)
		return adapters.CreateCategory(props)
	end

	adapters.CategoryList = function(props)
		return adapters.CreateCategoryList(props)
	end

	-- Obsidian has no floating overlay panel of the shape Vape's overlay needs, so
	-- this keeps the contract (a table with Object/Options and a destroy path)
	-- while leaving the drawing to the module that asks for it
	adapters.Overlay = function(props)
		local overlay = {
			Name = props.Name,
			Options = {},
			Type = 'Overlay',
			Visible = true
		}

		addMaid(overlay)

		overlay.Button = {
			Enabled = false,
			Toggle = function(self)
				self.Enabled = not self.Enabled
			end
		}

		function overlay:Save(data)
			data.Name = self.Name
		end

		function overlay:Load() end

		function overlay:Destroy() end

		if props.Tab then
			overlay.Groupbox = props.Tab:AddLeftGroupbox(props.Name)
		end

		for kind, method in OPTION_CREATORS do
			overlay[method] = function(self, optionProps)
				return addOption({Groupbox = overlay.Groupbox, Options = self.Options}, kind, optionProps or {})
			end
		end

		vape.Categories[props.Name] = overlay

		return overlay
	end

	components = adapters


	addMaid(vape)
	gui = Instance.new('ScreenGui')
	gui.Name = randomString()
	gui.DisplayOrder = 9999999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.IgnoreGuiInset = true

	if vape.ThreadFix then
		local holder = Instance.new('Folder')
		holder.Parent = cloneref(game:GetService('CoreGui'))
		gui.OnTopOfCoreBlur = true
		gui.Parent = (gethui and gethui()) or cloneref(game:GetService('CoreGui'))
		vape.holder = holder
	else
		gui.Parent = cloneref(game:GetService('Players')).LocalPlayer.PlayerGui
		gui.ResetOnSpawn = false
		vape.holder = gui
	end
	vape.gui = gui

	scaledgui = Instance.new('Frame')
	scaledgui.BackgroundTransparency = 1
	scaledgui.Name = 'ScaledGui'
	scaledgui.Size = UDim2.fromScale(1, 1)
	scaledgui.Parent = gui
	clickgui = Instance.new('Frame')
	clickgui.BackgroundTransparency = 1
	clickgui.Name = 'ClickGui'
	clickgui.Size = UDim2.fromScale(1, 1)
	clickgui.Visible = false
	clickgui.Parent = scaledgui
	local scarcitybanner = Instance.new('TextLabel')
	scarcitybanner.BackgroundTransparency = 1
	scarcitybanner.FontFace = uipallet.Font
	scarcitybanner.Position = UDim2.fromScale(0, 0.97)
	scarcitybanner.Size = UDim2.fromScale(1, 0.018)
	scarcitybanner.Text = 'Join Inhaler V4 Discord server at https://discord.gg/YSzD7f9neR'
	scarcitybanner.TextColor3 = Color3.new(1, 1, 1)
	scarcitybanner.TextScaled = true
	scarcitybanner.TextStrokeTransparency = 0.5
	scarcitybanner.Parent = clickgui
	local modal = Instance.new('TextButton')
	modal.BackgroundTransparency = 1
	modal.Modal = true
	modal.Text = ''
	modal.Parent = clickgui
	local cursor = Instance.new('ImageLabel')
	cursor.BackgroundTransparency = 1
	cursor.Image = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
	cursor.Size = UDim2.fromOffset(64, 64)
	cursor.Visible = false
	cursor.Parent = gui
	notifications = Instance.new('Folder')
	notifications.Name = 'Notifications'
	notifications.Parent = scaledgui
	tooltip = Instance.new('TextLabel')
	tooltip.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
	tooltip.FontFace = uipallet.Font
	tooltip.Position = UDim2.fromScale(-1, -1)
	tooltip.RichText = true
	tooltip.Text = ''
	tooltip.TextColor3 = color.Dark(uipallet.Text, 0.16)
	tooltip.TextSize = 12
	tooltip.Visible = false
	tooltip.ZIndex = 5
	tooltip.Parent = scaledgui
	toolblur = addBlur(tooltip)
	addCorner(tooltip)
	scale = Instance.new('UIScale')
	scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
	scale.Parent = scaledgui
	scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
	components.GUI({})

	vape:CreateCategory({
		Name = 'Combat',
		Icon = getvapeasset('newvape/assets/new/combat.png'),
		Size = UDim2.fromOffset(13, 14)
	})
	vape:CreateCategory({
		Name = 'Blatant',
		Icon = getvapeasset('newvape/assets/new/blatant.png'),
		Size = UDim2.fromOffset(14, 14)
	})
	vape:CreateCategory({
		Name = 'Render',
		Icon = getvapeasset('newvape/assets/new/render.png'),
		Size = UDim2.fromOffset(15, 14)
	})
	vape:CreateCategory({
		Name = 'Utility',
		Icon = getvapeasset('newvape/assets/new/utility.png'),
		Size = UDim2.fromOffset(15, 14)
	})
	vape:CreateCategory({
		Name = 'World',
		Icon = getvapeasset('newvape/assets/new/world.png'),
		Size = UDim2.fromOffset(14, 14)
	})
	vape:CreateCategory({
		Name = 'Inventory',
		Icon = getvapeasset('newvape/assets/new/inventory.png'),
		Size = UDim2.fromOffset(15, 14)
	})
	vape.Categories.Main:CreateDivider({
		Text = 'misc'
	})

	--[[
		Friends
	]]
	do
		local friends
		local friendscolor = {
			Hue = 1,
			Sat = 1,
			Value = 1
		}

		friends = vape:CreateCategoryList({
			Name = 'Friends',
			Icon = getvapeasset('newvape/assets/new/friends.png'),
			Size = UDim2.fromOffset(17, 16),
			Placeholder = 'Roblox username',
			Color = Color3.fromRGB(5, 134, 105),
			Player = true,
			Function = function()
				friends.Update:Fire()
				friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
			end
		})
		friends.Update = Instance.new('BindableEvent')
		friends.ColorUpdate = Instance.new('BindableEvent')
		friends:CreateToggle({
			Name = 'Recolor visuals',
			Darker = true,
			Default = true,
			Function = function()
				friends.Update:Fire()
				friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
			end
		})
		friendscolor = friends:CreateColorSlider({
			Name = 'Friends color',
			Darker = true,
			Function = function(hue, sat, val)
				for _, v in friends.Object.Children:GetChildren() do
					local dot = v:FindFirstChild('Dot')
					if dot and dot.BackgroundColor3 ~= color.Light(uipallet.Main, 0.37) then
						dot.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
						dot.Dot.BackgroundColor3 = dot.BackgroundColor3
					end
				end

				friends.ColorUpdate:Fire(hue, sat, val)
			end
		})
		friends:CreateToggle({
			Name = 'Use friends',
			Darker = true,
			Default = true,
			Function = function()
				friends.Update:Fire()
				friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
			end
		})
		vape:Clean(friends.Update)
		vape:Clean(friends.ColorUpdate)
	end

	--[[
		Profiles
	]]
	vape:CreateCategoryList({
		Name = 'Profiles',
		Icon = getvapeasset('newvape/assets/new/profiles.png'),
		Size = UDim2.fromOffset(17, 10),
		Position = UDim2.fromOffset(12, 16),
		Placeholder = 'Type name',
		Profiles = true
	})

	--[[
		Targets
	]]
	local targets
	targets = vape:CreateCategoryList({
		Name = 'Targets',
		Icon = getvapeasset('newvape/assets/new/friends.png'),
		Size = UDim2.fromOffset(17, 16),
		Placeholder = 'Roblox username',
		Player = true,
		Function = function()
			targets.Update:Fire()
		end
	})
	targets.Update = Instance.new('BindableEvent')
	vape:Clean(targets.Update)

	components.LegitWindow()
	vape.SearchBar = components.SearchBar()
	vape.Categories.Main:CreateOverlayBar()

	--[[
		General Settings
	]]

	local general = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'General'})
	local settingConnections = {}
	vape.MultiKeybind = general:CreateToggle({
		Name = 'Enable Multi-Keybinding',
		Tooltip = 'Allows multiple keys to be bound to a module (eg. G + H)'
	})
	general:CreateToggle({
		Name = 'Allow setting keybinds',
		Function = function(callback)
			if callback then
				for _, container in {vape.Modules, vape.Legit.Modules} do
					for _, module in container do
						for _, component in module.Options do
							if component.Type == 'Toggle' then
								local bind = components.Bind({
									Module = true
								}, nil, component)
								bind.Object.Position = UDim2.new(1, -40, 0, 5)

								table.insert(settingConnections, bind.Triggered:Connect(function(isDown)
									if bind.Hold then
										if component.Enabled ~= isDown then
											if vape.SettingToggleNotifications.Enabled then
												vape:CreateNotification(module.Name, component.Name..' '..(not component.Enabled and "<font color='#00AA00'>ON</font>" or "<font color='#FF5A5A'>OFF</font>"), 1.5)
											end

											component:Toggle()
										end
									else
										if vape.SettingToggleNotifications.Enabled then
											vape:CreateNotification(module.Name, component.Name..' '..(not component.Enabled and "<font color='#00AA00'>ON</font>" or "<font color='#FF5A5A'>OFF</font>"), 1.5)
										end

										component:Toggle()
									end
								end))

								table.insert(settingConnections, component.Object.MouseEnter:Connect(function()
									bind:SetVisible(true)
								end))

								table.insert(settingConnections, component.Object.MouseLeave:Connect(function()
									bind:SetVisible(false)
								end))
							end
						end
					end
				end
			else
				for _, container in {vape.Modules, vape.Legit.Modules} do
					for _, module in container do
						for _, component in module.Options do
							if component.Bind then
								component.Bind:Destroy()
							end
						end
					end
				end

				for _, connection in settingConnections do
					connection:Disconnect()
				end
				table.clear(settingConnections)
			end
		end,
		Tooltip = 'Hover a toggle setting to bind it to a key'
	})

	general:CreateButton({
		Name = 'Reset current profile',
		Function = function()
		vape.Save = function() end
			if isfile('newvape/profiles/'..vape.Profile..vape.Place..'.txt') and delfile then
				delfile('newvape/profiles/'..vape.Profile..vape.Place..'.txt')
			end

			shared.vapereload = true
			if shared.VapeDeveloper then
				loadstring(readfile('newvape/loader.lua'), 'loader')()
			else
				loadstring(game:HttpGet('https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
			end
		end,
		Tooltip = 'This will set your profile to the default settings of Vape'
	})

	general:CreateButton({
		Name = 'Self destruct',
		Function = function()
			vape:Uninject()
		end,
		Tooltip = 'Removes vape from the current game'
	})

	general:CreateButton({
		Name = 'Reinject',
		Function = function()
			shared.vapereload = true
			if shared.VapeDeveloper then
				loadstring(readfile('newvape/loader.lua'), 'loader')()
			else
				loadstring(game:HttpGet('https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
			end
		end,
		Tooltip = 'Reloads vape for debugging purposes'
	})

	--[[
		Module Settings
	]]

	local modules = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'Modules'})
	modules:CreateToggle({
		Name = 'Teams by server',
		Tooltip = 'Ignore players on your team designated by the server',
		Default = true,
		Function = function()
			if vape.Libraries.entity and vape.Libraries.entity.Running then
				vape.Libraries.entity.refresh()
			end
		end
	})

	modules:CreateToggle({
		Name = 'Use team color',
		Tooltip = 'Uses the TeamColor property on players for render modules',
		Default = true,
		Function = function()
			if vape.Libraries.entity and vape.Libraries.entity.Running then
				vape.Libraries.entity.refresh()
			end
		end
	})

	--[[
		GUI Settings
	]]

	local guipane = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'GUI'})
	vape.Blur = guipane:CreateToggle({
		Name = 'Blur background',
		Function = function()
			vape:BlurCheck()
		end,
		Default = true,
		Tooltip = 'Blur the background of the GUI'
	})

	guipane:CreateToggle({
		Name = 'GUI bind indicator',
		Default = true,
		Tooltip = "Displays a message indicating your GUI upon injecting.\nI.E. 'Press RSHIFT to open GUI'"
	})

	guipane:CreateToggle({
		Name = 'Show tooltips',
		Function = function(enabled)
			tooltip.Visible = false
			toolblur.Enabled = enabled
		end,
		Default = true,
		Tooltip = 'Toggles visibility of these'
	})

	guipane:CreateToggle({
		Name = 'Show legit mode',
		Function = function(enabled)
			clickgui.Search.Legit.Visible = enabled
			clickgui.Search.LegitDivider.Visible = enabled
			clickgui.Search.TextBox.Size = UDim2.new(1, enabled and -50 or -10, 0, 37)
			clickgui.Search.TextBox.Position = UDim2.fromOffset(enabled and 50 or 10, 0)
		end,
		Default = true,
		Tooltip = 'Shows the button to switch to the legit mod menu'
	})

	local ScaleSlider = {Object = {}, Value = 1}
	vape.Scale = guipane:CreateToggle({
		Name = 'Auto rescale',
		Default = true,
		Function = function(callback)
			ScaleSlider.Object.Visible = not callback
			if callback then
				--scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
			else
				scale.Scale = ScaleSlider.Value
			end
		end,
		Tooltip = 'Automatically rescales the gui using the screens resolution'
	})

	ScaleSlider = guipane:CreateSlider({
		Name = 'Scale',
		Min = 0.1,
		Max = 2,
		Decimal = 10,
		Function = function(val, final)
			if final and not vape.Scale.Enabled then
				scale.Scale = val
			end
		end,
		Default = 1,
		Darker = true,
		Visible = false
	})

	vape.RainbowSpeed = guipane:CreateSlider({
		Name = 'Rainbow speed',
		Min = 0.1,
		Max = 10,
		Decimal = 10,
		Default = 1,
		Tooltip = 'Adjusts the speed of rainbow values'
	})

	vape.RainbowUpdateSpeed = guipane:CreateSlider({
		Name = 'Rainbow update rate',
		Min = 1,
		Max = 144,
		Default = 60,
		Tooltip = 'Adjusts the update rate of rainbow values',
		Suffix = 'hz'
	})

	--[[guipane:CreateDropdown({
		Name = 'GUI Theme',
		List = inputService.TouchEnabled and {'new', 'old'} or {'new', 'old', 'rise'},
		Function = function(val, mouse)
			if mouse then
				writefile('newvape/profiles/gui.txt', val)
				shared.vapereload = true
				if shared.VapeDeveloper then
					loadstring(readfile('newvape/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
				end
			end
		end,
		Tooltip = 'new - The newest vape theme to since v4.05\nold - The vape theme pre v4.05\nrise - Rise 6.0'
	})]]

	guipane:CreateDropdown({
		Name = 'Search bar style',
		List = {'Floating', 'None'},
		Default = 'Floating',
		Function = function(value)
			vape.SearchBar.Object.Visible = value == 'Floating'
		end,
		Tooltip = 'Switch between search bar styles'
	})

	vape.RainbowMode = guipane:CreateDropdown({
		Name = 'Rainbow Mode',
		List = {'Normal', 'Gradient', 'Retro'},
		Tooltip = 'Normal - Smooth color fade\nGradient - Gradient color fade\nRetro - Static color'
	})

	guipane:CreateButton({
		Name = 'Reset GUI positions',
		Function = function()
			for _, category in vape.Categories do
				category.Object.Position = UDim2.fromOffset(6, 42)
			end
		end,
		Tooltip = 'This will reset your GUI back to the default'
	})

	guipane:CreateButton({
		Name = 'Sort GUI',
		Function = function()
			local priority = {
				GUICategory = 1,
				CombatCategory = 2,
				BlatantCategory = 3,
				RenderCategory = 4,
				UtilityCategory = 5,
				WorldCategory = 6,
				InventoryCategory = 7,
				FriendsCategory = 8,
				ProfilesCategory = 9
			}

			local categories = {}
			for _, category in vape.Categories do
				if category.Type ~= 'Overlay' then
					table.insert(categories, category)
				end
			end

			table.sort(categories, function(a, b)
				return (priority[a.Object.Name] or 99) < (priority[b.Object.Name] or 99)
			end)

			local index = 0
			for _, category in categories do
				if category.Object.Visible then
					category.Object.Position = UDim2.fromOffset(6 + (index % 8 * 230), 60 + (index > 7 and 360 or 0))
					index += 1
				end
			end
		end,
		Tooltip = 'Sorts GUI by category order'
	})

	--[[
		Notification Settings
	]]

	local notifpane = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'Notifications'})
	vape.Notifications = notifpane:CreateToggle({
		Name = 'Notifications',
		Function = function(enabled)
			if vape.ToggleNotifications.Object then
				vape.ToggleNotifications.Object.Visible = enabled
			end

			if vape.SettingToggleNotifications.Object then
				vape.SettingToggleNotifications.Object.Visible = enabled
			end
		end,
		Tooltip = 'Shows notifications',
		Default = true
	})

	vape.ToggleNotifications = notifpane:CreateToggle({
		Name = 'Toggle alert',
		Tooltip = 'Notifies you if a module is enabled/disabled.',
		Default = true,
		Darker = true
	})
	vape.SettingToggleNotifications = notifpane:CreateToggle({
		Name = 'Setting toggle alert',
		Tooltip = 'Notifies you when a bound setting is toggled.',
		Default = true,
		Darker = true
	})

	vape.GUIColor = vape.Categories.Main.Settings:CreateGUISlider({
		Name = 'GUI Theme',
		Function = function(h, s, v)
			vape:UpdateGUI()
		end
	})

	vape.GUIBind = vape.Categories.Main.Settings:CreateBind({
		Name = 'Rebind GUI',
		Default = {'RightShift'},
		NoRemove = true,
		Tooltip = 'Change the bind of the GUI'
	})

	--Overlays

	vape:Clean(task.spawn(function()
		local hue = 0
		repeat
			for _, component in vape.RainbowSliders do
				if component.Type == 'GUISlider' then
					component:SetValue(vape:Color(hue))
				else
					component:SetValue(hue)
				end
			end

			local delta = task.wait(1 / vape.RainbowUpdateSpeed.Value)
			hue = (hue + (delta * (0.2 * vape.RainbowSpeed.Value))) % 1
		until false
	end))

	local cursorConnection
	vape:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
		vape:UpdateGUI()

		if clickgui.Visible and inputService.MouseEnabled then
			if cursorConnection then
				cursorConnection:Disconnect()
			end

			cursorConnection = runService.RenderStepped:Connect(function()
				local isVisible = clickgui.Visible
				for _, window in vape.Windows do
					isVisible = isVisible or window.Visible
				end

				if not isVisible then
					cursor.Visible = false
					cursorConnection:Disconnect()
					cursorConnection = nil
					return
				end

				cursor.Visible = not inputService.MouseIconEnabled
				if cursor.Visible then
					local mouseLocation = inputService:GetMouseLocation()
					cursor.Position = UDim2.fromOffset(mouseLocation.X - 31, mouseLocation.Y - 32)
				end
			end)
		end
	end))

	vape:Clean(function()
		if cursorConnection then
			cursorConnection:Disconnect()
		end
	end)

	vape:Clean(gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
		if vape.Scale.Enabled then
			scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
		end
	end))

	vape:Clean(notifications.ChildRemoved:Connect(function()
		for index, notif in notifications:GetChildren() do
			if tween.Tween then
				tween:Tween(notif, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
					Position = UDim2.new(1, 0, 1, -(29 + (78 * index)))
				})
			end
		end
	end))

	vape:Clean(scale:GetPropertyChangedSignal('Scale'):Connect(function()
		scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)

		for _, obj in scaledgui:QueryDescendants('GuiObject >> [Visible = true]') do
			obj.Visible = false
			obj.Visible = true
		end
	end))

	vape:Clean(vape.GUIBind.Triggered:Connect(function()
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		for _, window in self.Windows do
			window.Visible = false
		end

		for _, module in self.Modules do
			if module.Bind.Mobile then
				module.Bind.Mobile.Visible = clickgui.Visible
			end
		end

		clickgui.Visible = not clickgui.Visible
		vape:BlurCheck()
	end))

	vape:Clean(inputService.InputBegan:Connect(function(input)
		if vape.CurrentTooltip and input.KeyCode == Enum.KeyCode.LeftShift then
			vape.CurrentTooltip()
		end

		if vape.Autocomplete and input.KeyCode == Enum.KeyCode.Tab then
			vape.Autocomplete()
		end

		if not inputService:GetFocusedTextBox() and input.KeyCode ~= Enum.KeyCode.Unknown then
			table.insert(vape.HeldKeybinds, input.KeyCode.Name)
			if vape.Binding then return end

			for _, bind in vape.ActiveBinds do
				if checkKeybinds(vape.HeldKeybinds, bind.Keys, input.KeyCode.Name) then
					bind.Triggered:Fire(true)
				end
			end
		end
	end))

	vape:Clean(inputService.InputEnded:Connect(function(input)
		if vape.CurrentTooltip and input.KeyCode == Enum.KeyCode.LeftShift then
			vape.CurrentTooltip()
		end

		if not inputService:GetFocusedTextBox() and input.KeyCode ~= Enum.KeyCode.Unknown then
			if vape.Binding then
				if not vape.MultiKeybind.Enabled then
					vape.HeldKeybinds = {input.KeyCode.Name}
				end

				vape.Binding:SetBind(vape.HeldKeybinds, true)
				vape.Binding = nil
			else
				for _, bind in vape.ActiveBinds do
					if bind.Hold and checkKeybinds(vape.HeldKeybinds, bind.Keys, input.KeyCode.Name) then
						bind.Triggered:Fire(false)
					end
				end
			end
		end

		local index = table.find(vape.HeldKeybinds, input.KeyCode.Name)
		if index then
			table.remove(vape.HeldKeybinds, index)
		end
	end))
end

function vape:Remove(obj)
	local container = (self.Modules[obj] and self.Modules or self.Legit.Modules[obj] and self.Legit.Modules or self.Categories)
	if container and container[obj] then
		local component = container[obj]
		local isModule = component.Type == 'Module'
		if self.ThreadFix then
			setthreadidentity(8)
		end

		if component.Destroy then
			component:Destroy()
		end

		for _, child in {'Object', 'Children', 'Toggle', 'Button'} do
			child = typeof(component[child]) == 'table' and component[child].Object or component[child]

			if typeof(child) == 'Instance' then
				child:Destroy()
				child:ClearAllChildren()
			end
		end

		loopClean(component)
		container[obj] = nil

		if isModule then
			self:SortCategories()
		end
	end
end

function vape:Save(newProfile)
	if not self.Loaded then
		return
	end

	local guiData = {
		Categories = {},
		Profile = newProfile or self.Profile,
		v = 1
	}

	local mainData = {
		Modules = {},
		Categories = {},
		Legit = {},
		v = 1
	}

	for name, category in self.Categories do
		category:Save((category.Type == 'Overlay' and mainData or guiData).Categories)
	end

	for _, module in self.Modules do
		module:Save(mainData.Modules)
	end

	for _, module in self.Legit.Modules do
		module:Save(mainData.Legit)
	end

	writefile('newvape/profiles/'..game.GameId..'.gui.txt', httpService:JSONEncode(guiData))
	writefile('newvape/profiles/'..self.Profile..self.Place..'.txt', httpService:JSONEncode(mainData))
end

function vape:SaveOptions(obj)
	local data = {}
	for _, component in obj.Options do
		if not component.Save then
			continue
		end

		component:Save(data)
	end

	return data
end

function vape:SortCategories()
	local sorting = {}
	for _, module in self.Modules do
		sorting[module.Category] = sorting[module.Category] or {}
		table.insert(sorting[module.Category], module.Name)
	end

	for _, sort in sorting do
		table.sort(sort)

		local index = 2
		for _, name in sort do
			self.Modules[name].Index = index / 2
			self.Modules[name].Object.LayoutOrder = index
			self.Modules[name].Children.LayoutOrder = index + 1
			index += 2
		end
	end
end

function vape:Uninject()
	self:Save()
	self.Loaded = nil

	for _, module in self.Modules do
		if module.Enabled then
			module:Toggle()
		end
	end

	for _, module in self.Legit.Modules do
		if module.Enabled then
			module:Toggle()
		end
	end

	for _, category in self.Categories do
		if category.Type == 'Overlay' and category.Button.Enabled then
			category.Button:Toggle()
		end
	end

	for _, connection in self.Connections do
		pcall(function()
			connection:Disconnect()
		end)
	end

	if self.ThreadFix then
		setthreadidentity(8)
		clickgui.Visible = false
		self:BlurCheck()
	end

	gui:ClearAllChildren()
	gui:Destroy()
	table.clear(self.Connections)
	table.clear(self.Libraries)
	loopClean(self)

	shared.vape = nil
	shared.vapereload = nil
	shared.VapeIndependent = nil
end

local guiUpdate
function vape:UpdateGUI()
	if guiUpdate then
		return
	end

	guiUpdate = runService.RenderStepped:Once(function()
		if vape.Loaded ~= nil then
			vape:UpdateGUIQueue(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		end

		guiUpdate = nil
	end)
end

function vape:UpdateGUIQueue(hue, sat, val)
	if TextGUI.Button.Enabled then
		TextGUI:UpdateColor(hue, sat, val, default)
	end

	if not clickgui.Visible and not vape.Legit.Window.Visible then return end
	local isRainbow = vape.GUIColor.Rainbow and vape.RainbowMode.Value ~= 'Retro'

	for name, component in vape.Categories do
		component:Color(hue, sat, val, isRainbow)
	end

	for _, component in vape.Modules do
		component:Color(hue, sat, val, isRainbow)
	end

	for _, component in vape.Overlays.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end

	for _, pane in vape.Settings do
		for _, component in pane.Options do
			if component.Color then
				component:Color(hue, sat, val, isRainbow)
			end
		end
	end

	if vape.Legit.Window.Visible then
		for _, component in vape.Legit.Modules do
			component:Color(hue, sat, val, isRainbow)
		end
	end
end

--Components

vape.Components = setmetatable(components, {
	__newindex = function(_, index, callback)
		for _, module in vape.Modules do
			rawset(module, 'Create'..index, function(_, props)
				return callback(props, module.Children, module)
			end)
		end

		if vape.Legit then
			for _, module in vape.Legit.Modules do
				rawset(module, 'Create'..index, function(_, props)
					return callback(props, module.Children, module)
				end)
			end
		end

		rawset(components, index, callback)
	end
})

vape:LoadGUI()

return vape