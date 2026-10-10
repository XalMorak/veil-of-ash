# Veil of Ash

High-end 3D souls-like action RPG built in **Godot 4**.

Multiple playable remnants, stamina/poise combat, lock-on, interconnected world, and a short but dense vertical slice: Ember Hearth → Cinder Crypt → Ash Causeway → First Ember.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Play

1. Godot 4.3+ → open this folder → **F5**.
2. New Game, pick a remnant.
3. **Ember Hearth**: hollows and a knight. Bonfire (E) refills the flask and opens level-up.
4. Side arch → **Cinder Crypt**. Slay the Behemoth. Flask shard on the left.
5. Far arch unlocks → **Ash Causeway**. Climb to the First Ember (3 phases).
6. Die and your souls drop. Touch the blue gem. Die again before that and they are lost.
7. Continue on the title screen resumes the last bonfire area.

## Controls

| Action | Key |
|--------|-----|
| Move | WASD |
| Look | Mouse |
| Light attack | LMB |
| Heavy attack | RMB |
| Dodge | Space |
| Block | Shift |
| Lock-on | MMB |
| Flask | R |
| Rest / Level-up | E |
| Pause | Esc |

## Stats

Vigor (HP), Endurance (stamina), Strength & Dexterity (weapon damage), Ember (both).  
Cost: `80 + level * 40` souls.

## Art

Silhouettes are generated in `scripts/art/mesh_kit.gd` until Mixamo / GLB heroes land.  
See `MODELS.md` and `ASSETS.md`.

## License

MIT
