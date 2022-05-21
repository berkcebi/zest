local graphics <const> = playdate.graphics
local rows <const> = 9
local columns <const> = 12
local width <const> = 30
local height <const> = 32

class("Battleground").extends(graphics.sprite)

function Battleground:init(style)
    Battleground.super.init(self)

    local image = graphics.image.new(
        columns * width + width / 2 + 1,
        rows * (height * 3 / 4) + height / 4
    )

    graphics.pushContext(image)

    for column = 1, columns do
        for row = 1, rows do
            local x = (column - 0.5) * width + (row % 2 == 1 and width / 2 or 0)
            local y = (row - 1) * (height * 3 / 4) + height / 2

            graphics.drawPolygon(
                x - width / 2, y - height / 4,
                x, y - height / 2,
                x + width / 2, y - height / 4,
                x + width / 2, y + height / 4,
                x, y + height / 2,
                x - width / 2, y + height / 4
            )
        end
    end
    graphics.popContext()

    self:setImage(image)
end
