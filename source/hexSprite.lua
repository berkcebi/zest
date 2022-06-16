local graphics <const> = playdate.graphics
local width <const> = 32
local height <const> = 30
local offsetY <const> = 6

HexSprite = nil
class("HexSprite", { isSelected = false }).extends(graphics.sprite)

function HexSprite.size()
    return width, height
end

function HexSprite.offsetY()
    return offsetY
end

function HexSprite:init()
    HexSprite.super.init(self)

    self:_reloadImage()
end

function HexSprite:setSelected(isSelected)
    if self.isSelected == isSelected then
        return
    end

    self.isSelected = isSelected
    self:_reloadImage()
end

function HexSprite:_reloadImage()
    local imagePath
    if self.isSelected then
        imagePath = "assets/images/hex-selected"
    else
        imagePath = "assets/images/hex"
    end

    local image = graphics.image.new(imagePath)
    self:setImage(image)
end
