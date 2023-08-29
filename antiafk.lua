	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")

	local player = game.Players.LocalPlayer
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")

	local initialPosition = character.PrimaryPart.Position
	local isAntiAFKEnabled = false

	local gui = Instance.new("ScreenGui")
	gui.Parent = player.PlayerGui

	local frame = Instance.new("Frame")
	frame.Parent = gui
	frame.Size = UDim2.new(0, 180, 0, 80)  -- Taille ajustée pour le titre et le bouton
	frame.Position = UDim2.new(0.5, -90, 0.9, -60)  -- Position ajustée
	frame.BackgroundTransparency = 0.4
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true  -- Permet de déplacer l'interface avec la souris

	local roundedCorner = Instance.new("UICorner")
	roundedCorner.CornerRadius = UDim.new(0, 20)
	roundedCorner.Parent = frame

	local title = Instance.new("TextLabel")  -- Ajout du titre
	title.Parent = frame
	title.Size = UDim2.new(1, 0, 0.5, 0)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.Text = "Anti-AFK"
	title.TextSize = 18
	title.Font = Enum.Font.SourceSansBold
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1

	local button = Instance.new("TextButton")
	button.Parent = frame
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.Position = UDim2.new(0.5, 0, 0.75, 0)  -- Ajustement de la position du bouton
	button.Size = UDim2.new(0.8, 0, 0.4, 0)  -- Ajustement de la taille du bouton
	button.Text = "Activer"
	button.TextSize = 18
	button.BackgroundTransparency = 0.5
	button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	button.BorderColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)

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
			button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			
			-- Démarre la simulation d'entrée aléatoire
			coroutine.wrap(function()
				local keyCodes = {
					Enum.KeyCode.W,
					Enum.KeyCode.A,
					Enum.KeyCode.S,
					Enum.KeyCode.D,
					Enum.KeyCode.Space,
					-- Ajoutez d'autres touches au besoin
				}
				
				while isAntiAFKEnabled do
					local randomKeyCode = keyCodes[math.random(1, #keyCodes)]
					local inputObject = Instance.new("InputObject", game)
					inputObject.UserInputType = Enum.UserInputType.Keyboard
					inputObject.KeyCode = randomKeyCode
					inputObject.InputState = Enum.InputState.Begin
			
					wait(0.05)  -- Attente très courte pour simuler l'appui de touche
			
					inputObject.InputState = Enum.InputState.End
					wait(0.05)
					inputObject:Destroy()
			
					wait(math.random(2, 10))  -- Attente aléatoire avant la prochaine simulation d'entrée
				end
			end)()
			
		else
			button.Text = "Activer"
			button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		end
	end)

	gui.DisplayOrder = 10  -- Assurer que l'interface est au premier plan

	RunService.Heartbeat:Connect(function()
		-- Vérifier régulièrement si le personnage est inactif et lancer la simulation d'entrée si nécessaire
		if isAntiAFKEnabled and character and character.PrimaryPart then
			local lastPosition = character.PrimaryPart.Position
			wait(1)  -- Attente d'une seconde entre les vérifications
			local currentPosition = character.PrimaryPart.Position
			if (currentPosition - lastPosition).Magnitude < 0.1 then
				local inputObject = Instance.new("InputObject", game)
				inputObject.UserInputType = Enum.UserInputType.Keyboard
				inputObject.KeyCode = Enum.KeyCode.W
				inputObject.InputState = Enum.InputState.Begin
			
				wait(0.05)  -- Attente très courte pour simuler l'appui de touche
			
				inputObject.InputState = Enum.InputState.End
				wait(0.05)
				inputObject:Destroy()
			end
		end
	end)
