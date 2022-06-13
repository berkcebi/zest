import "cursor"
import "hex"
import "troop"

local geometry <const> = playdate.geometry
local graphics <const> = playdate.graphics
local sound <const> = playdate.sound
local rows <const> = 9
local columns <const> = 11
local cursorAnimationDuration <const> = 250

Battleground = nil
class("Battleground", {
    grid = {},
    cursor = nil,
    cursorPoint = geometry.point.new(1, 1),
    cursorAnimator = nil,
    cursorSamplePlayer = nil,
    selectedPoint = nil,
    selectSamplePlayer = nil,
    deselectSamplePlayer = nil,
}).extends()

function Battleground:init()
    Battleground.super.init(self)

    local hexWidth, hexHeight = Hex.size()
    local hexOffsetY = Hex.offsetY()
    local width = columns * hexWidth + hexWidth / 2
    local height = rows * (hexHeight - hexOffsetY) + hexOffsetY
    local marginX = (playdate.display.getWidth() - width) / 2
    local marginY = (playdate.display.getHeight() - height) / 2

    for column = 1, columns do
        self.grid[column] = {}

        for row = 1, rows do
            local x = marginX + hexWidth / 2 + (column - 1) * hexWidth + (row % 2 == 1 and hexWidth / 2 or 0)
            local y = marginY + hexHeight / 2 + (row - 1) * (hexHeight - hexOffsetY)

            local hex = Hex()
            hex:moveTo(x, y)
            hex:setZIndex(0)
            hex:add()

            self.grid[column][row] = hex
        end
    end

    self.cursor = Cursor()
    self.cursor:setZIndex(2)
    self.cursor:add()

    self:_moveCursor(false)

    self.cursorSamplePlayer = sound.sampleplayer.new("assets/sfx/cursor")
    self.selectSamplePlayer = sound.sampleplayer.new("assets/sfx/select")
    self.deselectSamplePlayer = sound.sampleplayer.new("assets/sfx/deselect")

    local troop = Troop("J", 2)
    local hex = self:_getHex(geometry.point.new(3, 4))
    troop:moveTo(hex.x, hex.y)
    troop:setZIndex(1)
    troop:add()
end

function Battleground:update()
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
        self.cursor:moveTo(x, y)

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

function Battleground:_getHex(point)
    return self.grid[point.x][point.y]
end

function Battleground:_moveCursor(animate)
    local hex = self:_getHex(self.cursorPoint)

    if animate then
        local from = geometry.point.new(self.cursor.x, self.cursor.y)
        local to = geometry.point.new(hex.x, hex.y)

        self.cursorAnimator = graphics.animator.new(cursorAnimationDuration, from, to,
            playdate.easingFunctions.outBack)
    else
        self.cursor:moveTo(hex.x, hex.y)
    end
end
