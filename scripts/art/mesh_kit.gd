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

static func _humanoid(root: Node3D, body_r: float, body_h: float, head_r: float, body_mat: Material, head_mat: Material) -> void:
	root.add_child(part("cyl", Vector3(0, 0.72, 0), Vector3(body_r, body_h, 0), body_mat))
	root.add_child(part("sph", Vector3(0, 1.52, 0), Vector3(head_r, 0, 0), head_mat))
	root.add_child(part("cyl", Vector3(-0.22, 0.22, 0), Vector3(0.09, 0.44, 0), body_mat))
	root.add_child(part("cyl", Vector3(0.22, 0.22, 0), Vector3(0.09, 0.44, 0), body_mat))

static func _warden(root: Node3D) -> void:
	var st := steel()
	var cl := cloth()
	var em := ember(2.4)
	_humanoid(root, 0.30, 1.12, 0.20, st, st)
	root.add_child(part("box", Vector3(0, 1.18, 0), Vector3(0.92, 0.18, 0.42), st))
	root.add_child(part("box", Vector3(0, 1.58, 0.02), Vector3(0.34, 0.28, 0.30), st))
	root.add_child(part("box", Vector3(0, 1.56, 0.16), Vector3(0.22, 0.04, 0.04), em))
	root.add_child(part("box", Vector3(0, 1.05, -0.16), Vector3(0.62, 1.05, 0.08), cl))
	root.add_child(part("box", Vector3(0.42, 0.82, 0.02), Vector3(0.06, 0.95, 0.38), st))
	root.add_child(part("box", Vector3(-0.48, 0.95, -0.08), Vector3(0.08, 0.72, 0.42), st))
	root.add_child(part("tor", Vector3(0, 0.55, 0), Vector3(0.22, 0.34, 0), gold(), Vector3(90, 0, 0)))

static func _dancer(root: Node3D) -> void:
	var vl := veil()
	var cl := cloth()
	var st := steel()
	_humanoid(root, 0.22, 1.05, 0.17, cl, ash_skin())
	root.add_child(part("box", Vector3(0, 1.42, 0.12), Vector3(0.28, 0.34, 0.04), vl))
	root.add_child(part("box", Vector3(0, 0.95, -0.12), Vector3(0.38, 1.15, 0.06), vl))
	root.add_child(part("box", Vector3(0.38, 0.95, -0.05), Vector3(0.04, 0.72, 0.10), st, Vector3(12, 0, -18)))
	root.add_child(part("box", Vector3(-0.38, 0.88, -0.02), Vector3(0.04, 0.62, 0.10), st, Vector3(-8, 0, 22)))
	root.add_child(part("cyl", Vector3(0, 1.18, 0), Vector3(0.26, 0.08, 0), rust()))

static func _priest(root: Node3D) -> void:
	var cl := cloth()
	var st := steel()
	var em := ember(4.0)
	_humanoid(root, 0.28, 1.18, 0.18, cl, ash_skin())
	root.add_child(part("cyl", Vector3(0, 1.62, 0), Vector3(0.26, 0.28, 0), cl))
	root.add_child(part("box", Vector3(0, 0.85, -0.08), Vector3(0.72, 1.35, 0.18), cl))
	root.add_child(part("cyl", Vector3(0.42, 1.05, -0.04), Vector3(0.035, 1.55, 0), st))
	root.add_child(part("sph", Vector3(0.42, 1.88, -0.04), Vector3(0.12, 0, 0), em))
	root.add_child(part("tor", Vector3(0.42, 1.88, -0.04), Vector3(0.10, 0.16, 0), st))
	root.add_child(part("sph", Vector3(-0.18, 0.72, 0.16), Vector3(0.08, 0, 0), rust()))

static func _penitent(root: Node3D) -> void:
	var st := steel()
	var rs := rust()
	var em := ember(1.6)
	_humanoid(root, 0.38, 1.22, 0.21, st, st)
	root.add_child(part("box", Vector3(0, 1.22, 0), Vector3(1.18, 0.28, 0.52), st))
	root.add_child(part("box", Vector3(0, 1.56, 0.04), Vector3(0.32, 0.26, 0.28), rs))
	root.add_child(part("box", Vector3(0, 1.54, 0.18), Vector3(0.18, 0.05, 0.04), em))
	root.add_child(part("cyl", Vector3(0.55, 0.95, 0.02), Vector3(0.07, 1.35, 0), st))
	root.add_child(part("box", Vector3(0.55, 0.28, 0.02), Vector3(0.28, 0.28, 0.28), rs))
	root.add_child(part("cyl", Vector3(-0.32, 1.05, 0.12), Vector3(0.03, 0.85, 0), rust(), Vector3(12, 0, 18)))
	root.add_child(part("cyl", Vector3(0.28, 1.12, 0.14), Vector3(0.03, 0.7, 0), rust(), Vector3(-10, 0, -14)))

static func _hollow(root: Node3D) -> void:
	var sk := ash_skin()
	var rs := rust()
	var cl := cloth()
	root.add_child(part("cyl", Vector3(0, 0.62, 0.04), Vector3(0.20, 0.95, 0), sk, Vector3(8, 0, 0)))
	root.add_child(part("sph", Vector3(0, 1.28, 0.10), Vector3(0.15, 0, 0), sk))
	root.add_child(part("sph", Vector3(-0.06, 1.30, 0.22), Vector3(0.03, 0, 0), ember(1.2)))
	root.add_child(part("sph", Vector3(0.06, 1.30, 0.22), Vector3(0.03, 0, 0), ember(1.2)))
	root.add_child(part("box", Vector3(0, 0.72, -0.06), Vector3(0.42, 0.55, 0.08), cl))
	root.add_child(part("box", Vector3(0.34, 0.70, 0.08), Vector3(0.04, 0.62, 0.08), rs, Vector3(18, 0, -20)))
	root.add_child(part("cyl", Vector3(-0.16, 0.22, 0.06), Vector3(0.07, 0.38, 0), sk))
	root.add_child(part("cyl", Vector3(0.16, 0.22, 0.02), Vector3(0.07, 0.38, 0), sk))

static func _knight(root: Node3D) -> void:
	var st := steel()
	var vl := veil()
	var em := ember(2.0)
	root.add_child(part("cyl", Vector3(0, 0.95, 0), Vector3(0.34, 1.45, 0), st))
	root.add_child(part("sph", Vector3(0, 1.82, 0), Vector3(0.23, 0, 0), st))
	root.add_child(part("box", Vector3(0, 1.78, 0.16), Vector3(0.20, 0.04, 0.04), em))
	root.add_child(part("box", Vector3(0, 1.42, 0), Vector3(1.08, 0.22, 0.48), st))
	root.add_child(part("box", Vector3(0, 1.15, -0.22), Vector3(0.42, 1.35, 0.06), vl))
	root.add_child(part("box", Vector3(0.52, 1.05, -0.08), Vector3(0.08, 1.25, 0.16), st, Vector3(8, 0, 0)))
	root.add_child(part("cyl", Vector3(-0.24, 0.28, 0), Vector3(0.11, 0.52, 0), st))
	root.add_child(part("cyl", Vector3(0.24, 0.28, 0), Vector3(0.11, 0.52, 0), st))

static func _behemoth(root: Node3D) -> void:
	var st := soot()
	var em := ember(5.0)
	var rs := rust()
	root.add_child(part("box", Vector3(0, 1.15, 0.15), Vector3(1.35, 1.55, 1.8), st))
	root.add_child(part("sph", Vector3(0, 2.05, 0.55), Vector3(0.48, 0, 0), st))
	root.add_child(part("cyl", Vector3(-0.22, 2.48, 0.40), Vector3(0.08, 0.55, 0), rs, Vector3(18, 0, -12)))
	root.add_child(part("cyl", Vector3(0.22, 2.48, 0.40), Vector3(0.08, 0.55, 0), rs, Vector3(18, 0, 12)))
	root.add_child(part("box", Vector3(0, 1.15, 0.15), Vector3(1.38, 0.08, 1.82), em))
	root.add_child(part("box", Vector3(0.85, 0.95, 0.55), Vector3(0.35, 1.55, 0.35), rs))
	root.add_child(part("box", Vector3(-0.55, 0.42, 0.55), Vector3(0.32, 0.85, 0.32), st))
	root.add_child(part("box", Vector3(0.35, 0.42, -0.45), Vector3(0.32, 0.85, 0.32), st))
	root.add_child(part("box", Vector3(-0.35, 0.42, -0.45), Vector3(0.32, 0.85, 0.32), st))

static func _lord(root: Node3D) -> void:
	var st := steel()
	var cl := cloth()
	var em := ember(6.5)
	var gd := gold()
	root.add_child(part("cyl", Vector3(0, 1.35, 0), Vector3(0.52, 2.15, 0), st))
	root.add_child(part("sph", Vector3(0, 2.55, 0), Vector3(0.32, 0, 0), st))
	root.add_child(part("tor", Vector3(0, 2.78, 0), Vector3(0.18, 0.42, 0), gd))
	root.add_child(part("sph", Vector3(0, 1.45, 0.08), Vector3(0.28, 0, 0), em))
	root.add_child(part("box", Vector3(0, 1.55, -0.28), Vector3(0.95, 2.05, 0.10), cl))
	root.add_child(part("box", Vector3(0.72, 1.35, -0.12), Vector3(0.10, 2.05, 0.16), st, Vector3(6, 0, 0)))
	var light := OmniLight3D.new()
	light.light_color = EMBER
	light.light_energy = 7.0
	light.omni_range = 12.0
	light.position = Vector3(0, 1.6, 0.1)
	root.add_child(light)
