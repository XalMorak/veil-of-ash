# Character model briefs — Veil of Ash

Production target for sculpted GLB hero meshes. Read with `MODELS.md`.
Art law: dark metal, wet stone, ember accents. Humble silhouette. No neon.

Ember only: approx sRGB `255, 90, 20`. Albedo luminance 0.05–0.35. Never pure black.

---

## Playable remnants

### ash_warden — Ash Warden (1.80 m)
- Closed greathelm, single horizontal ember slit, no face.
- Kite shield on left forearm, worn gold boss.
- Ashen longsword, straight, soot-dark, leather wrap.
- Mid-weight plate + tattered ash cloak falling to mid-calf.
- Hip height ~0.95 m. Tris 18–28k. Maps 2k albedo / ARM / normal.

### veil_dancer — Veil Dancer (1.72 m)
- Slim wrap, layered veil strips that read at 20 m as a hanging banner.
- Face half-covered. Pale ashen skin, no glow in the eyes.
- Twin curved blades, dark iron, slight rust at the tang.
- Lowest mass of the roster. Fast read: thin + two blade lines.
- Tris 18–24k. Cloth strips can be cards with alpha, not simulated.

### cinder_priest — Cinder Priest (1.84 m)
- Hooded robe mass. Gaunt ashen face inside the hood.
- Ember-cage staff: iron ring + living coal. This is the only strong emissive.
- Censer on a short chain at the hip.
- Tris 18–26k. Staff 2–3k separate or welded.

### iron_penitent — Iron Penitent (1.92 m)
- Iron mask, rust-pitted slab pauldrons, hanging chains.
- Penance greatmace: block head with cracked ember core.
- Widest silhouette. Slow roll read must be obvious from the mass.
- Tris 22–28k.

---

## Enemies

### ash_hollow — fodder (hunched ~1.45 m)
- Broken posture, hollow sockets with dying coals.
- Rag cloak, snapped blade.
- Shared 1k atlas across variants later. Tris 6–10k.

### veil_knight — elite (~2.05 m)
- Taller plate than the Warden. Veil-banner on a back pole.
- Greatsword held in a guard that reads before the swing.
- Tris 16–22k.

### cinder_behemoth — mini-boss (~2.5 m)
- Slag brute. Ember crack splits the torso horizontally.
- Asymmetric slag arm. Custom 18-bone rig allowed.
- Tris 28–40k.

### the_first_ember — lord (~3.0 m)
- Crowned hollow king. Chest is an open furnace, not a breastplate.
- Gold crown is the only bright metal. Greatsword as tall as a remnant.
- Extra clips: `phase2_slam`, `phase3_burst`.
- Tris 40–55k. 2k + emissive.

---

## Import contract
- glTF 2.0 / GLB, Y-up, 1 unit = 1 meter, root at feet.
- Mixamo / humanoid skeleton for remnants + knight + hollow.
- Drop each GLB in `assets/characters/<id>/` then instance under `MeshRoot`.
- Hide or skip `MeshKit.apply_*` once the real mesh is present.
