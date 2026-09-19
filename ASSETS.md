# Mixamo → Veil of Ash

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

## Import steps
1. mixamo.com → Y Bot (or any same-skeleton pack)
2. Download each take as FBX, *without skin* after the first (first = with skin)
3. Drop into `res://assets/mixamo/`
4. Godot Import dock → Animation Library. Rename clips to the table above.
5. Instance the `.glb` under `Player/MeshRoot`. Hide or delete the CSG Body/Head.
6. Ensure the scene has `AnimationPlayer`. `AnimDriver` finds it automatically.

No clips yet = CSG capsule still renders. Driver silently no-ops missing names.
