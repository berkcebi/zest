Adventurer = nil
class("Adventurer", { troops = {} }).extends()

function Adventurer:addTroop(troop)
    table.insert(self.troops, troop)
end
