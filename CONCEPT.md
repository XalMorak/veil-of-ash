# Concept pass — Veil of Ash (v0.5)

Art law from DESIGN.md: dark metal, wet stone, ember accents.
Humble silhouette, heavy material. No neon. Ember ≈ sRGB `255, 90, 20`.

Hero-art track. In-engine bodies stay MeshKit CSG until a GLB lands under
`assets/characters/<id>/`. Concepts lock the silhouette.

## Concept stills (drop `concept.jpg` in each folder)

| ID | File |
| --- | --- |
| Ash Warden | `assets/characters/ash_warden/concept.jpg` |
| Veil Dancer | `assets/characters/veil_dancer/concept.jpg` |
| Cinder Priest | `assets/characters/cinder_priest/concept.jpg` |
| Iron Penitent | `assets/characters/iron_penitent/concept.jpg` |
| Ash Hollow | `assets/characters/ash_hollow/concept.jpg` |
| Cinder Acolyte | `assets/characters/cinder_acolyte/concept.jpg` |
| Veil Shade | `assets/characters/veil_shade/concept.jpg` |
| Ash Sentinel | `assets/characters/ash_sentinel/concept.jpg` |
| Veil Knight | `assets/characters/veil_knight/concept.jpg` |
| Cinder Behemoth | `assets/characters/cinder_behemoth/concept.jpg` |
| The First Ember | `assets/characters/the_first_ember/concept.jpg` |

Unzip the concept pack at the repo root so those paths fill in.

```
unzip veil-of-ash-concepts.zip
git add assets/characters/*/concept.jpg
git commit -m "Add locked concept stills for 11-character roster"
git push
```

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

## Production next
1. Blockout in Blender at real height (MODELS.md).
2. Mixamo humanoid for remnants + knight + hollow + sentinel + shade + acolyte.
3. Custom rig for Behemoth and First Ember.
4. Bake ARM into one 2k. Instance GLB under `MeshRoot`.
