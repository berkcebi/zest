Battle = nil
class("Battle", {
    columns = 11,
    rows = 9,
    adventurer = nil,
    deployedTroops = {}
}).extends()

function Battle:init(adventurer)
    Battle.super.init(self)

    self.adventurer = adventurer

    local troopRowsWithGaps = 2 * #adventurer.troops - 1
    local firstRow = math.floor((self.rows - troopRowsWithGaps) / 2) + 1
    for index, troop in ipairs(adventurer.troops) do
        local row = firstRow + (index - 1) * 2
        table.insert(self.deployedTroops, {
            troop = troop,
            point = playdate.geometry.point.new(1, row)
        })
    end
end
