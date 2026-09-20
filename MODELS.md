# Veil of Ash — 3D Model Bible

Visual target from DESIGN.md: **dark metal, wet stone, ember accents. Humble silhouette, heavy material. No neon.**

This pass ships *readable production silhouettes* in-engine via `MeshKit`.
They are not final hero meshes. They exist so every remnant and enemy is
identifiable at 20 meters while Mixamo / sculpted GLBs come in.

## Roster (v0.3 art)

### Playable remnants
| ID | Silhouette read | Weapon | Height |
| --- | --- | --- | --- |
| `ash_warden` | Closed helm + kite shield + cloak | Ashen Longsword | 1.80 m |
| `veil_dancer` | Veil + dual curved blades + slim wrap | Twin Veil Blades | 1.72 m |
| `cinder_priest` | Hood + robe mass + ember-cage staff | Ember Staff | 1.84 m |
| `iron_penitent` | Iron mask + slab pauldrons + greatmace | Penance Greatmace | 1.92 m |

### Enemies
| ID | Tier | Silhouette read |
| --- | --- | --- |
| `ash_hollow` | fodder | Hunched, hollow sockets, broken blade |
| `veil_knight` | elite | Taller plate, veil-banner, greatsword guard |
| `cinder_behemoth` | mini-boss | 2.5 m slag brute, ember crack through torso |
| `the_first_ember` | lord | 3 m crowned king, hollow chest-flame |

## How MeshKit is used
- Player: `PlayerController` calls `MeshKit.apply_playable(MeshRoot, selected_id)`.
- Enemies: `EnemyBase` looks for `MeshRoot` (creates it if missing) and calls `MeshKit.apply_enemy`.
- Hide / delete CSG children when a real `.glb` is instanced under `MeshRoot`.

## Final hero-art spec (next)
Target engine import: **glTF 2.0 / GLB**, Y-up, 1 unit = 1 meter.

### Poly / texture budgets
| Asset | Tris | Maps |
| --- | --- | --- |
| Playable body | 18–28k | 2k albedo / ARM / normal |
| Elite knight | 16–22k | 2k |
| Hollow | 6–10k | 1k shared atlas |
| Behemoth | 28–40k | 2k |
| First Ember | 40–55k | 2k + emissive |
| Weapons | 1.5–4k | 1k shared |

ARM = AO + Roughness + Metallic packed RGB.

### Skeleton
Mixamo / Humanoid compatible. Root at feet. Hip height ~0.95 m for remnants.
Behemoth may use a custom 18-bone rig.

### Required clips (see ASSETS.md)
`idle walk run dodge attack_light attack_heavy block hit death`

Lord extra: `phase2_slam`, `phase3_burst`.

### Material rules
- Base albedo stays in the 0.05–0.35 luminance band.
- Only emissive is ember (approx sRGB 255, 90, 20).
- No pure black albedo. Lift to 0.04 so SSAO still reads form.
- Edge wear lives in roughness, not in extra albedo noise.

## Folder plan
```
assets/
  mixamo/          # animation library only
  characters/
    ash_warden/
    veil_dancer/
    cinder_priest/
    iron_penitent/
    ash_hollow/
    veil_knight/
    cinder_behemoth/
    the_first_ember/
  weapons/
  world/
```

Do not commit multi-hundred-MB binaries until the slice is locked.
