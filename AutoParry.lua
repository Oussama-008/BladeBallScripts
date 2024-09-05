local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local CategoryFrame = Instance.new("Frame")
local AutoParryButton = Instance.new("TextButton")
local AutoSpamButton = Instance.new("TextButton")
local ParryDropdown = Instance.new("TextButton")
local ParryList = Instance.new("Frame")

local ParryOptions = {"Very Early", "Mid Early", "Little Early", "Perfect"}
local AutoSpamEnabled = false
local ParryTiming = "Perfect"

ScreenGui.Parent = game.CoreGui

Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

MinimizeButton.Size = UDim2.new(0, 50, 0, 50)
MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.Parent = Frame

CategoryFrame.Size = UDim2.new(1, 0, 1, -50)
CategoryFrame.Position = UDim2.new(0, 0, 0, 50)
CategoryFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CategoryFrame.Parent = Frame

AutoParryButton.Size = UDim2.new(1, 0, 0, 50)
AutoParryButton.Position = UDim2.new(0, 0, 0, 0)
AutoParryButton.Text = "Auto Parry"
AutoParryButton.Parent = CategoryFrame

AutoSpamButton.Size = UDim2.new(1, 0, 0, 50)
AutoSpamButton.Position = UDim2.new(0, 0, 0, 50)
AutoSpamButton.Text = "Auto Spam"
AutoSpamButton.Parent = CategoryFrame

ParryDropdown.Size = UDim2.new(1, 0, 0, 50)
ParryDropdown.Position = UDim2.new(0, 0, 0, 100)
ParryDropdown.Text = "Select Parry Timing"
ParryDropdown.Parent = CategoryFrame

ParryList.Size = UDim2.new(1, 0, 0, #ParryOptions * 50)
ParryList.Position = UDim2.new(0, 0, 0, 150)
ParryList.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
ParryList.Visible = false
ParryList.Parent = CategoryFrame

for i, option in ipairs(ParryOptions) do
    local OptionButton = Instance.new("TextButton")
    OptionButton.Size = UDim2.new(1, 0, 0, 50)
    OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 50)
    OptionButton.Text = option
    OptionButton.Parent = ParryList

    OptionButton.MouseButton1Click:Connect(function()
        ParryDropdown.Text = option
        ParryList.Visible = false
        ParryTiming = option
    end)
end

ParryDropdown.MouseButton1Click:Connect(function()
    ParryList.Visible = not ParryList.Visible
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local minimized = not CategoryFrame.Visible
    CategoryFrame.Visible = not minimized
    MinimizeButton.Text = minimized and "+" or "-"
end)

AutoParryButton.MouseButton1Click:Connect(function()
    local autoParryEnabled = not AutoParryButton.Text:find("ON")
    AutoParryButton.Text = autoParryEnabled and "Auto Parry: ON" or "Auto Parry: OFF"
    if autoParryEnabled then
        AutoParry()
    end
end)

AutoSpamButton.MouseButton1Click:Connect(function()
    AutoSpamEnabled = not AutoSpamEnabled
    AutoSpamButton.Text = AutoSpamEnabled and "Auto Spam: ON" or "Auto Spam: OFF"
    if AutoSpamEnabled then
        AutoSpam()
    end
end)

local function AutoParry()
    while AutoParryButton.Text:find("ON") do
        wait(0.1)
        for _, ball in pairs(workspace:GetChildren()) do
            if ball:IsA("Part") and ball.Name == "Ball" then
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                local parryDistance = 10
                if ParryTiming == "Very Early" then
                    parryDistance = 20
                elseif ParryTiming == "Mid Early" then
                    parryDistance = 15
                elseif ParryTiming == "Little Early" then
                    parryDistance = 10
                elseif ParryTiming == "Perfect" then
                    parryDistance = 5
                end
                if distance < parryDistance then
                    game:GetService("ReplicatedStorage").Events.Parry:FireServer(ball)
                end
            end
        end
    end
end

local function AutoSpam()
    while AutoSpamEnabled do
        wait(0.1)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                game:GetService("ReplicatedStorage").Events.Spam:FireServer(player)
            end
        end
    end
end
