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
