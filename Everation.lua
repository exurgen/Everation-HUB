---- The Everation HUB ----

-- RayField Settings
getgenv().RAYFIELD_SECURE = true

-- Load RayField UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Survive The Apocalypse Everation HUB",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Everation HUB",
   LoadingSubtitle = "By exurgen",
   ShowText = "Everation",
   Theme = "Amethyst",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Everation HUB",
      FileName = "Everation Config"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false,
   KeySettings = {
      Title = "Key for Everation HUB",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key for Everation HUB", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Everation"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

-- Functions
function AutoSellFunction()
  while getgenv().AutoSellValue do
    game:GetService("ReplicatedStorage").Remotes.SellCrates:FireServer()
    wait(0.01)
  end
end

function ThemeSet(Options)
  Window.ModifyTheme(Options)
end

function AutoPickupFuelFunction()
    while getgenv().AutoPickupFuel do
        local Character = game.Players.LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Character.HumanoidRootPart

            local nearest = nil
            local nearestDist = 12 -- радиус подбора

            for _, fuel in ipairs(workspace:GetChildren()) do
                if fuel.Name == "Fuel" then
                    local union = fuel:FindFirstChild("Union")
                    if union then
                        local dist = (union.Position - HRP.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = fuel
                        end
                    end
                end
            end

            if nearest then
                local dragSystem = nearest:FindFirstChild("DragSystem")
                if dragSystem and dragSystem:FindFirstChild("DragItem") then
                    dragSystem.DragItem:FireServer()
                end
            end
        end

        task.wait(0.1)
    end
end

-- Tabs
local AutoThingsTab = Window:CreateTab("Auto Things", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Sections
local AutoThingsSection = AutoThingsTab:CreateSection("Auto Things")
local ThemesSection = SettingsTab:CreateSection("Themes")

-- Toggles
local AutoSellToggle = AutoThingsTab:CreateToggle({
   Name = "Auto Sell",
   CurrentValue = false,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      getgenv().AutoSellValue = Value
      AutoSellFunction()
   end,
})

local AutoPickupFuelToggle = AutoThingsTab:CreateToggle({
    Name = "Auto Pickup Fuel",
    CurrentValue = false,
    Flag = "AutoPickupFuelToggle",
    Callback = function(Value)
        getgenv().AutoPickupFuel = Value
        AutoPickupFuelFunction()
    end,
})

-- Dropdowns
local ThemesDropdown = SettingsTab:CreateDropdown({
   Name = "Themes",
   Options = {"Default", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Ocean", "Serenity"},
   CurrentOption = {"Amethyst"},
   MultipleOptions = false,
   Flag = "ThemesDropdown",
   Callback = function(Options)
      ThemeSet(Options[1])
   end,
})

-- Load Configuration
Rayfield:LoadConfiguration()