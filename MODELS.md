# Models — Veil of Ash

Pipeline is live in-engine:

1. Runtime looks for `res://assets/characters/<id>/<id>.glb`.
2. If missing, MeshKit / MeshKitExt builds the CSG silhouette.
3. `AssetLoader` is the single switch (`scripts/art/asset_loader.gd`).

## Heights
| ID | Height m |
| --- | --- |
| ash_warden | 1.85 |
| veil_dancer | 1.72 |
| cinder_priest | 1.78 |
| iron_penitent | 1.92 |
| ash_hollow | 1.55 |
| cinder_acolyte | 1.68 |
| veil_shade | 1.70 |
| ash_sentinel | 1.88 |
| veil_knight | 2.05 |
| cinder_behemoth | 2.50 |
| the_first_ember | 3.05 |

## Export
- Godot 4 GLB, +Y up, -Z forward, meters.
- Humanoids: Mixamo bone names.
- 18–55k tris. One 2k ARM + one 2k albedo.
- Origin at feet.

Causeway now spawns hollows, acolyte, shade, sentinel, knight, behemoth, lord.
