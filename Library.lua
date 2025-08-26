-- Aether UI Library
-- By Avi
-- Version 1.0

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

Library.Themes = {
    Default = {
        MainColor = Color3.fromRGB(85, 170, 255),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(15, 15, 20),
        TextColor = Color3.fromRGB(220, 220, 220),
        ButtonColor = Color3.fromRGB(40, 40, 50),
        ButtonHover = Color3.fromRGB(50, 50, 60),
        ToggleOff = Color3.fromRGB(60, 60, 70),
        ToggleOn = Color3.fromRGB(85, 170, 255),
        Dropdown = Color3.fromRGB(40, 40, 50),
        DropdownHover = Color3.fromRGB(50, 50, 60),
        TextBox = Color3.fromRGB(40, 40, 50),
        Folder = Color3.fromRGB(35, 35, 45),
        Separator = Color3.fromRGB(50, 50, 50),
        Notification = Color3.fromRGB(25, 25, 35),
        NotificationStroke = Color3.fromRGB(150, 90, 255)
    }
}

function Library:CreateWindow(title, options)
    options = options or {}
    local mainColor = options.main_color or self.Themes.Default.MainColor
    local windowSize = options.main_size or UDim2.new(0, 600, 0, 400)
    
    local window = setmetatable({
        MainColor = mainColor,
        Tabs = {},
        CurrentTab = nil,
        Elements = {},
        Notifications = {}
    }, self)
    
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local corner = Instance.new("UICorner")

    screenGui.Name = "AetherUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.BackgroundColor3 = self.Themes.Default.Background
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = true

    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = self.Themes.Default.Header
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = self.Themes.Default.TextColor
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = titleBar

    local close = Instance.new("ImageButton")
    close.Name = "Close"
    close.Parent = titleBar
    close.BackgroundTransparency = 1
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -10, 0.5, 0)
    close.Size = UDim2.new(0, 20, 0, 20)
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.ImageColor3 = Color3.fromRGB(200, 200, 200)

    close.MouseEnter:Connect(function()
        close.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end)

    close.MouseLeave:Connect(function()
        close.ImageColor3 = Color3.fromRGB(200, 200, 200)
    end)

    close.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Wait()
        mainFrame:Destroy()
    end)

    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(1, -16, 0, 1)
    Separator.Position = UDim2.new(0, 8, 0, 30)
    Separator.BackgroundColor3 = self.Themes.Default.Separator
    Separator.BackgroundTransparency = 0
    Separator.BorderSizePixel = 0
    Separator.Parent = mainFrame

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -16, 0, 30)
    tabContainer.Position = UDim2.new(0, 8, 0, 31)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local tabIndicator = Instance.new("Frame")
    tabIndicator.Size = UDim2.new(0, 80, 0, 2)
    tabIndicator.Position = UDim2.new(0, 0, 1, 0)
    tabIndicator.BackgroundColor3 = mainColor
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Parent = tabContainer

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -16, 1, -80)
    contentArea.Position = UDim2.new(0, 8, 0, 65)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    window.Gui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.TabIndicator = tabIndicator
    window.ContentArea = contentArea
    
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, -16, 0, 30)
    footer.Position = UDim2.new(0, 8, 1, -35)
    footer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    footer.BorderSizePixel = 0
    footer.Parent = mainFrame

    local footerCorner = Instance.new("UICorner")
    footerCorner.CornerRadius = UDim.new(0, 4)
    footerCorner.Parent = footer

    local userThumbnail = Instance.new("ImageLabel")
    userThumbnail.Size = UDim2.new(0, 20, 0, 20)
    userThumbnail.Position = UDim2.new(0, 5, 0.5, -10)
    userThumbnail.BackgroundTransparency = 1

    local thumb = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
    userThumbnail.Image = thumb
    userThumbnail.Parent = footer

    local userName = Instance.new("TextLabel")
    userName.Size = UDim2.new(0, 200, 1, 0)
    userName.Position = UDim2.new(0, 30, 0, 0)
    userName.BackgroundTransparency = 1
    userName.Text = player.Name
    userName.TextColor3 = self.Themes.Default.TextColor
    userName.TextSize = 14
    userName.Font = Enum.Font.GothamBold
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = footer
    
    return window
end

function Library:AddTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 1, 0)
    tabButton.Position = UDim2.new(0, (#self.Tabs)*80, 0, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = self.TabContainer
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
    tabContent.Visible = (#self.Tabs == 0)
    tabContent.Parent = self.ContentArea
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 8)
    uiListLayout.Parent = tabContent
    
    local tab = {
        Name = name,
        Button = tabButton,
        Content = tabContent,
        Elements = {}
    }
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self.CurrentTab = tab
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    tabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        tabContent.Visible = true
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local tween = TweenService:Create(self.TabIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, (tabButton.Position.X.Scale)*80, 1, 0)
        })
        tween:Play()
        
        self.CurrentTab = tab
    end)
    
    return tab
end

function Library:AddLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Themes.Default.TextColor
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Content
    
    table.insert(tab.Elements, label)
    return label
end

function Library:AddButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = self.Themes.Default.ButtonColor
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = self.Themes.Default.TextColor
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = self.Themes.Default.ButtonHover
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = self.Themes.Default.ButtonColor
        })
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    table.insert(tab.Elements, button)
    return button
end

function Library:AddToggle(tab, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 25)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tab.Content
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 22)
    toggleButton.Position = UDim2.new(1, -45, 0, 0)
    toggleButton.BackgroundColor3 = self.Themes.Default.ToggleOff
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 11)
    toggleCorner.Parent = toggleButton
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 18, 0, 18)
    toggleDot.Position = UDim2.new(0, 2, 0, 2)
    toggleDot.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleButton
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 9)
    dotCorner.Parent = toggleDot
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -55, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = self.Themes.Default.TextColor
    toggleLabel.TextSize = 14
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local isToggled = default or false
    
    local function updateToggle()
        if isToggled then
            local tween = TweenService:Create(toggleDot, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 25, 0, 2),
                BackgroundColor3 = self.MainColor
            })
            tween:Play()
            toggleButton.BackgroundColor3 = Color3.fromRGB(
                self.MainColor.R * 255 * 0.3,
                self.MainColor.G * 255 * 0.3,
                self.MainColor.B * 255 * 0.3
            )
        else
            local tween = TweenService:Create(toggleDot, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            })
            tween:Play()
            toggleButton.BackgroundColor3 = self.Themes.Default.ToggleOff
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        if callback then callback(isToggled) end
    end)
    
    updateToggle()
    
    local toggle = {
        Set = function(self, value)
            isToggled = value
            updateToggle()
        end,
        Get = function(self)
            return isToggled
        end
    }
    
    table.insert(tab.Elements, toggleFrame)
    return toggle
end

function Library:AddTextBox(tab, placeholder, callback)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Size = UDim2.new(1, 0, 0, 30)
    textBoxFrame.BackgroundColor3 = self.Themes.Default.TextBox
    textBoxFrame.BorderSizePixel = 0
    textBoxFrame.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = textBoxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 1, 0)
    textBox.Position = UDim2.new(0, 5, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = self.Themes.Default.TextColor
    textBox.TextSize = 14
    textBox.Font = Enum.Font.GothamBold
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = textBoxFrame
    
    textBox.FocusLost:Connect(function()
        if callback then callback(textBox.Text) end
    end)
    
    table.insert(tab.Elements, textBoxFrame)
    return textBox
end

function Library:AddKeybind(tab, text, default, callback)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Size = UDim2.new(1, 0, 0, 20)
    keybindFrame.BackgroundTransparency = 1
    keybindFrame.Parent = tab.Content
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = UDim2.new(0, 60, 0, 20)
    keybindButton.Position = UDim2.new(1, -60, 0, 0)
    keybindButton.BackgroundColor3 = self.Themes.Default.ButtonColor
    keybindButton.BorderSizePixel = 0
    keybindButton.Text = tostring(default or Enum.KeyCode.F):gsub("Enum.KeyCode.", "")
    keybindButton.TextColor3 = self.Themes.Default.TextColor
    keybindButton.TextSize = 14
    keybindButton.Font = Enum.Font.GothamBold
    keybindButton.Parent = keybindFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = keybindButton
    
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Size = UDim2.new(1, -70, 1, 0)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = text
    keybindLabel.TextColor3 = self.Themes.Default.TextColor
    keybindLabel.TextSize = 14
    keybindLabel.Font = Enum.Font.GothamBold
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    keybindLabel.Parent = keybindFrame
    
    local listening = false
    local currentKey = default or Enum.KeyCode.F
    
    keybindButton.MouseButton1Click:Connect(function()
        listening = true
        keybindButton.Text = "..."
        keybindButton.BackgroundColor3 = self.Themes.Default.ButtonHover
    end)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keybindButton.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                listening = false
                keybindButton.BackgroundColor3 = self.Themes.Default.ButtonColor
                if callback then callback(input.KeyCode) end
            end
        end
    end)
    
    local keybind = {
        Set = function(self, key)
            currentKey = key
            keybindButton.Text = tostring(key):gsub("Enum.KeyCode.", "")
        end,
        Get = function(self)
            return currentKey
        end
    }
    
    table.insert(tab.Elements, keybindFrame)
    return keybind
end

function Library:AddDropdown(tab, text, options, default, callback)
    local BTN_H = 30
    local ITEM_H = 25
    local PAD = 2

    local function calcTotalHeight()
        if #options == 0 then return 0 end
        return (#options * ITEM_H) + ((#options - 1) * PAD)
    end

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, BTN_H)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.ZIndex = 20
    dropdownFrame.Parent = tab.Content

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 0, BTN_H)
    dropdownButton.BackgroundColor3 = self.Themes.Default.Dropdown
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = text .. ": " .. (default or options[1])
    dropdownButton.TextColor3 = self.Themes.Default.TextColor
    dropdownButton.TextSize = 14
    dropdownButton.Font = Enum.Font.GothamBold
    dropdownButton.ZIndex = 21
    dropdownButton.Parent = dropdownFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = dropdownButton

    local arrowFrame = Instance.new("Frame")
    arrowFrame.Size = UDim2.new(0, 12, 0, 12)
    arrowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    arrowFrame.Position = UDim2.new(1, -20, 0.5, 0)
    arrowFrame.BackgroundTransparency = 1
    arrowFrame.ZIndex = 22
    arrowFrame.Parent = dropdownButton

    local line1 = Instance.new("Frame")
    line1.Size = UDim2.new(1, 0, 0, 2)
    line1.Position = UDim2.new(0, 0, 0.35, 0)
    line1.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    line1.BorderSizePixel = 0
    line1.Rotation = 45
    line1.ZIndex = 22
    line1.Parent = arrowFrame

    local line2 = line1:Clone()
    line2.Rotation = -45
    line2.Parent = arrowFrame

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 0, BTN_H)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ClipsDescendants = true
    optionsFrame.ZIndex = 22
    optionsFrame.Parent = dropdownFrame

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4)
    optionsCorner.Parent = optionsFrame

    local optionsList = Instance.new("UIListLayout")
    optionsList.Padding = UDim.new(0, PAD)
    optionsList.Parent = optionsFrame

    local isOpen = false
    local selectedOption = default or options[1]

    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, ITEM_H)
        optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = self.Themes.Default.TextColor
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.GothamBold
        optionButton.ZIndex = 23
        optionButton.Parent = optionsFrame

        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownButton.Text = text .. ": " .. option
            isOpen = false

            local closeH = 0
            TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, closeH)
            }):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, BTN_H)
            }):Play()
            TweenService:Create(arrowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 0
            }):Play()

            if callback then
                task.spawn(callback, option)
            end
        end)
    end

    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetOptionsH = isOpen and calcTotalHeight() or 0
        local targetDropdownH = isOpen and (BTN_H + targetOptionsH) or BTN_H
        local targetArrowRot = isOpen and 180 or 0

        TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, targetOptionsH)
        }):Play()
        TweenService:Create(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, targetDropdownH)
        }):Play()
        TweenService:Create(arrowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = targetArrowRot
        }):Play()
    end)

    local dropdown = {
        Set = function(_, option)
            selectedOption = option
            dropdownButton.Text = text .. ": " .. option
        end,
        Get = function() return selectedOption end
    }
    
    table.insert(tab.Elements, dropdownFrame)
    return dropdown
end

function Library:AddFolder(tab, text)
    local folderFrame = Instance.new("Frame")
    folderFrame.Size = UDim2.new(1, 0, 0, 30)
    folderFrame.BackgroundColor3 = self.Themes.Default.Folder
    folderFrame.BorderSizePixel = 0
    folderFrame.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = folderFrame
    
    local folderButton = Instance.new("TextButton")
    folderButton.Size = UDim2.new(1, 0, 0, 30)
    folderButton.BackgroundTransparency = 1
    folderButton.Text = text
    folderButton.TextColor3 = self.Themes.Default.TextColor
    folderButton.TextSize = 14
    folderButton.Font = Enum.Font.GothamBold
    folderButton.TextXAlignment = Enum.TextXAlignment.Left
    folderButton.Parent = folderFrame
    
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 15, 0, 15)
    arrow.Position = UDim2.new(0, 10, 0.5, -7)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://3926305904"
    arrow.ImageRectOffset = Vector2.new(364, 284)
    arrow.ImageRectSize = Vector2.new(36, 36)
    arrow.ImageColor3 = Color3.fromRGB(180, 180, 180)
    arrow.Rotation = 0
    arrow.Parent = folderButton
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -10, 0, 0)
    contentFrame.Position = UDim2.new(0, 10, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = folderFrame
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 5)
    contentList.Parent = contentFrame
    
    local isOpen = false
    
    folderButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            contentList:Apply()
            local tween = TweenService:Create(contentFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -10, 0, contentFrame.UIListLayout.AbsoluteContentSize.Y)
            })
            tween:Play()
            
            local folderTween = TweenService:Create(folderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 35 + contentFrame.UIListLayout.AbsoluteContentSize.Y)
            })
            folderTween:Play()
            
            local arrowTween = TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 90
            })
            arrowTween:Play()
        else
            local tween = TweenService:Create(contentFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -10, 0, 0)
            })
            tween:Play()
            
            local folderTween = TweenService:Create(folderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 30)
            })
            folderTween:Play()
            
            local arrowTween = TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 0
            })
            arrowTween:Play()
        end
    end)
    
    table.insert(tab.Elements, folderFrame)
    return contentFrame
end

function Library:AddParagraph(tab, text, liveUpdate)
    local paragraphFrame = Instance.new("Frame")
    paragraphFrame.Size = UDim2.new(1, 0, 0, 80)
    paragraphFrame.BackgroundColor3 = self.Themes.Default.Folder
    paragraphFrame.BorderSizePixel = 0
    paragraphFrame.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = paragraphFrame
    
    local paragraphText = Instance.new("TextLabel")
    paragraphText.Size = UDim2.new(1, -10, 1, -10)
    paragraphText.Position = UDim2.new(0, 5, 0, 5)
    paragraphText.BackgroundTransparency = 1
    paragraphText.Text = text
    paragraphText.TextColor3 = self.Themes.Default.TextColor
    paragraphText.TextSize = 14
    paragraphText.Font = Enum.Font.GothamBold
    paragraphText.TextWrapped = true
    paragraphText.TextXAlignment = Enum.TextXAlignment.Left
    paragraphText.TextYAlignment = Enum.TextYAlignment.Top
    paragraphText.Parent = paragraphFrame
    
    if liveUpdate then
        local connection
        connection = RunService.Heartbeat:Connect(function()
            paragraphText.Text = liveUpdate()
        end)
    end
    
    local paragraph = {
        SetText = function(self, newText)
            paragraphText.Text = newText
        end,
        GetText = function(self)
            return paragraphText.Text
        end
    }
    
    table.insert(tab.Elements, paragraphFrame)
    return paragraph
end

function Library:Notify(title, message, duration)
    duration = duration or 4

    local screenGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AetherNotifyGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AetherNotifyGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local holder = screenGui:FindFirstChild("Holder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(0, 300, 0, 400)
        holder.Position = UDim2.new(1, -10, 1, -10)
        holder.AnchorPoint = Vector2.new(1, 1)
        holder.Parent = screenGui

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        listLayout.Parent = holder
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 0, 0, 70)
    notifFrame.BackgroundColor3 = self.Themes.Default.Notification
    notifFrame.BackgroundTransparency = 0.15
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = holder

    local corner = Instance.new("UICorner", notifFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Thickness = 1.8
    stroke.Color = self.Themes.Default.NotificationStroke
    stroke.Transparency = 0.25

    local gradient = Instance.new("UIGradient", notifFrame)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 30, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    }
    gradient.Rotation = 45

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 28)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(230, 220, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame

    local msgLabel = Instance.new("TextLabel")
    msgLabel.BackgroundTransparency = 1
    msgLabel.Size = UDim2.new(1, -20, 1, -35)
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Text = message
    msgLabel.TextWrapped = true
    msgLabel.TextSize = 15
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.Parent = notifFrame

    notifFrame.Size = UDim2.new(0, 0, 0, 70)
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 70)
    }):Play()

    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = self.Themes.Default.NotificationStroke
    glow.ImageTransparency = 0.8
    glow.ZIndex = 0
    glow.Parent = notifFrame

    task.delay(duration, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 70),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(msgLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()

        task.wait(0.45)
        notifFrame:Destroy()
    end)
end

function Library:ApplyTheme(theme)
    self.MainColor = theme.MainColor or self.Themes.Default.MainColor
    
    self.TabIndicator.BackgroundColor3 = self.MainColor
    
    for _, tab in ipairs(self.Tabs) do
        for _, element in ipairs(tab.Elements) do
            if element:IsA("TextButton") and element.Name == "ToggleButton" then
                -- this is for colors
            end
        end
    end
end

return Aether
