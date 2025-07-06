
if game.PlaceId == 142823291 then

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Murder Mystery 2 Script",
   Icon = 0,
   LoadingTitle = "welcome to mm2 Script!",
   LoadingSubtitle = "tip > Use with a unbannable executor ",
   ShowText = "MM2",
   Theme = "Ocean",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MM2 Script Tag: 0091832132.31"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

Rayfield:Notify({
   Title = "Beta Test Warn",
   Content = "️⚠ this Script is on Beta Test, Its gonna have some bugs!",
   Duration = 6.5,
   Image = nil,
})

Rayfield:Notify({
   Title = "Script Welcomer",
   Content = "This is a mm2 Script,enjoy it as much as you want, it has been tested by professionals and there is no chance of it being bannable (only if you are reported)",
   Duration = 10.0,
   Image = nil,
})

-- Noclip system
local NoclipConnection = nil
local Clip = true

function EnableNoclip()
   Clip = false
   local function Nocl()
      if not Clip and game.Players.LocalPlayer.Character then
         for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA('BasePart') and v.CanCollide then
               v.CanCollide = false
            end
         end
      end
   end
   NoclipConnection = game:GetService('RunService').Stepped:Connect(Nocl)
end

function DisableNoclip()
   if NoclipConnection then
      NoclipConnection:Disconnect()
   end
   Clip = true
end

-- Fly compatível com celular e PC
local UIS = game:GetService("UserInputService")
local directions = { F = false, B = false, L = false, R = false, U = false, D = false }

function EnableFly()
   local lp = game.Players.LocalPlayer
   local char = lp.Character or lp.CharacterAdded:Wait()
   local hrp = char:WaitForChild("HumanoidRootPart")

   local bv = Instance.new("BodyVelocity")
   bv.Name = "FlyVelocity"
   bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
   bv.Velocity = Vector3.zero
   bv.Parent = hrp

   if UIS.TouchEnabled and not lp.PlayerGui:FindFirstChild("FlyControls") then
      local screen = Instance.new("ScreenGui", lp.PlayerGui)
      screen.Name = "FlyControls"
      screen.ResetOnSpawn = false

      local function makeButton(name, pos, callbackDown, callbackUp)
         local btn = Instance.new("TextButton", screen)
         btn.Name = name
         btn.Size = UDim2.new(0, 50, 0, 50)
         btn.Position = pos
         btn.BackgroundTransparency = 0.3
         btn.BackgroundColor3 = Color3.new(0, 0, 0)
         btn.TextColor3 = Color3.new(1, 1, 1)
         btn.Text = name
         btn.TextScaled = true
         btn.TouchTap:Connect(callbackDown)
         btn.MouseButton1Down:Connect(callbackDown)
         btn.MouseButton1Up:Connect(callbackUp)
      end

      makeButton("↑", UDim2.new(0.05, 0, 0.7, 0), function() directions.F = true end, function() directions.F = false end)
      makeButton("↓", UDim2.new(0.05, 0, 0.8, 0), function() directions.B = true end, function() directions.B = false end)
      makeButton("←", UDim2.new(0, 0, 0.75, 0), function() directions.L = true end, function() directions.L = false end)
      makeButton("→", UDim2.new(0.1, 0, 0.75, 0), function() directions.R = true end, function() directions.R = false end)
      makeButton("Up", UDim2.new(0.9, 0, 0.7, 0), function() directions.U = true end, function() directions.U = false end)
      makeButton("Dn", UDim2.new(0.9, 0, 0.8, 0), function() directions.D = true end, function() directions.D = false end)
   end

   getgenv().FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
      local move = Vector3.zero
      if UIS:IsKeyDown(Enum.KeyCode.W) or directions.F then move += workspace.CurrentCamera.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.S) or directions.B then move -= workspace.CurrentCamera.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.A) or directions.L then move -= workspace.CurrentCamera.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.D) or directions.R then move += workspace.CurrentCamera.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.Space) or directions.U then move += Vector3.new(0, 1, 0) end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or directions.D then move -= Vector3.new(0, 1, 0) end
      hrp.FlyVelocity.Velocity = move.Magnitude > 0 and move.Unit * 50 or Vector3.zero
   end)
end

function DisableFly()
   local lp = game.Players.LocalPlayer
   local char = lp.Character
   local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if hrp and hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
   if getgenv().FlyConnection then getgenv().FlyConnection:Disconnect() end
   local gui = lp:FindFirstChild("PlayerGui")
   if gui and gui:FindFirstChild("FlyControls") then gui.FlyControls:Destroy() end
   for k in pairs(directions) do directions[k] = false end
end

-- ESP com Highlight (sem BillboardGui)
local function GetColorFromTool(player)
   local char = player.Character
   if not char then return Color3.new(1,1,1) end
   for _, tool in ipairs(player.Backpack:GetChildren()) do
      if tool:IsA("Tool") then
         if tool.Name == "Knife" then
            return Color3.fromRGB(255, 0, 0)
         elseif tool.Name == "Gun" then
            return Color3.fromRGB(0, 0, 255)
         elseif tool.Name == "AAAAA" then
            return Color3.fromRGB(0, 255, 0)
         end
      end
   end
   for _, tool in ipairs(char:GetDescendants()) do
      if tool:IsA("Tool") then
         if tool.Name == "Knife" then
            return Color3.fromRGB(255, 0, 0)
         elseif tool.Name == "Gun" then
            return Color3.fromRGB(0, 0, 255)
         elseif tool.Name == "AAAAA" then
            return Color3.fromRGB(0, 255, 0)
         end
      end
   end
   return Color3.new(1, 1, 1)
end

local function CreateHighlightESP(player)
   if player == game.Players.LocalPlayer then return end

   local function updateHighlightColor(highlight)
      highlight.FillColor = GetColorFromTool(player)
   end

   local function attach()
      local char = player.Character or player.CharacterAdded:Wait()

      local oldHighlight = char:FindFirstChild("_espHighlight")
      if oldHighlight then
         oldHighlight:Destroy()
      end

      local highlight = Instance.new("Highlight")
      highlight.Name = "_espHighlight"
      highlight.Adornee = char
      highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      highlight.FillTransparency = 0.8
      highlight.OutlineTransparency = 0.3
      highlight.FillColor = GetColorFromTool(player)
      highlight.OutlineColor = Color3.new(0, 0, 0)
      highlight.Parent = char

      char.ChildAdded:Connect(function(c)
         if c:IsA("Tool") then
            updateHighlightColor(highlight)
         end
      end)

      char.ChildRemoved:Connect(function(c)
         if c:IsA("Tool") then
            updateHighlightColor(highlight)
         end
      end)
   end

   if player.Character then
      attach()
   end

   player.CharacterAdded:Connect(function()
      task.wait(1)
      attach()
   end)
end

local function RemoveHighlightESP(player)
   if player.Character then
      local h = player.Character:FindFirstChild("_espHighlight")
      if h then h:Destroy() end
   end
end

-- Adiciona à aba Player
local PlayerTab = Window:CreateTab("🎩 | Player", nil)
local MurderTab = Window:CreateTab("🔪 | Murder", nil)
local SherrifTab = Window:CreateTab("🔫 | Sherrif", nil)
local MiscTab = Window:CreateTab("🍖 | Misc", nil)

-- Player Tab UI
PlayerTab:CreateSlider({
   Name = "Speed",
   Range = {16, 100},
   Increment = 10,
   Suffix = "SP",
   CurrentValue = 16,
   Flag = "SpeedFlag",
   Callback = function(Value)
      local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
      if humanoid then
         humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 250},
   Increment = 10,
   Suffix = "JP",
   CurrentValue = 50,
   Flag = "JumpPowerFlag",
   Callback = function(Value)
      local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
      if humanoid then
         humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      if Value then EnableNoclip() else DisableNoclip() end
   end,
})

PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      if Value then EnableFly() else DisableFly() end
   end,
})

PlayerTab:CreateToggle({
   Name = "ESP (Highlight)",
   CurrentValue = false,
   Flag = "ESP_Highlight",
   Callback = function(Value)
      if Value then
         for _, p in ipairs(game.Players:GetPlayers()) do
            CreateHighlightESP(p)
         end
         game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
               task.wait(1)
               CreateHighlightESP(p)
            end)
         end)
      else
         for _, p in ipairs(game.Players:GetPlayers()) do
            RemoveHighlightESP(p)
         end
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "HumanoidRootPart Anchor",
   CurrentValue = false,
   Flag = "HRPAnchorToggle",
   Callback = function(Value)
      local lp = game.Players.LocalPlayer
      local char = lp.Character
      if char then
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.Anchored = Value
         end
      end
   end,
})

-- Murder Tab UI
MurderTab:CreateToggle({
   Name = "Bring All",
   CurrentValue = false,
   Flag = "BringallFlag",
   Callback = function(Value)
      local lp = game.Players.LocalPlayer
      local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if not hrp then return end
      if Value then
         getgenv().BringLoop = true
         task.spawn(function()
            while getgenv().BringLoop do
               for _, player in pairs(game.Players:GetPlayers()) do
                  if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                     local targetHRP = player.Character.HumanoidRootPart
                     targetHRP.Anchored = true
                     targetHRP.CFrame = hrp.CFrame
                  end
               end
               task.wait(1)
            end
         end)
      else
         getgenv().BringLoop = false
         for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.Anchored = false
            end
         end
      end
   end,
})

MurderTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "KillAura",
   Callback = function(Value)
      getgenv().KillAuraRunning = Value
      task.spawn(function()
         while getgenv().KillAuraRunning do
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local distance = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                  if distance <= 10 then
                     local knife = char:FindFirstChild("Knife")
                     if knife and knife:FindFirstChild("Stab") then
                        knife.Stab:FireServer("Slash")
                     end
                  end
               end
            end
            task.wait(0.5)
         end
      end)
   end,
})

MurderTab:CreateToggle({
   Name = "Auto Throw",
   CurrentValue = false,
   Flag = "AutoThrowFlag",
   Callback = function(Value)
      getgenv().AutoThrow = Value
      if Value then
         task.spawn(function()
            while getgenv().AutoThrow do
               local lp = game.Players.LocalPlayer
               local knife = lp.Character and lp.Character:FindFirstChild("Knife")
               if knife and knife:FindFirstChild("Throw") then
                  local players = game.Players:GetPlayers()
                  local targets = {}
                  for _, p in pairs(players) do
                     if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        table.insert(targets, p)
                     end
                  end
                  if #targets > 0 then
                     local target = targets[math.random(1, #targets)]
                     local hrp = target.Character.HumanoidRootPart
                     local args = {
                        hrp.CFrame,
                        Vector3.new(hrp.Position.X + 15, hrp.Position.Y, hrp.Position.Z + 15)
                     }
                     knife.Throw:FireServer(unpack(args))
                  end
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

local ShootMurder = SherrifTab:CreateButton({
   Name = "Shoot Murder (Beta test Desenabled)",
   Callback = function()
      -- Implementação futura
   end,
})

local GetGun = SherrifTab:CreateButton({
   Name = "Get The Gun",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local partToSimulateTouch = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")

      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("BasePart") and v.Name == "GunDrop" and partToSimulateTouch then
            firetouchinterest(v, partToSimulateTouch, 0) -- iniciar o toque
            wait()
            firetouchinterest(v, partToSimulateTouch, 1) -- encerrar o toque
         end
      end
   end,
})

local GetAllCoins = MiscTab:CreateToggle({
   Name = "Get All Coins (Teleport)",
   CurrentValue = false,
   Flag = "GetAllCoinsFlag",
   Callback = function(Value)
      getgenv().CollectingCoins = Value
      local player = game.Players.LocalPlayer
      task.spawn(function()
         while getgenv().CollectingCoins do
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            if hrp then
               for _, v in pairs(workspace:GetDescendants()) do
                  if v:IsA("BasePart") and v.Name == "Coin_Server" then
                     -- Teleporta para a moeda
                     hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                     task.wait(0.1)
                     -- Toca na moeda para coletar
                     pcall(function()
                        firetouchinterest(v, hrp, 0)
                        task.wait(0.05)
                        firetouchinterest(v, hrp, 1)
                     end)
                     task.wait(0.1)
                  end
               end
            end
            task.wait(0.5)
         end
      end)
   end,
})


end
