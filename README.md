# zest

Tactical role-playing roguelike for Playdate

## Architectural pattern

### Model

Model objects encapsulate game data, e.g. `Troop`. They typically persist when the game is terminated.

### Sprite

Sprites are objects that are drawn on screen, e.g. `TroopSprite`. They extend `playdate.graphics.sprite` and might depend on models to draw their data.

### Scene

Scene objects, e.g. `BattleScene`, manage lifecycles of sprites, accept user input and update models.
