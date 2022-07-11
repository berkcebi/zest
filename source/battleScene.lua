import "cursorSprite"
import "hexSprite"
import "selectionIndicatorSprite"
import "troopSprite"

local geometry <const> = playdate.geometry
local graphics <const> = playdate.graphics
local sound <const> = playdate.sound
local cursorAnimationDuration <const> = 250

BattleScene = {}
class("BattleScene", {
    battle = nil,
    grid = {},
    cursorSprite = nil,
    cursorPoint = geometry.point.new(1, 1),
    cursorAnimator = nil,
    cursorSamplePlayer = nil,
    selectionIndicatorSprite = nil,
    selectedDeployedTroop = nil,
    selectSamplePlayer = nil,
    deselectSamplePlayer = nil,
    troopSprites = {}
}).extends()

function BattleScene:init(battle)
    BattleScene.super.init(self)

    self.battle = battle

    local columns = self.battle.columns
    local rows = self.battle.rows
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
    self.cursorSprite:setZIndex(3)
    self.cursorSprite:add()

    self:_moveCursor(false)

    self.selectionIndicatorSprite = SelectionIndicatorSprite()
    self.selectionIndicatorSprite:setZIndex(1)
    self.selectionIndicatorSprite:setVisible(false)
    self.selectionIndicatorSprite:add()

    for _, deployedTroop in ipairs(self.battle.deployedTroops) do
        local troopSprite = TroopSprite(deployedTroop.troop)

        local hexSprite = self:_getHex(deployedTroop.point)
        troopSprite:moveTo(hexSprite.x, hexSprite.y)
        troopSprite:setZIndex(2)
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
        cursorPoint.x = math.min(cursorPoint.x + 1, self.battle.columns)
    elseif playdate.buttonJustPressed(playdate.kButtonUp) then
        cursorPoint.y = math.max(cursorPoint.y - 1, 1)
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        cursorPoint.y = math.min(cursorPoint.y + 1, self.battle.rows)
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
        if self.selectedDeployedTroop then
            if self.selectedDeployedTroop.point ~= self.cursorPoint then
                self.selectedDeployedTroop.point = self.cursorPoint
                self:_reloadDeployedTroop(self.selectedDeployedTroop)
            end

            self.selectedDeployedTroop = nil
            self:_reloadSelectionIndicator()

            self.deselectSamplePlayer:play()
        else
            local deployedTroop = self:_getDeployedTroop(self.cursorPoint)
            if deployedTroop then
                self.selectedDeployedTroop = deployedTroop
                self:_reloadSelectionIndicator()

                self.selectSamplePlayer:play()
            end
        end
    end
end

function BattleScene:_getHex(point)
    return self.grid[point.x][point.y]
end

function BattleScene:_getDeployedTroop(point)
    for _, deployedTroop in ipairs(self.battle.deployedTroops) do
        if deployedTroop.point == point then
            return deployedTroop
        end
    end

    return nil
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

function BattleScene:_reloadSelectionIndicator()
    if self.selectedDeployedTroop then
        local hexSprite = self:_getHex(self.selectedDeployedTroop.point)
        self.selectionIndicatorSprite:moveTo(hexSprite.x, hexSprite.y)
        self.selectionIndicatorSprite:setVisible(true)
    else
        self.selectionIndicatorSprite:setVisible(false)
    end
end

function BattleScene:_reloadDeployedTroop(deployedTroop)
    local hexSprite = self:_getHex(deployedTroop.point)
    for _, troopSprite in ipairs(self.troopSprites) do
        if troopSprite.troop == self.selectedDeployedTroop.troop then
            troopSprite:moveTo(hexSprite.x, hexSprite.y)
            return
        end
    end
end
