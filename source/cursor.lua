local graphics <const> = playdate.graphics
local size <const> = 9

class("Cursor", {}, Zest).extends(graphics.sprite)

function Zest.Cursor:init()
    Zest.Cursor.super.init(self)

    local image = graphics.image.new(size, size)

    graphics.pushContext(image)
    playdate.graphics.fillCircleAtPoint(size / 2, size / 2, size / 2)
    graphics.popContext()

    self:setImage(image)
end
