import "cursorSprite"
import "hexSprite"
import "troopSprite"

local geometry <const> = playdate.geometry
local graphics <const> = playdate.graphics
local sound <const> = playdate.sound
local rows <const> = 9
local columns <const> = 11
local cursorAnimationDuration <const> = 250

BattleScene = nil
class("BattleScene", {
    battle = nil,
    grid = {},
    cursorSprite = nil,
    cursorPoint = geometry.point.new(1, 1),
    cursorAnimator = nil,
    cursorSamplePlayer = nil,
    selectedPoint = nil,
    selectSamplePlayer = nil,
    deselectSamplePlayer = nil,
    troopSprites = {}
}).extends()

function BattleScene:init(battle)
    BattleScene.super.init(self)

    self.battle = battle

    local hexWidth, hexHeight = HexSprite.size()
    local hexOffsetY = HexSprite.offsetY()
    local width = columns * hexWidth + hexWidth / 2
    local height = rows * (hexHeight - hexOffsetY) + hexOffsetY
    local marginX = (playdate.display.getWidth() - width) / 2
    local marginY = (playdate.display.getHeight() - height) / 2

    for column = 1, columns do
        self.grid[column] = {}

        for row = 1, rows do
            local x = marginX + hexWidth / 2 + (column - 1) * hexWidth + (row % 2 == 1 and hexWidth / 2 or 0)
            local y = marginY + hexHeight / 2 + (row - 1) * (hexHeight - hexOffsetY)

            local hexSprite = HexSprite()
            hexSprite:moveTo(x, y)
            hexSprite:setZIndex(0)
            hexSprite:add()

            self.grid[column][row] = hexSprite
        end
    end

    self.cursorSprite = CursorSprite()
    self.cursorSprite:setZIndex(2)
    self.cursorSprite:add()

    self:_moveCursor(false)

    for _, deployedTroop in ipairs(self.battle.deployedTroops) do
        local troopSprite = TroopSprite(deployedTroop.troop)

        local hexSprite = self:_getHex(deployedTroop.point)
        troopSprite:moveTo(hexSprite.x, hexSprite.y)
        troopSprite:setZIndex(1)
        troopSprite:add()

        table.insert(self.troopSprites, troopSprite)
    end

    self.cursorSamplePlayer = sound.sampleplayer.new("assets/sfx/cursor")
    self.selectSamplePlayer = sound.sampleplayer.new("assets/sfx/select")
    self.deselectSamplePlayer = sound.sampleplayer.new("assets/sfx/deselect")
end

function BattleScene:update()
    local cursorPoint = self.cursorPoint:copy()
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        cursorPoint.x = math.max(cursorPoint.x - 1, 1)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        cursorPoint.x = math.min(cursorPoint.x + 1, columns)
    elseif playdate.buttonJustPressed(playdate.kButtonUp) then
        cursorPoint.y = math.max(cursorPoint.y - 1, 1)
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        cursorPoint.y = math.min(cursorPoint.y + 1, rows)
    end

    if self.cursorPoint ~= cursorPoint then
        self.cursorPoint = cursorPoint

        self:_moveCursor(true)
        self.cursorSamplePlayer:play()
    end

    if self.cursorAnimator then
        local x, y = self.cursorAnimator:currentValue()
        self.cursorSprite:moveTo(x, y)

        if self.cursorAnimator:ended() then
            self.cursorAnimator = nil
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        if self.selectedPoint ~= nil then
            self:_getHex(self.selectedPoint):setSelected(false)
        end

        if self.selectedPoint == self.cursorPoint then
            self.selectedPoint = nil
            self.deselectSamplePlayer:play()
        else
            self:_getHex(self.cursorPoint):setSelected(true)

            self.selectedPoint = self.cursorPoint:copy()
            self.selectSamplePlayer:play()
        end
    end
end

function BattleScene:_getHex(point)
    return self.grid[point.x][point.y]
end

function BattleScene:_moveCursor(animate)
    local hexSprite = self:_getHex(self.cursorPoint)

    if animate then
        local from = geometry.point.new(self.cursorSprite.x, self.cursorSprite.y)
        local to = geometry.point.new(hexSprite.x, hexSprite.y)

        self.cursorAnimator = graphics.animator.new(cursorAnimationDuration, from, to,
            playdate.easingFunctions.outBack)
    else
        self.cursorSprite:moveTo(hexSprite.x, hexSprite.y)
    end
end
