Battle = nil
class("Battle", {
    adventurer = nil,
    deployedTroops = {}
}).extends()

function Battle:init(adventurer)
    Battle.super.init(self)

    self.adventurer = adventurer

    for index, troop in ipairs(adventurer.troops) do
        table.insert(self.deployedTroops, {
            troop = troop,
            point = playdate.geometry.point.new(1, index)
        })
    end
end
