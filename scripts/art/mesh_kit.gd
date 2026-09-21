class_name MeshKit
extends RefCounted
## High-read souls-like silhouettes built from CSG.
## Replace these with Mixamo/GLB under MeshRoot when hero art lands.
## Visual target: dark metal, wet stone, ember accents. No neon.

const STEEL := Color(0.18, 0.17, 0.18)
const SOOT := Color(0.09, 0.08, 0.08)
const CLOTH := Color(0.12, 0.10, 0.09)
const BONE := Color(0.62, 0.56, 0.48)
const RUST := Color(0.28, 0.14, 0.08)
const ASH := Color(0.32, 0.30, 0.28)
const EMBER := Color(1.0, 0.38, 0.08)
const GOLD := Color(0.42, 0.32, 0.16)
const VEIL := Color(0.22, 0.20, 0.22)
const DARK_IRON := Color(0.11, 0.10, 0.11)
const CHAR := Color(0.07, 0.06, 0.06)

static func mat(albedo: Color, metallic := 0.0, roughness := 0.72, emission := Color.BLACK, e_energy := 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = albedo
	m.metallic = metallic
	m.roughness = roughness
	m.specular_mode = BaseMaterial3D.SPECULAR_SCHLICK_GGX
	if e_energy > 0.0:
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy_multiplier = e_energy
	return m

static func steel() -> StandardMaterial3D:
	return mat(STEEL, 0.82, 0.38)

static func dark_iron() -> StandardMaterial3D:
	return mat(DARK_IRON, 0.88, 0.32)

static func soot() -> StandardMaterial3D:
	return mat(SOOT, 0.05, 0.88)

static func cloth() -> StandardMaterial3D:
	return mat(CLOTH, 0.0, 0.92)

static func ember(energy := 3.2) -> StandardMaterial3D:
	return mat(EMBER, 0.15, 0.35, EMBER, energy)

static func bone() -> StandardMaterial3D:
	return mat(BONE, 0.05, 0.55)

static func rust() -> StandardMaterial3D:
	return mat(RUST, 0.45, 0.62)

static func gold() -> StandardMaterial3D:
	return mat(GOLD, 0.7, 0.42)

static func veil() -> StandardMaterial3D:
	return mat(VEIL, 0.08, 0.78)

static func ash_skin() -> StandardMaterial3D:
	return mat(ASH, 0.02, 0.85)

static func charred() -> StandardMaterial3D:
	return mat(CHAR, 0.12, 0.9)

static func part(kind: String, pos: Vector3, size: Vector3, material: Material, rot := Vector3.ZERO) -> CSGPrimitive3D:
	var n: CSGPrimitive3D
	match kind:
		"box":
			var b := CSGBox3D.new()
			b.size = size
			n = b
		"cyl":
			var c := CSGCylinder3D.new()
			c.radius = size.x
			c.height = size.y
			n = c
		"sph":
			var s := CSGSphere3D.new()
			s.radius = size.x
			n = s
		"tor":
			var t := CSGTorus3D.new()
			t.inner_radius = size.x
			t.outer_radius = size.y
			n = t
		_:
			var d := CSGBox3D.new()
			d.size = size
			n = d
	n.material = material
	n.position = pos
	n.rotation_degrees = rot
	return n

static func ember_light(pos: Vector3, energy := 4.0, rng := 6.0) -> OmniLight3D:
	var light := OmniLight3D.new()
	light.light_color = EMBER
	light.light_energy = energy
	light.omni_range = rng
	light.position = pos
	light.shadow_enabled = false
	return light

static func clear(root: Node3D) -> void:
	for c in root.get_children():
		c.queue_free()

static func apply_playable(root: Node3D, id: String) -> void:
	clear(root)
	match id:
		"veil_dancer":
			_dancer(root)
		"cinder_priest":
			_priest(root)
		"iron_penitent":
			_penitent(root)
		_:
			_warden(root)

static func apply_enemy(root: Node3D, id: String) -> void:
	clear(root)
	match id:
		"veil_knight":
			_knight(root)
		"cinder_behemoth":
			_behemoth(root)
		"the_first_ember":
			_lord(root)
		_:
			_hollow(root)

static func _humanoid(root: Node3D, body_r: float, body_h: float, head_r: float, body_mat: Material, head_mat: Material, hip_y := 0.72) -> void:
	root.add_child(part("cyl", Vector3(0, hip_y, 0), Vector3(body_r, body_h, 0), body_mat))
	root.add_child(part("sph", Vector3(0, hip_y + body_h * 0.5 + head_r * 0.35, 0), Vector3(head_r, 0, 0), head_mat))
	root.add_child(part("cyl", Vector3(-body_r * 0.72, 0.22, 0), Vector3(body_r * 0.30, 0.44, 0), body_mat))
	root.add_child(part("cyl", Vector3(body_r * 0.72, 0.22, 0), Vector3(body_r * 0.30, 0.44, 0), body_mat))

static func _warden(root: Node3D) -> void:
	var st := steel()
	var di := dark_iron()
	var cl := cloth()
	var em := ember(2.4)
	var gd := gold()
	_humanoid(root, 0.30, 1.12, 0.20, st, st)
	root.add_child(part("box", Vector3(0, 1.58, 0.02), Vector3(0.36, 0.30, 0.32), di))
	root.add_child(part("box", Vector3(0, 1.56, 0.18), Vector3(0.22, 0.035, 0.03), em))
	root.add_child(part("cyl", Vector3(0, 1.74, 0), Vector3(0.16, 0.08, 0), di))
	root.add_child(part("box", Vector3(0, 1.18, 0.04), Vector3(0.62, 0.22, 0.36), st))
	root.add_child(part("tor", Vector3(0, 1.32, 0.02), Vector3(0.16, 0.26, 0), gd, Vector3(90, 0, 0)))
	root.add_child(part("box", Vector3(-0.38, 1.28, 0), Vector3(0.28, 0.16, 0.38), di, Vector3(0, 0, 18)))
	root.add_child(part("box", Vector3(0.38, 1.28, 0), Vector3(0.28, 0.16, 0.38), di, Vector3(0, 0, -18)))
	root.add_child(part("box", Vector3(0, 1.05, -0.18), Vector3(0.68, 1.12, 0.07), cl))
	root.add_child(part("box", Vector3(0.08, 0.62, -0.22), Vector3(0.42, 0.55, 0.05), cl, Vector3(6, 8, 0)))
	root.add_child(part("box", Vector3(-0.48, 0.95, -0.04), Vector3(0.08, 0.82, 0.46), st))
	root.add_child(part("cyl", Vector3(-0.53, 1.02, 0.0), Vector3(0.07, 0.04, 0), gd, Vector3(0, 0, 90)))
	root.add_child(part("box", Vector3(0.44, 0.92, 0.02), Vector3(0.045, 1.05, 0.10), st, Vector3(8, 0, -12)))
	root.add_child(part("box", Vector3(0.46, 1.38, 0.02), Vector3(0.18, 0.04, 0.08), di, Vector3(8, 0, -12)))
	root.add_child(part("cyl", Vector3(0.47, 1.48, 0.02), Vector3(0.03, 0.14, 0), rust(), Vector3(8, 0, -12)))
	root.add_child(ember_light(Vector3(0, 1.56, 0.22), 1.6, 3.5))

static func _dancer(root: Node3D) -> void:
	var vl := veil()
	var cl := cloth()
	var st := steel()
	var di := dark_iron()
	_humanoid(root, 0.21, 1.02, 0.16, cl, ash_skin(), 0.70)
	root.add_child(part("box", Vector3(0, 1.40, 0.14), Vector3(0.26, 0.36, 0.03), vl))
	root.add_child(part("box", Vector3(0, 1.52, 0.02), Vector3(0.30, 0.08, 0.22), cl))
	root.add_child(part("cyl", Vector3(0, 1.12, 0), Vector3(0.24, 0.07, 0), rust()))
	root.add_child(part("box", Vector3(0, 0.92, -0.12), Vector3(0.36, 1.10, 0.05), vl))
	root.add_child(part("box", Vector3(-0.10, 0.70, -0.16), Vector3(0.12, 0.85, 0.03), vl, Vector3(8, 12, 0)))
	root.add_child(part("box", Vector3(0.12, 0.64, -0.15), Vector3(0.10, 0.78, 0.03), vl, Vector3(-6, -10, 0)))
	root.add_child(part("box", Vector3(0.36, 0.92, -0.04), Vector3(0.035, 0.78, 0.09), di, Vector3(14, 0, -22)))
	root.add_child(part("box", Vector3(0.40, 1.28, -0.02), Vector3(0.10, 0.03, 0.06), st, Vector3(14, 0, -22)))
	root.add_child(part("box", Vector3(-0.36, 0.86, 0.00), Vector3(0.035, 0.70, 0.09), di, Vector3(-10, 0, 24)))
	root.add_child(part("box", Vector3(-0.40, 1.18, 0.02), Vector3(0.10, 0.03, 0.06), st, Vector3(-10, 0, 24)))
	root.add_child(part("cyl", Vector3(0.28, 1.08, 0.02), Vector3(0.05, 0.16, 0), st, Vector3(0, 0, 70)))
	root.add_child(part("cyl", Vector3(-0.28, 1.08, 0.02), Vector3(0.05, 0.16, 0), st, Vector3(0, 0, -70)))

static func _priest(root: Node3D) -> void:
	var cl := cloth()
	var st := steel()
	var di := dark_iron()
	var em := ember(4.2)
	_humanoid(root, 0.27, 1.16, 0.17, cl, ash_skin(), 0.74)
	root.add_child(part("cyl", Vector3(0, 1.62, -0.02), Vector3(0.28, 0.32, 0), cl))
	root.add_child(part("box", Vector3(0, 1.58, 0.14), Vector3(0.30, 0.22, 0.08), cl))
	root.add_child(part("box", Vector3(0, 0.82, -0.06), Vector3(0.78, 1.38, 0.22), cl))
	root.add_child(part("box", Vector3(0, 0.55, -0.14), Vector3(0.62, 0.85, 0.10), cl, Vector3(8, 0, 0)))
	root.add_child(part("cyl", Vector3(0, 1.05, 0.04), Vector3(0.29, 0.06, 0), rust()))
	root.add_child(part("sph", Vector3(-0.18, 0.70, 0.18), Vector3(0.07, 0, 0), rust()))
	root.add_child(part("cyl", Vector3(-0.18, 0.86, 0.18), Vector3(0.012, 0.28, 0), di))
	root.add_child(part("cyl", Vector3(0.44, 1.02, -0.04), Vector3(0.032, 1.62, 0), st))
	root.add_child(part("tor", Vector3(0.44, 1.90, -0.04), Vector3(0.09, 0.16, 0), di))
	root.add_child(part("sph", Vector3(0.44, 1.90, -0.04), Vector3(0.11, 0, 0), em))
	root.add_child(part("box", Vector3(0.44, 2.04, -0.04), Vector3(0.03, 0.14, 0.03), di))
	root.add_child(ember_light(Vector3(0.44, 1.90, -0.04), 5.0, 8.0))

static func _penitent(root: Node3D) -> void:
	var st := steel()
	var di := dark_iron()
	var rs := rust()
	var em := ember(1.8)
	_humanoid(root, 0.38, 1.24, 0.21, st, di, 0.76)
	root.add_child(part("box", Vector3(0, 1.58, 0.06), Vector3(0.34, 0.28, 0.28), rs))
	root.add_child(part("box", Vector3(0, 1.56, 0.20), Vector3(0.16, 0.04, 0.03), em))
	root.add_child(part("box", Vector3(0, 1.24, 0.02), Vector3(1.22, 0.30, 0.54), di))
	root.add_child(part("box", Vector3(-0.52, 1.34, 0), Vector3(0.36, 0.22, 0.46), st, Vector3(0, 0, 16)))
	root.add_child(part("box", Vector3(0.52, 1.34, 0), Vector3(0.36, 0.22, 0.46), st, Vector3(0, 0, -16)))
	root.add_child(part("cyl", Vector3(-0.22, 0.95, 0.16), Vector3(0.025, 0.92, 0), rs, Vector3(10, 0, 12)))
	root.add_child(part("cyl", Vector3(0.18, 1.00, 0.18), Vector3(0.025, 0.78, 0), rs, Vector3(-8, 0, -10)))
	root.add_child(part("sph", Vector3(-0.24, 0.48, 0.22), Vector3(0.05, 0, 0), rs))
	root.add_child(part("cyl", Vector3(0.58, 0.98, 0.04), Vector3(0.055, 1.42, 0), di))
	root.add_child(part("box", Vector3(0.58, 0.28, 0.04), Vector3(0.32, 0.32, 0.32), rs))
	root.add_child(part("box", Vector3(0.58, 0.28, 0.04), Vector3(0.18, 0.18, 0.18), em))
	root.add_child(ember_light(Vector3(0.58, 0.28, 0.04), 2.2, 4.0))

static func _hollow(root: Node3D) -> void:
	var sk := ash_skin()
	var rs := rust()
	var cl := cloth()
	var ch := charred()
	root.add_child(part("cyl", Vector3(0, 0.60, 0.08), Vector3(0.19, 0.92, 0), sk, Vector3(14, 0, 0)))
	root.add_child(part("sph", Vector3(0.02, 1.22, 0.18), Vector3(0.145, 0, 0), ch))
	root.add_child(part("sph", Vector3(-0.05, 1.24, 0.30), Vector3(0.032, 0, 0), ember(1.1)))
	root.add_child(part("sph", Vector3(0.07, 1.24, 0.30), Vector3(0.032, 0, 0), ember(1.1)))
	root.add_child(part("box", Vector3(0, 1.12, 0.22), Vector3(0.08, 0.04, 0.04), ch))
	root.add_child(part("box", Vector3(0, 0.68, -0.02), Vector3(0.40, 0.52, 0.07), cl, Vector3(10, 0, 0)))
	root.add_child(part("box", Vector3(0.30, 0.66, 0.12), Vector3(0.035, 0.48, 0.07), rs, Vector3(22, 0, -18)))
	root.add_child(part("box", Vector3(0.32, 0.88, 0.10), Vector3(0.08, 0.03, 0.05), rs, Vector3(22, 0, -18)))
	root.add_child(part("cyl", Vector3(-0.14, 0.20, 0.10), Vector3(0.065, 0.36, 0), sk, Vector3(8, 0, 0)))
	root.add_child(part("cyl", Vector3(0.14, 0.18, 0.04), Vector3(0.065, 0.34, 0), sk, Vector3(-4, 0, 0)))

static func _knight(root: Node3D) -> void:
	var st := steel()
	var di := dark_iron()
	var vl := veil()
	var em := ember(2.0)
	var gd := gold()
	root.add_child(part("cyl", Vector3(0, 0.95, 0), Vector3(0.33, 1.48, 0), st))
	root.add_child(part("sph", Vector3(0, 1.84, 0), Vector3(0.22, 0, 0), di))
	root.add_child(part("box", Vector3(0, 1.80, 0.18), Vector3(0.18, 0.035, 0.03), em))
	root.add_child(part("box", Vector3(0, 1.44, 0.02), Vector3(1.10, 0.22, 0.48), di))
	root.add_child(part("tor", Vector3(0, 1.56, 0.02), Vector3(0.18, 0.28, 0), gd, Vector3(90, 0, 0)))
	root.add_child(part("cyl", Vector3(-0.12, 1.55, -0.28), Vector3(0.025, 1.55, 0), di))
	root.add_child(part("box", Vector3(0.02, 1.35, -0.30), Vector3(0.38, 1.15, 0.04), vl))
	root.add_child(part("box", Vector3(0.54, 1.05, -0.06), Vector3(0.06, 1.38, 0.14), st, Vector3(6, 0, 0)))
	root.add_child(part("box", Vector3(0.54, 1.68, -0.06), Vector3(0.22, 0.05, 0.10), di, Vector3(6, 0, 0)))
	root.add_child(part("cyl", Vector3(-0.24, 0.28, 0), Vector3(0.11, 0.52, 0), st))
	root.add_child(part("cyl", Vector3(0.24, 0.28, 0), Vector3(0.11, 0.52, 0), st))
	root.add_child(ember_light(Vector3(0, 1.80, 0.22), 1.8, 4.0))

static func _behemoth(root: Node3D) -> void:
	var st := soot()
	var em := ember(5.2)
	var rs := rust()
	var di := dark_iron()
	root.add_child(part("box", Vector3(0, 1.15, 0.12), Vector3(1.38, 1.58, 1.72), st))
	root.add_child(part("sph", Vector3(0, 2.08, 0.52), Vector3(0.50, 0, 0), st))
	root.add_child(part("cyl", Vector3(-0.24, 2.52, 0.38), Vector3(0.08, 0.58, 0), rs, Vector3(20, 0, -14)))
	root.add_child(part("cyl", Vector3(0.24, 2.52, 0.38), Vector3(0.08, 0.58, 0), rs, Vector3(20, 0, 14)))
	root.add_child(part("box", Vector3(0, 1.18, 0.14), Vector3(1.40, 0.10, 1.74), em))
	root.add_child(part("box", Vector3(0.08, 1.40, 0.98), Vector3(0.12, 0.85, 0.06), em, Vector3(0, 0, 8)))
	root.add_child(part("box", Vector3(0.88, 0.98, 0.52), Vector3(0.38, 1.58, 0.38), rs))
	root.add_child(part("box", Vector3(0.90, 0.18, 0.55), Vector3(0.42, 0.22, 0.42), di))
	root.add_child(part("box", Vector3(-0.55, 0.42, 0.52), Vector3(0.34, 0.85, 0.34), st))
	root.add_child(part("box", Vector3(0.35, 0.42, -0.48), Vector3(0.34, 0.85, 0.34), st))
	root.add_child(part("box", Vector3(-0.35, 0.42, -0.48), Vector3(0.34, 0.85, 0.34), st))
	root.add_child(ember_light(Vector3(0, 1.2, 0.4), 7.0, 10.0))

static func _lord(root: Node3D) -> void:
	var st := steel()
	var di := dark_iron()
	var cl := cloth()
	var em := ember(6.8)
	var gd := gold()
	root.add_child(part("cyl", Vector3(0, 1.35, 0), Vector3(0.50, 2.18, 0), di))
	root.add_child(part("sph", Vector3(0, 2.58, 0), Vector3(0.30, 0, 0), st))
	root.add_child(part("tor", Vector3(0, 2.82, 0), Vector3(0.16, 0.40, 0), gd))
	root.add_child(part("box", Vector3(0, 3.02, 0), Vector3(0.06, 0.28, 0.06), gd))
	root.add_child(part("box", Vector3(-0.22, 2.96, 0), Vector3(0.05, 0.20, 0.05), gd, Vector3(0, 0, 18)))
	root.add_child(part("box", Vector3(0.22, 2.96, 0), Vector3(0.05, 0.20, 0.05), gd, Vector3(0, 0, -18)))
	root.add_child(part("sph", Vector3(0, 1.48, 0.10), Vector3(0.30, 0, 0), em))
	root.add_child(part("tor", Vector3(0, 1.48, 0.10), Vector3(0.22, 0.34, 0), st, Vector3(90, 0, 0)))
	root.add_child(part("box", Vector3(0, 1.52, -0.30), Vector3(1.02, 2.12, 0.10), cl))
	root.add_child(part("box", Vector3(0.76, 1.38, -0.10), Vector3(0.10, 2.18, 0.16), st, Vector3(5, 0, 0)))
	root.add_child(part("box", Vector3(0.76, 2.42, -0.10), Vector3(0.28, 0.06, 0.12), gd, Vector3(5, 0, 0)))
	root.add_child(part("cyl", Vector3(-0.28, 0.28, 0), Vector3(0.13, 0.55, 0), di))
	root.add_child(part("cyl", Vector3(0.28, 0.28, 0), Vector3(0.13, 0.55, 0), di))
	root.add_child(ember_light(Vector3(0, 1.55, 0.12), 8.0, 14.0))
