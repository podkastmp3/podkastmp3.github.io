local UI = game:GetService('CoreGui').DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog

getgenv().print = function(...)
    local frame = Instance.new('Frame')
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Name = #UI:GetChildren() - 1
    frame.Size = UDim2.new(1, 0, 0, 15)
    frame.BackgroundTransparency = 1
    frame.Parent = UI

    local msg = Instance.new('TextLabel', frame)
    msg.AutomaticSize = Enum.AutomaticSize.Y
    msg.Name = 'msg'
    msg.BackgroundTransparency = 1
    msg.Position = UDim2.fromOffset(20, 0)
    msg.Size = UDim2.new(1, 0, 0, 15)
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextColor3 = Color3.new(1, 1, 1)
    msg.TextWrapped = true
    msg.FontFace = Font.new('rbxasset://fonts/families/Inconsolata.json')
    msg.TextSize = 15

    local time = DateTime.now():FormatUniversalTime("HH:mm:ss", "en-us")
    local args = table.pack(...)
    local output = {}
    for i = 1, args.n do
        table.insert(output, tostring(args[i]))
    end
    msg.Text = time.." -- " .. table.concat(output, " ")
end

getgenv().warn = function(...)
    local frame = Instance.new('Frame', UI)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Name = #UI:GetChildren() - 1
    frame.Size = UDim2.new(1, 0, 0, 15)
    frame.BackgroundTransparency = 1

    local icon = Instance.new('ImageLabel', frame)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 3, 0.5, -7)
    icon.Size = UDim2.fromScale(14, 14)
    icon.Image = 'rbxasset://textures/DevConsole/Warning.png'

    local msg = Instance.new('TextLabel', frame)
    msg.AutomaticSize = Enum.AutomaticSize.Y
    msg.Name = 'msg'
    msg.BackgroundTransparency = 1
    msg.Position = UDim2.fromOffset(20, 0)
    msg.Size = UDim2.new(1, 0, 0, 15)
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextColor3 = Color3.fromRGB(255, 218, 68)
    msg.TextWrapped = true
    msg.FontFace = Font.new('rbxasset://fonts/families/Inconsolata.json')
    msg.TextSize = 15

    local time = DateTime.now():FormatUniversalTime("HH:mm:ss", "en-us")
    local args = table.pack(...)
    local output = {}
    for i = 1, args.n do
        table.insert(output, tostring(args[i]))
    end
    msg.Text = time.." -- " .. table.concat(output, " ")
end

print('UD Print: Activated.')
