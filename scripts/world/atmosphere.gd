class_name Atmosphere
extends RefCounted
## Dark fog, low sun, and ruin dressing so the hearth reads like the concept reel.

static func apply(root: Node) -> void:
	var env_node := root.get_node_or_null("WorldEnvironment") as WorldEnvironment
	if env_node and env_node.environment:
		var e := env_node.environment
		e.background_mode = Environment.BG_COLOR
		e.background_color = Color(0.035, 0.038, 0.045)
		e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		e.ambient_light_color = Color(0.14, 0.13, 0.14)
		e.ambient_light_energy = 0.18
		e.tonemap_mode = Environment.TONE_MAPPER_ACES
		e.fog_enabled = true
		e.fog_mode = Environment.FOG_MODE_EXPONENTIAL
		e.fog_light_color = Color(0.09, 0.09, 0.10)
		e.fog_density = 0.016
		e.fog_aerial_perspective = 0.55
		e.adjustment_enabled = true
		e.adjustment_brightness = 0.86
		e.adjustment_contrast = 1.18
		e.adjustment_saturation = 0.72
	var sun := root.get_node_or_null("DirectionalLight3D") as DirectionalLight3D
	if sun:
		sun.light_color = Color(0.62, 0.66, 0.74)
		sun.light_energy = 0.28
		sun.shadow_enabled = true

static func stone() -> StandardMaterial3D:
	return MeshKit.mat(Color(0.15, 0.14, 0.13), 0.05, 0.9)

static func bark() -> StandardMaterial3D:
	return MeshKit.mat(Color(0.07, 0.065, 0.06), 0.02, 0.94)

static func arch(parent: Node, at: Vector3, scale := 1.0) -> void:
	var mat := stone()
	var h := 4.4 * scale
	var gap := 2.15 * scale
	var left := MeshKit.part("box", at + Vector3(-gap, h * 0.5, 0), Vector3(0.72, h, 0.95), mat)
	var right := MeshKit.part("box", at + Vector3(gap, h * 0.5, 0), Vector3(0.72, h, 0.95), mat)
	var ring := MeshKit.part("tor", at + Vector3(0, h * 0.92, 0), Vector3(gap * 0.55, gap * 1.05, 0), mat, Vector3(90, 0, 0))
	for n in [left, right, ring]:
		n.use_collision = false
		parent.add_child(n)

static func tree(parent: Node, at: Vector3) -> void:
	var mat := bark()
	var trunk := MeshKit.part("cyl", at + Vector3(0, 2.4, 0), Vector3(0.16, 4.8, 0), mat, Vector3(3, 0, 2))
	trunk.use_collision = false
	parent.add_child(trunk)
	var tips: Array = [
		[1.1, 3.4, 0.2, 40.0, 10.0],
		[-0.9, 3.8, -0.2, -32.0, 18.0],
		[0.2, 4.5, -0.5, 12.0, -24.0],
		[-0.3, 4.2, 0.6, -18.0, 30.0],
	]
	for b in tips:
		var br := MeshKit.part("cyl", at + Vector3(b[0], b[1], b[2]), Vector3(0.045, 1.5, 0), mat, Vector3(b[3], b[4], 0))
		br.use_collision = false
		parent.add_child(br)

static func fire_ring(parent: Node, at: Vector3) -> void:
	var mat := stone()
	for i in 14:
		var a := float(i) / 14.0 * TAU
		var rock := MeshKit.part(
			"box",
			at + Vector3(cos(a) * 2.15, 0.12, sin(a) * 2.15),
			Vector3(0.48, 0.22, 0.32),
			mat,
			Vector3(0, rad_to_deg(a), randf_range(-6.0, 6.0))
		)
		rock.use_collision = false
		parent.add_child(rock)

static func colonnade(parent: Node, x: float, z_from: float, z_to: float, step: float) -> void:
	var z := z_from
	while z >= z_to:
		var pillar := MeshKit.part("box", Vector3(x, 3.2, z), Vector3(0.85, 6.4, 0.85), stone())
		pillar.use_collision = false
		parent.add_child(pillar)
		z -= step
