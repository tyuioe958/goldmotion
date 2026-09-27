local PS = game:GetService("Players")
local RS = game:GetService("RunService")

function RoClothes(Player)
    print("RoCC")

    -- ============================================================
    -- 全局变量（原代码 variables 部分，原样保留）
    -- ============================================================
    local Mouse = Player:GetMouse()

    local Method2CharacterFolder = game.Workspace:FindFirstChild("Method2CharacterFolder")
    if not Method2CharacterFolder then
        Method2CharacterFolder = Instance.new("Folder", game.Workspace)
        Method2CharacterFolder.Name = "Method2CharacterFolder"
    end

    local IS   = game:GetService("InsertService")
    local UIS  = game:GetService("UserInputService")
    local TS   = game:GetService("TweenService")
    local MPS  = game:GetService("MarketplaceService")

    local CVersion = "0.7.8:lerp()"

    local loadupBundle  = "nil"
    local loadupExecute = false
    local loadupClosed  = false

    local Method     = 2
    local MaxMethod  = 3

    local MaxBreastsType = 4
    local MaxTorsoType   = 8
    local MaxArmType     = 4
    local MaxLegsType    = 6
    local MaxButtType    = 3

    local KEYBIND = Enum.KeyCode.Insert
    local KeybindDetect = false

    local hpKEYBIND = Enum.KeyCode.Equals
    local hpKeybindDetect = false

    local ClickExecute = false

    local IsEnterFrame = false
    local IsMouseDown  = false

    local GuiPositionStart = nil
    local MouseDownStart   = nil

    local AllConnect    = {}
    local MeshEditConnect = {}
    local Debug = false

    local SelectPlayer = Player.Name

    local DarkerColorPercentage  = 17.75
    local Darker2ColorPercentage = 32.75

    local Circle            = 2 * math.pi
    local PreviewRotate     = 0
    local PreviewRadius     = 5
    local PreviewRotateSpeed = 200
    local CharacterPreviewLoading = false

    local NPCs = {}

    local PositionPhysicsMultiply = 1
    local RotationPhysicsMultiply = 4

    -- tail stuff --
    local includedAccessoryNames = {}
    local timeStep         = 1 / 120
    local inverseTimeStep  = 1 / timeStep

    local wagAnimationDropAmplitude = 0.2
    local wagAnimationSwayAmplitude = 0.4
    local wagAnimationRollAmplitude = 0.5

    local wagAnimationBlendInAlpha  = 0.008
    local wagAnimationBlendOutAlpha = 0.02

    local movementDistanceThreshold = 15

    local tailVariables = {
        ["Default"] = {
            tailScaledAnimationTime = 0,
            tailScaledTime = 0,
            accumulator = 0,
        }
    }

    local globalWindEnabled = false
    local gravityEnabled    = false

    local customPersistantWindForce   = Vector3.new(0, 0, 0)
    local customPersistantLinearForce = Vector3.new(0, 0, 0)
    -- end tail stuff --

    local Function = { Spring = {} }
    local PlayerData = {}
    local PartList
    local Bundle
    local Clothes
    local MetaClothes

    -- ============================================================
    -- WindUI 界面构建
    -- ============================================================
    local Window = WindUI:CreateWindow({
        Title  = "RoClothes modded",
        Author = "Version - " .. CVersion,
        Icon   = "shirt",
        Theme  = "Dark",
        Size   = UDim2.fromOffset(580, 460),
        ToggleKeybind = Enum.KeyCode.Insert,
        Folder = "RoClothes",
    })

    local Tabs = {}

    Tabs.Menu = Window:Tab({ Title = "Menu",     Icon = "home" })
    Tabs.Settings = Window:Tab({ Title = "Settings", Icon = "settings" })
    Tabs.Body = Window:Tab({ Title = "Body",     Icon = "user" })
    Tabs.Clothes = Window:Tab({ Title = "Clothes",  Icon = "shirt" })
    Tabs.Bundles = Window:Tab({ Title = "Bundles",  Icon = "package" })
    Tabs.Catalog = Window:Tab({ Title = "Catalog",  Icon = "shopping-cart" })
    Tabs.Edit = Window:Tab({ Title = "Edit",     Icon = "pencil" })
    Tabs.Recolor = Window:Tab({ Title = "Recolor",  Icon = "palette" })
    Tabs.HP = Window:Tab({ Title = "HP",       Icon = "heart" })
    Tabs.Tail = Window:Tab({ Title = "Tail",     Icon = "activity" })

    -- 组件引用表（替代原来的 GUIObject.XXX）
    -- 在第 6~10 段里逐个填充
    local UI = {}

    -- 分隔线，方便后面加内容
    local MainSection = Tabs.Menu:Section({ Title = "General" })
    -- ============================================================
-- 数据表（原样保留）
-- ============================================================

local R15Size = {
    ["UpperTorso"]     = Vector3.new(2.043, 1.796, 1.01),
    ["UpperTorsoFemale"] = Vector3.new(2.043, 1.796, 1.01),
    ["RightLowerArm"]  = Vector3.new(1, 0.78, 1),
    ["LeftLowerArm"]   = Vector3.new(1, 0.78, 1),
    ["RightLowerLeg"]  = Vector3.new(1, 1.231, 1.335),
    ["LeftLowerLeg"]   = Vector3.new(1, 1.231, 1.335),
}

local R15Transparency = {
    "UpperTorso","LowerTorso",
    "RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperLeg","RightLowerLeg","RightFoot",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot",
}

local R6Size = {
    ["Head"]      = Vector3.new(2, 1, 1),
    ["Torso"]     = Vector3.new(2, 2, 1),
    ["Left Arm"]  = Vector3.new(1, 2, 1),
    ["Left Leg"]  = Vector3.new(1, 2, 1),
    ["Right Arm"] = Vector3.new(1, 2, 1),
    ["Right Leg"] = Vector3.new(1, 2, 1),
}

local WeldCFrame = {
    ["Torso"]     = CFrame.new(0, -0.2, 0),
    ["Right Arm"] = CFrame.new(0, 0.2, 0),
    ["Left Arm"]  = CFrame.new(0, 0.2, 0),
    ["Right Leg"] = CFrame.new(0, 0.2, 0),
    ["Left Leg"]  = CFrame.new(0, 0.2, 0),
}

local ConvertPart = {
    ["Torso"]     = "UpperTorso",
    ["Right Arm"] = "RightLowerArm",
    ["Left Arm"]  = "LeftLowerArm",
    ["Right Leg"] = "RightLowerLeg",
    ["Left Leg"]  = "LeftLowerLeg",
}

local R6Mesh = {
    ["TorsoMale"]   = "rbxassetid://456901040",
    ["TorsoFemale"] = "rbxassetid://9747912904",
    ["Right Arm"]   = "rbxassetid://5062992824",
    ["Left Arm"]    = "rbxassetid://5062992824",
    ["Right Leg"]   = "rbxassetid://5062992824",
    ["Left Leg"]    = "rbxassetid://5062992824",
}

-- 说明：PartListDefault 是一个巨大的表（第八~十一段），
-- 内容原封不动，此处仅给出骨架，完整内容请从你的原代码中直接复制过来。
function Function.PartListDefault()
    return {
        -- [[ 原样保留你第八 ~ 十一段的所有 Mesh / Part / 数值 ]]
    }
end

-- Bundle 表：原样保留第九段（Preset / ClothingBundle / 服装等）
Bundle = {
    -- [[ 原样保留你第九段的 Bundle 数据 ]]
}

-- Clothes 表：原样保留第九 ~ 十一段（School Shirt / Skirt 等）
Clothes = {
    -- [[ 原样保留你第九 ~ 十一段的 Clothes 数据 ]]
}

-- MetaClothes：原样保留第十一段末尾
MetaClothes = {
    __index = {
        ["Name"]        = "Clothes",
        ["TextureId"]   = "",
        ["DoubleSided"] = false,
        ["Size"]        = Vector3.new(1,1,1),
        ["CFrame"]      = CFrame.new(0,0,0),
        ["CFrame1"]     = CFrame.new(0,0,0),
        ["Offset"]      = Vector3.new(0,0,0),
        ["Rotation"]    = Vector3.new(0,0,0),
        ["Transparency"]= 0,
        ["Reflectance"] = 0,
        ["MeshBasePartTransparency"] = 0,
        ["Material"]    = Enum.Material.SmoothPlastic,
        ["Shape"]       = Enum.PartType.Block,
        ["Color"] = {
            ["Tone"]  = "Base",
            ["Color"] = Color3.fromRGB(163, 162, 165),
        },
        ["Parent"] = { [1] = "Torso" },
        ["Function"] = "",
        ["Scale"] = nil,
        ["AdjustScale"] = {"Size", "CFrame", "CFrame1"},
    }
}

PartList = Function.PartListDefault()
-- ============================================================
-- 核心函数（原样保留，UI 无关）
-- ============================================================

function Function.PlayerDataDefault()
    return {
        Character = nil,

        isTailCurrentlyEnabled = true,
        tailSettings = {
            tailPhysicsEnabled = true,
            stiffness        = 96,
            damping          = 9,
            linearAmplitude  = Vector3.new(20, 11, 20),
            angularAmplitude = Vector3.new(0, 25, 0),
            timeScale        = 1,
            wagAnimationEnabled = true,
            wagAnimationSpeed   = 1,
        },

        CurrentClothes = {},
        ClothesRecolor = {},
        CurrentBundle = "nil",
        AutoExecute = true,
        DelayTime = 1,
        Tone = "Base",
        BundleBodyColor = true,
        Face = true,
        MeshSizeLock = false,
        AccessorySizeLock = false,
        MeshBasePartInvisible = false,
        BodyPartPhysics = false,
        PhysicsObeyGravity = true,
        CatalogUsername = "",
        CatalogOutfitId = "",
        CatalogClothes = { Shirt = "", Pants = "", ShirtGraphic = "" },
        OldestClothings = { Shirt = nil, Pants = nil, ShirtGraphic = nil },
        CatalogAccessory = {},
        CatalogRemove = {},
        SkinTone = nil,
        NippleColor = nil,
        CockScale = 1,
        BreastsScale = 1,
        ButtsScale = 1,
        LegsScale = 1,
        BreastsType = 1,
        TorsoType = 1,
        ArmType = 1,
        LegsType = 1,
        ButtType = 1,
        ToggleBBC = false,
        Cooldown = false,
        updateCooldown = false,
        FPsnap = false,
        FPerson = false,
        HeadTracking = true,
        RealtimeBodyTransparency = true,
        OldTransparency = {},

        TopRipped = false,
        BottomRipped = false,
        SavedPreviousHP = 0,
        SavedTopHP = 0,
        SavedBottomHP = 0,
        Healing = false,
        HealProgress = 0,
        HardcoreHP = false,
        TopHP = "",
        BottomHP = "",
        HPClothes = { Shirt = "", Pants = "" },
        DamageSFX = "",
        Volume = 1,
        TearParticles = true,
        HealParticles = true,

        PartList = Function.PartListDefault(),

        LocalTransparency = {
            ["Head"]      = false,
            ["Right Arm"] = false,
            ["Left Arm"]  = false,
            ["Torso"]     = false,
            ["Right Leg"] = false,
            ["Left Leg"]  = false,
            ["Hat"]       = true,
        },

        CurrentPartList = {
            Organ = {},
            Clothes = {},
            Accessory = {},
            TransparencyLink = {},
            ParentTransparency = {},
            RealtimeUpdateList = { Mesh = {}, Accessory = {}, Special = {} },
            PartParent = {},
            BodyPartPhysics = {},
            physicsTails = {},
            AreolaDecal = {},
        },
        ConvertedPart = {}
    }
end

-- 以下函数从你的原代码中**原样保留**，我只列函数名，
-- 具体函数体请从你发的第 13~25 段直接复制粘贴，逻辑完全不变：
--
--   Function.CumDripDisplay
--   Function.Lactation
--   Function.OilUp / OilUp2 / OilUp3 / OilUpOld
--   Function.addFreckles
--   Function.nippleCensor
--   Function.TurtleTexture
--   Function.StringTexture
--   Function.FabricTexture
--   Function.SockLineDecal
--   Function.AreolaDecalCreate
--   Function.AreolaDecalType2Create
--   Function.Spring（完整模块，含 new / Impulse / TimeSkip / __index / __newindex / _positionVelocity）
--   Function.AttachmentCreate
--   Function.HeadMesh
--   Function.Dummy
--   Function.CharacterPreview
--   Function.SpringCreate
--   Function.MinMaxCalulate
--   Function.CFrameOrientation
--   Function.MultiplyCalculate
--   Function.UIStrokeCreate（★ 这条在 WindUI 版里不再需要，可删除）
--   Function.Weld（★ 核心，保留）
--   Function.CharacterFunction
--   Function.BodyColorForceSet
--   Function.BodyColorSet
--   Function.BodyColorsFunction
--   Function.AccessoryAdd
--   Function.HumanoidDescriptionSet
--   Function.HumanoidDescriptionLoader
--   Function.AccessoryLoaderFunction
--   Function.CatalogLoader
--   Function.TableFind
--   Function.TableClone
--   Function.CharacterReset
--   Function.RodPhysics
--   Function.BBCBallPhysics
--   Function.Converter
--   Function.CharacterExecute
--   Function.CharacterConnection
--   Function.StringTo
--   Function.MeshEditButton（★ 这个要改：见第 8 段，因为 Edit Tab 变了）
--   Function.DragUpdate（★ 不再需要，WindUI 自带拖动，可删除）
--   Function.IsCharacter
--   Function.GUIUpdate（★ 要重写，见第 6 段）
--   Function.FallenPartCheck
--   Function.IsParentNil
--   Function.GetMiddleNumber
-- ============================================================
-- 尾巴物理 / Spring（原样保留）
-- ============================================================

-- 说明：
--   你原代码第 15 段里的以下内容**全部原样保留**，逻辑一字不改：
--
--   local modelInstance           = Instance.new("Model")
--   local modelGetScale           = modelInstance.GetScale
--   local cframeIdentity          = CFrame.identity
--   local cframeToObjectSpace     = cframeIdentity.ToObjectSpace
--   local cframeVectorToObjectSpace = cframeIdentity.VectorToObjectSpace
--   local cframeInverse           = cframeIdentity.Inverse
--   local cframeToEulerAnglesXYZ  = cframeIdentity.ToEulerAnglesXYZ
--   local cframeFromEulerAngles   = CFrame.fromEulerAngles
--   local cframeNew               = CFrame.new
--
--   local function calculateElasticity(...)
--   local function vector3ToAngles(...)
--   local function lerp(...)
--   local function cframeOrAttachmentOrNilParameterToCFrame(...)
--   local function nameToTailWagSeed(...)
--   local function updateIncludedAccessoryNamesValidationSet()
--   local function isTailAccessory(accessory)
--   local r6TailPivotOffset = CFrame.new(0, 0.3, 0)
--   local function getTailPivotOffsetFromRoot(root)
--   local function setUpWeld(character, weld, tailPart, customPivotOffset, Data)
--   local function setUpTailAccessory(character, accessory, Data)
--   local function updatePhysicsTailToStatic(physicsTail)
--   local function getTailAnimationOffset(physicsTail, Data)
--   local function updatePhysicsTailToInterpolation(physicsTail, interpolationAlpha, Data)
--
--   local persistantTailWindUnit / persistantTailWindAlpha / ...
--   local function updateTailPersistantWindForceInformation()
--   local function updateTailPersistantLinearForceInformation()
--   local function updateGravityInformation()
--
--   local vector3Zero / vector3Cross / vector3New
--   local function updatePhysicsTail(physicsTail, updateWeld, interpolationAlpha, Data)
--   local cameraPosition = Vector3.zero
--   local function physicsTailsDistanceToCameraComparer(a, b)
--
-- ★ 注意：你原代码里的这两句
--     local workspaceGlobalWindPropertyChangeSignal = workspace:GetPropertyChangedSignal("GlobalWind"):Connect(...)
--     table.insert(AllConnect, workspaceGlobalWindPropertyChangeSignal)
--     local workspaceGravityPropertyChangeSignal = workspace:GetPropertyChangedSignal("Gravity"):Connect(...)
--     table.insert(AllConnect, workspaceGravityPropertyChangeSignal)
--   依旧保留，但 AllConnect 在 WindUI 版本里最终用于"销毁/断开"。

-- 上面这一大块内容请从原代码第 15 段整块复制粘贴到这里。
-- （为了不重复占用篇幅，此处仅做占位说明，逻辑不变。）
-- ============================================================
-- 物理渲染循环 / RealtimeUpdate 循环（原样保留）
-- ============================================================

-- ★ 说明：
--   以下这些循环**整块保留**，逻辑完全不变：
--
--   1) 主 RealtimeUpdate 循环（原代码里那个巨大的
--      while task.wait() do ... end 里处理：
--         - Mesh / Accessory 尺寸自适应
--         - Special 粒子（cTrail / nCensor）
--         - TransparencyLink
--         - ParentTransparency
--         - AreolaDecal
--         - Preview 旋转
--      ）
--
--   2) 第一人称循环（aWhile = task.spawn(function() ... end)）
--      → 处理 HeadTracking / CameraOffset
--
--   3) PhysicsConnect = RS.RenderStepped:Connect(...)
--      → 处理 BodyPartPhysics（胸部 / 屁股 / 阴茎物理）
--
--   4) tailPhysicsConnect = RS.PreRender:Connect(...)
--      → 处理尾巴物理
--
--   这些循环都**不要动**，直接整块拷贝到 WindUI 版本里。

-- ------------------------------------------------------------
-- 鼠标事件：左键 / 右键 / 抬起（原样保留，但 TargetFilter 需要注意）
-- ------------------------------------------------------------
--
-- 原代码里的：
--   local MouseDown  = Mouse.Button1Down:Connect(...)
--   local MouseDown2 = Mouse.Button2Down:Connect(...)
--   local MouseUp    = Mouse.Button1Up:Connect(...)
--   local MouseMoveConnect = Mouse.Move:Connect(Function.DragUpdate)
--
-- ★ 改动：
--   - MouseMoveConnect 那一行可以删掉（WindUI 自带拖拽，Function.DragUpdate 已废弃）
--   - 其它三个原样保留。
--   - 若你以后加了 ClickExecute，它们仍能正常工作。
--
-- 对应的 table.insert(AllConnect, xxx) 也要保留。

-- ------------------------------------------------------------
-- 键盘事件：UIS.InputBegan / InputEnded
-- ------------------------------------------------------------
--
-- 原代码里的 UISBeganConnect / UISEndedConnect：
--   - 处理 KEYBIND（原版是切换 GUIObject.Screen.Enabled）
--   - 处理 hpKEYBIND（补血）
--
-- ★ 改动：
--   KEYBIND 那一行原来写的是：
--     GUIObject.Screen.Enabled = not GUIObject.Screen.Enabled
--   在 WindUI 版本里改成：
--     Window:Toggle()      -- WindUI 内置的显示/隐藏
--
-- 其余逻辑完全不变。

-- ------------------------------------------------------------
-- 窗口拖动（原代码里有 IsEnterFrame / IsMouseDown / GuiPositionStart）
-- ------------------------------------------------------------
--
-- ★ 在 WindUI 版本中，这部分**全部删除**，包括：
--   local FrameEnterConnect = GUIObject.MainFrame.MouseEnter:Connect(...)
--   local FrameLeaveConnect = GUIObject.MainFrame.MouseLeave:Connect(...)
--   Function.DragUpdate
--   以及 IsEnterFrame / IsMouseDown / GuiPositionStart / MouseDownStart 的用法
--   （变量本身可以保留，因为 MouseDown 里还在用 MouseDownStart）
--
-- 但是：
--   MouseDownStart 仍然需要保留，因为 ClickExecute 的射线检测用到它。
--   IsMouseDown 也可以保留（无害）。
--   变量声明保持不动。

-- ------------------------------------------------------------
-- 事件连接登记（全部保留）
-- ------------------------------------------------------------
--
-- 你原代码最后的：
--   table.insert(AllConnect, MouseDown)
--   table.insert(AllConnect, MouseDown2)
--   table.insert(AllConnect, MouseUp)
--   table.insert(AllConnect, UISBeganConnect)
--   table.insert(AllConnect, UISEndedConnect)
--   table.insert(AllConnect, PhysicsConnect)
--   table.insert(AllConnect, tailPhysicsConnect)
--   ...
--
-- ★ 全部保留。
--   MouseMoveConnect / FrameEnterConnect / FrameLeaveConnect 不再插入。
-- ============================================================
-- WindUI — Menu Tab
-- ============================================================

local MenuSection = Tabs.Menu:Section({ Title = "General" })

-- Player Execute
UI.PlayerExecute = MenuSection:Input({
    Title = "Player To Execute",
    Desc  = "Self = Yourself",
    Placeholder = "Self",
    Value = "Self",
    Flag = "PlayerExecute",
    Callback = function(text)
        if PS:FindFirstChild(text) then
            SelectPlayer = text
            Function.PlayerDataAdd(SelectPlayer)
            Function.GUIUpdate()
        elseif text == "Self" then
            SelectPlayer = Player.Name
            Function.PlayerDataAdd(SelectPlayer)
            Function.GUIUpdate()
        end
    end
})

-- Delay Time
UI.DelayTime = MenuSection:Input({
    Title = "Delay Time After Respawn",
    Placeholder = "1",
    Value = "1",
    Flag = "DelayTime",
    Callback = function(text)
        local n = tonumber(text)
        if n then
            PlayerData[SelectPlayer].DelayTime = n
        end
    end
})

-- Execute / Reset / Destroy
MenuSection:Button({
    Title = "Execute",
    Desc  = "Load clothing on the target player",
    Callback = function()
        local ep = PS:FindFirstChild(SelectPlayer)
        if ep and ep.Character then
            Function.CharacterReset(ep.Name)
            Function.CharacterExecute(ep.Character, ep.Name)
        end
    end
})

MenuSection:Button({
    Title = "Reset",
    Desc  = "Reset target's clothes",
    Callback = function()
        Function.CharacterReset(SelectPlayer)
        if Method2CharacterFolder:FindFirstChild(SelectPlayer) then
            Method2CharacterFolder[SelectPlayer]:Destroy()
        end
    end
})

MenuSection:Button({
    Title = "Destroy",
    Desc  = "Stop RoClothes",
    Callback = function()
        local BreakerInstance = Instance.new("BoolValue", game.Workspace)
        BreakerInstance.Name = "RoClothesBreaker"
        game:GetService("Debris"):AddItem(BreakerInstance, 2)
    end
})

-- ------------------------------------------------------------
-- Toggles 区
-- ------------------------------------------------------------
local ToggleSection = Tabs.Menu:Section({ Title = "Toggles" })

UI.AutoExecute = ToggleSection:Toggle({
    Title = "Auto Execute",
    Desc  = "Re-apply after respawn",
    Flag  = "AutoExecute",
    Value = true,
    Callback = function(state)
        PlayerData[SelectPlayer].AutoExecute = state
    end
})

UI.BundleBodyColor = ToggleSection:Toggle({
    Title = "Bundle Body Color",
    Flag  = "BundleBodyColor",
    Value = true,
    Callback = function(state)
        PlayerData[SelectPlayer].BundleBodyColor = state
    end
})

UI.Face = ToggleSection:Toggle({
    Title = "Face",
    Flag  = "Face",
    Value = true,
    Callback = function(state)
        PlayerData[SelectPlayer].Face = state
    end
})

UI.MeshSizeLock = ToggleSection:Toggle({
    Title = "Mesh Size Lock",
    Flag  = "MeshSizeLock",
    Value = false,
    Callback = function(state)
        PlayerData[SelectPlayer].MeshSizeLock = state
    end
})

UI.AccessorySizeLock = ToggleSection:Toggle({
    Title = "Accessory Size Lock",
    Flag  = "AccessorySizeLock",
    Value = false,
    Callback = function(state)
        PlayerData[SelectPlayer].AccessorySizeLock = state
    end
})

UI.MeshBasePartInvisible = ToggleSection:Toggle({
    Title = "Mesh Base Part Invisible",
    Flag  = "MeshBasePartInvisible",
    Value = false,
    Callback = function(state)
        PlayerData[SelectPlayer].MeshBasePartInvisible = state
    end
})

UI.BodyPartPhysics = ToggleSection:Toggle({
    Title = "Body Part Physics",
    Flag  = "BodyPartPhysics",
    Value = false,
    Callback = function(state)
        PlayerData[SelectPlayer].BodyPartPhysics = state
    end
})

-- ------------------------------------------------------------
-- Tone / Method（点击循环切换）
-- ------------------------------------------------------------
local MiscSection = Tabs.Menu:Section({ Title = "Misc" })

UI.Tone = MiscSection:Button({
    Title = "Tone: Base",
    Desc  = "Click to cycle: Base → Dark → Use NippleColor",
    Callback = function()
        local t = PlayerData[SelectPlayer].Tone
        if t == "Base" then
            PlayerData[SelectPlayer].Tone = "Dark"
        elseif t == "Dark" then
            PlayerData[SelectPlayer].Tone = "Use NippleColor"
        else
            PlayerData[SelectPlayer].Tone = "Base"
        end
        Function.GUIUpdate()
    end
})

UI.Method = MiscSection:Button({
    Title = "Method: 2",
    Desc  = "Click to cycle 1 → 2 → 3",
    Callback = function()
        Method += 1
        if Method > MaxMethod then Method = 1 end
        Function.GUIUpdate()
    end
})

UI.Keybind = MiscSection:Button({
    Title = "Change Keybind",
    Desc  = "Click, then press a key",
    Callback = function()
        if UIS.KeyboardEnabled then
            KeybindDetect = true
            -- 提示
            UI.Keybind:SetTitle("Press any key...")
        end
    end
})
-- ============================================================
-- WindUI — Settings Tab
-- ============================================================

local SettingsInfo = Tabs.Settings:Section({ Title = "Player" })

UI.SettingsPlayer = SettingsInfo:Input({
    Title = "Player",
    Desc  = "Self = yourself",
    Placeholder = "Self",
    Value = "Self",
    Callback = function(text)
        if PS:FindFirstChild(text) then
            SelectPlayer = text
            Function.PlayerDataAdd(SelectPlayer)
            Function.GUIUpdate()
        elseif text == "Self" then
            SelectPlayer = Player.Name
            Function.PlayerDataAdd(SelectPlayer)
            Function.GUIUpdate()
        end
    end
})

-- ------------------------------------------------------------
-- Physics multipliers
-- ------------------------------------------------------------
local SettingsPhysics = Tabs.Settings:Section({ Title = "Physics" })

UI.PositionPhysicsMultiply = SettingsPhysics:Input({
    Title = "Position Physics Multiply",
    Value = "1",
    Callback = function(text)
        if tonumber(text) then
            PositionPhysicsMultiply = tonumber(text)
        end
    end
})

UI.RotationPhysicsMultiply = SettingsPhysics:Input({
    Title = "Rotation Physics Multiply",
    Value = "4",
    Callback = function(text)
        if tonumber(text) then
            RotationPhysicsMultiply = tonumber(text)
        end
    end
})

UI.PhysicsObeyGravity = SettingsPhysics:Toggle({
    Title = "Physics Obey Gravity",
    Value = true,
    Callback = function(state)
        PlayerData[SelectPlayer].PhysicsObeyGravity = state
    end
})

-- ------------------------------------------------------------
-- 第一人称
-- ------------------------------------------------------------
local SettingsFP = Tabs.Settings:Section({ Title = "First Person" })

UI.FPerson = SettingsFP:Toggle({
    Title = "First Person POV",
    Value = false,
    Callback = function(state)
        PlayerData[SelectPlayer].FPerson = state
    end
})

UI.FPsnap = SettingsFP:Toggle({
    Title = "FPerson Snap",
    Value = false,
    Callback = function(state)
        PlayerData[SelectPlayer].FPsnap = state
    end
})

UI.HeadTracking = SettingsFP:Toggle({
    Title = "Head Tracking",
    Value = true,
    Callback = function(state)
        PlayerData[SelectPlayer].HeadTracking = state
    end
})

-- ------------------------------------------------------------
-- 其他
-- ------------------------------------------------------------
local SettingsMisc = Tabs.Settings:Section({ Title = "Misc" })

UI.RealtimeBodyTransparency = SettingsMisc:Toggle({
    Title = "Realtime Body Transparency",
    Value = true,
    Callback = function(state)
        PlayerData[SelectPlayer].RealtimeBodyTransparency = state
    end
})

UI.ClickExecute = SettingsMisc:Toggle({
    Title = "Click Execute",
    Desc  = "Click a character to apply clothes",
    Value = false,
    Callback = function(state)
        ClickExecute = state
    end
})

-- ------------------------------------------------------------
-- Skin / Nipple color
-- ------------------------------------------------------------
local SettingsColor = Tabs.Settings:Section({ Title = "Colors" })

UI.SkinTone = SettingsColor:Input({
    Title = "Skin Tone [RGB]",
    Desc  = "Empty to disable. Format: R,G,B",
    Placeholder = "255,255,255",
    Value = "",
    Callback = function(text)
        if text == "" then
            PlayerData[SelectPlayer].SkinTone = nil
        else
            local color = Function.StringTo(text, "RGB")
            if color then
                PlayerData[SelectPlayer].SkinTone = color
            end
        end
    end
})

UI.NippleColor = SettingsColor:Input({
    Title = "Nipple Color [RGB]",
    Desc  = "Empty to disable. Format: R,G,B",
    Placeholder = "255,255,255",
    Value = "",
    Callback = function(text)
        if text == "" then
            PlayerData[SelectPlayer].NippleColor = nil
        else
            local color = Function.StringTo(text, "RGB")
            if color then
                PlayerData[SelectPlayer].NippleColor = color
            end
        end
    end
})

-- ------------------------------------------------------------
-- Character Preview
-- ------------------------------------------------------------
local SettingsPreview = Tabs.Settings:Section({ Title = "Preview" })

SettingsPreview:Button({
    Title = "Preview Character",
    Desc  = "Open a 3D preview of the target",
    Callback = function()
        Function.CharacterPreview(SelectPlayer)
    end
})

-- ------------------------------------------------------------
-- Keybind + Method（Settings 里也放一份，方便）
-- ------------------------------------------------------------
local SettingsAdv = Tabs.Settings:Section({ Title = "Advanced" })

UI.SettingsMethod = SettingsAdv:Button({
    Title = "Method: 2",
    Desc  = "Click to cycle",
    Callback = function()
        Method += 1
        if Method > MaxMethod then Method = 1 end
        Function.GUIUpdate()
    end
})

UI.SettingsKeybind = SettingsAdv:Button({
    Title = "Change Keybind",
    Desc  = "Click, then press a key",
    Callback = function()
        if UIS.KeyboardEnabled then
            KeybindDetect = true
            UI.SettingsKeybind:SetTitle("Press any key...")
        end
    end
})
-- ============================================================
-- WindUI — Body Tab
-- ============================================================

local BodyScaleSection = Tabs.Body:Section({ Title = "Scale" })

UI.BreastsScale = BodyScaleSection:Input({
    Title = "Breasts Scale",
    Value = "1",
    Callback = function(text)
        if tonumber(text) then
            PlayerData[SelectPlayer].BreastsScale = tonumber(text)
        end
    end
})

UI.ButtsScale = BodyScaleSection:Input({
    Title = "Butts Scale",
    Value = "1",
    Callback = function(text)
        if tonumber(text) then
            PlayerData[SelectPlayer].ButtsScale = tonumber(text)
        end
    end
})

UI.LegsScale = BodyScaleSection:Input({
    Title = "Legs Scale",
    Value = "1",
    Callback = function(text)
        if tonumber(text) then
            PlayerData[SelectPlayer].LegsScale = tonumber(text)
        end
    end
})

local BodyTypeSection = Tabs.Body:Section({ Title = "Type" })

UI.BreastsType = BodyTypeSection:Button({
    Title = "Breasts Type: 1",
    Callback = function()
        PlayerData[SelectPlayer].BreastsType += 1
        if PlayerData[SelectPlayer].BreastsType > MaxBreastsType then
            PlayerData[SelectPlayer].BreastsType = 1
        end
        Function.GUIUpdate()
    end
})

UI.TorsoType = BodyTypeSection:Button({
    Title = "Torso Type: 1",
    Callback = function()
        PlayerData[SelectPlayer].TorsoType += 1
        if PlayerData[SelectPlayer].TorsoType > MaxTorsoType then
            PlayerData[SelectPlayer].TorsoType = 1
        end
        Function.GUIUpdate()
    end
})

UI.ArmType = BodyTypeSection:Button({
    Title = "Arm Type: 1",
    Callback = function()
        PlayerData[SelectPlayer].ArmType += 1
        if PlayerData[SelectPlayer].ArmType > MaxArmType then
            PlayerData[SelectPlayer].ArmType = 1
        end
        Function.GUIUpdate()
    end
})

UI.LegsType = BodyTypeSection:Button({
    Title = "Legs Type: 1",
    Callback = function()
        PlayerData[SelectPlayer].LegsType += 1
        if PlayerData[SelectPlayer].LegsType > MaxLegsType then
            PlayerData[SelectPlayer].LegsType = 1
        end
        Function.GUIUpdate()
    end
})

UI.ButtType = BodyTypeSection:Button({
    Title = "Butt Type: 1",
    Callback = function()
        PlayerData[SelectPlayer].ButtType += 1
        if PlayerData[SelectPlayer].ButtType > MaxButtType then
            PlayerData[SelectPlayer].ButtType = 1
        end
        Function.GUIUpdate()
    end
})

-- Local Transparency（按部位）
local BodyTransSection = Tabs.Body:Section({ Title = "Local Transparency" })

for _, partName in ipairs({"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg","Hat"}) do
    UI["Local_" .. partName] = BodyTransSection:Toggle({
        Title = partName,
        Value = PlayerData[SelectPlayer].LocalTransparency[partName] or false,
        Callback = function(state)
            PlayerData[SelectPlayer].LocalTransparency[partName] = state
        end
    })
end

-- ============================================================
-- WindUI — Clothes Tab
-- ============================================================

local ClothesSearchSection = Tabs.Clothes:Section({ Title = "Search" })

UI.ClothesSearch = ClothesSearchSection:Input({
    Title = "Search Clothes",
    Placeholder = "Type name...",
    Value = "",
    Callback = function(text)
        Function.GUIUpdate()
    end
})

-- 说明：
-- 原版 ClothesButtonFrame 是一个 ScrollingFrame，里面动态生成 N 个按钮。
-- 在 WindUI 中，由于没有内置动态列表控件（不同版本不同），
-- 最简单稳妥的做法是：用一个 Section + 一个 Toggle 组，
-- 或者你自己用 Window 的 API 塞。
--
-- 下面给出**通用做法**：把 Clothes 全部做成 Toggle，
-- 加进一个 Section，用户点一下就等于原来的"选中/取消选中"。
--
local ClothesListSection = Tabs.Clothes:Section({ Title = "Clothes List" })

local ClothesToggles = {}
for name, _ in pairs(Clothes) do
    if name ~= "nil" then
        local tog = ClothesListSection:Toggle({
            Title = name,
            Value = false,
            Callback = function(state, byUser)
                if not byUser then return end
                local list = PlayerData[SelectPlayer].CurrentClothes
                if state then
                    if not table.find(list, name) then
                        table.insert(list, name)
                    end
                    -- 生成 Recolor 输入（如果这件衣服有 Recolor 属性）
                    if Clothes[name].Weld then
                        for _, v in pairs(Clothes[name].Weld) do
                            if PartList[v] and PartList[v].Recolor then
                                if not PlayerData[SelectPlayer].ClothesRecolor[name] then
                                    PlayerData[SelectPlayer].ClothesRecolor[name] = {}
                                end
                                local key = PartList[v].Recolor
                                if not PlayerData[SelectPlayer].ClothesRecolor[name][key] then
                                    PlayerData[SelectPlayer].ClothesRecolor[name][key] = "nil"
                                end
                            end
                        end
                    end
                else
                    for i, v in pairs(list) do
                        if v == name then
                            table.remove(list, i)
                            break
                        end
                    end
                    PlayerData[SelectPlayer].ClothesRecolor[name] = nil
                end
                Function.GUIUpdate()
            end
        })
        ClothesToggles[name] = tog
    end
end

UI.ClothesToggles = ClothesToggles

-- ============================================================
-- WindUI — Bundles Tab
-- ============================================================

local BundleSearchSection = Tabs.Bundles:Section({ Title = "Search" })

UI.BundleSearch = BundleSearchSection:Input({
    Title = "Search Bundles",
    Placeholder = "Type name...",
    Value = "",
    Callback = function(text)
        Function.GUIUpdate()
    end
})

local BundleListSection = Tabs.Bundles:Section({ Title = "Bundle List" })

local BundleButtons = {}

-- 说明：Bundle 通常只能选一个。用 Button 更合适。
-- checkBundle 是原代码里的核心函数，你需要把它**从原代码里复制过来**。
for name, v in pairs(Bundle) do
    local btn = BundleListSection:Button({
        Title = name,
        Desc  = v.ClothingBundle and "Clothing Bundle"
             or v.IsPreset and "Preset"
             or nil,
        Callback = function()
            if name == "nil" and PlayerData[SelectPlayer].CurrentBundle == "nil" then
                Function.CharacterReset(SelectPlayer)
                PlayerData[SelectPlayer] = Function.PlayerDataDefault()
            end

            if (not v.ClothingBundle or v.ClothingBundle == false)
               and (not v.IsPreset or v.IsPreset == false) then
                PlayerData[SelectPlayer].CurrentBundle = name
            end

            checkBundle(v)
            Function.GUIUpdate()
        end
    })
    BundleButtons[name] = btn
end

UI.BundleButtons = BundleButtons
-- ============================================================
-- WindUI — Catalog Tab
-- ============================================================

local CatalogSection = Tabs.Catalog:Section({ Title = "Load from Catalog" })

UI.CatalogUsername = CatalogSection:Input({
    Title = "Username",
    Desc  = "Load avatar accessories from a Roblox username",
    Placeholder = "Roblox username",
    Value = "",
    Callback = function(text)
        PlayerData[SelectPlayer].CatalogUsername = text
        PlayerData[SelectPlayer].CatalogRemove = {}
        Function.CatalogRefreshList()
    end
})

UI.CatalogOutfitId = CatalogSection:Input({
    Title = "Outfit Id",
    Desc  = "Load a saved outfit by id",
    Placeholder = "Outfit id",
    Value = "",
    Callback = function(text)
        PlayerData[SelectPlayer].CatalogOutfitId = text
        PlayerData[SelectPlayer].CatalogRemove = {}
        Function.CatalogRefreshList()
    end
})

UI.CatalogShirt = CatalogSection:Input({
    Title = "Shirt Id",
    Placeholder = "Shirt asset id",
    Value = "",
    Callback = function(text)
        if tonumber(text) then
            PlayerData[SelectPlayer].CatalogClothes.Shirt = text
        else
            PlayerData[SelectPlayer].CatalogClothes.Shirt = ""
        end
    end
})

UI.CatalogPants = CatalogSection:Input({
    Title = "Pants Id",
    Placeholder = "Pants asset id",
    Value = "",
    Callback = function(text)
        if tonumber(text) then
            PlayerData[SelectPlayer].CatalogClothes.Pants = text
        else
            PlayerData[SelectPlayer].CatalogClothes.Pants = ""
        end
    end
})

UI.CatalogShirtGraphic = CatalogSection:Input({
    Title = "Shirt Graphic Id",
    Placeholder = "Shirt Graphic asset id",
    Value = "",
    Callback = function(text)
        if tonumber(text) then
            PlayerData[SelectPlayer].CatalogClothes.ShirtGraphic = text
        end
    end
})

UI.CatalogAccessory = CatalogSection:Input({
    Title = "Add Accessory Id",
    Desc  = "Press Enter to add to list",
    Placeholder = "Accessory asset id",
    Value = "",
    Callback = function(text)
        if tonumber(text) then
            table.insert(PlayerData[SelectPlayer].CatalogAccessory, text)
            Function.CatalogRefreshList()
        end
    end
})

-- 已添加的 Accessory 列表（用 Button 代表"点击移除"）
local CatalogListSection = Tabs.Catalog:Section({ Title = "Loaded Accessories" })

UI.CatalogAccessories = {}      -- 保存当前显示的所有 accessory 按钮
UI.CatalogRemoveIds   = {}      -- 保存"点击移除"的 asset id

function Function.CatalogRefreshList()
    -- 清空旧按钮
    for _, btn in pairs(UI.CatalogAccessories) do
        if btn and btn.Destroy then btn:Destroy() end
    end
    UI.CatalogAccessories = {}

    -- 加入已手动添加的 accessory
    for _, id in ipairs(PlayerData[SelectPlayer].CatalogAccessory) do
        local btn = CatalogListSection:Button({
            Title = "Accessory " .. tostring(id),
            Desc  = "Click to remove",
            Callback = function()
                for i, v in pairs(PlayerData[SelectPlayer].CatalogAccessory) do
                    if tostring(v) == tostring(id) then
                        table.remove(PlayerData[SelectPlayer].CatalogAccessory, i)
                        break
                    end
                end
                Function.CatalogRefreshList()
            end
        })
        table.insert(UI.CatalogAccessories, btn)
    end
end

-- ============================================================
-- WindUI — Edit Tab
-- ============================================================

local EditSection = Tabs.Edit:Section({ Title = "Edit Mesh Part" })

UI.EditMeshName = EditSection:Input({
    Title = "Mesh Name",
    Desc  = "Self = default, PlayerName = personal",
    Placeholder = "Torso, Left Leg, ...",
    Value = "",
    Callback = function(text)
        Function.MeshEditButton(text)
    end
})

-- 属性编辑区域（动态塞 Input）
local EditPropsSection = Tabs.Edit:Section({ Title = "Properties" })

UI.EditProps = {}   -- 保存每个属性 Input 的引用
UI.EditHandles = {} -- 保存每个 Input 的连接/句柄

-- 重写 Function.MeshEditButton
-- 原版往 GUIObject.PropertyListFrame 里塞 TextBox
-- 新版往 EditPropsSection 里塞 Input
function Function.MeshEditButton(Name)
    -- 清空旧的属性
    for _, handle in pairs(UI.EditHandles) do
        if handle and handle.Destroy then handle:Destroy() end
    end
    UI.EditHandles = {}
    UI.EditProps = {}
    Debug = false

    local PlayerPartList = PlayerData[SelectPlayer] and PlayerData[SelectPlayer]["PartList"]
    local MeshDetail = PlayerPartList and PlayerPartList[Name]

    if not MeshDetail then
        return
    end

    setmetatable(MeshDetail, MetaClothes)

    -- EditableProperty 需要在原代码里有定义（约 11 个字段）
    -- 若原代码没有, 你可以手动补一个:
    -- local EditableProperty = {
    --   "Name","MeshId","TextureId","Size","CFrame","CFrame1",
    --   "Offset","Rotation","Transparency","Reflectance","Material"
    -- }

    -- 若有 CockScale
    if MeshDetail["Scale"] == "CockScale" then
        local inp = EditPropsSection:Input({
            Title = "CockScale",
            Value = tostring(PlayerData[SelectPlayer].CockScale),
            Callback = function(text)
                if tonumber(text) then
                    PlayerData[SelectPlayer].CockScale = tonumber(text)
                end
            end
        })
        table.insert(UI.EditHandles, inp)
    end

    for _, propertyName in ipairs(EditableProperty) do
        local value = MeshDetail[propertyName]
        if value == nil then value = "" end

        local displayText
        if propertyName == "Color" then
            local split = string.split(tostring(value.Color), ",")
            if tonumber(split[1]) and tonumber(split[2]) and tonumber(split[3]) then
                displayText = math.round(split[1] * 255) .. ","
                           .. math.round(split[2] * 255) .. ","
                           .. math.round(split[3] * 255)
            else
                displayText = ""
            end
        else
            displayText = tostring(value)
        end

        local inp = EditPropsSection:Input({
            Title = propertyName,
            Value = displayText,
            Callback = function(text)
                if propertyName == "Size"
                   or propertyName == "Offset"
                   or propertyName == "Rotation" then
                    PlayerData[SelectPlayer]["PartList"][Name][propertyName]
                        = Function.StringTo(text, "Vector3")
                elseif propertyName == "TextureId" then
                    PlayerData[SelectPlayer]["PartList"][Name][propertyName] = text
                elseif propertyName == "Color" then
                    local rgb = Function.StringTo(text, "RGB")
                    if rgb then
                        PlayerData[SelectPlayer]["PartList"][Name][propertyName].Color = rgb
                    end
                else
                    if tonumber(text) then
                        PlayerData[SelectPlayer]["PartList"][Name][propertyName]
                            = tonumber(text)
                    end
                end
            end
        })
        table.insert(UI.EditHandles, inp)
    end
end

-- ============================================================
-- WindUI — Recolor Tab
-- ============================================================

local RecolorSection = Tabs.Recolor:Section({ Title = "Clothing Recolor" })

UI.RecolorInputs = {}   -- 保存 [ClothesName] = { Primary = input, Secondary = input, Tertiary = input }
UI.RecolorHandles = {}

-- 清空 + 重建 Recolor 界面
function Function.RecolorRebuild()
    for _, handles in pairs(UI.RecolorHandles) do
        for _, h in pairs(handles) do
            if h and h.Destroy then h:Destroy() end
        end
    end
    UI.RecolorHandles = {}
    UI.RecolorInputs = {}

    for clothesName, colors in pairs(PlayerData[SelectPlayer].ClothesRecolor) do
        local set = {}
        for key, _ in pairs(colors) do
            local input = RecolorSection:Input({
                Title = clothesName .. " " .. key,
                Desc  = "Format: R,G,B (empty to disable)",
                Value = "",
                Callback = function(text)
                    if text ~= "" then
                        local rgb = Function.StringTo(text, "RGB")
                        if rgb then
                            PlayerData[SelectPlayer].ClothesRecolor[clothesName][key] = rgb
                        end
                    else
                        PlayerData[SelectPlayer].ClothesRecolor[clothesName][key] = "nil"
                    end
                end
            })
            set[key] = input
            table.insert(UI.RecolorHandles, { input })
        end
        UI.RecolorInputs[clothesName] = set
    end
end
-- ============================================================
    -- WindUI — HP Tab
    -- ============================================================

    local HPSection = Tabs.HP:Section({ Title = "Clothing HP" })

    UI.TopHP = HPSection:Input({
        Title = "Shirt Health",
        Desc  = "Leave blank to disable",
        Placeholder = "0",
        Value = "",
        Callback = function(text)
            if tonumber(text) then
                PlayerData[SelectPlayer].TopHP = tonumber(text)
            else
                PlayerData[SelectPlayer].TopHP = ""
            end
        end
    })

    UI.BottomHP = HPSection:Input({
        Title = "Pants Health",
        Desc  = "Leave blank to disable",
        Placeholder = "0",
        Value = "",
        Callback = function(text)
            if tonumber(text) then
                PlayerData[SelectPlayer].BottomHP = tonumber(text)
            else
                PlayerData[SelectPlayer].BottomHP = ""
            end
        end
    })

    UI.TopClothes = HPSection:Input({
        Title = "Ripped Shirt Id",
        Placeholder = "Shirt asset id",
        Value = "",
        Callback = function(text)
            if tonumber(text) then
                PlayerData[SelectPlayer].HPClothes.Shirt = tonumber(text)
            else
                PlayerData[SelectPlayer].HPClothes.Shirt = ""
            end
        end
    })

    UI.BottomClothes = HPSection:Input({
        Title = "Ripped Pants Id",
        Placeholder = "Pants asset id",
        Value = "",
        Callback = function(text)
            if tonumber(text) then
                PlayerData[SelectPlayer].HPClothes.Pants = tonumber(text)
            else
                PlayerData[SelectPlayer].HPClothes.Pants = ""
            end
        end
    })

    local HPSoundSection = Tabs.HP:Section({ Title = "Sound & FX" })

    UI.DamageSFX = HPSoundSection:Input({
        Title = "Damage SFX Minimum",
        Desc  = "Leave blank to disable",
        Value = "",
        Callback = function(text)
            if tonumber(text) then
                PlayerData[SelectPlayer].DamageSFX = tonumber(text)
            else
                PlayerData[SelectPlayer].DamageSFX = ""
            end
        end
    })

    UI.Volume = HPSoundSection:Input({
        Title = "Volume",
        Value = "1",
        Callback = function(text)
            if tonumber(text) then
                PlayerData[SelectPlayer].Volume = tonumber(text)
            end
        end
    })

    UI.TearParticles = HPSoundSection:Toggle({
        Title = "Toggle Tear Particles",
        Value = true,
        Callback = function(state)
            PlayerData[SelectPlayer].TearParticles = state
        end
    })

    UI.HealParticles = HPSoundSection:Toggle({
        Title = "Toggle Heal Particles",
        Value = true,
        Callback = function(state)
            PlayerData[SelectPlayer].HealParticles = state
        end
    })

    UI.HardcoreHP = HPSoundSection:Toggle({
        Title = "Clothing Hardcore HP",
        Desc  = "Requires holding the heal key to restore",
        Value = false,
        Callback = function(state)
            PlayerData[SelectPlayer].HardcoreHP = state
        end
    })

    -- ============================================================
    -- WindUI — Tail Tab
    -- ============================================================

    local TailSection = Tabs.Tail:Section({ Title = "Tail Physics" })

    UI.TailPhysics = TailSection:Toggle({
        Title = "Tail Physics",
        Value = true,
        Callback = function(state)
            PlayerData[SelectPlayer].tailSettings.tailPhysicsEnabled = state
        end
    })

    UI.TailWag = TailSection:Toggle({
        Title = "Wag Animation",
        Value = true,
        Callback = function(state)
            PlayerData[SelectPlayer].tailSettings.wagAnimationEnabled = state
        end
    })

    UI.TailWagSpeed = TailSection:Slider({
        Title = "Wag Speed",
        Min = 0,
        Max = 3,
        Default = 1,
        Callback = function(value)
            PlayerData[SelectPlayer].tailSettings.wagAnimationSpeed = value
        end
    })

    UI.TailStiffness = TailSection:Slider({
        Title = "Stiffness",
        Min = 0,
        Max = 200,
        Default = 96,
        Callback = function(value)
            PlayerData[SelectPlayer].tailSettings.stiffness = value
        end
    })

    UI.TailDamping = TailSection:Slider({
        Title = "Damping",
        Min = 0,
        Max = 30,
        Default = 9,
        Callback = function(value)
            PlayerData[SelectPlayer].tailSettings.damping = value
        end
    })

    UI.TailTimeScale = TailSection:Slider({
        Title = "Time Scale",
        Min = 0,
        Max = 2,
        Default = 1,
        Callback = function(value)
            PlayerData[SelectPlayer].tailSettings.timeScale = value
        end
    })

    -- ============================================================
    -- 重写 Function.GUIUpdate
    -- ============================================================

    function Function.GUIUpdate()
        -- 玩家数据
        local data = PlayerData[SelectPlayer]
        if not data then return end

        -- 更新按钮/输入框显示
        if UI.AutoExecute then
            UI.AutoExecute:Set(data.AutoExecute)
        end
        if UI.BundleBodyColor then UI.BundleBodyColor:Set(data.BundleBodyColor) end
        if UI.Face then UI.Face:Set(data.Face) end
        if UI.MeshSizeLock then UI.MeshSizeLock:Set(data.MeshSizeLock) end
        if UI.AccessorySizeLock then UI.AccessorySizeLock:Set(data.AccessorySizeLock) end
        if UI.MeshBasePartInvisible then UI.MeshBasePartInvisible:Set(data.MeshBasePartInvisible) end
        if UI.BodyPartPhysics then UI.BodyPartPhysics:Set(data.BodyPartPhysics) end
        if UI.RealtimeBodyTransparency then UI.RealtimeBodyTransparency:Set(data.RealtimeBodyTransparency) end
        if UI.ClickExecute then UI.ClickExecute:Set(ClickExecute) end
        if UI.FPerson then UI.FPerson:Set(data.FPerson) end
        if UI.PhysicsObeyGravity then UI.PhysicsObeyGravity:Set(data.PhysicsObeyGravity) end
        if UI.TearParticles then UI.TearParticles:Set(data.TearParticles) end
        if UI.HealParticles then UI.HealParticles:Set(data.HealParticles) end
        if UI.HardcoreHP then UI.HardcoreHP:Set(data.HardcoreHP) end
        if UI.TailPhysics then UI.TailPhysics:Set(data.tailSettings.tailPhysicsEnabled) end

        -- 文本
        if UI.Tone then UI.Tone:SetTitle("Tone: " .. data.Tone) end
        if UI.Method then UI.Method:SetTitle("Method: " .. Method) end
        if UI.SettingsMethod then UI.SettingsMethod:SetTitle("Method: " .. Method) end

        -- 输入框
        if UI.PlayerExecute then UI.PlayerExecute:Set(tostring(SelectPlayer)) end
        if UI.SettingsPlayer then UI.SettingsPlayer:Set(tostring(SelectPlayer)) end
        if UI.DelayTime then UI.DelayTime:Set(tostring(data.DelayTime)) end
        if UI.BreastsScale then UI.BreastsScale:Set(tostring(data.BreastsScale)) end
        if UI.ButtsScale then UI.ButtsScale:Set(tostring(data.ButtsScale)) end
        if UI.LegsScale then UI.LegsScale:Set(tostring(data.LegsScale)) end
        if UI.TopHP then UI.TopHP:Set(tostring(data.TopHP)) end
        if UI.BottomHP then UI.BottomHP:Set(tostring(data.BottomHP)) end
        if UI.DamageSFX then UI.DamageSFX:Set(tostring(data.DamageSFX)) end
        if UI.Volume then UI.Volume:Set(tostring(data.Volume)) end

        -- Type 按钮
        if UI.BreastsType then UI.BreastsType:SetTitle("Breasts Type: " .. data.BreastsType) end
        if UI.TorsoType then UI.TorsoType:SetTitle("Torso Type: " .. data.TorsoType) end
        if UI.ArmType then UI.ArmType:SetTitle("Arm Type: " .. data.ArmType) end
        if UI.LegsType then UI.LegsType:SetTitle("Legs Type: " .. data.LegsType) end
        if UI.ButtType then UI.ButtType:SetTitle("Butt Type: " .. data.ButtType) end

        -- 局部透明开关
        for _, partName in ipairs({"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg","Hat"}) do
            local tog = UI["Local_" .. partName]
            if tog then
                tog:Set(data.LocalTransparency[partName] or false)
            end
        end

        -- Clothes 开关同步（不触发回调）
        if UI.ClothesToggles then
            for name, tog in pairs(UI.ClothesToggles) do
                local active = table.find(data.CurrentClothes, name) ~= nil
                if tog.Set then
                    -- 用 setter 传 false 表示"非用户点击"
                    tog:Set(active, false)
                end
            end
        end

        -- Recolor 重建（如果当前有选中）
        if Function.RecolorRebuild then
            Function.RecolorRebuild()
        end
    end

    -- ============================================================
    -- 启动收尾
    -- ============================================================

    -- 保留原代码的启动部分：
    --   - RoClothesBreaker 检测循环
    --   - 断开所有 AllConnect
    --   - 若有 loadupBundle / loadupExecute 自动执行
    --
    -- 这些逻辑基本不用改，除了：
    --   - GUIObject.Screen:Destroy()  → Window:Destroy()  （如果 WindUI 支持）
    --   - GUIObject.MobileCloseButtonScreen:Destroy() → 直接删掉这行

    Function.PlayerDataAdd(Player.Name)
    Function.GUIUpdate()

    -- 如果 loadupBundle 不是 nil，则自动加载
    if loadupBundle and loadupBundle ~= "nil" and Bundle[loadupBundle] then
        checkBundle(Bundle[loadupBundle])
    end

    -- 如果 loadupExecute，则自动执行角色
    if loadupExecute and Player.Character then
        Function.CharacterExecute(Player.Character, Player.Name)
    end

    -- Breaker 监听：一旦出现 RoClothesBreaker，清场
    task.spawn(function()
        while task.wait(0.5) do
            local BreakerObject = game.Workspace:FindFirstChild("RoClothesBreaker")
            if BreakerObject then
                for _, connect in pairs(AllConnect) do
                    if connect and connect.Disconnect then
                        connect:Disconnect()
                    end
                end
                if aWhile then task.cancel(aWhile) end

                -- ★ 关键：如果 Window 有 Destroy 方法
                if Window.Destroy then
                    Window:Destroy()
                end

                BreakerObject:Destroy()
                print("RoCDC")
                break
            end
        end
    end)

    -- 角色重生自动执行
    for _, plr in pairs(PS:GetPlayers()) do
        Function.CharacterConnection(plr)
    end

    PS.PlayerAdded:Connect(function(plr)
        Function.CharacterConnection(plr)
    end)
end

-- ============================================================
-- 入口（原样保留）
-- ============================================================
if RS:IsStudio() then
    RoClothes(PS.LocalPlayer)
else
    if RS:IsClient() then
        if not PS.LocalPlayer then
            PS.PlayerAdded:Wait()
        end
        RoClothes(PS.LocalPlayer)
    elseif RS:IsServer() then
        RoClothes(PS:WaitForChild("lerp()"))
    end
end