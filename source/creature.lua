Creature = {}
class("Creature", {
    name = "",
    health = 0,
    attack = 0
}).extends()

function Creature:init(name, health, attack)
    Creature.super.init(self)

    self.name = name
    self.health = health
    self.attack = attack
end
