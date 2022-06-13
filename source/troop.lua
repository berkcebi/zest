local graphics <const> = playdate.graphics
local width <const> = 32
local height <const> = 30
local textGap <const> = 2
local countOffsetY <const> = 5
local titleFont <const> = graphics.font.new("assets/fonts/font-pixieval-large-black-bold")
local countFont <const> = graphics.font.new("assets/fonts/Bitmore")
countFont:setTracking(1)

Troop = nil
class("Troop", { title = "", count = 0 }).extends(graphics.sprite)

function Troop:init(title, count)
    Troop.super.init(self)

    self.title = title
    self.count = count

    local image = graphics.image.new(width, height)
    self:setImage(image)
    self:_reloadImage()
end

function Troop:_reloadImage()
    local image = self:getImage()

    graphics.pushContext(image)

    graphics.setFont(titleFont)
    local titleWidth, titleHeight = graphics.getTextSize(self.title)

    graphics.setFont(countFont)
    local countWidth, _ = graphics.getTextSize(self.count)

    local x = math.ceil((width - titleWidth - textGap - countWidth) / 2)
    local y = math.ceil((height - titleHeight) / 2)

    graphics.setFont(titleFont)
    graphics.drawText(self.title, x, y)

    graphics.setFont(countFont)
    graphics.drawText(self.count, x + titleWidth + textGap, y + countOffsetY)

    graphics.popContext()
end
