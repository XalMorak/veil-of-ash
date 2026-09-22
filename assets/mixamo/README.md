# Mixamo import — Veil of Ash

PoseDriver already animates CSG silhouettes. Drop real clips here when ready.

## Required clip names
idle, walk, run, dodge, attack_light, attack_heavy, block, hit, death

Lord extras later: phase2_slam, phase3_burst

## Steps
1. mixamo.com → Y Bot (same skeleton for all remnants)
2. First download: FBX, *with skin*
3. Other takes: FBX, *without skin*
4. Import in Godot → Animation Library
5. Rename clips to the table above
6. Instance the skinned GLB under `Player/MeshRoot`
7. Keep `AnimationPlayer` on the player. AnimDriver prefers clips over PoseDriver.

Do not commit multi-hundred-MB binaries until the vertical slice is locked.
