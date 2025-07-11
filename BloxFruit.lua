--[[
Blox Fruits GUI Script (Mobile Friendly)
Atualizado por: GitHub Copilot (2025)
Funções:
- Ninja Icon flutuante
- Auto Farm (nível, inimigos próximos, todos bosses)
- ESP Jogador (nome vermelho), ESP Fruta
- Lista de bosses spawnados
- Teleporte para ilhas (por mar), teleporte entre mares
- Otimizado para mobile
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Anti-AFK
pcall(function()
    for _, c in pairs(getconnections(LocalPlayer.Idled)) do
        c:Disable()
    end
end)

-- [GUI]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Flutuante Ninja Icon
local NinjaIcon = Instance.new("ImageLabel")
NinjaIcon.Name = "NinjaIcon"
NinjaIcon.Parent = ScreenGui
NinjaIcon.BackgroundTransparency = 1
NinjaIcon.Size = UDim2.new(0, 60, 0, 60)
NinjaIcon.Position = UDim2.new(0.8, 0, 0.15, 0)
NinjaIcon.Image = "rbxassetid://15432080" -- Troque se quiser outro ícone

local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.8, 0, 0.15, 0)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Text = ""
OpenBtn.ZIndex = 2

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 370, 0, 480)
MainFrame.Position = UDim2.new(0.5, -185, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Blox Fruits - Leozin Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

-- [Auto Farm Section]
local AutoFarm = false
local Weapon = "Melee"
local Weapons = {"Melee","Sword","Gun","Blox Fruit"}
local BtnAutoFarm = Instance.new("TextButton")
BtnAutoFarm.Parent = MainFrame
BtnAutoFarm.Position = UDim2.new(0, 10, 0, 50)
BtnAutoFarm.Size = UDim2.new(0, 150, 0, 36)
BtnAutoFarm.Text = "Auto Farm: OFF"
BtnAutoFarm.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnAutoFarm.TextColor3 = Color3.new(1,1,1)
BtnAutoFarm.Font = Enum.Font.Gotham
BtnAutoFarm.TextSize = 16

local WeaponSelector = Instance.new("TextButton")
WeaponSelector.Parent = MainFrame
WeaponSelector.Position = UDim2.new(0, 170, 0, 50)
WeaponSelector.Size = UDim2.new(0, 150, 0, 36)
WeaponSelector.Text = "Arma: Melee"
WeaponSelector.BackgroundColor3 = Color3.fromRGB(32,32,32)
WeaponSelector.TextColor3 = Color3.new(1,1,1)
WeaponSelector.Font = Enum.Font.Gotham
WeaponSelector.TextSize = 16

-- [Farmar Inimigos Próximos]
local FarmNearest = false
local BtnFarmNearest = Instance.new("TextButton")
BtnFarmNearest.Parent = MainFrame
BtnFarmNearest.Position = UDim2.new(0, 10, 0, 92)
BtnFarmNearest.Size = UDim2.new(0, 150, 0, 36)
BtnFarmNearest.Text = "Farm Próx: OFF"
BtnFarmNearest.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnFarmNearest.TextColor3 = Color3.new(1,1,1)
BtnFarmNearest.Font = Enum.Font.Gotham
BtnFarmNearest.TextSize = 16

-- [Farmar TODOS os Bosses]
local FarmAllBosses = false
local BtnFarmBosses = Instance.new("TextButton")
BtnFarmBosses.Parent = MainFrame
BtnFarmBosses.Position = UDim2.new(0, 170, 0, 92)
BtnFarmBosses.Size = UDim2.new(0, 150, 0, 36)
BtnFarmBosses.Text = "Farm Bosses: OFF"
BtnFarmBosses.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnFarmBosses.TextColor3 = Color3.new(1,1,1)
BtnFarmBosses.Font = Enum.Font.Gotham
BtnFarmBosses.TextSize = 16

-- [ESP PLAYER]
local PlayerESPEnabled = false
local BtnPlayerESP = Instance.new("TextButton")
BtnPlayerESP.Parent = MainFrame
BtnPlayerESP.Position = UDim2.new(0, 10, 0, 134)
BtnPlayerESP.Size = UDim2.new(0, 150, 0, 36)
BtnPlayerESP.Text = "ESP Player: OFF"
BtnPlayerESP.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnPlayerESP.TextColor3 = Color3.new(1,1,1)
BtnPlayerESP.Font = Enum.Font.Gotham
BtnPlayerESP.TextSize = 16

-- [ESP FRUIT]
local FruitESPEnabled = false
local BtnFruitESP = Instance.new("TextButton")
BtnFruitESP.Parent = MainFrame
BtnFruitESP.Position = UDim2.new(0, 170, 0, 134)
BtnFruitESP.Size = UDim2.new(0, 150, 0, 36)
BtnFruitESP.Text = "ESP Fruta: OFF"
BtnFruitESP.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnFruitESP.TextColor3 = Color3.new(1,1,1)
BtnFruitESP.Font = Enum.Font.Gotham
BtnFruitESP.TextSize = 16

-- [Lista de Bosses Spawnados]
local BossListLabel = Instance.new("TextLabel")
BossListLabel.Parent = MainFrame
BossListLabel.Position = UDim2.new(0,10,0,176)
BossListLabel.Size = UDim2.new(0, 340, 0, 70)
BossListLabel.BackgroundTransparency = 0.3
BossListLabel.BackgroundColor3 = Color3.fromRGB(22,22,22)
BossListLabel.Text = "Bosses: (Carregando...)"
BossListLabel.Font = Enum.Font.Gotham
BossListLabel.TextSize = 15
BossListLabel.TextColor3 = Color3.new(1,0.8,0.2)
BossListLabel.TextWrapped = true

-- [TP Spawn]
local BtnTPHome = Instance.new("TextButton")
BtnTPHome.Parent = MainFrame
BtnTPHome.Position = UDim2.new(0, 10, 0, 252)
BtnTPHome.Size = UDim2.new(0, 150, 0, 36)
BtnTPHome.Text = "Teleportar Spawn"
BtnTPHome.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnTPHome.TextColor3 = Color3.new(1,1,1)
BtnTPHome.Font = Enum.Font.Gotham
BtnTPHome.TextSize = 16

-- [TP para os Mares]
local SeaList = {"First Sea","Second Sea","Third Sea"}
local BtnToSea1 = Instance.new("TextButton")
BtnToSea1.Parent = MainFrame
BtnToSea1.Position = UDim2.new(0, 170, 0, 252)
BtnToSea1.Size = UDim2.new(0, 150, 0, 36)
BtnToSea1.Text = "Ir p/ Mar 1"
BtnToSea1.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnToSea1.TextColor3 = Color3.new(1,1,1)
BtnToSea1.Font = Enum.Font.Gotham
BtnToSea1.TextSize = 16

local BtnToSea2 = Instance.new("TextButton")
BtnToSea2.Parent = MainFrame
BtnToSea2.Position = UDim2.new(0, 10, 0, 294)
BtnToSea2.Size = UDim2.new(0, 150, 0, 36)
BtnToSea2.Text = "Ir p/ Mar 2"
BtnToSea2.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnToSea2.TextColor3 = Color3.new(1,1,1)
BtnToSea2.Font = Enum.Font.Gotham
BtnToSea2.TextSize = 16

local BtnToSea3 = Instance.new("TextButton")
BtnToSea3.Parent = MainFrame
BtnToSea3.Position = UDim2.new(0, 170, 0, 294)
BtnToSea3.Size = UDim2.new(0, 150, 0, 36)
BtnToSea3.Text = "Ir p/ Mar 3"
BtnToSea3.BackgroundColor3 = Color3.fromRGB(32,32,32)
BtnToSea3.TextColor3 = Color3.new(1,1,1)
BtnToSea3.Font = Enum.Font.Gotham
BtnToSea3.TextSize = 16

-- [TP PARA ILHAS]
local IslandList = {
    ["First Sea"] = {
        {"Starter Island", Vector3.new(1061,16,1437)},
        {"Jungle", Vector3.new(-1602, 36, 152)},
        {"Pirate Village", Vector3.new(-1122, 4, 3856)},
        {"Desert", Vector3.new(1094, 13, 4372)},
        {"Middle Town", Vector3.new(-655, 8, 1436)},
        {"Frozen Village", Vector3.new(1122, 17, -1285)},
        {"Marine Fortress", Vector3.new(-4500, 20, 4260)},
        {"Sky Islands", Vector3.new(-4920, 717, -2622)},
        {"Colosseum", Vector3.new(-1837, 7, -2746)},
        {"Prison", Vector3.new(4847, 5, 742)},
        {"Magma Village", Vector3.new(-5310, 78, 8519)},
        {"Underwater City", Vector3.new(3876, 5, -1890)},
        {"Fountain City", Vector3.new(5132, 15, 4196)}
    },
    ["Second Sea"] = {
        {"Kingdom of Rose", Vector3.new(-393, 73, 354)},
        {"Green Zone", Vector3.new(-3845, 215, 367)},
        {"Graveyard", Vector3.new(-5372, 8, -474)},
        {"Snow Mountain", Vector3.new(1406, 448, -5377)},
        {"Hot and Cold", Vector3.new(-5790, 38, -2300)},
        {"Cursed Ship", Vector3.new(-909, 4, 5299)},
        {"Ice Castle", Vector3.new(5442, 272, -6237)},
        {"Forgotten Island", Vector3.new(-3051, 238, -10192)},
        {"Usoap's Island", Vector3.new(4748, 8, 2841)}
    },
    ["Third Sea"] = {
        {"Port Town", Vector3.new(-260, 6, 5458)},
        {"Hydra Island", Vector3.new(5223, 604, 346)},
        {"Great Tree", Vector3.new(2347, 50, -6459)},
        {"Floating Turtle", Vector3.new(-10564, 331, -8750)},
        {"Castle on the Sea", Vector3.new(-5500, 313, -2926)},
        {"Haunted Castle", Vector3.new(-9515, 142, 6062)},
        {"Sea of Treats", Vector3.new(-2135, 39, -12347)}
    }
}
local CurrentSea = "First Sea"
local IslandDropdown = Instance.new("TextButton")
IslandDropdown.Parent = MainFrame
IslandDropdown.Position = UDim2.new(0, 10, 0, 336)
IslandDropdown.Size = UDim2.new(0, 310, 0, 36)
IslandDropdown.Text = "Ilha: Nenhuma"
IslandDropdown.BackgroundColor3 = Color3.fromRGB(32,32,32)
IslandDropdown.TextColor3 = Color3.new(1,1,1)
IslandDropdown.Font = Enum.Font.Gotham
IslandDropdown.TextSize = 16
local SelectedIsland = nil

local BtnTpIsland = Instance.new("TextButton")
BtnTpIsland.Parent = MainFrame
BtnTpIsland.Position = UDim2.new(0, 325, 0, 336)
BtnTpIsland.Size = UDim2.new(0, 35, 0, 36)
BtnTpIsland.Text = "TP"
BtnTpIsland.BackgroundColor3 = Color3.fromRGB(52,52,52)
BtnTpIsland.TextColor3 = Color3.new(1,1,1)
BtnTpIsland.Font = Enum.Font.GothamBold
BtnTpIsland.TextSize = 18

-- [ABRIR MENU]
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [MUDAR ARMA]
WeaponSelector.MouseButton1Click:Connect(function()
    local i = table.find(Weapons, Weapon)
    Weapon = Weapons[(i%#Weapons)+1]
    WeaponSelector.Text = "Arma: "..Weapon
end)

-- [TOGGLE AUTO FARM]
BtnAutoFarm.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    BtnAutoFarm.Text = AutoFarm and "Auto Farm: ON" or "Auto Farm: OFF"
end)

BtnFarmNearest.MouseButton1Click:Connect(function()
    FarmNearest = not FarmNearest
    BtnFarmNearest.Text = FarmNearest and "Farm Próx: ON" or "Farm Próx: OFF"
end)

BtnFarmBosses.MouseButton1Click:Connect(function()
    FarmAllBosses = not FarmAllBosses
    BtnFarmBosses.Text = FarmAllBosses and "Farm Bosses: ON" or "Farm Bosses: OFF"
end)

BtnPlayerESP.MouseButton1Click:Connect(function()
    PlayerESPEnabled = not PlayerESPEnabled
    BtnPlayerESP.Text = PlayerESPEnabled and "ESP Player: ON" or "ESP Player: OFF"
end)

BtnFruitESP.MouseButton1Click:Connect(function()
    FruitESPEnabled = not FruitESPEnabled
    BtnFruitESP.Text = FruitESPEnabled and "ESP Fruta: ON" or "ESP Fruta: OFF"
end)

BtnTPHome.MouseButton1Click:Connect(function()
    local spawns = Workspace:FindFirstChild("SpawnPoints") or Workspace:FindFirstChild("SpawnPoint")
    if spawns then
        for _, v in pairs(spawns:GetChildren()) do
            LocalPlayer.Character:SetPrimaryPartCFrame(v.CFrame + Vector3.new(0,3,0))
            break
        end
    end
end)

BtnToSea1.MouseButton1Click:Connect(function()
    if CurrentSea ~= "First Sea" then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
    end
end)
BtnToSea2.MouseButton1Click:Connect(function()
    if CurrentSea ~= "Second Sea" then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
    end
end)
BtnToSea3.MouseButton1Click:Connect(function()
    if CurrentSea ~= "Third Sea" then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
    end
end)

IslandDropdown.MouseButton1Click:Connect(function()
    -- Cicla entre ilhas do mar atual
    local islands = IslandList[CurrentSea]
    if not islands then return end
    local idx = 1
    if SelectedIsland then
        for i, v in ipairs(islands) do
            if v[1] == SelectedIsland[1] then
                idx = i+1
                break
            end
        end
    end
    if idx > #islands then idx = 1 end
    SelectedIsland = islands[idx]
    IslandDropdown.Text = "Ilha: "..SelectedIsland[1]
end)
BtnTpIsland.MouseButton1Click:Connect(function()
    if SelectedIsland and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(SelectedIsland[2]+Vector3.new(0,3,0)))
    end
end)

-- [ESP PLAYER LOGIC]
local function DrawESPPlayer()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not plr.Character:FindFirstChild("ESPName") then
                local Billboard = Instance.new("BillboardGui",plr.Character)
                Billboard.Name = "ESPName"
                Billboard.Adornee = plr.Character:FindFirstChild("Head")
                Billboard.Size = UDim2.new(0,200,0,50)
                Billboard.StudsOffset = Vector3.new(0,2,0)
                Billboard.AlwaysOnTop = true
                local NameLabel = Instance.new("TextLabel",Billboard)
                NameLabel.Size = UDim2.new(1,0,1,0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = plr.Name
                NameLabel.TextColor3 = Color3.new(1,0,0)
                NameLabel.TextStrokeTransparency = 0.5
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.TextSize = 20
            end
        end
    end
end
local function RemoveESPPlayer()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("ESPName") then
            plr.Character.ESPName:Destroy()
        end
    end
end

local function DrawESPFruit()
    for _,v in pairs(Workspace:GetChildren()) do
        if string.find(v.Name:lower(),"fruit") and not v:FindFirstChild("FruitESP") then
            local Billboard = Instance.new("BillboardGui",v)
            Billboard.Name = "FruitESP"
            Billboard.Size = UDim2.new(0,100,0,40)
            Billboard.StudsOffset = Vector3.new(0,2,0)
            Billboard.AlwaysOnTop = true
            local NameLabel = Instance.new("TextLabel",Billboard)
            NameLabel.Size = UDim2.new(1,0,1,0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = v.Name
            NameLabel.TextColor3 = Color3.new(1,1,0)
            NameLabel.TextStrokeTransparency = 0.5
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.TextSize = 18
        end
    end
end

local function RemoveESPFruit()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:FindFirstChild("FruitESP") then
            v.FruitESP:Destroy()
        end
    end
end

-- [FARM LOGIC]
local function FindNearestMob()
    local dist, mob = math.huge, nil
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
            if d < dist then
                dist = d
                mob = v
            end
        end
    end
    return mob
end

local function FindAllBosses()
    local list = {}
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if v.Name:lower():find("boss") or v.Name:lower():find("admiral") or v.Name:lower():find("king") or v.Name:lower():find("beard") or v.Name:lower():find("kaido") or v.Name:lower():find("rip_") then
                table.insert(list, v)
            end
        end
    end
    return list
end

local function AttackMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    LocalPlayer.Character:SetPrimaryPartCFrame(mob.HumanoidRootPart.CFrame + Vector3.new(0,3,0))
    -- Equipar arma
    for _,v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if (Weapon == "Melee" and v:IsA("Tool") and v.ToolTip == "Melee") or
           (Weapon == "Sword" and v:IsA("Tool") and string.find(v.Name:lower(),"sword")) or
           (Weapon == "Gun" and v:IsA("Tool") and string.find(v.Name:lower(),"gun")) or
           (Weapon == "Blox Fruit" and v:IsA("Tool") and v.ToolTip == "Blox Fruit") then
            LocalPlayer.Character.Humanoid:EquipTool(v)
            break
        end
    end
    -- Atacar
    mouse1click()
end

-- [ATUALIZA LISTA DE BOSSES]
local function GetBossList()
    local bossList = {}
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if v.Name:lower():find("boss") or v.Name:lower():find("admiral") or v.Name:lower():find("king") or v.Name:lower():find("beard") or v.Name:lower():find("kaido") or v.Name:lower():find("rip_") then
                table.insert(bossList, v.Name)
            end
        end
    end
    return bossList
end

-- [ATUALIZA O MAR ATUAL]
local function UpdateCurrentSea()
    local map = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("MAP")
    if map then
        if map:FindFirstChild("FountainCity") then
            CurrentSea = "First Sea"
        elseif map:FindFirstChild("Kingdom of Rose") then
            CurrentSea = "Second Sea"
        elseif map:FindFirstChild("Port Town") then
            CurrentSea = "Third Sea"
        end
    end
end

-- [LOOP PRINCIPAL]
RunService.RenderStepped:Connect(function()
    -- ESPs
    if PlayerESPEnabled then DrawESPPlayer() else RemoveESPPlayer() end
    if FruitESPEnabled then DrawESPFruit() else RemoveESPFruit() end
    -- Atualiza lista bosses
    local bosses = GetBossList()
    BossListLabel.Text = "Bosses spawnados:\n"
    if #bosses == 0 then
        BossListLabel.Text = BossListLabel.Text .. "Nenhum boss visível."
    else
        for i,b in ipairs(bosses) do
            BossListLabel.Text = BossListLabel.Text.."• "..b.."\n"
        end
    end
    -- Atualiza mar atual
    UpdateCurrentSea()
    -- Farm
    if AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local mob = FindNearestMob()
        if mob then AttackMob(mob) end
    end
    if FarmNearest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local mob = FindNearestMob()
        if mob then AttackMob(mob) end
    end
    if FarmAllBosses and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _,boss in ipairs(FindAllBosses()) do
            AttackMob(boss)
            wait(0.5)
        end
    end
end)

for _, btn in pairs(MainFrame:GetChildren()) do
    if btn:IsA("TextButton") then
        btn.TextWrapped = true
        btn.TextScaled = true
        btn.AutoButtonColor = true
        btn.BackgroundTransparency = 0.1
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
    end
end

ScreenGui.InputBegan:Connect(function(input)
    if MainFrame.Visible and input.UserInputType == Enum.UserInputType.Touch then
        if not MainFrame.AbsolutePosition:PointInRect(input.Position) then
            MainFrame.Visible = false
        end
    end
end)

-- FIM
