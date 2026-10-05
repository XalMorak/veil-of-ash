# Veil of Ash

Short 3D souls-like. Four remnants, a locked causeway, a crypt mini-boss, and the First Ember.

https://github.com/XalMorak/veil-of-ash

## Play
Godot 4.3+ → open this folder → F5.

1. New Game, pick a remnant.
2. Ember Hearth: hollows and a knight. Bonfire (E) refills the flask and opens level-up. Rising reloads the area.
3. Side arch → **Cinder Crypt**. Slay the Behemoth. Flask shard on the left.
4. Far arch unlocks → **Ash Causeway**. Climb to the First Ember (3 phases).
5. Die and your souls drop. Touch the blue gem. Die again before that and they are lost.
6. Continue on the title screen resumes the last bonfire area.

## Controls
WASD move, mouse look, LMB light, RMB heavy, Space dodge, Shift block, MMB lock-on, R flask, E rest, Esc pause.

## Build
Vigor raises HP, Endurance raises stamina, Strength and Dexterity raise weapon damage, Ember raises both. Cost is `80 + level * 40` souls.

## Art
Silhouettes are generated in `scripts/art/mesh_kit.gd` until Mixamo / GLB heroes land. See `MODELS.md` and `ASSETS.md`.
