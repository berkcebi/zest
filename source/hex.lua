local graphics <const> = playdate.graphics
local width <const> = 30
local height <const> = 32

class("Hex").extends(graphics.sprite)

function Hex.size()
    return width, height
end

function Hex:init()
    Hex.super.init(self)

    local image = graphics.image.new(width + 1, height + 1)

    graphics.pushContext(image)
    graphics.drawPolygon(
        0, height / 4,
        width / 2, 0,
        width, height / 4,
        width, height * 3 / 4,
        width / 2, height,
        0, height * 3 / 4
    )
    graphics.popContext()

    self:setImage(image)
end
