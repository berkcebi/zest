import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "adventurer"
import "battle"
import "battleScene"
import "creature"
import "troop"

local graphics <const> = playdate.graphics

local adventurer = nil
local battleScene = nil

local function initialize()
    adventurer = Adventurer()

    local soldier = Creature("Soldier", 2, 1)
    local soldierTroop = Troop(soldier, 8)
    adventurer:addTroop(soldierTroop)

    local griffon = Creature("Griffon", 5, 2)
    local griffonTroop = Troop(griffon, 4)
    adventurer:addTroop(griffonTroop)

    local battle = Battle(adventurer)
    battleScene = BattleScene(battle)
end

initialize()

function playdate.update()
    battleScene:update()
    graphics.sprite.update()
end
