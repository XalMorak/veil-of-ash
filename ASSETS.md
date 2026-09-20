# Art pipeline — Veil of Ash

## Now (in engine)
`MeshKit` (`scripts/art/mesh_kit.gd`) builds a distinct CSG silhouette per remnant and enemy.
`WorldPalette` paints CSG architecture wet-stone / soot.
See `MODELS.md` for budgets, folders, and the final GLB spec.

No clips yet = MeshKit still renders. `AnimDriver` silently no-ops missing clip names.

## Mixamo → Godot (hero meshes)
`AnimDriver` looks for an `AnimationPlayer` under the player and plays these exact clip names:

| State | Clip |
| --- | --- |
| idle | `idle` |
| walk | `walk` |
| run | `run` |
| dodge | `dodge` |
| light attack | `attack_light` |
| heavy attack | `attack_heavy` |
| block | `block` |
| hit | `hit` |
| death | `death` |

### Import steps
1. mixamo.com → Y Bot (or any same-skeleton pack)
2. Download each take as FBX, *without skin* after the first (first = with skin)
3. Drop into `res://assets/mixamo/`
4. Godot Import dock → Animation Library. Rename clips to the table above.
5. Instance the `.glb` under `Player/MeshRoot`. MeshKit will not run if you skip `apply_playable` and keep the GLB.
6. Ensure the scene has `AnimationPlayer`. `AnimDriver` finds it automatically.
