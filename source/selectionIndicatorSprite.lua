local graphics <const> = playdate.graphics

SelectionIndicatorSprite = {}
class("SelectionIndicatorSprite").extends(graphics.sprite)

function SelectionIndicatorSprite:init()
    SelectionIndicatorSprite.super.init(self)

    local image = graphics.image.new("assets/images/hex-selected")
    self:setImage(image)
end
