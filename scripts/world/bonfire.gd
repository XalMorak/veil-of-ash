class_name Bonfire
extends Area3D

@export var bonfire_id: String = "hub_hearth"
@export var display_name: String = "Hub Hearth"

var _player_near: bool = false
var _menu_open: bool = false

func _ready() -> void:
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	collision_mask = 2
	monitoring = true
	_flames()

func _flames() -> void:
	var flame := StandardMaterial3D.new()
	flame.albedo_color = Color(1, 0.42, 0.08)
	flame.emission_enabled = true
	flame.emission = Color(1, 0.35, 0.05)
	flame.emission_energy_multiplier = 4.0
	flame.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var mesh := SphereMesh.new()
	mesh.radius = 0.06
	mesh.height = 0.16
	mesh.material = flame
	var fire := CPUParticles3D.new()
	fire.amount = 36
	fire.lifetime = 0.55
	fire.mesh = mesh
	fire.direction = Vector3(0, 1, 0)
	fire.spread = 16.0
	fire.gravity = Vector3(0, 0.2, 0)
	fire.initial_velocity_min = 0.8
	fire.initial_velocity_max = 1.8
	fire.scale_amount_min = 0.6
	fire.scale_amount_max = 1.4
	fire.position = Vector3(0, 0.35, 0)
	add_child(fire)
	var spark := fire.duplicate() as CPUParticles3D
	spark.amount = 18
	spark.lifetime = 1.3
	spark.spread = 42.0
	spark.initial_velocity_min = 0.4
	spark.initial_velocity_max = 1.2
	spark.gravity = Vector3(0, -0.15, 0)
	spark.position = Vector3(0, 0.8, 0)
	add_child(spark)

func _on_enter(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_near = true
		Game.toast("E — rest at %s" % display_name)

func _on_exit(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_near = false

func _unhandled_input(event: InputEvent) -> void:
	if not _player_near or _menu_open or Game.paused:
		return
	if event.is_action_pressed("interact"):
		_rest()

func _rest() -> void:
	var p := get_tree().get_first_node_in_group("player")
	if p and p.has_node("Vitality"):
		Game.apply_build(p)
	Game.rest_at(bonfire_id)
	Game.toast("Rested at %s. Flask refilled." % display_name)
	_menu_open = true
	var menu := preload("res://scripts/ui/level_up.gd").new()
	menu.name = "LevelUp"
	get_tree().current_scene.add_child(menu)
