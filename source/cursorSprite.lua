local graphics <const> = playdate.graphics

CursorSprite = nil
class("CursorSprite").extends(graphics.sprite)

function CursorSprite:init()
    CursorSprite.super.init(self)

    local image = graphics.image.new("assets/images/cursor")
    self:setImage(image)
end
