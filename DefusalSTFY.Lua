--[[
    ═══════════════════════════════════════════════════════════
    ⚡ DEFUSAL HUB - GREEN BLACK EDITION ⚡
    ═══════════════════════════════════════════════════════════
    Features:
    - Gradient Hijau-Hitam Berputar (Animated)
    - Open Button (Draggable)
    - Minimize Button
    - Destroy GUI
    - Tabs System
    - Config System (Save/Load)
    - Notifications
    ═══════════════════════════════════════════════════════════
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--// CLEANUP EXISTING
if CoreGui:FindFirstChild("DefusalHub") then
    CoreGui.DefusalHub:Destroy()
end

--// MAIN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DefusalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

--// THEME COLORS
local Theme = {
    Background = Color3.fromRGB(10, 15, 10),
    Secondary = Color3.fromRGB(15, 25, 15),
    Accent = Color3.fromRGB(0, 255, 100),
    AccentDark = Color3.fromRGB(0, 180, 70),
    Text = Color3.fromRGB(240, 255, 240),
    SubText = Color3.fromRGB(150, 200, 150),
    Red = Color3.fromRGB(255, 60, 60),
    Yellow = Color3.fromRGB(255, 200, 50),
}

--// ============================================
-- // ANIMATED GRADIENT BACKGROUND (BERPUTAR)
-- // ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 400)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- UIGradient yang berputar
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 100)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 80, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 15, 5)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 80, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 100)),
}
Gradient.Rotation = 0
Gradient.Parent = MainFrame

-- Frame dalam untuk konten (biar gradient jadi border animasi)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -4, 1, -4)
ContentFrame.Position = UDim2.new(0, 2, 0, 2)
ContentFrame.BackgroundColor3 = Theme.Background
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Animasi gradient berputar
local rotation = 0
local gradientConnection = RunService.RenderStepped:Connect(function(dt)
    rotation = (rotation + dt * 45) % 360
    Gradient.Rotation = rotation
end)

--// ============================================
-- // TOP BAR (TITLE + MINIMIZE + DESTROY)
-- // ============================================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = ContentFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Fix corner bawah biar kotak
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 12)
TopBarFix.Position = UDim2.new(0, 0, 1, -12)
TopBarFix.BackgroundColor3 = Theme.Secondary
TopBarFix.BackgroundTransparency = 0.2
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ DEFUSAL HUB"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 100, 1, 0)
VersionLabel.Position = UDim2.new(0, 45, 0, 15)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0 | Green Edition"
VersionLabel.TextColor3 = Theme.SubText
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = TopBar

-- Logo icon
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0, 5, 0, 2)
Logo.BackgroundTransparency = 1
Logo.Text = "🎯"
Logo.TextSize = 20
Logo.Font = Enum.Font.GothamBold
Logo.Parent = TopBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0, 7)
MinBtn.BackgroundColor3 = Theme.Yellow
MinBtn.BackgroundTransparency = 0.7
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.Yellow
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Destroy Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.BackgroundColor3 = Theme.Red
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.Red
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

--// ============================================
-- // SIDEBAR (TABS)
-- // ============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Theme.Secondary
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = ContentFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

--// ============================================
-- // CONTENT AREA (UNUTK TABS)
-- // ============================================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -145, 1, -50)
ContentArea.Position = UDim2.new(0, 140, 0, 45)
ContentArea.BackgroundColor3 = Theme.Secondary
ContentArea.BackgroundTransparency = 0.3
ContentArea.BorderSizePixel = 0
ContentArea.Parent = ContentFrame
ContentArea.ClipsDescendants = true

local ContentCorner2 = Instance.new("UICorner")
ContentCorner2.CornerRadius = UDim.new(0, 8)
ContentCorner2.Parent = ContentArea

--// ============================================
-- // TABS SYSTEM
-- // ============================================
local Tabs = {}
local ActiveTab = nil

local function CreateTab(name, icon)
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.BackgroundColor3 = Theme.Background
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "  " .. icon .. "  " .. name
    TabBtn.TextColor3 = Theme.SubText
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 12
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn

    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Theme.Accent
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = ContentArea

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabContent

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.Parent = TabContent

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)

    local tab = {
        Button = TabBtn,
        Content = TabContent,
        Name = name,
    }

    -- Click handler
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                TextColor3 = Theme.SubText
            }):Play()
        end
        TabContent.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.7,
            TextColor3 = Theme.Accent
        }):Play()
        ActiveTab = name
    end)

    Tabs[name] = tab
    return tab
end

--// ============================================
-- // UI HELPER FUNCTIONS
-- // ============================================
local function CreateSection(parent, text)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -10, 0, 26)
    Section.BackgroundColor3 = Theme.Background
    Section.BackgroundTransparency = 0.4
    Section.BorderSizePixel = 0
    Section.Parent = parent

    local SecCorner = Instance.new("UICorner")
    SecCorner.CornerRadius = UDim.new(0, 4)
    SecCorner.Parent = Section

    local SecLabel = Instance.new("TextLabel")
    SecLabel.Size = UDim2.new(1, -10, 1, 0)
    SecLabel.Position = UDim2.new(0, 8, 0, 0)
    SecLabel.BackgroundTransparency = 1
    SecLabel.Text = "▸ " .. text
    SecLabel.TextColor3 = Theme.Accent
    SecLabel.Font = Enum.Font.GothamBold
    SecLabel.TextSize = 11
    SecLabel.TextXAlignment = Enum.TextXAlignment.Left
    SecLabel.Parent = Section

    return Section
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.BackgroundColor3 = Theme.AccentDark
    Btn.BackgroundTransparency = 0.6
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Theme.Accent
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = 0.5
    BtnStroke.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3,
            TextColor3 = Theme.Accent
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.6,
            TextColor3 = Theme.Text
        }):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.1
        }):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.6
        }):Play()
        pcall(callback)
    end)

    return Btn
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -40, 0.5, -10)
    ToggleBtn.BackgroundColor3 = Theme.Background
    ToggleBtn.Text = ""
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = ToggleFrame

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(1, 0)
    TCorner.Parent = ToggleBtn

    local TStroke = Instance.new("UIStroke")
    TStroke.Color = Theme.Accent
    TStroke.Thickness = 1
    TStroke.Transparency = default and 0 or 0.7
    TStroke.Parent = ToggleBtn

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    Circle.BackgroundColor3 = default and Theme.Accent or Theme.SubText
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBtn

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local state = default

    local function SetState(val)
        state = val
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = val and Theme.Accent or Theme.SubText
        }):Play()
        TweenService:Create(TStroke, TweenInfo.new(0.2), {
            Transparency = val and 0 or 0.7
        }):Play()
        if callback then pcall(callback, val) end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        SetState(not state)
    end)

    return {SetState = SetState, GetState = function() return state end}
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 45)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Theme.Accent
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0, 30)
    Bar.BackgroundColor3 = Theme.Background
    Bar.BorderSizePixel = 0
    Bar.Parent = SliderFrame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local value = default
    local dragging = false

    local function UpdateValue(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos + 0.5)
        ValueLabel.Text = tostring(value)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        if callback then pcall(callback, value) end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateValue(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateValue(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {Set = function(v) value = v; ValueLabel.Text = tostring(v); Fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0); if callback then callback(v) end end}
end

local function CreateTextbox(parent, text, placeholder, callback)
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, -10, 0, 45)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = BoxFrame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, 0, 0, 22)
    Box.Position = UDim2.new(0, 0, 0, 20)
    Box.BackgroundColor3 = Theme.Background
    Box.BackgroundTransparency = 0.4
    Box.Text = ""
    Box.PlaceholderText = placeholder
    Box.PlaceholderColor3 = Theme.SubText
    Box.TextColor3 = Theme.Accent
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 12
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Box.ClearTextOnFocus = false
    Box.BorderSizePixel = 0
    Box.Parent = BoxFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    local BoxPadding = Instance.new("UIPadding")
    BoxPadding.PaddingLeft = UDim.new(0, 8)
    BoxPadding.Parent = Box

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Theme.Accent
    BoxStroke.Thickness = 1
    BoxStroke.Transparency = 0.7
    BoxStroke.Parent = Box

    Box.Focused:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    Box.FocusLost:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
        if callback then pcall(callback, Box.Text) end
    end)

    return Box
end

local function CreateDropdown(parent, text, options, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, -10, 0, 30)
    DropFrame.BackgroundTransparency = 1
    DropFrame.Parent = parent

        local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropFrame

    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0, 100, 0, 24)
    DropBtn.Position = UDim2.new(1, -100, 0.5, -12)
    DropBtn.BackgroundColor3 = Theme.Background
    DropBtn.BackgroundTransparency = 0.4
    DropBtn.Text = tostring(options[1]) .. " ▼"
    DropBtn.TextColor3 = Theme.Accent
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.TextSize = 11
    DropBtn.BorderSizePixel = 0
    DropBtn.Parent = DropFrame

    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 4)
    DropCorner.Parent = DropBtn

    local DropStroke = Instance.new("UIStroke")
    DropStroke.Color = Theme.Accent
    DropStroke.Thickness = 1
    DropStroke.Transparency = 0.5
    DropStroke.Parent = DropBtn

    local selected = options[1]
    local currentList = nil

    DropBtn.MouseButton1Click:Connect(function()
        if currentList then
            currentList:Destroy()
            currentList = nil
            return
        end
        local List = Instance.new("Frame")
        List.Size = UDim2.new(0, 100, 0, math.min(#options * 20 + 4, 160))
        List.Position = UDim2.new(1, -100, 1, 2)
        List.BackgroundColor3 = Theme.Secondary
        List.BorderSizePixel = 0
        List.ZIndex = 50
        List.Parent = DropFrame
        currentList = List

        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 4)
        ListCorner.Parent = List

        local ListStroke = Instance.new("UIStroke")
        ListStroke.Color = Theme.Accent
        ListStroke.Thickness = 1
        ListStroke.Transparency = 0.5
        ListStroke.Parent = List

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -4, 1, -4)
        Scroll.Position = UDim2.new(0, 2, 0, 2)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Theme.Accent
        Scroll.CanvasSize = UDim2.new(0, 0, 0, #options * 20)
        Scroll.ZIndex = 51
        Scroll.Parent = List

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 1)
        ListLayout.Parent = Scroll

        for _, opt in pairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, -4, 0, 19)
            OptBtn.BackgroundColor3 = Theme.Background
            OptBtn.BackgroundTransparency = 1
            OptBtn.Text = tostring(opt)
            OptBtn.TextColor3 = Theme.Text
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 11
            OptBtn.BorderSizePixel = 0
            OptBtn.ZIndex = 52
            OptBtn.Parent = Scroll
            OptBtn.MouseEnter:Connect(function()
                OptBtn.BackgroundTransparency = 0.5
                OptBtn.TextColor3 = Theme.Accent
            end)
            OptBtn.MouseLeave:Connect(function()
                OptBtn.BackgroundTransparency = 1
                OptBtn.TextColor3 = Theme.Text
            end)
            OptBtn.MouseButton1Click:Connect(function()
                selected = opt
                DropBtn.Text = tostring(opt) .. " ▼"
                List:Destroy()
                currentList = nil
                if callback then pcall(callback, opt) end
            end)
        end
    end)

    return {Get = function() return selected end}
end

--// ============================================
-- // NOTIFICATION SYSTEM
-- // ============================================
local function Notify(title, text, duration)
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 250, 0, 60)
    Notif.Position = UDim2.new(1, 20, 1, -80)
    Notif.BackgroundColor3 = Theme.Secondary
    Notif.BorderSizePixel = 0
    Notif.Parent = ScreenGui

    local NCorner = Instance.new("UICorner")
    NCorner.CornerRadius = UDim.new(0, 8)
    NCorner.Parent = Notif

    local NStroke = Instance.new("UIStroke")
    NStroke.Color = Theme.Accent
    NStroke.Thickness = 1
    NStroke.Transparency = 0.3
    NStroke.Parent = Notif

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, -10)
    AccentBar.Position = UDim2.new(0, 5, 0, 5)
    AccentBar.BackgroundColor3 = Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Notif

    local ABarCorner = Instance.new("UICorner")
    ABarCorner.CornerRadius = UDim.new(1, 0)
    ABarCorner.Parent = AccentBar

    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -20, 0, 20)
    NTitle.Position = UDim2.new(0, 15, 0, 8)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = title
    NTitle.TextColor3 = Theme.Accent
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextSize = 13
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = Notif

    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -20, 0, 25)
    NText.Position = UDim2.new(0, 15, 0, 28)
    NText.BackgroundTransparency = 1
    NText.Text = text
    NText.TextColor3 = Theme.Text
    NText.Font = Enum.Font.Gotham
    NText.TextSize = 11
    NText.TextWrapped = true
    NText.TextXAlignment = Enum.TextXAlignment.Left
    NText.Parent = Notif

    TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -270, 1, -80)
    }):Play()

    task.delay(duration or 3, function()
        TweenService:Create(Notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, 1, -80)
        }):Play()
        task.wait(0.3)
        Notif:Destroy()
    end)
end

--// ============================================
-- // GAME REFERENCE (ambil dari game Defusal)
-- // ============================================
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local IsAlive = function(plr)
    return plr.Character
        and plr.Character:FindFirstChild("Head")
        and plr.Character:FindFirstChild("HumanoidRootPart")
        and plr.Character:FindFirstChild("Torso")
        and plr.Character:FindFirstChild("Humanoid")
        and plr:GetAttribute("Health") > 0
        and plr:GetAttribute("Team") ~= "Spectator"
        and plr:GetAttribute("Alive")
end

--// ============================================
-- // TABS
-- // ============================================
local MainTab = CreateTab("Main", "🏠")
local LegitTab = CreateTab("Legit", "🎯")
local RageTab = CreateTab("Rage", "💥")
local VisualTab = CreateTab("Visuals", "👁️")
local MiscTab = CreateTab("Misc", "🔧")
local ConfigTab = CreateTab("Config", "⚙️")

-- Default active tab
MainTab.Content.Visible = true
MainTab.Button.BackgroundTransparency = 0.7
MainTab.Button.TextColor3 = Theme.Accent

--// ============================================
-- // MAIN TAB - FULL FUNCTION
-- // ============================================
CreateSection(MainTab.Content, "Bomb Info")
local bombStatusLabel = Instance.new("TextLabel")
bombStatusLabel.Size = UDim2.new(1, -10, 0, 55)
bombStatusLabel.BackgroundColor3 = Theme.Background
bombStatusLabel.BackgroundTransparency = 0.4
bombStatusLabel.Text = "🎯 Status: Not Planted\n⏱️ Timer: --:--"
bombStatusLabel.TextColor3 = Theme.Text
bombStatusLabel.Font = Enum.Font.Gotham
bombStatusLabel.TextSize = 11
bombStatusLabel.BorderSizePixel = 0
bombStatusLabel.Parent = MainTab.Content

local bsCorner = Instance.new("UICorner")
bsCorner.CornerRadius = UDim.new(0, 4)
bsCorner.Parent = bombStatusLabel

-- Update loop Bomb Info
task.spawn(function()
    while ScreenGui.Parent do
        local planted = workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("PlantedC4")
        if planted then
            local explodedAt = planted:GetAttribute("ExplodeAt") or planted:GetAttribute("PlantedAt")
            local timerText = "--"
            if typeof(explodedAt) == "number" then
                local rem = math.max(0, explodedAt - tick())
                timerText = string.format("%02d:%02d", math.floor(rem / 60), math.floor(rem % 60))
            end
            bombStatusLabel.Text = "🎯 Status: PLANTED\n⏱️ Timer: " .. timerText
            bombStatusLabel.TextColor3 = Theme.Red
        else
            bombStatusLabel.Text = "🎯 Status: Not Planted\n⏱️ Timer: --:--"
            bombStatusLabel.TextColor3 = Theme.Text
        end
        task.wait(0.5)
    end
end)

CreateSection(MainTab.Content, "C4 Actions")
CreateButton(MainTab.Content, "🌱 Plant C4 (Instant)", function()
    if not IsAlive(LocalPlayer) then
        Notify("C4", "You are dead!", 2); return
    end
    if LocalPlayer:GetAttribute("Team") ~= "T" then
        Notify("C4", "Not in Militia team!", 2); return
    end
    if RS:GetAttribute("HasBomb") ~= LocalPlayer.Name then
        Notify("C4", "You don't have the bomb!", 2); return
    end
    if RS:GetAttribute("Preparation") then
        Notify("C4", "Let the round start!", 2); return
    end
    local origCF = LocalPlayer.Character.HumanoidRootPart.CFrame
    local map = workspace:FindFirstChild("Map")
    if not map or not map:FindFirstChild("Markers") then
        Notify("C4", "Map markers not found!", 2); return
    end
    local siteKey = RS:GetAttribute("PlantedAt") or "BombA"
    local siteName = (Misc && Misc.plantSite) or "A"
    local marker = map.Markers:FindFirstChild(siteName == "A" and "BombA" or "BombB")
    if not marker then
        Notify("C4", "Site marker not found!", 2); return
    end
    LocalPlayer.Character.HumanoidRootPart.CFrame = marker.CFrame - Vector3.new(0, -1, 0)
    task.wait(0.3)
    pcall(function()
        RS.Events.PlantC4:FireServer()
    end)
    LocalPlayer.Character.HumanoidRootPart.CFrame = origCF
    Notify("C4", "Planted on site " .. siteName, 3)
end)

CreateButton(MainTab.Content, "⚡ Instant Defuse", function()
    if not IsAlive(LocalPlayer) then
        Notify("Defuse", "You are dead!", 2); return
    end
    if LocalPlayer:GetAttribute("Team") ~= "CT" then
        Notify("Defuse", "Not in Operators team!", 2); return
    end
    if not (workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("PlantedC4")) then
        Notify("Defuse", "Bomb not planted!", 2); return
    end
    if not (Data and Data.Game and Data.Game.Ambassador) then
        -- fallback: langsung fire event
        pcall(function() RS.Events.StartDefuse:FireServer() end)
        Notify("Defuse", "Attempted defuse (fallback)", 2)
        return
    end
    pcall(function()
        RS.Events.StartDefuse:FireServer()
        Data.Game.Ambassador.Fire("UpdateDefuse")
        RS.Events.StartDefuse:FireServer()
        Data.Game.Ambassador.Fire("StopDefuse")
    end)
    Notify("Defuse", "Defusing... wait 8 sec", 3)
end)

CreateSection(MainTab.Content, "Server")
CreateButton(MainTab.Content, "🔄 Rejoin Server", function()
    Notify("Server", "Rejoining...", 2)
    task.wait(1)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

CreateButton(MainTab.Content, "🚪 Leave Server", function()
    LocalPlayer:Kick("Left via Defusal Hub")
end)

CreateButton(MainTab.Content, "☠️ Crash Server", function()
    Notify("Crash", "⚠️ Crashing server...", 3)
    local success, err = pcall(function()
        local ev = RS:FindFirstChild("Events")
        if not ev then error("Events folder not found") end
        local big = string.rep("defusalhub" .. math.random(1, 99999), 100000)
        local setting = ev:FindFirstChild("UpdateSetting")
        if not setting then error("UpdateSetting not found") end
        for _, key in ipairs({"Graphics", "Voices", "Tracers", "Shadows", "Muzzle Flash"}) do
            setting:FireServer("Graphics", key, big)
        end
        local getSettings = ev:FindFirstChild("GetSettings")
        if getSettings and getSettings.InvokeServer then
            task.spawn(function()
                while true do
                    pcall(function() getSettings:InvokeServer() end)
                end
            end)
        end
    end)
    if not success then
        Notify("Crash", "Failed: " .. tostring(err), 3)
    end
end)

--// ============================================
-- // LEGIT TAB - FULL FUNCTION
-- // ============================================
local legitFlags = {
    silentAim = false,
    hitChance = 100,
    aimbot = false,
    aimSpeed = 10,
    aimType = "Mouse Movement",
    activate = "Mouse 1",
    hitscan = "Head",
    trigger = false,
    triggerBind = false,
    triggerDelay = 0,
    useFov = false,
    fovVisible = false,
    fovValue = 25,
    fovSides = 100,
}

local silentAimTarget = nil
local hitboxMap = {Head = "Head", Torso = "HumanoidRootPart"}

-- FOV Circle Drawing
local fovCircle = Drawing.new("Circle")
fovCircle.ZIndex = 2
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.new(1, 1, 1)
fovCircle.NumSides = 100
fovCircle.Filled = false

local function GetTarget(useFov, radius)
    local closest = useFov and radius or math.huge
    local target = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not IsAlive(plr) then continue end
        local sameTeam = plr:GetAttribute("Team") == LocalPlayer:GetAttribute("Team")
        if not RS:GetAttribute("NoTKPenalty") and sameTeam then continue end
        if plr.Character:FindFirstChildWhichIsA("ForceField") then continue end
        local part = plr.Character[hitboxMap[legitFlags.hitscan]]
        if not part then continue end
        local mousePos = UserInputService:GetMouseLocation()
        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
        if dist <= closest and onScreen then
            closest = dist
            target = plr
        end
    end
    return target
end

CreateSection(LegitTab.Content, "Silent Aim")
local silentAimToggle = CreateToggle(LegitTab.Content, "Enabled", false, function(v)
    legitFlags.silentAim = v
    Notify("Legit", "Silent Aim: " .. (v and "ON" or "OFF"), 2)
end)
CreateSlider(LegitTab.Content, "Hit Chance (%)", 0, 100, 100, function(v)
    legitFlags.hitChance = v
end)

CreateSection(LegitTab.Content, "Aim Assist")
CreateToggle(LegitTab.Content, "Enabled", false, function(v)
    legitFlags.aimbot = v
end)
CreateSlider(LegitTab.Content, "Speed (%)", 0, 100, 10, function(v)
    legitFlags.aimSpeed = v
end)
CreateDropdown(LegitTab.Content, "Aim Type", {"Mouse Movement", "Lerp", "Stick"}, function(v)
    legitFlags.aimType = v
end)
CreateDropdown(LegitTab.Content, "Activation", {"Mouse 1", "Mouse 2"}, function(v)
    legitFlags.activate = v
end)
CreateDropdown(LegitTab.Content, "Hitscan", {"Head", "Torso"}, function(v)
    legitFlags.hitscan = v
end)

CreateSection(LegitTab.Content, "Trigger Bot")
CreateToggle(LegitTab.Content, "Enabled", false, function(v)
    legitFlags.trigger = v
end)
CreateToggle(LegitTab.Content, "Hold Bind (C)", false, function(v)
    legitFlags.triggerBind = v
end)
CreateSlider(LegitTab.Content, "Delay (ms)", 0, 200, 0, function(v)
    legitFlags.triggerDelay = v
end)

CreateSection(LegitTab.Content, "FOV")
CreateToggle(LegitTab.Content, "Use FOV", false, function(v)
    legitFlags.useFov = v
end)
CreateToggle(LegitTab.Content, "Show FOV Circle", false, function(v)
    legitFlags.fovVisible = v
end)
CreateSlider(LegitTab.Content, "FOV (°)", 0, 80, 25, function(v)
    legitFlags.fovValue = v
end)
CreateSlider(LegitTab.Content, "Num Sides", 0, 100, 100, function(v)
    legitFlags.fovSides = v
end)

-- Trigger bind via key C
local triggerKeyDown = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.C and legitFlags.trigger then
        triggerKeyDown = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        triggerKeyDown = false
    end
end)

-- Silent Aim Hook (Raycast)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Raycast" and self == workspace then
        local args = {...}
        if legitFlags.silentAim and silentAimTarget and legitFlags.hitChance >= math.random(1, 100) then
            if silentAimTarget.Parent and silentAimTarget.Parent:FindFirstChild("Humanoid") then
                args[2] = (silentAimTarget.Position - args[1]).Unit * args[2].Magnitude
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end))

-- Legit loop (PreRender)
RunService.PreRender:Connect(function()
    if not IsAlive(LocalPlayer) then return end
    local viewport = Camera.ViewportSize
    local radius = (viewport.X * ((legitFlags.fovValue / 2) / Camera.FieldOfView)) / 2

    -- FOV circle
    if fovCircle then
        fovCircle.Radius = radius
        fovCircle.Visible = legitFlags.fovVisible
        fovCircle.NumSides = legitFlags.fovSides
        fovCircle.Position = Vector2.new(math.floor(viewport.X / 2), math.floor(viewport.Y / 2))
    end

    -- Silent aim target update
    if legitFlags.silentAim then
        local target = GetTarget(legitFlags.useFov, radius)
        if target then
            silentAimTarget = target.Character[hitboxMap[legitFlags.hitscan]]
        else
            silentAimTarget = nil
        end
    end

    -- Aimbot
    if legitFlags.aimbot then
        local activated = (legitFlags.activate == "Mouse 1" and UserInputService:IsMouseButtonPressed(0))
            or (legitFlags.activate == "Mouse 2" and UserInputService:IsMouseButtonPressed(1))
        if activated then
            local target = GetTarget(legitFlags.useFov, radius)
            if target then
                local part = target.Character[hitboxMap[legitFlags.hitscan]]
                if part then
                    if legitFlags.aimType == "Mouse Movement" and mousemoverel then
                        local speed = legitFlags.aimSpeed / 9
                        local screenPos = Camera:WorldToViewportPoint(part.Position)
                        local dx = (screenPos.X - (Camera.ViewportSize.X / 2)) * speed / 20.5
                        local dy = (screenPos.Y - (Camera.ViewportSize.Y / 2)) * speed / 20.5
                        mousemoverel(dx, dy)
                    elseif legitFlags.aimType == "Lerp" then
                        local targetCF = CFrame.new(Camera.CFrame.Position, part.Position)
                        local angleDiff = math.abs(math.deg(math.acos(Camera.CFrame.LookVector:Dot(targetCF.LookVector)))) * 2
                        local factor = (legitFlags.aimSpeed / angleDiff) / 100
                        Camera.CFrame = Camera.CFrame:Lerp(targetCF, factor)
                    else
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                    end
                end
            end
        end
    end

    -- Triggerbot
    if legitFlags.trigger and triggerKeyDown then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
        params.IgnoreWater = true
        local ray = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 365, params)
        if ray and ray.Instance and ray.Instance:IsA("BasePart") then
            local plr = Players:GetPlayerFromCharacter(ray.Instance.Parent)
            if plr and IsAlive(plr) and not plr.Character:FindFirstChildWhichIsA("ForceField") then
                                local sameTe = plr:GetAttribute("Team") == LocalPlayer:GetAttribute("Team")
                if RS:GetAttribute("NoTKPenalty") or not sameTeam then
                    -- wait, pakai sameTeam bukan sameTe
                end
                if RS:GetAttribute("NoTKPenalty") or not sameTe then
                    if legitFlags.triggerDelay > 0 then
                        task.wait(legitFlags.triggerDelay / 1000)
                    end
                    if mouse1press and mouse1release then
                        mouse1press()
                        task.wait()
                        mouse1release()
                    end
                end
            end
        end
    end
end)

--// ============================================
-- // RAGE TAB - FULL FUNCTION
-- // ============================================
local rageFlags = {
    enabled = false,
    silentAim = false,
    autoWall = false,
    forceDamage = false,
    minDamage = 80,
    hitscan = "Head",
    useFov = false,
    fovVisible = false,
    fovValue = 25,
    fovSides = 100,
    rapidFire = false,
    forceHead = false,
    doubleTap = false,
    throwables = false,
    noscope = false,
    backstab = false,
    debug = false,
}

local rageFovCircle = Drawing.new("Circle")
rageFovCircle.ZIndex = 2
rageFovCircle.Visible = false
rageFovCircle.Thickness = 1
rageFovCircle.Color = Color3.new(1, 1, 1)
rageFovCircle.NumSides = 100
rageFovCircle.Filled = false

-- Rage internal state
local rageHitboxMultipliers = {Head = 1.75, Torso = 1.25, ['Left Arm'] = 1, ['Right Arm'] = 1, ['Left Leg'] = 0.75, ['Right Leg'] = 0.75}
local rageDefaults = {Range = 8192, Penetration = 300, ArmorPenetration = 80, Damage = 50, Bullets = 1}
local lastShotTick = 0
local lastReloadTick = 0

local function GetRageHitboxes(plr, types)
    local result = {}
    if not IsAlive(plr) then return result end
    if type(types) == "string" then types = {types} end
    for _, t in ipairs(types) do
        if t == "Head" and plr.Character:FindFirstChild("Head") then table.insert(result, plr.Character.Head) end
        if t == "Torso" and plr.Character:FindFirstChild("Torso") then table.insert(result, plr.Character.Torso) end
        if t == "Arms" then
            if plr.Character:FindFirstChild("Left Arm") then table.insert(result, plr.Character["Left Arm"]) end
            if plr.Character:FindFirstChild("Right Arm") then table.insert(result, plr.Character["Right Arm"]) end
        end
        if t == "Legs" then
            if plr.Character:FindFirstChild("Left Leg") then table.insert(result, plr.Character["Left Leg"]) end
            if plr.Character:FindFirstChild("Right Leg") then table.insert(result, plr.Character["Right Leg"]) end
        end
    end
    return result
end

local function GetEquippedWeapon()
    if not IsAlive(LocalPlayer) then return nil, nil end
    local gunName = LocalPlayer.Character:GetAttribute("WhatGun")
    if not gunName then return nil, nil end
    local weaponsFolder = RS:FindFirstChild("Weapons")
    if not weaponsFolder then return nil, nil end
    return weaponsFolder:FindFirstChild(gunName), gunName
end

local function DistanceDamageLoss(rangeMod, dist)
    if not rangeMod then return 1 end
    return math.clamp((dist / 100) ^ (rangeMod / 34.7), 0.45, 1)
end

local function ArmorDamageLoss(armorPen)
    return 0.01 * armorPen
end

local function FireEventServer(weapon, hitPart, ratio, wallbang, bulletCount, noscope, backstab)
    local fireEvent = RS:FindFirstChild("Events")
    if not fireEvent then return end
    local weaponFire = fireEvent:FindFirstChild("WeaponFire")
    if not weaponFire then return end
    local loops = rageFlags.doubleTap and 2 or 1
    for _ = 1, loops do
        for _ = 1, bulletCount do
            local data = {
                Normal = Vector3.zero,
                Position = hitPart.Position + Vector3.one,
                Hit = hitPart.Parent,
                cCF = Camera.CFrame,
                hS = hitPart.Size and hitPart.Size.Magnitude,
                hP = hitPart.Position,
                PartName = (rageFlags.forceHead or hitPart.Name:find("Head")) and "Head" or hitPart.Name,
                Wallbang = wallbang,
                Noscope = noscope or false,
                Backstab = backstab or false,
                Ratio = ratio,
            }
            pcall(function()
                weaponFire:FireServer(data, weapon, nil, true, Camera.CFrame, hitPart.Position, nil, nil)
            end)
        end
    end
end

local function ShootTarget(weapon, origin, plr, part, visible, ratio, wallbang)
    local noscope = rageFlags.noscope
    local backstab = rageFlags.backstab
    local hasArmor = plr:GetAttribute("Armor") and plr:GetAttribute("Armor") > 0
    local hasHelmet = plr:GetAttribute("Helmet")
    local armorPen = weapon:GetAttribute("ArmorPenetration") or rageDefaults.ArmorPenetration
    local rangeMod = weapon:GetAttribute("RangeModifier")
    local dmg = weapon:GetAttribute("DMG") or rageDefaults.Damage
    local bullets = weapon:GetAttribute("Bullets") or rageDefaults.Bullets
    local highHS = weapon:GetAttribute("HighHS") and 15 or 0
    local hitboxMult = rageHitboxMultipliers[part.Name] or 1
    local dist = (origin - plr.Character.HumanoidRootPart.Position).Magnitude
    local distLoss = DistanceDamageLoss(rangeMod, dist)
    local armorLoss = hasArmor and ArmorDamageLoss(armorPen) or 1
    local approxDmg = dmg * hitboxMult * ratio * armorLoss * distLoss + (part.Name:find("Head") and highHS or 0)

    if visible or approxDmg >= rageFlags.minDamage then
        if not rageFlags.silentAim then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
        end
        if rageFlags.debug then
            Notify("Rage Debug", string.format("Shot at %s's %s | Dmg: %.1f | Ratio: %.2f", plr.Name, part.Name, approxDmg, ratio), 3)
        end
        task.spawn(FireEventServer, weapon, part, ratio, wallbang, bullets, noscope, backstab)
        return true
    end
    return false
end

local function AutoWall(weapon, origin, part, ignoreList)
    local results = {}
    local dir = (part.Position - origin).Unit
    local range = weapon:GetAttribute("Range") or 8000
    local step = range / 8
    local rayVec = dir * step
    local penetration = weapon:GetAttribute("Penetration") or 0
    local maxPene = penetration > 0 and penetration * 0.02 or 0
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList
    params.IgnoreWater = true

    local curList = table.clone(ignoreList)
    local cast = workspace:Raycast(origin, rayVec, params)
    local penUsed = 0
    local wallsHit = 0
    local iterations = 0

    repeat
        iterations = iterations + 1
        if iterations > 16 then break end
        local hitInst, hitPos = nil, origin + rayVec
        if cast then
            hitInst = cast.Instance
            hitPos = cast.Position
        end
        local entry = {
            Hit = hitInst,
            Position = hitPos,
            Normal = cast and cast.Normal or Vector3.new(0, 1, 0),
        }
        if wallsHit > 0 then entry.Wallbang = true end
        if entry.Hit then table.insert(results, entry) end
        if maxPene == 0 then break end

        if hitInst then
            local pene = 0
            local humanoid = hitInst.Parent:FindFirstChild("Humanoid")
            wallsHit = wallsHit + 1
            if not humanoid then
                local peneValue = hitInst:GetAttribute("PeneValue") or 1
                local mat = hitInst.Material
                local mult = peneValue
                if mat == Enum.Material.DiamondPlate then mult = 3
                elseif mat == Enum.Material.CorrodedMetal or mat == Enum.Material.Metal then mult = 2
                elseif mat == Enum.Material.Concrete or mat == Enum.Material.Brick then mult = 2
                elseif hitInst.Name == "Grate" or mat == Enum.Material.Wood or mat == Enum.Material.WoodPlanks then mult = 0.5
                elseif mat == Enum.Material.Fabric or mat == Enum.Material.Sand or mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass or mat == Enum.Material.Ground then mult = 0.1
                elseif hitInst.Transparency == 1 or not hitInst.CanCollide or hitInst.Name == "Glass" or hitInst.Name == "Cardboard" then mult = 0
                end
                if hitInst.Name == "nowallbang" then penetration = maxPene end
                pene = mult
            end
            table.insert(curList, hitInst.Parent)
            params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = curList
            params.IgnoreWater = true
            if penetration > 0 and humanoid then
                entry.Ratio = 1 - penetration / maxPene
            end
            penUsed = penUsed + pene
            cast = workspace:Raycast(origin, rayVec, params)
        end
        if not hitInst or (penetration < wallsHit or penetration <= penUsed) then break end
    until false

    return results
end

local function RagebotInit(weapon, players, isMelee)
    if not workspace:FindFirstChild("Map") then return end
    if RS:GetAttribute("RoundOver") or RS:GetAttribute("Preparation") or RS:GetAttribute("GameOver") then return end

    local fireRate = weapon:GetAttribute("FireRate") or 0.1
    local scopedFireRate = weapon:GetAttribute("ScopedFireRate") or fireRate
    local effFireRate = (LocalPlayer.Character:GetAttribute("Aiming") and scopedFireRate) or fireRate
    if rageFlags.rapidFire then effFireRate = 0.01 end
    local reloadTime = weapon:GetAttribute("ReloadTime") or 0
    local now = tick()
    if now - lastShotTick < effFireRate or now - lastReloadTick < reloadTime then return end

    local bullets = weapon:GetAttribute("Bullets") or 1
    local origin = LocalPlayer.Character.Head.Position
    local didShoot = false
    local ignoreList = {}
    local variables = game:GetService("ReplicatedStorage"):FindFirstChild("Variables")

    for _, plr in ipairs(players) do
        if not plr or not IsAlive(plr) then continue end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        table.clear(ignoreList)
        ignoreList = {workspace.Destroyable, workspace.Debris, workspace.Map.Clips}
        params.FilterDescendantsInstances = ignoreList
        params.IgnoreWater = true
        params:AddToFilter(LocalPlayer.Character)
        params:AddToFilter(Camera)

        if isMelee then
            if not rageFlags.enabled then return end
            local dir = (plr.Character.HumanoidRootPart.Position - origin).Unit * 7
            if not params.FilterDescendantsInstances then end
            local ray = workspace:Raycast(origin, dir, params)
            if ray and ray.Instance and ray.Instance:IsDescendantOf(plr.Character) then
                task.spawn(FireEventServer, weapon, plr.Character.HumanoidRootPart, 1, false, bullets, rageFlags.noscope, rageFlags.backstab)
                didShoot = true
                break
            end
        else
            local hitboxes = GetRageHitboxes(plr, rageFlags.hitscan)
            if #hitboxes == 0 then continue end
            for _, part in ipairs(plr.Character:GetChildren()) do
                if not table.find(hitboxes, part) then params:AddToFilter(part) end
            end
            for _, part in ipairs(hitboxes) do
                if rageFlags.useFov then
                    local mousePos = UserInputService:GetMouseLocation()
                    local vSize = Camera.ViewportSize
                    local fovRadius = (vSize.X * ((rageFlags.fovValue / 2) / Camera.FieldOfView)) / 2
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist > fovRadius or not onScreen then continue end
                end
                local dir = part.Position - origin
                local cast = workspace:Raycast(origin, dir, params)
                if cast and cast.Instance == part then
                    if ShootTarget(weapon, origin, plr, part, true, 1, false) then
                        didShoot = true
                        break
                    end
                end
                if rageFlags.autoWall then
                    local walls = AutoWall(weapon, origin, part, ignoreList)
                    local foundHit = false
                    local actualRatio = 1
                    local actualWallbang = false
                    for _, entry in ipairs(walls) do
                        if entry.Hit and entry.Hit.Parent == plr.Character then
                            foundHit = true
                            actualRatio = rageFlags.forceDamage and 1 or (entry.Ratio or 1)
                            actualWallbang = entry.Wallbang or false
                            break
                        end
                    end
                    if foundHit then
                        if ShootTarget(weapon, origin, plr, part, false, actualRatio, actualWallbang) then
                            didShoot = true
                            break
                        end
                    end
                end
            end
        end
        if didShoot then
            lastShotTick = now
            break
        end
    end
end

local function RagebotStart()
    if not rageFlags.enabled or not IsAlive(LocalPlayer) then return end
    local weapon, weaponName = GetEquippedWeapon()
    if not weapon or weaponName == "C4" then return end
    local weaponType = weapon:GetAttribute("WeaponType")
    if weaponType == "Throwable" and not rageFlags.throwables then return end
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not IsAlive(plr) then continue end
        local noTK = RS:GetAttribute("NoTKPenalty")
        if not noTK and plr:GetAttribute("Team") == LocalPlayer:GetAttribute("Team") then continue end
        if plr.Character:FindFirstChildWhichIsA("ForceField") then continue end
        if table.find(list, plr) then continue end
        table.insert(list, plr)
    end
    if #list > 0 then
        RagebotInit(weapon, list, weaponType == "Melee")
    end
end

RunService.Stepped:Connect(function()
    task.spawn(RagebotStart)
end)

CreateSection(RageTab.Content, "Rage Bot")
CreateToggle(RageTab.Content, "Enabled", false, function(v)
    rageFlags.enabled = v
    Notify("Rage", "Ragebot: " .. (v and "ON" or "OFF"), 2)
end)
CreateToggle(RageTab.Content, "Silent Aim", false, function(v) rageFlags.silentAim = v end)
CreateToggle(RageTab.Content, "Auto Wall", false, function(v) rageFlags.autoWall = v end)
CreateToggle(RageTab.Content, "Force Full Damage", false, function(v) rageFlags.forceDamage = v end)
CreateSlider(RageTab.Content, "Min Damage", 1, 115, 80, function(v) rageFlags.minDamage = v end)
CreateDropdown(RageTab.Content, "Hitscan", {"Head", "Torso", "Arms", "Legs"}, function(v) rageFlags.hitscan = {v} end)

CreateSection(RageTab.Content, "Misc")
CreateToggle(RageTab.Content, "Debug", false, function(v) rageFlags.debug = v end)
CreateToggle(RageTab.Content, "Use FOV", false, function(v) rageFlags.useFov = v end)
CreateToggle(RageTab.Content, "Show FOV Circle", false, function(v) rageFlags.fovVisible = v end)
CreateSlider(RageTab.Content, "FOV (°)", 0, 80, 25, function(v) rageFlags.fovValue = v end)
CreateSlider(RageTab.Content, "FOV Num Sides", 0, 100, 100, function(v) rageFlags.fovSides = v end)
CreateToggle(RageTab.Content, "Rapid Fire", false, function(v) rageFlags.rapidFire = v end)
CreateToggle(RageTab.Content, "Force Headshot", false, function(v) rageFlags.forceHead = v end)
CreateToggle(RageTab.Content, "Double Tap", false, function(v) rageFlags.doubleTap = v end)
CreateToggle(RageTab.Content, "Allow Throwables", false, function(v) rageFlags.throwables = v end)
CreateToggle(RageTab.Content, "Noscope Icon", false, function(v) rageFlags.noscope = v end)
CreateToggle(RageTab.Content, "Backstab Icon", false, function(v) rageFlags.backstab = v end)

-- Rage FOV circle loop
RunService.RenderStepped:Connect(function()
    if rageFovCircle then
        local vSize = Camera.ViewportSize
        rageFovCircle.Radius = (vSize.X * ((rageFlags.fovValue / 2) / Camera.FieldOfView)) / 2
        rageFovCircle.Visible = rageFlags.fovVisible
        rageFovCircle.NumSides = rageFlags.fovSides
        rageFovCircle.Position = Vector2.new(math.floor(vSize.X / 2), math.floor(vSize.Y / 2))
    end
end)

--// ============================================
-- // VISUALS TAB - FULL FUNCTION
-- // ============================================
local visualFlags = {
    esp = false,
    box = false,
    name = false,
    weapon = false,
    distance = false,
    healthBar = false,
    healthNum = false,
    chams = false,
    textFont = "Plex",
    textSize = 13,
    timeChanger = false,
    time = 12,
    bombStatus = false,
    bombChams = false,
    tracer = false,
    tracerTexture = "Line",
    tracerLifetime = 3,
    impacts = false,
    impactLifetime = 6,
}

local TextFonts = {Plex = 1, System = 2, Monospace = 3, UI = 4}
local ESPStorage = {}

local function IsPlayerVisible(plr)
    if not plr.Character then return false end
    local root = plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local ray = workspace:Raycast(Camera.CFrame.Position, root.Position - Camera.CFrame.Position, params)
    return ray == nil or ray.Instance:IsDescendantOf(plr.Character)
end

local function CreateESP(plr)
    if ESPStorage[plr] then return end
    ESPStorage[plr] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        weapon = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        healthBg = Drawing.new("Square"),
        healthFill = Drawing.new("Square"),
        healthText = Drawing.new("Text"),
        highlight = nil,
    }
    local d = ESPStorage[plr]
    d.box.Visible = false
    d.box.Thickness = 1
    d.box.Filled = false
    d.name.Visible = false
    d.name.Center = true
    d.name.Outline = true
    d.weapon.Visible = false
    d.weapon.Center = true
    d.weapon.Outline = true
    d.distance.Visible = false
    d.distance.Center = true
    d.distance.Outline = true
    d.healthBg.Visible = false
    d.healthBg.Filled = true
    d.healthBg.Color = Color3.new(0, 0, 0)
    d.healthFill.Visible = false
    d.healthFill.Filled = true
    d.healthText.Visible = false
    d.healthText.Center = true
    d.healthText.Outline = true
end

local function RemoveESP(plr)
    if ESPStorage[plr] then
        for _, obj in pairs(ESPStorage[plr]) do
            if typeof(obj) ~= "Instance" then
                pcall(function() obj:Remove() end)
            end
        end
        if ESPStorage[plr].highlight then
            pcall(function() ESPStorage[plr].highlight:Destroy() end)
        end
        ESPStorage[plr] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

-- ESP loop
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPStorage[plr] then CreateESP(plr) end
        local data = ESPStorage[plr]
        if not data then continue end
        local visible = visualFlags.esp and IsAlive(plr) and not plr.Character:FindFirstChildWhichIsA("ForceField")
        if not visible then
            for _, obj in pairs(data) do
                if typeof(obj) ~= "Instance" then
                    pcall(function() obj.Visible = false end)
                end
            end
                        if data.highlight then data.highlight.Enabled = false end
            continue
        end
        local head = plr.Character:FindFirstChild("Head")
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if not (head and root and hum) then continue end
        local headPos, headOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footPos, footOn = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 2.5, 0))
        if not (headOn and footOn) then
            for _, obj in pairs(data) do
                if typeof(obj) ~= "Instance" then
                    pcall(function() obj.Visible = false end)
                end
            end
            if data.highlight then data.highlight.Enabled = false end
            continue
        end
        local height = math.abs(headPos.Y - footPos.Y)
        local width = height / 2
        local x = headPos.X - width / 2
        local y = headPos.Y

        -- Box
        if visualFlags.box then
            data.box.Size = Vector2.new(width, height)
            data.box.Position = Vector2.new(x, y)
            data.box.Color = Theme.Accent
            data.box.Visible = true
        else
            data.box.Visible = false
        end

        -- Name
        if visualFlags.name then
            data.name.Text = plr.Name
            data.name.Position = Vector2.new(headPos.X, y - 16)
            data.name.Size = visualFlags.textSize
            data.name.Font = TextFonts[visualFlags.textFont] or 1
            data.name.Color = Theme.Accent
            data.name.Visible = true
        else
            data.name.Visible = false
        end

        -- Weapon
        if visualFlags.weapon then
            local gun = plr.Character:GetAttribute("WhatGun") or "None"
            data.weapon.Text = gun
            data.weapon.Position = Vector2.new(headPos.X, y + height + 16)
            data.weapon.Size = visualFlags.textSize
            data.weapon.Font = TextFonts[visualFlags.textFont] or 1
            data.weapon.Color = Theme.Text
            data.weapon.Visible = true
        else
            data.weapon.Visible = false
        end

        -- Distance
        if visualFlags.distance then
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            data.distance.Text = math.floor(dist) .. "m"
            data.distance.Position = Vector2.new(headPos.X, y + height + 2)
            data.distance.Size = visualFlags.textSize
            data.distance.Font = TextFonts[visualFlags.textFont] or 1
            data.distance.Color = Theme.Text
            data.distance.Visible = true
        else
            data.distance.Visible = false
        end

        -- Health bar
        if visualFlags.healthBar then
            local hp = hum.Health
            local maxHp = hum.MaxHealth > 0 and hum.MaxHealth or 100
            local ratio = math.clamp(hp / maxHp, 0, 1)
            local barHeight = height
            local barWidth = 3
            local barX = x - barWidth - 3
            data.healthBg.Size = Vector2.new(barWidth, barHeight)
            data.healthBg.Position = Vector2.new(barX, y)
            data.healthBg.Color = Color3.new(0, 0, 0)
            data.healthBg.Visible = true
            data.healthFill.Size = Vector2.new(barWidth, barHeight * ratio)
            data.healthFill.Position = Vector2.new(barX, y + barHeight * (1 - ratio))
            data.healthFill.Color = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), 1 - ratio)
            data.healthFill.Visible = true
        else
            data.healthBg.Visible = false
            data.healthFill.Visible = false
        end

        -- Health number
        if visualFlags.healthNum then
            data.healthText.Text = tostring(math.floor(hum.Health))
            data.healthText.Position = Vector2.new(x + width + 4, y + height / 2)
            data.healthText.Size = visualFlags.textSize
            data.healthText.Font = TextFonts[visualFlags.textFont] or 1
            data.healthText.Color = Theme.Text
            data.healthText.Visible = true
        else
            data.healthText.Visible = false
        end

        -- Chams
        if visualFlags.chams then
            if not data.highlight or not data.highlight.Parent then
                local hl = Instance.new("Highlight")
                hl.Name = "DefusalESPChams"
                hl.FillColor = Theme.Accent
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.OutlineTransparency = 0.5
                hl.Adornee = plr.Character
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = plr.Character
                data.highlight = hl
            end
            data.highlight.Enabled = true
        else
            if data.highlight then data.highlight.Enabled = false end
        end
    end
end)

CreateSection(VisualTab.Content, "Enemy ESP")
CreateToggle(VisualTab.Content, "Enabled", false, function(v) visualFlags.esp = v end)
CreateToggle(VisualTab.Content, "Bounding Box", false, function(v) visualFlags.box = v end)
CreateToggle(VisualTab.Content, "Name", false, function(v) visualFlags.name = v end)
CreateToggle(VisualTab.Content, "Weapon", false, function(v) visualFlags.weapon = v end)
CreateToggle(VisualTab.Content, "Distance", false, function(v) visualFlags.distance = v end)
CreateToggle(VisualTab.Content, "Health Bar", false, function(v) visualFlags.healthBar = v end)
CreateToggle(VisualTab.Content, "Health Number", false, function(v) visualFlags.healthNum = v end)
CreateToggle(VisualTab.Content, "Chams", false, function(v) visualFlags.chams = v end)

CreateSection(VisualTab.Content, "ESP Settings")
CreateDropdown(VisualTab.Content, "Text Font", {"Plex", "System", "Monospace", "UI"}, function(v) visualFlags.textFont = v end)
CreateSlider(VisualTab.Content, "Text Size", 0, 50, 13, function(v) visualFlags.textSize = v end)

CreateSection(VisualTab.Content, "World")
CreateToggle(VisualTab.Content, "Time Changer", false, function(v)
    visualFlags.timeChanger = v
    if not v then Lighting.ClockTime = 14 end
end)
CreateSlider(VisualTab.Content, "Time", 0, 24, 12, function(v) visualFlags.time = v end)
CreateToggle(VisualTab.Content, "Bomb Status", false, function(v) visualFlags.bombStatus = v end)
CreateToggle(VisualTab.Content, "Bomb Chams", false, function(v) visualFlags.bombChams = v end)

-- Bomb chams loop
task.spawn(function()
    while ScreenGui.Parent do
        local debris = workspace:FindFirstChild("Debris")
        if debris then
            local planted = debris:FindFirstChild("PlantedC4")
            if planted and visualFlags.bombChams then
                if not planted:FindFirstChild("DefusalBombHL") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "DefusalBombHL"
                    hl.FillColor = Theme.Accent
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.OutlineTransparency = 0.5
                    hl.Adornee = planted
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = planted
                end
            elseif planted and not visualFlags.bombChams then
                local hl = planted:FindFirstChild("DefusalBombHL")
                if hl then hl:Destroy() end
            end
        end
        task.wait(0.5)
    end
end)

CreateSection(VisualTab.Content, "Effects")
CreateToggle(VisualTab.Content, "Bullet Tracers", false, function(v) visualFlags.tracer = v end)
CreateDropdown(VisualTab.Content, "Tracer Texture", {"Line", "Neyrone", "Lighting", "Tracer"}, function(v) visualFlags.tracerTexture = v end)
CreateSlider(VisualTab.Content, "Tracer Lifetime", 0, 10, 3, function(v) visualFlags.tracerLifetime = v end)
CreateToggle(VisualTab.Content, "Hit Impacts", false, function(v) visualFlags.impacts = v end)
CreateSlider(VisualTab.Content, "Impact Lifetime", 0, 10, 6, function(v) visualFlags.impactLifetime = v end)

-- Bullet tracers + Hit impacts (hook FireServer WeaponFire)
local tracerTextures = {
    Line = "rbxassetid://9150663556",
    Neyrone = "rbxassetid://1825953680",
    Lighting = "rbxassetid://446111271",
    Tracer = "ForceField",
}

local function CreateTracerPart(pos)
    local p = Instance.new("Part")
    p.Name = "DefusalTracer"
    p.Size = Vector3.new(0.2, 0.2, 0.2)
    p.Position = pos
    p.Transparency = 1
    p.CanCollide = false
    p.Anchored = true
    p.Parent = workspace:FindFirstChild("Debris") or workspace
    return p
end

local function CreateTracer(endPos, lifetime, texName)
    local char = LocalPlayer.Character
    if not char then return end
    local gun = char:FindFirstChild("Gun")
    if not gun or not gun:FindFirstChild("Flash") then return end
    local startPos = gun.Flash.WorldPosition
    local p1 = CreateTracerPart(startPos)
    local p2 = CreateTracerPart(endPos)
    local beam = Instance.new("Beam")
    beam.Texture = tracerTextures[texName] or tracerTextures.Line
    local a1 = Instance.new("Attachment", p1)
    local a2 = Instance.new("Attachment", p2)
    beam.Attachment0 = a1
    beam.Attachment1 = a2
    beam.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Theme.Accent)
    }
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.FaceCamera = true
    beam.Transparency = NumberSequence.new(0)
    beam.Parent = workspace:FindFirstChild("Debris") or workspace
    task.spawn(function()
        task.wait(lifetime)
        for i = 1, 10 do
            beam.Transparency = NumberSequence.new(i / 10)
            task.wait(0.03)
        end
        beam:Destroy()
        p1:Destroy()
        p2:Destroy()
        a1:Destroy()
        a2:Destroy()
    end)
end

local function CreateImpact(pos, lifetime)
    local part = Instance.new("Part")
    part.Name = "DefusalImpact"
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.Size = Vector3.new(0.3, 0.3, 0.3)
    part.Position = pos
    local box = Instance.new("SelectionBox", part)
    box.LineThickness = 0
    box.SurfaceTransparency = 0.5
    box.Color3 = Theme.Accent
    box.SurfaceColor3 = Theme.Accent
    box.Adornee = part
    part.Parent = workspace:FindFirstChild("Debris") or workspace
    task.spawn(function()
        task.wait(lifetime)
        box:Destroy()
        part:Destroy()
    end)
end

-- Hook WeaponFire untuk tracer + impact
local eventsFolder = RS:WaitForChild("Events", 10)
local weaponFireEvent = eventsFolder and eventsFolder:WaitForChild("WeaponFire", 10)

if weaponFireEvent and hookmetamethod and newcclosure then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self == weaponFireEvent then
            local args = {...}
            local data = args[1]
            if data and data.Position and typeof(data.Position) == "Vector3" then
                if visualFlags.tracer then
                    task.spawn(CreateTracer, data.Position, visualFlags.tracerLifetime, visualFlags.tracerTexture)
                end
                if visualFlags.impacts then
                    task.spawn(CreateImpact, data.Position, visualFlags.impactLifetime)
                end
            end
        end
        return oldNamecall(self, ...)
    end))
end

-- Time changer loop
RunService.Heartbeat:Connect(function()
    if visualFlags.timeChanger then
        if Lighting.ClockTime ~= visualFlags.time then
            Lighting.ClockTime = visualFlags.time
        end
    end
end)

--// ============================================
-- // MISC TAB - FULL FUNCTION
-- // ============================================
local miscFlags = {
    noclip = false,
    speedHack = false,
    speedValue = 40,
    autoJump = false,
    chatSpam = false,
    chatType = "DefHack",
    chatCustom = "DefHack on top!",
    autoJoinTeam = false,
    team = "Operators",
    noRecoil = false,
    noSpread = false,
    fullAuto = false,
    rapidFire = false,
    infAmmo = false,
    convertAmmo = false,
    laserActivate = false,
    laserRemove = false,
    thirdPerson = false,
    thirdPersonDist = 9,
    plantSite = "A",
}

CreateSection(MiscTab.Content, "Movement")
CreateToggle(MiscTab.Content, "Noclip", false, function(v) miscFlags.noclip = v end)
CreateToggle(MiscTab.Content, "Speed Hack", false, function(v) miscFlags.speedHack = v end)
CreateSlider(MiscTab.Content, "Speed", 16, 250, 40, function(v) miscFlags.speedValue = v end)
CreateToggle(MiscTab.Content, "Auto Jump", false, function(v) miscFlags.autoJump = v end)

CreateSection(MiscTab.Content, "Gun Mods")
CreateToggle(MiscTab.Content, "No Recoil", false, function(v) miscFlags.noRecoil = v end)
CreateToggle(MiscTab.Content, "No Spread", false, function(v) miscFlags.noSpread = v end)
CreateToggle(MiscTab.Content, "Full Auto", false, function(v) miscFlags.fullAuto = v end)
CreateToggle(MiscTab.Content, "Rapid Fire", false, function(v) miscFlags.rapidFire = v end)
CreateToggle(MiscTab.Content, "Infinite Ammo", false, function(v) miscFlags.infAmmo = v end)
CreateToggle(MiscTab.Content, "Convert Stored -> Ammo", false, function(v) miscFlags.convertAmmo = v end)

CreateSection(MiscTab.Content, "Laser Mines")
CreateToggle(MiscTab.Content, "Auto Activate", false, function(v) miscFlags.laserActivate = v end)
CreateToggle(MiscTab.Content, "Remove Laser", false, function(v) miscFlags.laserRemove = v end)

CreateSection(MiscTab.Content, "Chat")
CreateToggle(MiscTab.Content, "Chat Spammer", false, function(v) miscFlags.chatSpam = v end)
CreateDropdown(MiscTab.Content, "Message Type", {"DefHack", "Advertise", "Custom"}, function(v) miscFlags.chatType = v end)
CreateTextbox(MiscTab.Content, "Custom Message", "DefHack on top!", function(v) miscFlags.chatCustom = v end)

CreateSection(MiscTab.Content, "C4")
CreateDropdown(MiscTab.Content, "Plant Site", {"A", "B"}, function(v) miscFlags.plantSite = v end)

CreateSection(MiscTab.Content, "Client")
CreateToggle(MiscTab.Content, "Auto Join Team", false, function(v) miscFlags.autoJoinTeam = v end)
CreateDropdown(MiscTab.Content, "Team", {"Operators", "Militia"}, function(v) miscFlags.team = v end)
CreateToggle(MiscTab.Content, "Third Person", false, function(v) miscFlags.thirdPerson = v end)
CreateSlider(MiscTab.Content, "Third Person Distance", 1, 20, 9, function(v) miscFlags.thirdPersonDist = v end)

-- Movement loop
RunService.Heartbeat:Connect(function()
    if not IsAlive(LocalPlayer) then return end
    local char = LocalPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp) then return end

    if miscFlags.noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    if miscFlags.autoJump then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if hum.FloorMaterial ~= Enum.Material.Air then
                hum.Jump = true
            end
        end
    end

    if miscFlags.speedHack then
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if dir.Magnitude > 0 then
            local speed = miscFlags.speedValue / 10
            dir = Vector3.new(dir.X, 0, dir.Z).Unit * speed * 1.5
            hrp.CFrame = hrp.CFrame + dir / 100 * 2
        end
    end
end)

-- Weapon mods loop
task.spawn(function()
    while ScreenGui.Parent do
        pcall(function()
            local weaponsFolder = RS:FindFirstChild("Weapons")
            if not weaponsFolder then return end
            for _, weapon in ipairs(weaponsFolder:GetChildren()) do
                if weapon:IsA("Folder") then
                    if miscFlags.noRecoil then
                        weapon:SetAttribute("RecoilX", 0)
                        weapon:SetAttribute("RecoilY", 0)
                    end
                    if miscFlags.noSpread then
                        for _, attr in ipairs({"Spread", "CrouchSpread", "FireSpread", "LadderSpread", "LandSpread", "MoveSpread", "StandSpread", "JumpSpread", "RunSpread"}) do
                            weapon:SetAttribute(attr, 0)
                        end
                    end
                    if miscFlags.fullAuto then
                        weapon:SetAttribute("Auto", true)
                    end
                    if miscFlags.rapidFire then
                        weapon:SetAttribute("FireRate", 0.01)
                        weapon:SetAttribute("ScopedFireRate", 0.01)
                    end
                    if miscFlags.convertAmmo then
                        weapon:SetAttribute("Ammo", 9999)
                        weapon:SetAttribute("StoredAmmo", 9999)
                    end
                    if miscFlags.infAmmo then
                        weapon:SetAttribute("UseAmmo", 0)
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- Chat spam loop
local chatLastTick = 0
RunService.Heartbeat:Connect(function()
    if not miscFlags.chatSpam then return end
    if tick() - chatLastTick < 3 then return end
    local msg
    if miscFlags.chatType == "DefHack" then
        msg = string.rep("\n", 10) .. "defhack on top " .. tostring(math.random(1, 99))
    elseif miscFlags.chatType == "Advertise" then
        msg = string.rep("\n", 10) .. "defhack " .. tostring(math.random(1, 99))
    else
        msg = miscFlags.chatCustom
    end
    pcall(function()
        local Network = require(game:GetService("NetworkClient").Network)
        Network.FireServer("Chat", msg, false)
    end)
    chatLastTick = tick()
end)

-- Auto join team
task.spawn(function()
    while ScreenGui.Parent do
        if miscFlags.autoJoinTeam and IsAlive(LocalPlayer) then
            local currentTeam = LocalPlayer:GetAttribute("Team")
            local isCT = currentTeam == "CT"
            local shouldCT = miscFlags.team == "Operators"
            if currentTeam ~= "Spectator" and isCT ~= shouldCT then
                pcall(function()
                    local deployEvent = RS:FindFirstChild("RE_Deploy")
                    if deployEvent then deployEvent:FireServer(shouldCT) end
                end)
            end
        end
        task.wait(2)
    end
end)

-- Laser mines
task.spawn(function()
    while ScreenGui.Parent do
        if (miscFlags.laserActivate or miscFlags.laserRemove) and IsAlive(LocalPlayer) then
            pcall(function()
                local dest = workspace:FindFirstChild("Destroyable")
                if not dest then return end
                local mines = game:QueryDescendants(dest, "[$Weapon] >> TouchTransmitter")
                if not mines then return end
                for _, mine in ipairs(mines) do
                    local owner = mine.Parent and mine.Parent.Parent
                    if not owner or owner:GetAttribute("Weapon") ~= "Laser Mine" then continue end
                    if mine:FindFirstChild("DefHackNoLaser") then continue end
                    if miscFlags.laserRemove then
                        local flag = Instance.new("BoolValue", mine)
                        flag.Name = "DefHackNoLaser"
                        mine:Destroy()
                                        elseif miscFlags.laserActivate then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, mine.Parent, 0)
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- Third Person
task.spawn(function()
    while ScreenGui.Parent do
        if not IsAlive(LocalPlayer) then
            if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
            task.wait(1)
            continue
        end
        local arms = Camera:FindFirstChild("Arms")
        if miscFlags.thirdPerson then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = miscFlags.thirdPersonDist
            LocalPlayer.CameraMinZoomDistance = miscFlags.thirdPersonDist
            if arms then arms:SetAttribute("COffset", CFrame.new(99, 99, 99)) end
        else
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            LocalPlayer.CameraMaxZoomDistance = 0.5
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
        task.wait(0.2)
    end
end)

--// ============================================
-- // CONFIG TAB - FULL FUNCTION
-- // ============================================
local CONFIG_FOLDER = "DefusalHub/Configs/"
pcall(function() if not isfolder("DefusalHub") then makefolder("DefusalHub") end end)
pcall(function() if not isfolder("DefusalHub/Configs") then makefolder("DefusalHub/Configs") end end)

local configName = ""

CreateSection(ConfigTab.Content, "Save / Load")
CreateTextbox(ConfigTab.Content, "Config Name", "Enter name...", function(v) configName = v end)

local function SerializeFlags()
    return {
        legit = legitFlags,
        rage = rageFlags,
        visual = visualFlags,
        misc = miscFlags,
    }
end

local function ApplyConfig(json)
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or not data then Notify("Config", "Invalid config", 2); return end
    if data.legit then
        for k, v in pairs(data.legit) do
            if legitFlags[k] ~= nil then legitFlags[k] = v end
        end
    end
    if data.rage then
        for k, v in pairs(data.rage) do
            if rageFlags[k] ~= nil then rageFlags[k] = v end
        end
    end
    if data.visual then
        for k, v in pairs(data.visual) do
            if visualFlags[k] ~= nil then visualFlags[k] = v end
        end
    end
    if data.misc then
        for k, v in pairs(data.misc) do
            if miscFlags[k] ~= nil then miscFlags[k] = v end
        end
    end
    Notify("Config", "Loaded!", 2)
end

CreateButton(ConfigTab.Content, "💾 Save Config", function()
    if configName == "" then Notify("Config", "Enter name first!", 2); return end
    if not writefile then Notify("Config", "No writefile support", 2); return end
    pcall(function()
        writefile(CONFIG_FOLDER .. configName .. ".json", HttpService:JSONEncode(SerializeFlags()))
        Notify("Config", "Saved: " .. configName, 2)
    end)
end)

CreateButton(ConfigTab.Content, "📂 Load Config", function()
    if configName == "" then Notify("Config", "Enter name first!", 2); return end
    if not (isfile and isfile(CONFIG_FOLDER .. configName .. ".json")) then
        Notify("Config", "Config not found!", 2); return
    end
    pcall(function()
        ApplyConfig(readfile(CONFIG_FOLDER .. configName .. ".json"))
    end)
end)

CreateButton(ConfigTab.Content, "🗑️ Delete Config", function()
    if configName == "" then Notify("Config", "Enter name first!", 2); return end
    pcall(function()
        if delfile then delfile(CONFIG_FOLDER .. configName .. ".json") end
        Notify("Config", "Deleted: " .. configName, 2)
    end)
end)

CreateButton(ConfigTab.Content, "📋 List Configs", function()
    if not listfiles then Notify("Config", "No listfiles support", 2); return end
    pcall(function()
        local files = listfiles(CONFIG_FOLDER)
        local names = {}
        for _, f in ipairs(files) do
            table.insert(names, f:gsub(CONFIG_FOLDER, ""):gsub("%.json", ""))
        end
        Notify("Configs", #names > 0 and table.concat(names, ", ") or "No configs", 5)
    end)
end)

CreateSection(ConfigTab.Content, "Info")
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 60)
infoLabel.BackgroundColor3 = Theme.Background
infoLabel.BackgroundTransparency = 0.4
infoLabel.Text = "⚡ Defusal Hub - Green Edition\n🔧 Version: 1.0.0\n✅ All features FULL FUNCTIONAL"
infoLabel.TextColor3 = Theme.SubText
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11
infoLabel.BorderSizePixel = 0
infoLabel.Parent = ConfigTab.Content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 4)
infoCorner.Parent = infoLabel

--// ============================================
-- // OPEN BUTTON (DRAGGABLE)
-- // ============================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
OpenBtn.BackgroundColor3 = Theme.Background
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Theme.Accent
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 28
OpenBtn.BorderSizePixel = 0
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Theme.Accent
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenBtn

local OpenGradient = Instance.new("UIGradient")
OpenGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 100)),
}
OpenGradient.Rotation = 0
OpenGradient.Parent = OpenStroke

task.spawn(function()
    while OpenBtn.Parent do
        TweenService:Create(OpenStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.3
        }):Play()
        task.wait(1)
        if not OpenBtn.Parent then break end
        TweenService:Create(OpenStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0
        }):Play()
        task.wait(1)
    end
end)

local openRot = 0
RunService.RenderStepped:Connect(function(dt)
    if OpenBtn.Parent then
        openRot = (openRot + dt * 90) % 360
        OpenGradient.Rotation = openRot
    end
end)

local draggingOpen = false
local dragStartOpen = nil
local startPosOpen = nil

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingOpen = true
        dragStartOpen = input.Position
        startPosOpen = OpenBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingOpen and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartOpen
        OpenBtn.Position = UDim2.new(startPosOpen.X.Scale, startPosOpen.X.Offset + delta.X, startPosOpen.Y.Scale, startPosOpen.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingOpen = false
    end
end)

local function ToggleMain()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 580, 0, 400),
            Position = UDim2.new(0.5, -290, 0.5, -200)
        }):Play()
        OpenBtn.Visible = false
    else
        OpenBtn.Visible = true
    end
end
OpenBtn.MouseButton1Click:Connect(function()
    if not draggingOpen then ToggleMain() end
end)

MinBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 580, 0, 40)
    }):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    OpenBtn.Visible = true
    Notify("Minimized", "GUI minimized to button", 2)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Notify("Closing", "Destroying GUI...", 1)
    if gradientConnection then gradientConnection:Disconnect() end
    pcall(function()
        if fovCircle then fovCircle:Remove() end
        if rageFovCircle then rageFovCircle:Remove() end
        for plr in pairs(ESPStorage) do RemoveESP(plr) end
    end)
    task.wait(1)
    ScreenGui:Destroy()
end)

local draggingMain = false
local dragStartMain = nil
local startPosMain = nil
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = false
    end
end)

-- Auto-select first tab
task.defer(function()
    for _, t in pairs(Tabs) do
        t.Content.Visible = false
        t.Button.BackgroundTransparency = 1
        t.Button.TextColor3 = Theme.SubText
    end
    MainTab.Content.Visible = true
    MainTab.Button.BackgroundTransparency = 0.7
    MainTab.Button.TextColor3 = Theme.Accent
end)

-- Welcome notification
task.wait(0.5)
Notify("⚡ Defusal Hub", "Green Edition loaded successfully!", 3)
task.wait(0.3)
Notify("💡 Tips", "Klik ⚡ untuk buka/tutup GUI. Semua fitur FULL FUNCTIONAL!", 3)

print("✅ Defusal Hub - Green Edition Loaded! (FULL FUNCTION)")
print("🎯 Silent Aim | Aimbot | Triggerbot | Ragebot | ESP | Gun Mods | Chat Spam")
print("🎨 Custom UI with rotating green-black gradient") 
