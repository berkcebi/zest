import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "battleground"

local graphics <const> = playdate.graphics

local battleground = nil

local function initialize()
    local width, height = playdate.display.getSize()

    battleground = Battleground()
    battleground:moveTo(width / 2, height / 2)
    battleground:add()
end

initialize()

function playdate.update()
    graphics.sprite.update()
end
