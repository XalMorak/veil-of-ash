# Veil of Ash

**3D souls-like action RPG** — 4 playable remnants, stamina/poise combat, lock-on, bonfire, soul retrieve.

Repo: https://github.com/XalMorak/veil-of-ash

## Play (v0.2)

1. Install [Godot 4.3+](https://godotengine.org/download)
2. Clone this repo and open the folder as a project
3. F5 — character select → hub

### Loop that works now
- Pick Ash Warden / Veil Dancer / Cinder Priest / Iron Penitent
- Spring-arm camera, WASD, mouse look, MMB lock-on
- Light / heavy hitboxes spend stamina
- Dodge has 0.28s i-frames
- Block reduces damage if stamina remains
- 3 Ash Hollow + 1 Veil Knight in the hub
- Kill → souls. Die → souls drop at corpse. Touch the blue gem to retrieve. Die again first → lost.
- Walk to the ember pit, press E — full rest

### Controls
| Action | Input |
| --- | --- |
| Move | WASD |
| Look | Mouse |
| Light / Heavy | LMB / RMB |
| Dodge | Space |
| Block | Shift |
| Lock-on | MMB |
| Bonfire | E |
| Free cursor | Esc |

## What this is / is not
This is a **playable systems vertical slice** with primitive meshes (capsule bodies). It is not finished art, animation clips, or a full interconnected map. Those are the next production layer on top of working rules.

## Layout
```
scenes/actors/     player, ash_hollow, veil_knight
scenes/world/      hub, bonfire, soul_pickup
scenes/ui/         character_select, hud
scripts/combat/    hitbox, hurtbox, vitality
scripts/player/    controller, lock-on, 8-way loco machine
data/characters.json
DESIGN.md
```

## License
MIT © 2026 Xal'Morak
