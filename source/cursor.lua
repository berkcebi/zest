local graphics <const> = playdate.graphics

Cursor = nil
class("Cursor").extends(graphics.sprite)

function Cursor:init()
    Cursor.super.init(self)

    local image = graphics.image.new("assets/images/cursor")
    self:setImage(image)
end
