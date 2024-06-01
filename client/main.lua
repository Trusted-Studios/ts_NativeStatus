-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Trusted Development || Debug-print
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[CLIENT - DEBUG] ^0: "..filename()..".lua gestartet");
end

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

HUD = {
    hunger = 0,
    thirst = 0,
}

Config.UpdateEvent()

function HUD:Update(hunger, thirst)
    self.hunger = hunger
    self.thirst = thirst
end

exports('UpdateNativeStatus', function(hunger, thirst)
    HUD:Update(hunger, thirst)
end)

function HUD:GetMinimapAnchor()
    local safeZone <const> = GetSafeZoneSize()
    local safeZoneX <const> = 1.0 / 20.0
    local safeZoneY <const> = 1.0 / 20.0
    local aspectRatio <const> = GetAspectRatio(false)
    local resolutionX <const>, resolutionY <const> = GetActiveScreenResolution()
    local scaleX <const> = 1.0 / resolutionX
    local scaleY <const> = 1.0 / resolutionY

    local minimap <const> = {}
    minimap.width = scaleX * (resolutionX / (4 * aspectRatio))
    minimap.height = scaleY * (resolutionY / 5.674)
    minimap.leftX = scaleX * (resolutionX * (safeZoneX * (math.abs(safeZone - 1.0) * 10)))
    minimap.rightX = minimap.leftX + minimap.width
    minimap.bottomY = 1.0 - scaleY * (resolutionY * (safeZoneY * (math.abs(safeZone - 1.0) * 10)))
    minimap.topY = minimap.bottomY - minimap.height
    minimap.x = minimap.leftX
    minimap.y = minimap.topY
    minimap.unitX = scaleX
    minimap.unitY = scaleY

    return minimap
end

function HUD:DrawProgressBar(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function HUD:Display()
    -- repeat Wait(250) until self.hunger ~= nil and self.thirst ~= nil

    local anchor <const> = self:GetMinimapAnchor()

    ---@background:
    self:DrawProgressBar(anchor.x, anchor.y + anchor.height + 0.008, anchor.width, -12 * anchor.unitY, 0, 0, 0, 150)

    ---@splitter:
    self:DrawProgressBar(anchor.x + (anchor.width / 2) - 0.001, anchor.y + anchor.height + 0.005, anchor.width / 60, -8 * anchor.unitY, 0, 0, 0, 200)


    ---@thrirst:
    self:DrawProgressBar(anchor.x, anchor.y + anchor.height + 0.005, anchor.width / 2, -8 * anchor.unitY, 245, 202, 39, 100)
    self:DrawProgressBar(anchor.x, anchor.y + anchor.height + 0.005, ((anchor.width / 2) / 100) * self.thirst, -8 * anchor.unitY, 245, 202, 39, 150)

    ---@hunger:
    self:DrawProgressBar(anchor.x + (anchor.width / 2), anchor.y + anchor.height + 0.005, anchor.width / 2, -8 * anchor.unitY, 56, 200, 233, 100)
    self:DrawProgressBar(anchor.x + (anchor.width / 2), anchor.y + anchor.height + 0.005, ((anchor.width / 2) / 100) * self.hunger, -8 * anchor.unitY, 56, 200, 233, 150)
end

CreateThread(function()
    while true do
        Wait(0)
        HUD:Display()
    end
end)