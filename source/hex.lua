local graphics <const> = playdate.graphics
local width <const> = 32
local height <const> = 30
local offsetY <const> = 6

Hex = nil
class("Hex").extends(graphics.sprite)

function Hex.size()
    return width, height
end

function Hex.offsetY()
    return offsetY
end

function Hex:init()
    Hex.super.init(self)

    local image = graphics.image.new("assets/images/hex")
    self:setImage(image)
end
