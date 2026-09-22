# Veil of Ash — Design Pillars

## Fantasy
The last fire is dying. The Veil — a membrane between a ruined age and the next — is tearing. Players are remnants who walk the ash to either rekindle or extinguish the First Ember.

## Combat (non-negotiable)
1. **Reads over reactions.** Every enemy telegraph is learnable. No cheap tracking that invalidates positioning.
2. **Stamina is the real HP.** Attacks, blocks, and dodges all spend the same resource.
3. **Poise is a second conversation.** Heavy weapons break stance; light weapons punish recovery.
4. **i-frames are short and honest.** 0.28s default dodge. No infinite roll spam.
5. **Lock-on is a tool, not a crutch.** Camera still allows free look and vertical arena reads.
6. **Death is tuition.** Souls drop at the corpse. Retrieve or lose them.

## Characters
Four playable archetypes ship in v0.1 data:
- Ash Warden — balanced knight
- Veil Dancer — dual blades, low poise, high stamina
- Cinder Priest — staff / miracle hybrid
- Iron Penitent — ultra weapon, high poise, slow roll

Enemy ladder: Hollow → Knight → Behemoth → Lord (phased).

## World
Interconnected vertical hub. No fast travel until two lords are down. Shortcuts are the reward for courage.

## Visual target
Dark metal, wet stone, ember accents. Humble silhouette, heavy material. No neon UI.

## Production order
1. Player locomotion + stamina/poise loop
2. One elite humanoid duel AI
3. Bonfire rest / soul retrieve
4. First vertical slice map (Ash Causeway)
5. Character silhouettes in-engine (MeshKit)
6. **Readable combat loop + Veil Knight duel AI + PoseDriver — this commit**
7. Mixamo body + clip set (idle, walk, run, dodge, light, heavy, hit, death)
8. Sculpted hero GLBs to the `MODELS.md` budget
9. Lord: The First Ember, 3 phases (systems in; slam after recover)
