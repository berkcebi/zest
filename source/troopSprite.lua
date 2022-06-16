local graphics <const> = playdate.graphics
local width <const> = 32
local height <const> = 30
local textGap <const> = 2
local countOffsetY <const> = 5
local titleFont <const> = graphics.font.new("assets/fonts/font-pixieval-large-black-bold")
local countFont <const> = graphics.font.new("assets/fonts/Bitmore")
countFont:setTracking(1)

TroopSprite = nil
class("TroopSprite", { troop = nil }).extends(graphics.sprite)

function TroopSprite:init(troop)
    TroopSprite.super.init(self)

    self.troop = troop

    local image = graphics.image.new(width, height)
    self:setImage(image)
    self:_reloadImage()
end

function TroopSprite:_reloadImage()
    local image = self:getImage()

    graphics.pushContext(image)

    graphics.setFont(titleFont)
    local title = self.troop.creature.name:sub(1, 1)
    local titleWidth, titleHeight = graphics.getTextSize(title)

    graphics.setFont(countFont)
    local countWidth, _ = graphics.getTextSize(self.troop.count)

    local x = math.ceil((width - titleWidth - textGap - countWidth) / 2)
    local y = math.ceil((height - titleHeight) / 2)

    graphics.setFont(titleFont)
    graphics.drawText(title, x, y)

    graphics.setFont(countFont)
    graphics.drawText(self.troop.count, x + titleWidth + textGap, y + countOffsetY)

    graphics.popContext()
end
