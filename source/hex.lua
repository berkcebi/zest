local graphics <const> = playdate.graphics
local width <const> = 32
local height <const> = 30
local offsetY <const> = 6

Hex = nil
class("Hex", { isSelected = false }).extends(graphics.sprite)

function Hex.size()
    return width, height
end

function Hex.offsetY()
    return offsetY
end

function Hex:init()
    Hex.super.init(self)

    self:_reloadImage()
end

function Hex:setSelected(isSelected)
    if self.isSelected == isSelected then
        return
    end

    self.isSelected = isSelected
    self:_reloadImage()
end

function Hex:_reloadImage()
    local imagePath
    if self.isSelected then
        imagePath = "assets/images/hex-selected"
    else
        imagePath = "assets/images/hex"
    end

    local image = graphics.image.new(imagePath)
    self:setImage(image)
end
