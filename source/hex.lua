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

    self:reloadImage()
end

function Hex:setSelected(isSelected)
    if self.isSelected == isSelected then
        return
    end

    self.isSelected = isSelected
    self:reloadImage()
end

function Hex:reloadImage()
    local image
    if self.isSelected then
        image = graphics.image.new("assets/images/hex-selected")
    else
        image = graphics.image.new("assets/images/hex")
    end

    self:setImage(image)
end
