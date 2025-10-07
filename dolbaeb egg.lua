-- === ШАГ 0: Получаем персонажа === --
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
if not hum then
    warn("Humanoid не найден!")
    return
end
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- === Аргументы атак === --
local attackArgs = {
    {
        A = char,
        AN = "The Eggsterminator",
        O = Vector3.new(-20.569494247436523, 83.16070556640625, -229.44720458984375),
        D = Vector3.new(0.6126425862312317, -0.7733386158943176, -0.1631452739238739),
        T = workspace:WaitForChild("#GAME"):WaitForChild("Folders"):WaitForChild("AccessoryFolder"):WaitForChild("The Eggsterminator"),
        SP = Vector3.new(-3.698265552520752, 69.24060821533203, -238.54220581054688),
        HP = Vector3.new(-3.645169258117676, 69.17046356201172, -238.52304077148438),
        RS = Vector3.new(-3.698265552520752, 69.24060821533203, -238.54220581054688)
    }
}
local explosionArgs = function(pos)
    return {
        {
            ALV = Vector3.new(12.233718872070312, -408.0533752441406, -2.1072115898132324),
            A = char,
            AN = "The EggsterminatorExplode",
            EP = pos
        }
    }
end

-- === ШАГ 1: АТАКУЕМ CrackedBas ДО СМЕРТИ === --
local crackedBas = workspace["#GAME"].Folders.HumanoidFolder.NPCFolder:FindFirstChild("CrackedBas")
if not crackedBas then
    warn("CrackedBas не найден!")
    return
end
local crackedBasHumanoid = crackedBas:FindFirstChild("Humanoid")
if not crackedBasHumanoid then
    warn("CrackedBas.Humanoid не найден!")
    return
end
print("Атакуем CrackedBas...")
while crackedBasHumanoid.Parent and crackedBasHumanoid.Health > 0 do
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("MainAttack"):FireServer(unpack(attackArgs))
    end)
    wait(0.1)
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("MainAttack"):FireServer(unpack(explosionArgs(Vector3.new(45.0675163269043, 0.04987591505050659, -246.93588256835938))))
    end)
    wait(0.1)
end
print("CrackedBas убит. Ждём 5 секунд...")
wait(5)

-- === ШАГ 2: НАЖИМАЕМ НА ClickDetector В МАГАЗИНЕ === --
local shopDetector = workspace["#GAME"].Map._Other.Shop.ShopPictureFrame.Back.ClickDetector
if shopDetector and shopDetector.Parent then
    print("Нажимаем на ClickDetector магазина...")
    fireclickdetector(shopDetector)
else
    warn("ClickDetector магазина не найден!")
end
wait(3)

-- === ШАГ 3: ОТКРЫВАЕМ ДВЕРЬ ПЕРЕД ПОЛЁТОМ К ТОЧКЕ A === --
local door = workspace["#GAME"].Map.BlackRoom.WhiteRoom.Door
local doorDetector = door:FindFirstChild("ClickDetector")
if not doorDetector then
    warn("ClickDetector двери не найден!")
else
    print("Открываем дверь перед полётом к точке A...")
    fireclickdetector(doorDetector)
    wait(1)
end

-- === ШАГ 4: ПОЛЁТ К ТОЧКЕ A === --
local targetPosA = CFrame.new(
    2.07887316, 9962.97754, -55.1692734,
    0.147809565, -0.00526440004, 0.989001811,
    -8.41264036e-09, 0.999985814, 0.00532286847,
    -0.989015818, -0.000786779157, 0.147807464
)
print("Летим к точке A...")
local tween1 = tweenService:Create(humanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = targetPosA})
tween1:Play()
tween1.Completed:Wait()

-- === ШАГ 5: ПОЛЁТ К ТОЧКЕ B === --
local targetPosB = CFrame.new(
    -0.118163608, 9965.26172, -6.33421898,
    -1, -3.31514201e-07, 7.22597633e-07,
     4.16675006e-09, 0.906712592, 0.421749055,
    -7.950004155e-07, 0.421749055, -0.906712592
)
print("Летим к точке B...")
local tween2 = tweenService:Create(humanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = targetPosB})
tween2:Play()
tween2.Completed:Wait()
print("Прибыли на точку B. Фиксируем позицию до смерти WhiteBas...")
humanoidRootPart.Anchored = true
local bodyPos = Instance.new("BodyPosition")
bodyPos.MaxForce = Vector3.new(1e7, 1e7, 1e7)
bodyPos.D = 500
bodyPos.P = 10000
bodyPos.Position = targetPosB.Position
bodyPos.Parent = humanoidRootPart
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
bodyGyro.D = 200
bodyGyro.P = 20000
bodyGyro.CFrame = targetPosB
bodyGyro.Parent = humanoidRootPart

-- === ЖДЁМ 1 СЕКУНДУ, ЗАКРЫВАЕМ ДВЕРЬ === --
print("Ждём 1 секунду перед закрытием двери...")
wait(1)
if doorDetector then
    print("Закрываем дверь...")
    fireclickdetector(doorDetector)
    wait(1)
end

-- === ШАГ 6: АТАКУЕМ WhiteBas ДО СМЕРТИ === --
local whiteBas = workspace["#GAME"].Folders.HumanoidFolder.NPCFolder:FindFirstChild("WhiteBas")
if not whiteBas then
    warn("WhiteBas не найден!")
    bodyPos:Destroy()
    bodyGyro:Destroy()
    humanoidRootPart.Anchored = false
    return
end
local whiteBasHumanoid = whiteBas:FindFirstChild("Humanoid")
if not whiteBasHumanoid then
    warn("WhiteBas.Humanoid не найден!")
    bodyPos:Destroy()
    bodyGyro:Destroy()
    humanoidRootPart.Anchored = false
    return
end
local floorPart = workspace["#GAME"].Map.BlackRoom.WhiteRoom.Floor
if not floorPart then
    warn("Floor не найден!")
    bodyPos:Destroy()
    bodyGyro:Destroy()
    humanoidRootPart.Anchored = false
    return
end
print("Начинаем атаку WhiteBas...")
while whiteBasHumanoid.Parent and whiteBasHumanoid.Health > 0 do
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("MainAttack"):FireServer(unpack(attackArgs))
    end)
    wait(0.1)
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("MainAttack"):FireServer(unpack(explosionArgs(floorPart.Position)))
    end)
    wait(0.1)
end
print("WhiteBas убит.")
bodyPos:Destroy()
bodyGyro:Destroy()
humanoidRootPart.Anchored = false

-- === ШАГ 7: ТЕЛЕПОРТ НА ФИНАЛЬНУЮ ТОЧКУ === --
local finalPos = CFrame.new(
    -0.111955911, 9940.49805, 0.599699318,
    -0.139257208, -4.95666654e-08, 0.99025625,
    -6.72152511e-09, 1, 4.91091541e-08,
    -0.99025625, 1.82771215e-10, -0.139257208
)
print("Телепортируемся на финальную точку...")
humanoidRootPart.Anchored = true
humanoidRootPart.CFrame = finalPos
task.wait(0.1)

local function stabilizeAtCFrame(targetCFrame, duration)
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e7, 1e7, 1e7)
    bp.D = 500
    bp.P = 10000
    bp.Position = targetCFrame.Position
    bp.Parent = humanoidRootPart
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
    bg.D = 200
    bg.P = 20000
    bg.CFrame = targetCFrame
    bg.Parent = humanoidRootPart
    wait(duration)
    bp:Destroy()
    bg:Destroy()
    humanoidRootPart.Anchored = false
end
stabilizeAtCFrame(finalPos, 3)
print("Финальная точка достигнута. Миссия завершена.")

-- =============================================================================
-- 🟡 ЭТАП 2: АВТО-ПОЕДАНИЕ WhiteBas (ровно 10 секунд) — БЕЗ ОШИБКИ Disconnect
-- =============================================================================

print("🟢 Запускаем авто-поедание 'WhiteBas' на 10 секунд...")
local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("MainAttack")
local camera = workspace.CurrentCamera
local mainFolder = workspace["#GAME"].Folders.HumanoidFolder.NPCFolder
local TARGET_NAME = "WhiteBas"

local function getDeadWhiteBas()
    local npc = mainFolder:FindFirstChild(TARGET_NAME)
    if not npc then return nil end
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if humanoid and (humanoid.Health <= 0 or string.find(humanoid.Name, "Dead", 1, true)) then
        return npc
    end
    return nil
end

local function getValidBodyParts(model)
    local validParts = {}
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and not part:GetAttribute("IsGettingEaten") then
            table.insert(validParts, part)
        end
    end
    return validParts
end

local eatingActive = true
local heartbeatConn = nil  -- Объявляем заранее

heartbeatConn = runService.Heartbeat:Connect(function()
    if not eatingActive then
        if heartbeatConn then
            heartbeatConn:Disconnect()
        end
        return
    end
    local whiteBas = getDeadWhiteBas()
    if not whiteBas then return end
    local parts = getValidBodyParts(whiteBas)
    if #parts == 0 then return end
    local part = parts[math.random(1, #parts)]
    local origin = camera.CFrame.Position
    local targetPos = part.Position + Vector3.new(
        (math.random() - 0.5) * 1,
        (math.random() - 0.5) * 1,
        (math.random() - 0.5) * 1
    )
    local direction = (targetPos - origin).Unit or camera.CFrame.LookVector
    pcall(function()
        remote:FireServer({
            ["AN"] = "Eat",
            ["D"] = direction,
            ["O"] = origin,
            ["FBP"] = part
        })
    end)
end)

task.delay(10, function()
    eatingActive = false
    print("🍽️ Авто-поедание завершено (10 сек прошло).")
end)
task.wait(10)

-- =============================================================================
-- 🟡 ЭТАП 3: АВТО-ВЗЯТИЕ ИНСТРУМЕНТОВ (Eat, AHHH...) — С ПЕРЕКЛЮЧЕНИЕМ ПО T
-- =============================================================================

print("🔁 Запускаем авто-взятие инструментов... (нажми T, чтобы включить/выключить)")

local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack")

local EAT_NAMES = {"Eat", "Eat?", "Eaht", "Eahht", "Eahhht", "Eahhh", "ahhh", "AHHH"}
local ValidNameLookup = {}
for _, name in ipairs(EAT_NAMES) do
    ValidNameLookup[string.lower(name)] = true
end
local function IsEatName(name)
    return ValidNameLookup[string.lower(name)] == true
end
local function FindEatTool()
    for _, container in ipairs({backpack, char}) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and IsEatName(item.Name) then
                return item
            end
        end
    end
    return nil
end

local autoEquipEnabled = true
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        autoEquipEnabled = not autoEquipEnabled
        print("🔹 Авто-взятие: " .. (autoEquipEnabled and "ВКЛ" or "ВЫКЛ"))
    end
end)

task.spawn(function()
    while true do
        if autoEquipEnabled then
            local tool = FindEatTool()
            if tool then
                if not char:FindFirstChild(tool.Name) then
                    pcall(hum.EquipTool, hum, tool)
                    print("🔹 [Auto-Equip] Взят: " .. tool.Name)
                end
                task.wait(0.1)
                pcall(hum.UnequipTools, hum)
                print("🔸 [Auto-Equip] Снят")
                task.wait(0.1)
            else
                task.wait(0.1)
            end
        else
            task.wait(0.1)
        end
    end
end)

-- =============================================================================
-- 🔴 ЭТАП 4: АВТО-КЛИКИ + УПРАВЛЕНИЕ ДВЕРЬЮ ДЛЯ BlueBas & GreyBas
-- =============================================================================

print("🎮 Запускаем систему кликов и управления дверью...")

local GAME = workspace["#GAME"]
local MAP = GAME.Map
local DOOR = MAP.BlackRoom.WhiteRoom.Door
local DOOR_CLICK = DOOR:FindFirstChild("ClickDetector")
if not DOOR_CLICK then
    warn("❌ ClickDetector двери не найден!")
    return
end

-- --- Цели ---
local PATHS = {
    BlueBas           = "workspace['#GAME'].Map.BlueBas.ClickDetector",
    GreyBas           = "workspace['#GAME'].Map.GreyBas.ClickDetector",
    YellowBas         = "workspace['#GAME'].Map.YellowBas.ClickDetector",
    WhiteBasFakeHead  = "workspace['#GAME'].Map.WhiteBasFakeHead.ClickDetector",
    WhiteBas          = "workspace['#GAME'].Map.WhiteBas.ClickDetector",
    BlackBas          = "workspace['#GAME'].Map.BlackBas.ClickDetector"
}

-- --- Состояние ---
local State = {
    BlueBasActive = false,
    GreyBasActive = false
}

local function safeFire(detector, label)
    spawn(function()
        pcall(fireclickdetector, detector)
        print("🖱️ Кликнули по: " .. label)
    end)
end

local function getDetector(pathStr)
    local success, result = pcall(function()
        return loadstring("return " .. pathStr)()
    end)
    if success and result and result.Parent and result:IsA("ClickDetector") then
        return result
    end
    return nil
end

-- =================== [ BlueBas ] =================== --
spawn(function()
    while wait(0.1) do
        -- МЕНЯЕМ ТОЛЬКО ЭТУ СТРОКУ: проверяем сам Part, а не его ClickDetector
        local bluebasPart = workspace["#GAME"].Map:FindFirstChild("BlueBas")
        local exists = bluebasPart and bluebasPart:IsA("BasePart")

        if exists and not State.BlueBasActive then
            State.BlueBasActive = true
            print("🔵 BlueBas появился! Открываем дверь...")
            safeFire(DOOR_CLICK, "Door (открыть)")
        elseif not exists and State.BlueBasActive then
            State.BlueBasActive = false
            print("🔵 BlueBas исчез.")
            if not State.GreyBasActive then
                print("🚪 GreyBas тоже нет → закрываем дверь.")
                safeFire(DOOR_CLICK, "Door (закрыть после BlueBas)")
            end
        end
    end
end)

-- =================== [ GreyBas ] =================== --
spawn(function()
    while wait(0.1) do
        local det = getDetector(PATHS.GreyBas)
        if det and not State.GreyBasActive then
            State.GreyBasActive = true
            print("🟨 GreyBas появился! Кликаем, чтобы исчез...")
            safeFire(det, "GreyBas")
            task.wait(0.5)
        elseif not det and State.GreyBasActive then
            State.GreyBasActive = false
            print("🟨 GreyBas исчез.")
            if not State.BlueBasActive then
                print("🚪 BlueBas тоже нет → закрываем дверь.")
                safeFire(DOOR_CLICK, "Door (закрыть после GreyBas)")
            end
        end
    end
end)

-- =================== [ АВТО-КЛИКЕРЫ (0.1 сек) ] =================== --

local function startAutoClicker(npcName, path)
    spawn(function()
        while wait(0.1) do
            local detector = getDetector(path)
            if detector then
                safeFire(detector, npcName .. " (автоклик)")
            end
        end
    end)
end

for npcName, path in pairs(PATHS) do
    startAutoClicker(npcName, path)
end

print("✅ Все системы запущены: кач → поедание → авто-взятие → авто-клики.")

-- =============================================================================
-- 🔵 ЭТАП 5: УПРАВЛЕНИЕ ДВЕРЬЮ ПО КЛАВИШЕ R
-- =============================================================================

print("🚪 Подключаем ручное управление дверью: нажмите [R], чтобы открыть/закрыть")

local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R then
        if DOOR_CLICK and DOOR_CLICK.Parent then
            pcall(function()
                fireclickdetector(DOOR_CLICK)
                local isOpen = DOOR:GetAttribute("Open") or false
                print("🚪 Дверь " .. (isOpen and "закрыта" or "открыта") .. " (по R)")
            end)
        else
            warn("❌ Невозможно взаимодействовать с дверью: ClickDetector недоступен")
        end
    end
end)

-- LocalScript (в StarterPlayerScripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Путь к месту телепортации
local targetPart = workspace:FindFirstChild("#GAME")
    and workspace["#GAME"].Map.BlackRoom.WhiteRoom:FindFirstChild("Ahh")

if not targetPart then
    warn("Не найдено место телепортации: workspace['#GAME'].Map.BlackRoom.WhiteRoom.Ahh")
    return
end

local active = true

-- Самый быстрый способ — Heartbeat (выполняется каждый кадр)
RunService.Heartbeat:Connect(function()
    if not active or not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    -- Мгновенный телепорт
    humanoidRootPart.CFrame = CFrame.new(targetPart.Position)
end)

-- Остановка по нажатию Y
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Y then
        active = false
        print("Телепортация остановлена.")
    end
end)

print("Телепортация активирована. Нажмите Y, чтобы остановить.")

wait(0.5)

-- Получаем дверь и её ClickDetector
local DOOR = workspace["#GAME"].Map.BlackRoom.WhiteRoom.Door
local CLICK_DETECTOR = DOOR:FindFirstChild("ClickDetector")

if not CLICK_DETECTOR then
    warn("❌ ClickDetector не найден!")
    return
end

-- Подключаем сервис ввода
local UserInputService = game:GetService("UserInputService")

-- Флаг для остановки цикла
local shouldStop = false

-- Обработчик нажатия клавиш
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Игнорируем, если UI обработало ввод
    if input.KeyCode == Enum.KeyCode.E then
        shouldStop = true
        print("🛑 Остановка скрипта по нажатию E")
    end
end)

-- Шаблон CFrame для закрытого состояния (ориентация)
local CLOSED_ORIENTATION = CFrame.new(
    0, 0, 0,
    8.10623169e-05, -8.10623169e-05, -1,
    -1, 8.10623169e-05, -8.10623169e-05,
    8.10623169e-05, 1, -8.10623169e-05
)

-- Функция: получить только поворот (ориентацию) CFrame
local function getOrientation(cf)
    return CFrame.fromMatrix(Vector3.new(0, 0, 0), cf.XVector, cf.YVector, cf.ZVector)
end

-- Функция: проверить, закрыта ли дверь (с допуском)
local function isDoorClosed()
    local current = getOrientation(DOOR.CFrame)
    local target = CLOSED_ORIENTATION
    local diff = (current.LookVector - target.LookVector).Magnitude +
                 (current.RightVector - target.RightVector).Magnitude +
                 (current.UpVector - target.UpVector).Magnitude
    return diff < 0.1
end

-- Основной цикл
while not shouldStop do
    if not isDoorClosed() then
        -- Дверь НЕ закрыта → кликаем, чтобы закрыть
        pcall(fireclickdetector, CLICK_DETECTOR)
        print("🚪 Дверь открыта — закрываем!")
    end
    wait(0.4) -- Проверка каждые 0.2 секунды
end
