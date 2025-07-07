
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
