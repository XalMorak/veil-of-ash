class_name MeshKitExt
extends RefCounted
## Extra souls-like silhouettes for v0.5 roster.
## EnemyBase routes these IDs here; MeshKit keeps the original four.

static func apply_enemy(root: Node3D, id: String) -> bool:
	match id:
		"ash_sentinel":
			MeshKit.clear(root)
			_sentinel(root)
			return true
		"veil_shade":
			MeshKit.clear(root)
			_shade(root)
			return true
		"cinder_acolyte":
			MeshKit.clear(root)
			_acolyte(root)
			return true
		_:
			return false

static func _sentinel(root: Node3D) -> void:
	var st := MeshKit.steel()
	var di := MeshKit.dark_iron()
	var em := MeshKit.ember(1.6)
	MeshKit._humanoid(root, 0.32, 1.20, 0.20, st, di, 0.74)
	root.add_child(MeshKit.part("box", Vector3(0, 1.62, 0.04), Vector3(0.34, 0.28, 0.30), di))
	root.add_child(MeshKit.part("box", Vector3(0, 1.60, 0.19), Vector3(0.16, 0.03, 0.03), em))
	root.add_child(MeshKit.part("box", Vector3(0, 1.22, 0.02), Vector3(0.78, 0.18, 0.42), di))
	root.add_child(MeshKit.part("box", Vector3(-0.48, 0.92, 0.02), Vector3(0.08, 1.05, 0.52), st))
	root.add_child(MeshKit.part("cyl", Vector3(0.42, 1.10, -0.02), Vector3(0.03, 2.15, 0), di))
	root.add_child(MeshKit.part("box", Vector3(0.42, 2.18, -0.02), Vector3(0.08, 0.28, 0.08), st))
	root.add_child(MeshKit.part("box", Vector3(0, 0.95, -0.20), Vector3(0.55, 1.05, 0.06), MeshKit.cloth()))
	root.add_child(MeshKit.ember_light(Vector3(0, 1.60, 0.22), 1.4, 3.2))

static func _shade(root: Node3D) -> void:
	var vl := MeshKit.veil()
	var di := MeshKit.dark_iron()
	var sk := MeshKit.ash_skin()
	MeshKit._humanoid(root, 0.18, 1.00, 0.15, vl, sk, 0.68)
	root.add_child(MeshKit.part("sph", Vector3(0, 1.48, 0.02), Vector3(0.15, 0, 0), MeshKit.bone()))
	root.add_child(MeshKit.part("box", Vector3(0, 1.42, 0.12), Vector3(0.12, 0.10, 0.04), MeshKit.charred()))
	root.add_child(MeshKit.part("box", Vector3(0, 0.88, -0.10), Vector3(0.42, 1.22, 0.08), vl))
	root.add_child(MeshKit.part("box", Vector3(-0.12, 0.70, -0.16), Vector3(0.10, 1.00, 0.03), vl, Vector3(8, 14, 0)))
	root.add_child(MeshKit.part("box", Vector3(0.12, 0.64, -0.15), Vector3(0.10, 0.92, 0.03), vl, Vector3(-6, -12, 0)))
	root.add_child(MeshKit.part("box", Vector3(0.32, 0.90, 0.02), Vector3(0.03, 0.42, 0.07), di, Vector3(18, 0, -28)))
	root.add_child(MeshKit.part("box", Vector3(-0.32, 0.88, 0.02), Vector3(0.03, 0.42, 0.07), di, Vector3(-14, 0, 26)))

static func _acolyte(root: Node3D) -> void:
	var cl := MeshKit.cloth()
	var di := MeshKit.dark_iron()
	var em := MeshKit.ember(2.6)
	MeshKit._humanoid(root, 0.24, 1.08, 0.16, cl, MeshKit.charred(), 0.70)
	root.add_child(MeshKit.part("cyl", Vector3(0, 1.52, -0.02), Vector3(0.24, 0.26, 0), cl))
	root.add_child(MeshKit.part("box", Vector3(0, 0.78, -0.04), Vector3(0.70, 1.20, 0.20), cl))
	root.add_child(MeshKit.part("sph", Vector3(-0.28, 0.62, 0.16), Vector3(0.08, 0, 0), MeshKit.rust()))
	root.add_child(MeshKit.part("cyl", Vector3(-0.28, 0.78, 0.16), Vector3(0.012, 0.24, 0), di))
	root.add_child(MeshKit.part("box", Vector3(0.34, 0.78, 0.08), Vector3(0.12, 0.16, 0.12), di))
	root.add_child(MeshKit.part("sph", Vector3(0.34, 0.78, 0.08), Vector3(0.06, 0, 0), em))
	root.add_child(MeshKit.ember_light(Vector3(0.34, 0.78, 0.08), 2.4, 4.0))
