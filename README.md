# Veil of Ash

**3D souls-like action RPG** — олон дүр, stamina/poise тулаан, lock-on, холбоотой ертөнц.

High-ambition Godot 4 foundation. Not a prototype folder: combat rules, roster data, and scene architecture are already in place.

## Status

`v0.1.0` — engine skeleton. Playable loop comes next (locomotion polish → elite AI → first map slice).

## Why Godot 4

- Forward+ renderer + Jolt physics
- Entire project is text + git-friendly
- No engine tax, no revenue cliff
- Fits a solo / small-team souls-like better than a 100GB Unreal tree on day one

Target later: Steam + native. Web export is possible but not the fidelity target.

## Repo layout

```
data/characters.json          4 playable + enemy ladder
scripts/combat/               hitbox, hurtbox, vitality, defs
scripts/player/               controller + lock-on
scripts/enemies/              base AI
scripts/characters/           roster loader
scenes/world/hub.tscn         first space
DESIGN.md                     pillars (read this before adding systems)
```

## Controls (planned)

| Action | Input |
| --- | --- |
| Move | WASD |
| Light / Heavy | LMB / RMB |
| Dodge (i-frame) | Space |
| Block | Shift |
| Lock-on | MMB |
| Interact / Bonfire | E |

## Run locally

1. Install [Godot 4.3+](https://godotengine.org/download)
2. `git clone https://github.com/XalMorak/veil-of-ash.git`
3. Open the folder as a project
4. Press F5

## Next 5 commits

- [ ] Player scene with capsule + spring arm camera
- [ ] Hurtbox wired to Vitality on both sides
- [ ] Ash Hollow pawn in the hub
- [ ] Bonfire rest + soul drop
- [ ] AnimationTree stub for 8-way locomotion

## License

MIT © 2026 Xal'Morak
