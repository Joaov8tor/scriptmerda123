-- 🔐 Anti-Ban / Anti-Detect Avançado by Suysbs X
pcall(function()
	-- Bloqueia qualquer evento de Kick (como funções de kick) do LocalPlayer
	local player = game:GetService("Players").LocalPlayer
	for _, v in pairs(getconnections(player.Kick)) do
		v:Disable()
	end

	-- Evita que o jogo monitore a execução do script
	if hookfunction and getrawmetatable then
		local mt = getrawmetatable(game)
		setreadonly(mt, false)
		local old = mt.__namecall
		mt.__namecall = newcclosure(function(self, ...)
			local args = {...}
			local method = getnamecallmethod()

			-- Impede a execução de métodos de "Kick"
			if method == "Kick" or tostring(self):lower():find("kick") then
				return
			end

			-- Bloqueia chamadas de funções de kick e ban
			if method == "SetCore" and args[1] == "Kick" then
				return
			end

			return old(self, unpack(args))
		end)
	end

	-- Protege o jogador contra alterações no seu status
	local function protectPlayer()
		local player = game:GetService("Players").LocalPlayer
		local mt = getrawmetatable(player)

		setreadonly(mt, false)

		local oldIndex = mt.__index
		mt.__index = newcclosure(function(self, key)
			if key == "Character" then
				-- Impede alterações no personagem do jogador
				return oldIndex(self, key)
			elseif key == "Kick" then
				return nil  -- Impede o método "Kick"
			end
			return oldIndex(self, key)
		end)
	end
	protectPlayer()

	-- Função de Atravessar Paredes
	local function atravessarParedes()
		local playerChar = game:GetService("Players").LocalPlayer.Character
		local humanoid = playerChar and playerChar:FindFirstChild("Humanoid")
		if humanoid then
			-- Configurações de Camadas de Proteção
			humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			humanoid.PlatformStand = true
			playerChar.PrimaryPart.CanCollide = false
			playerChar:SetPrimaryPartCFrame(playerChar.PrimaryPart.CFrame * CFrame.new(0, 0, 0))

			-- Movimenta o jogador através das paredes
			while true do
				wait(0.1)
				playerChar:SetPrimaryPartCFrame(playerChar.PrimaryPart.CFrame * CFrame.new(0, 0, 0.2)) -- Ajuste de movimento
			end
		end
	end

	-- Função de Retornar ao Estado Normal (desativando atravessar paredes)
	local function pararAtravessarParedes()
		local playerChar = game:GetService("Players").LocalPlayer.Character
		local humanoid = playerChar and playerChar:FindFirstChild("Humanoid")
		if humanoid then
			-- Retorna ao estado de colisão normal
			humanoid.PlatformStand = false
			playerChar.PrimaryPart.CanCollide = true
		end
	end

	-- Ativar ou Desativar a Função de Atravessar Paredes
	local atravesando = false
	local function alternarAtravessar()
		atravessando = not atravessando
		if atravessando then
			atravessarParedes()
		else
			pararAtravessarParedes()
		end
	end

	-- Restante do código de UI e funcionalidades

	local TweenService = game:GetService("TweenService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera

	-- GUI Base
	local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
	ScreenGui.Name = "PainelSuysbsX"

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0, 300, 0, 400)
	Frame.Position = UDim2.new(0, -320, 0.3, 0) -- Começa fora da tela
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame.BorderSizePixel = 0
	Frame.Visible = true
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui

	local corner = Instance.new("UICorner", Frame)
	corner.CornerRadius = UDim.new(0, 10)

	-- Fade-in e Deslizamento
	TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 20, 0.3, 0)
	}):Play()

	-- Título
	local Title = Instance.new("TextLabel", Frame)
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.Text = "🌟 Painel Suysbs X"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18

	-- Função para botões animados
	local y = 50
	local function createButton(text, callback)
		local btn = Instance.new("TextButton", Frame)
		btn.Size = UDim2.new(0.9, 0, 0, 30)
		btn.Position = UDim2.new(0.05, 0, 0, y)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Text = text
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14

		local bcorner = Instance.new("UICorner", btn)
		bcorner.CornerRadius = UDim.new(0, 6)

		-- Animações ao passar o mouse
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
		end)

		btn.MouseButton1Click:Connect(callback)
		y += 35
	end

	-- Caixa de texto para nome do jogador
	local playerBox = Instance.new("TextBox", Frame)
	playerBox.Size = UDim2.new(0.9, 0, 0, 30)
	playerBox.Position = UDim2.new(0.05, 0, 0, y)
	playerBox.PlaceholderText = "Digite nome do jogador"
	playerBox.Text = ""
	playerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	playerBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	playerBox.Font = Enum.Font.Gotham
	playerBox.TextSize = 14
	local pcorn = Instance.new("UICorner", playerBox)
	pcorn.CornerRadius = UDim.new(0, 6)
	y += 40

	-- Funções
	createButton("Definir Velocidade", function()
		local speed = tonumber(playerBox.Text)
		if speed then
			LocalPlayer.Character.Humanoid.WalkSpeed = speed
		end
	end)

	createButton("Teleportar para Jogador", function()
		local target = Players:FindFirstChild(playerBox.Text)
		if target and target.Character then
			LocalPlayer.Character:MoveTo(target.Character:GetPivot().Position + Vector3.new(0, 3, 0))
		end
	end)

	createButton("Trazer Jogador até Você", function()
		local target = Players:FindFirstChild(playerBox.Text)
		if target and target.Character then
			local myPos = LocalPlayer.Character:GetPivot().Position
			target.Character:SetPrimaryPartCFrame(CFrame.new(myPos + Vector3.new(2, 1, 0)))
		end
	end)

	-- Atravessar Paredes
	createButton("Atravessar Paredes", function()
		alternarAtravessar()
	end)

	-- Espectador
	local spectating = false
	createButton("👁 Ver Tela do Jogador", function()
		local target = Players:FindFirstChild(playerBox.Text)
		if target and target.Character and target.Character:FindFirstChild("Humanoid") then
			Camera.CameraSubject = target.Character.Humanoid
			spectating = true
		end
	end)

	createButton("↩️ Voltar à Sua Tela", function()
		Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
		spectating = false
	end)

	-- Super Jump
	createButton("Pulo Power!", function()
		LocalPlayer.Character.Humanoid.JumpPower = 120
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	-- Fly Script externo
	createButton("Ativar Voo", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
	end)
end)
