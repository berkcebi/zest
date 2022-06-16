Troop = nil
class("Troop", {
    creature = nil,
    count = 0
}).extends()

function Troop:init(creature, count)
    Troop.super.init(self)

    self.creature = creature
    self.count = count
end
