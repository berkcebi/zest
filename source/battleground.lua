import "cursor"
import "hex"

local rows <const> = 9
local columns <const> = 12
local cursorAnimationDuration <const> = 250

Battleground = nil
class("Battleground", {
    grid = {},
    cursor = nil,
    cursorColumn = 1,
    cursorRow = 1,
    cursorAnimator = nil,
    cursorSamplePlayer = nil }).extends()

function Battleground:init()
    Battleground.super.init(self)

    local hexWidth, hexHeight = Hex.size()
    local width = columns * hexWidth + hexWidth / 2
    local height = rows * (hexHeight * 3 / 4) + hexHeight / 4
    local offsetX = (playdate.display.getWidth() - width) / 2
    local offsetY = (playdate.display.getHeight() - height) / 2

    for column = 1, columns do
        self.grid[column] = {}

        for row = 1, rows do
            local x = offsetX + (column - 0.5) * hexWidth + (row % 2 == 1 and hexWidth / 2 or 0)
            local y = offsetY + (row - 1) * (hexHeight * 3 / 4) + hexHeight / 2

            local hex = Hex()
            hex:moveTo(x, y)
            hex:add()

            self.grid[column][row] = hex
        end
    end

    self.cursor = Cursor()
    self.cursor:add()

    self:reloadCursorPosition(false)

    self.cursorSamplePlayer = playdate.sound.sampleplayer.new("assets/sfx/cursor")
end

function Battleground:update()
    local cursorColumn = self.cursorColumn
    local cursorRow = self.cursorRow
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        cursorColumn = math.max(self.cursorColumn - 1, 1)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        cursorColumn = math.min(self.cursorColumn + 1, columns)
    elseif playdate.buttonJustPressed(playdate.kButtonUp) then
        cursorRow = math.max(self.cursorRow - 1, 1)
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        cursorRow = math.min(self.cursorRow + 1, rows)
    end

    if self.cursorColumn ~= cursorColumn or self.cursorRow ~= cursorRow then
        self.cursorColumn = cursorColumn
        self.cursorRow = cursorRow

        self:reloadCursorPosition(true)
        self.cursorSamplePlayer:play()
    end

    if self.cursorAnimator then
        local x, y = self.cursorAnimator:currentValue()
        self.cursor:moveTo(x, y)

        if self.cursorAnimator:ended() then
            self.cursorAnimator = nil
        end
    end
end

function Battleground:getHexPosition(column, row)
    local hex = self.grid[column][row]

    return hex.x, hex.y
end

function Battleground:reloadCursorPosition(animate)
    local x, y = self:getHexPosition(self.cursorColumn, self.cursorRow)

    if animate then
        local from = playdate.geometry.point.new(self.cursor.x, self.cursor.y)
        local to = playdate.geometry.point.new(x, y)

        self.cursorAnimator = playdate.graphics.animator.new(cursorAnimationDuration, from, to, playdate.easingFunctions.outBack)
    else
        self.cursor:moveTo(x, y)
    end
end
