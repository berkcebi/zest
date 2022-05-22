Zest = {}

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "battleground"

local graphics <const> = playdate.graphics

local battleground = nil

local function initialize()
    battleground = Zest.Battleground()
end

initialize()

function playdate.update()
    battleground:update()
    graphics.sprite.update()
end
