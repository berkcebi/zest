local graphics <const> = playdate.graphics
local width <const> = 32
local height <const> = 30
local offsetY <const> = 6

HexSprite = {}
class("HexSprite").extends(graphics.sprite)

function HexSprite.size()
    return width, height
end

function HexSprite.offsetY()
    return offsetY
end

function HexSprite:init()
    HexSprite.super.init(self)

    local image = graphics.image.new("assets/images/hex")
    self:setImage(image)
end
