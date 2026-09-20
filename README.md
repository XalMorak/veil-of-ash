# Veil of Ash

3D souls-like — 4 remnants, 4 enemy silhouettes, weapon stats, lock-on, bonfire respawn, soul retrieve, Ash Causeway, First Ember (3 phases).

https://github.com/XalMorak/veil-of-ash

## Play
Godot 4.3+ → open folder → F5.

1. Choose a remnant (each has its own MeshKit silhouette)
2. Hub: Hollows + Knight. Ember pit = rest (E). Rest respawns enemies.
3. Arch at the far end → **Ash Causeway** (ramp, bridge, upper court)
4. Upper court: **The First Ember** — phase 2 slam, phase 3 faster
5. Die → souls drop. Touch blue gem. Die again first → lost. Respawn last scene.

Controls: WASD, mouse, LMB/RMB, Space dodge, Shift block, MMB lock-on, E rest, Esc cursor.

## Art
In-engine high-read silhouettes live in `scripts/art/mesh_kit.gd`.
Final hero GLB spec, poly budgets, and folder plan: `MODELS.md`.
Mixamo clip names: `ASSETS.md`.
