-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Trusted Development || Debug-print
-- ════════════════════════════════════════════════════════════════════════════════════ --

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end
print("^6[SHARED] - DEBUG] ^0: "..filename()..".lua gestartet");

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Trusted Development || System
-- ════════════════════════════════════════════════════════════════════════════════════ --

Trusted = {}
Trusted.Debug = true
Trusted.Webhook = ''

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Config = {}

--- change according to your framework or use the export (more about in the README.md)
Config.UpdateEvent = function()
    AddEventHandler("esx_status:onTick", function(data)
        HUD:Update(data[3].percent, data[2].percent)
    end)
end