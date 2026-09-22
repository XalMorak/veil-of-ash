# Concept pass — Veil of Ash (v0.5)

Art law from DESIGN.md: dark metal, wet stone, ember accents.
Humble silhouette, heavy material. No neon. Ember ≈ sRGB `255, 90, 20`.

This commit starts the hero-art track. In-engine bodies stay MeshKit CSG until
a GLB is dropped under `assets/characters/<id>/`. Concepts lock the silhouette
so sculpt / kitbash work does not drift.

## Locked roster (11)

### Playable remnants
| ID | Read at 20 m | Weapon |
| --- | --- | --- |
| `ash_warden` | Closed helm + kite + cloak | Ashen Longsword |
| `veil_dancer` | Veil strips + two curved lines | Twin Veil Blades |
| `cinder_priest` | Robe mass + ember-cage staff | Ember Staff |
| `iron_penitent` | Slab pauldrons + block mace | Penance Greatmace |

### Enemy ladder
| ID | Tier | Read at 20 m |
| --- | --- | --- |
| `ash_hollow` | fodder | Hunched sockets, snapped blade |
| `cinder_acolyte` | fodder | Bandaged hood + handheld coal cage |
| `veil_shade` | skirmisher | Pale mask + hanging ash body |
| `ash_sentinel` | soldier | Spear + planted kite at a gate |
| `veil_knight` | elite | Taller plate + back-banner + greatsword guard |
| `cinder_behemoth` | mini-boss | 2.5 m slag, horizontal torso crack |
| `the_first_ember` | lord | 3 m crowned king, open chest-furnace |

## Production next (sculpt / kitbash)
1. Blockout in Blender at real height (see MODELS.md).
2. Keep Mixamo humanoid for remnants + knight + hollow + sentinel + shade + acolyte.
3. Behemoth and First Ember may use custom rigs.
4. Bake ARM (AO / Roughness / Metallic) into one 2k.
5. Instance GLB under `MeshRoot` and skip `MeshKit.apply_*`.

Do not commit multi-hundred-MB binaries until the slice is locked.
