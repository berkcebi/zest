local graphics <const> = playdate.graphics
local size <const> = 9

Cursor = nil
class("Cursor").extends(graphics.sprite)

function Cursor:init()
    Cursor.super.init(self)

    local image = graphics.image.new(size, size)

    graphics.pushContext(image)
    playdate.graphics.fillCircleAtPoint(size / 2, size / 2, size / 2)
    graphics.popContext()

    self:setImage(image)
end
