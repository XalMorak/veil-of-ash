class_name PoseDriver
extends Node
## Mixamo байхгүй үед MeshRoot-ыг уншигдах pose-оор хөдөлгөнө.
## Clip ирэхэд AnimDriver clip тоглоно; энэ node зөвхөн fallback.

enum Pose { IDLE, WALK, RUN, DODGE, WINDUP, STRIKE_LIGHT, STRIKE_HEAVY, BLOCK, HIT, DEATH }

@export var mesh_path: NodePath
@export var scale_amp := 1.0

var pose: Pose = Pose.IDLE
var _t := 0.0
var _mesh: Node3D
var _base := Transform3D.IDENTITY

func _ready() -> void:
	_resolve_mesh()

func _resolve_mesh() -> void:
	if mesh_path != NodePath():
		_mesh = get_node_or_null(mesh_path) as Node3D
	if _mesh == null:
		_mesh = get_parent().get_node_or_null("MeshRoot") as Node3D
	if _mesh:
		_base = _mesh.transform

func set_pose(p: Pose) -> void:
	if pose == p:
		return
	pose = p
	_t = 0.0

func set_from_name(clip: String) -> void:
	match clip:
		"walk":
			set_pose(Pose.WALK)
		"run":
			set_pose(Pose.RUN)
		"dodge":
			set_pose(Pose.DODGE)
		"attack_light":
			set_pose(Pose.STRIKE_LIGHT)
		"attack_heavy":
			set_pose(Pose.STRIKE_HEAVY)
		"windup":
			set_pose(Pose.WINDUP)
		"block":
			set_pose(Pose.BLOCK)
		"hit":
			set_pose(Pose.HIT)
		"death":
			set_pose(Pose.DEATH)
		_:
			set_pose(Pose.IDLE)

func _process(delta: float) -> void:
	if _mesh == null:
		_resolve_mesh()
		if _mesh == null:
			return
	_t += delta
	var t := _base
	var a := scale_amp
	match pose:
		Pose.IDLE:
			t.origin.y += sin(_t * 2.1) * 0.012 * a
			t.basis = t.basis.rotated(Vector3.RIGHT, sin(_t * 1.4) * 0.02 * a)
		Pose.WALK:
			t.origin.y += abs(sin(_t * 8.0)) * 0.04 * a
			t.basis = t.basis.rotated(Vector3.FORWARD, sin(_t * 8.0) * 0.06 * a)
		Pose.RUN:
			t.origin.y += abs(sin(_t * 12.0)) * 0.07 * a
			t.basis = t.basis.rotated(Vector3.RIGHT, -0.08 * a)
			t.basis = t.basis.rotated(Vector3.FORWARD, sin(_t * 12.0) * 0.09 * a)
		Pose.DODGE:
		var k := clampf(_t / 0.28, 0.0, 1.0)
			t.origin += Vector3(0, 0.08 * sin(k * PI), -0.35 * sin(k * PI)) * a
			t.basis = t.basis.rotated(Vector3.RIGHT, 0.35 * sin(k * PI) * a)
		Pose.WINDUP:
			t.origin.z += 0.18 * a
			t.basis = t.basis.rotated(Vector3.RIGHT, -0.42 * a)
			t.basis = t.basis.rotated(Vector3.UP, 0.18 * a)
		Pose.STRIKE_LIGHT:
			var k2 := clampf(_t / 0.22, 0.0, 1.0)
			t.origin.z -= 0.42 * sin(k2 * PI) * a
			t.basis = t.basis.rotated(Vector3.RIGHT, 0.55 * sin(k2 * PI) * a)
			t.basis = t.basis.rotated(Vector3.UP, -0.35 * sin(k2 * PI) * a)
		Pose.STRIKE_HEAVY:
			var k3 := clampf(_t / 0.32, 0.0, 1.0)
			t.origin.y += 0.12 * (1.0 - k3) * a
			t.origin.z -= 0.62 * sin(k3 * PI) * a
			t.basis = t.basis.rotated(Vector3.RIGHT, 0.85 * sin(k3 * PI) * a)
		Pose.BLOCK:
			t.origin.z += 0.08 * a
			t.basis = t.basis.rotated(Vector3.RIGHT, -0.12 * a)
		Pose.HIT:
			var k4 := clampf(_t / 0.28, 0.0, 1.0)
			t.origin.z += 0.22 * (1.0 - k4) * a
			t.basis = t.basis.rotated(Vector3.RIGHT, -0.25 * (1.0 - k4) * a)
		Pose.DEATH:
			var k5 := clampf(_t / 1.1, 0.0, 1.0)
			t.origin.y -= 0.35 * k5 * a
			t.basis = t.basis.rotated(Vector3.RIGHT, 1.15 * k5)
	_mesh.transform = t
