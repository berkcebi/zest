import "cursor"
import "hex"

local rows <const> = 9
local columns <const> = 12

class("Battleground", {
    grid = {},
    cursor = nil,
    cursorColumn = 1,
    cursorRow = 1 }).extends()

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

    self:reloadCursorPosition()
end

function Battleground:update()
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        self.cursorColumn = math.max(self.cursorColumn - 1, 1)
        self:reloadCursorPosition()
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        self.cursorColumn = math.min(self.cursorColumn + 1, columns)
        self:reloadCursorPosition()
    elseif playdate.buttonJustPressed(playdate.kButtonUp) then
        self.cursorRow = math.max(self.cursorRow - 1, 1)
        self:reloadCursorPosition()
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        self.cursorRow = math.min(self.cursorRow + 1, rows)
        self:reloadCursorPosition()
    end
end

function Battleground:getHexPosition(column, row)
    local hex = self.grid[column][row]

    return hex.x, hex.y
end

function Battleground:reloadCursorPosition()
    local x, y = self:getHexPosition(self.cursorColumn, self.cursorRow)
    self.cursor:moveTo(x, y)
end
