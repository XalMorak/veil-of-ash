# Asset pipeline (next art pass)

Systems are in. Art is intentionally primitive so git stays text-only.

## Recommended import
1. Mixamo: Y-Bot + Idle / Walk / Run / Jump / Sword Slash / Great Sword Slash / Hit / Death
2. Export FBX, Godot Import as AnimationLibrary
3. Replace `MeshRoot` CSG with `PackedScene` of the rig
4. Hook `LocomotionMachine.state` to AnimationTree blend space 2D + OneShot attack/dodge

## Naming contract
```
idle, walk, run, dodge, attack_light, attack_heavy, block, hit, death, boss_slam
```

Do not commit multi-hundred-MB `.glb` until the slice is locked.
