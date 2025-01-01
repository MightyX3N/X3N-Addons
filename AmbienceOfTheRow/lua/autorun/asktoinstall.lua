-- File: lua/autorun/asktoinstall.lua

-- Define the Workshop addon ID
local WORKSHOP_ID = 3397425251 -- Numeric ID (can also be a string)

---------------------------
-- Server-Side Code
---------------------------
if SERVER then
    -- Function to check if the server has the required Workshop addon
    local function CheckServerWorkshopAddon()
        -- Ensure steamworks library is available
        if not steamworks or not steamworks.IsSubscribed then
            print("[X3NAmbience] Error: steamworks.IsSubscribed is not available on the server.")
            return
        end

        -- Check if the server is subscribed to the Workshop addon
        local isSubscribed = steamworks.IsSubscribed(WORKSHOP_ID)
        if not isSubscribed then
            print("[X3NAmbience] WARNING: Required Workshop addon (ID: " .. WORKSHOP_ID .. ") is not installed on the server.")
            -- Optional: Disable certain features or notify admins
            -- Example: 
            -- hook.Remove("SomeFeatureHook", "FeatureName")
        else
            print("[X3NAmbience] Required Workshop addon is installed on the server.")
        end
    end

    -- Hook the check to run when the server initializes
    hook.Add("Initialize", "CheckServerWorkshopAddon", CheckServerWorkshopAddon)
end

---------------------------
-- Client-Side Code
---------------------------
if CLIENT then
    -- Function to check if the client has the required Workshop addon
    local function CheckClientWorkshopAddon()
        -- Ensure steamworks library is available
        if not steamworks or not steamworks.IsSubscribed then
            print("[X3NAmbience] Error: steamworks.IsSubscribed is not available on the client.")
            return
        end

        -- Check if the client is subscribed to the Workshop addon
        local isSubscribed = steamworks.IsSubscribed(WORKSHOP_ID)
        if not isSubscribed then
            -- Send a red-colored message to the in-game chat
            chat.AddText(Color(255, 0, 0), "X3NAmbience Base has to be installed to use Ambience Sounds.")

            -- Open the Workshop page in the player's default web browser
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. WORKSHOP_ID)
        else
            -- Optional: Notify that the addon is installed (can be removed if not needed)
            print("[X3NAmbience] X3NAmbience Base is installed on the client.")
        end
    end

    -- Hook the check function to run after all entities have been initialized
    hook.Add("InitPostEntity", "CheckClientWorkshopAddon", function()
        -- Delay the check slightly to ensure steamworks is fully initialized
        timer.Simple(1, CheckClientWorkshopAddon)
    end)
end
