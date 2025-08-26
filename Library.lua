local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local function createRoundedCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

Library.Windows = {}
Library.NotificationQueue = {}

function Library:AddWindow(options)
    local window = {
        Name = options.name or "UI Library",
        MainColor = options.main_color or Color3.fromRGB(85, 170, 255),
        Size = options.main_size or Vector2.new(600, 400),
        Tabs = {},
        CurrentTab = nil
    }
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AetherUILibrary"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, window.Size.X, 0, window.Size.Y)
    mainFrame.Position = UDim2.new(0.5, -window.Size.X/2, 0.5, -window.Size.Y/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = true
    createRoundedCorner(mainFrame)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    createRoundedCorner(titleBar, 8)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = window.Name
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
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
    
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -16, 0, 1)
    separator.Position = UDim2.new(0, 8, 0, 30)
    separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    separator.BackgroundTransparency = 0
    separator.BorderSizePixel = 0
    separator.Parent = mainFrame
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -16, 0, 30)
    tabContainer.Position = UDim2.new(0, 8, 0, 31)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Size = UDim2.new(0, 80, 0, 2)
    tabIndicator.Position = UDim2.new(0, 0, 1, 0)
    tabIndicator.BackgroundColor3 = window.MainColor
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Parent = tabContainer
    
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -16, 1, -80)
    contentArea.Position = UDim2.new(0, 8, 0, 65)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, -16, 0, 30)
    footer.Position = UDim2.new(0, 8, 1, -35)
    footer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    footer.BorderSizePixel = 0
    footer.Parent = mainFrame
    createRoundedCorner(footer, 4)
    
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
    userName.TextColor3 = Color3.fromRGB(220, 220, 220)
    userName.TextSize = 14
    userName.Font = Enum.Font.GothamBold
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = footer
    
    function window:AddTab(name)
        local tab = {
            Name = name,
            Elements = {},
            Container = nil
        }
        
        local tabIndex = #window.Tabs + 1
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.Position = UDim2.new(0, (tabIndex-1)*80, 0, 0)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabContainer
        
        -- Create tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
        tabContent.Visible = (tabIndex == 1)
        tabContent.Parent = contentArea
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 8)
        uiListLayout.Parent = tabContent
        
        tab.Container = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(window.Tabs) do
                t.Container.Visible = false
            end
            tabContent.Visible = true
            
            local tween = TweenService:Create(tabIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, (tabIndex-1)*80, 1, 0)
            })
            tween:Play()
            
            -- Change tab colors
            for _, btn in ipairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            window.CurrentTab = tab
        end)
        
        if tabIndex == 1 then
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            window.CurrentTab = tab
        end
        
        -- Tab methods
        function tab:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tabContent
            
            table.insert(tab.Elements, label)
            return label
        end
        
        function tab:AddButton(text, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 30)
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = Color3.fromRGB(220, 220, 220)
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold
            button.Parent = tabContent
            
            createRoundedCorner(button, 4)
            
            button.MouseEnter:Connect(function()
                local tween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = window.MainColor
                })
                tween:Play()
            end)
            
            button.MouseLeave:Connect(function()
                local tween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                })
                tween:Play()
            end)
            
            button.MouseButton1Click:Connect(callback)
            
            table.insert(tab.Elements, button)
            return button
        end
        
        function tab:AddToggle(text, callback)
            local toggle = {
                State = false,
                Callback = callback
            }
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 25)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 45, 0, 22)
            toggleButton.Position = UDim2.new(1, -45, 0, 0)
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            createRoundedCorner(toggleButton, 11)
            
            local toggleDot = Instance.new("Frame")
            toggleDot.Size = UDim2.new(0, 18, 0, 18)
            toggleDot.Position = UDim2.new(0, 2, 0, 2)
            toggleDot.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            toggleDot.BorderSizePixel = 0
            toggleDot.Parent = toggleButton
            
            createRoundedCorner(toggleDot, 9)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -55, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = text
            toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.GothamBold
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local function updateToggle()
                if toggle.State then
                    local tween = TweenService:Create(toggleDot, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 25, 0, 2),
                        BackgroundColor3 = window.MainColor
                    })
                    tween:Play()
                    toggleButton.BackgroundColor3 = Color3.fromRGB(
                        window.MainColor.R * 255 * 0.3,
                        window.MainColor.G * 255 * 0.3,
                        window.MainColor.B * 255 * 0.3
                    )
                else
                    local tween = TweenService:Create(toggleDot, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 2, 0, 2),
                        BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                    })
                    tween:Play()
                    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggle.State = not toggle.State
                updateToggle()
                if toggle.Callback then toggle.Callback(toggle.State) end
            end)
            
            updateToggle()
            
            function toggle:Set(value)
                toggle.State = value
                updateToggle()
            end
            
            function toggle:Get()
                return toggle.State
            end
            
            table.insert(tab.Elements, toggleFrame)
            return toggle
        end
        
        function tab:AddTextBox(placeholder, callback)
            local textBoxFrame = Instance.new("Frame")
            textBoxFrame.Size = UDim2.new(1, 0, 0, 30)
            textBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            textBoxFrame.BorderSizePixel = 0
            textBoxFrame.Parent = tabContent
            
            createRoundedCorner(textBoxFrame, 4)
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -10, 1, 0)
            textBox.Position = UDim2.new(0, 5, 0, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = ""
            textBox.PlaceholderText = placeholder
            textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
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
        
        function tab:AddKeybind(text, callback)
            local keybind = {
                Key = Enum.KeyCode.F,
                Callback = callback
            }
            
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Size = UDim2.new(1, 0, 0, 20)
            keybindFrame.BackgroundTransparency = 1
            keybindFrame.Parent = tabContent
            
            local keybindButton = Instance.new("TextButton")
            keybindButton.Size = UDim2.new(0, 60, 0, 20)
            keybindButton.Position = UDim2.new(1, -60, 0, 0)
            keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            keybindButton.BorderSizePixel = 0
            keybindButton.Text = tostring(keybind.Key):gsub("Enum.KeyCode.", "")
            keybindButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            keybindButton.TextSize = 14
            keybindButton.Font = Enum.Font.GothamBold
            keybindButton.Parent = keybindFrame
            
            createRoundedCorner(keybindButton, 4)
            
            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.Size = UDim2.new(1, -70, 1, 0)
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Text = text
            keybindLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            keybindLabel.TextSize = 14
            keybindLabel.Font = Enum.Font.GothamBold
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindLabel.Parent = keybindFrame
            
            local listening = false
            
            keybindButton.MouseButton1Click:Connect(function()
                listening = true
                keybindButton.Text = "..."
                keybindButton.BackgroundColor3 = window.MainColor
            end)
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        keybind.Key = input.KeyCode
                        keybindButton.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                        listening = false
                        keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                        if keybind.Callback then keybind.Callback(input.KeyCode) end
                    end
                end
            end)
            
            function keybind:Set(key)
                keybind.Key = key
                keybindButton.Text = tostring(key):gsub("Enum.KeyCode.", "")
            end
            
            function keybind:Get()
                return keybind.Key
            end
            
            table.insert(tab.Elements, keybindFrame)
            return keybind
        end
        
        function tab:AddDropdown(text, callback)
            local dropdown = {
                Options = {},
                Selected = nil,
                Callback = callback
            }
            
            local BTN_H = 30
            local ITEM_H = 25
            local PAD = 2
            
            local function calcTotalHeight()
                if #dropdown.Options == 0 then return 0 end
                return (#dropdown.Options * ITEM_H) + ((#dropdown.Options - 1) * PAD)
            end
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, BTN_H)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.ClipsDescendants = true
            dropdownFrame.ZIndex = 20
            dropdownFrame.Parent = tabContent
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(1, 0, 0, BTN_H)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Text = text .. ": " .. (dropdown.Selected or "Select")
            dropdownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            dropdownButton.TextSize = 14
            dropdownButton.Font = Enum.Font.GothamBold
            dropdownButton.ZIndex = 21
            dropdownButton.Parent = dropdownFrame
            
            createRoundedCorner(dropdownButton, 4)
            
            -- Arrow
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
            
            createRoundedCorner(optionsFrame, 4)
            
            local optionsList = Instance.new("UIListLayout")
            optionsList.Padding = UDim.new(0, PAD)
            optionsList.Parent = optionsFrame
            
            local isOpen = false
            
            function dropdown:Add(option)
                table.insert(dropdown.Options, option)
                
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, ITEM_H)
                optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                optionButton.TextSize = 14
                optionButton.Font = Enum.Font.GothamBold
                optionButton.ZIndex = 23
                optionButton.Parent = optionsFrame
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdown.Selected = option
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
                    
                    if dropdown.Callback then
                        task.spawn(dropdown.Callback, option)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundColor3 = window.MainColor
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
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
            
            function dropdown:Set(option)
                dropdown.Selected = option
                dropdownButton.Text = text .. ": " .. option
            end
            
            function dropdown:Get()
                return dropdown.Selected
            end
            
            table.insert(tab.Elements, dropdownFrame)
            return dropdown
        end
        
        function tab:AddParagraph(text, liveUpdate)
            local paragraph = {
                Text = text
            }
            
            local paragraphFrame = Instance.new("Frame")
            paragraphFrame.Size = UDim2.new(1, 0, 0, 80)
            paragraphFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            paragraphFrame.BorderSizePixel = 0
            paragraphFrame.Parent = tabContent
            
            createRoundedCorner(paragraphFrame, 4)
            
            local paragraphText = Instance.new("TextLabel")
            paragraphText.Size = UDim2.new(1, -10, 1, -10)
            paragraphText.Position = UDim2.new(0, 5, 0, 5)
            paragraphText.BackgroundTransparency = 1
            paragraphText.Text = text
            paragraphText.TextColor3 = Color3.fromRGB(220, 220, 220)
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
            
            function paragraph:SetContent(newText)
                paragraphText.Text = newText
            end
            
            function paragraph:GetContent()
                return paragraphText.Text
            end
            
            table.insert(tab.Elements, paragraphFrame)
            return paragraph
        end
        
        table.insert(window.Tabs, tab)
        return tab
    end
    
    table.insert(Library.Windows, window)
    return window
end

-- Notification function
function Library:Notify(title, message, duration)
    duration = duration or 4
    
    local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("AetherNotifyGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AetherNotifyGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = player:WaitForChild("PlayerGui")
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
    notifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    notifFrame.BackgroundTransparency = 0.15
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = holder
    
    createRoundedCorner(notifFrame, 12)
    
    local stroke = createStroke(notifFrame, Color3.fromRGB(150, 90, 255), 1.8)
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

return Library
