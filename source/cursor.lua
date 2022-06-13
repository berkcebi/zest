local graphics <const> = playdate.graphics
local size <const> = 9
local borderSize <const> = 2

Cursor = nil
class("Cursor").extends(graphics.sprite)

function Cursor:init()
    Cursor.super.init(self)

    local image = graphics.image.new(size, size)

    graphics.pushContext(image)
    graphics.setColor(graphics.kColorWhite)
    graphics.fillCircleAtPoint(size / 2, size / 2, size / 2)

    graphics.setColor(graphics.kColorBlack)
    graphics.fillCircleAtPoint(size / 2, size / 2, (size - borderSize) / 2)
    graphics.popContext()

    self:setImage(image)
end
