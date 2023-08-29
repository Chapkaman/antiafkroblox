local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local initialPosition = character.PrimaryPart.Position
local isAntiAFKEnabled = false

local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 180, 0, 60)  
frame.Position = UDim2.new(0.5, -90, 0.9, -45)  
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true  

local roundedCorner = Instance.new("UICorner")
roundedCorner.CornerRadius = UDim.new(0, 20)
roundedCorner.Parent = frame

local title = Instance.new("TextLabel")  
title.Parent = frame
title.Size = UDim2.new(1, 0, 0.5, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ANTI AFK ZEBIII"
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

local button = Instance.new("TextButton")
button.Parent = frame
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Position = UDim2.new(0.5, 0, 0.75, 0)  
button.Size = UDim2.new(0.8, 0, 0.4, 0) 
button.Text = "Activer"
button.TextSize = 18
button.BackgroundTransparency = 0.5
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.BorderColor3 = Color3.fromRGB(70, 70, 70)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

local buttonDirection = 1  

local isDragging = false
local dragStartPos
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = input.Position
        startPos = frame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

button.MouseButton1Click:Connect(function()
    isAntiAFKEnabled = not isAntiAFKEnabled
    if isAntiAFKEnabled then
        button.Text = "Désactiver"
        buttonDirection = 1
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        button.Text = "Activer"
        buttonDirection = -1
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

gui.DisplayOrder = 10  

while true do
    wait(5)
    
    if isAntiAFKEnabled then
        local currentPosition = character.PrimaryPart.Position
        if (currentPosition - initialPosition).Magnitude < 0.1 then
            local randomMovement = Vector3.new(
                math.random(-5, 5),  
                0,                   
                math.random(-5, 5)   
            )
            local newPosition = initialPosition + randomMovement
            humanoid:Move(newPosition - currentPosition)
        end
    end
    wait(5)  
end
