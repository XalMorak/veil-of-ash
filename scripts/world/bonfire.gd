class_name Bonfire
extends Area3D

@export var bonfire_id: String = "hub_hearth"
@export var display_name: String = "Hub Hearth"

var _player_near: bool = false

func _ready() -> void:
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	collision_mask = 2
	monitoring = true

func _on_enter(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_near = true

func _on_exit(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_near = false

func _unhandled_input(event: InputEvent) -> void:
	if not _player_near:
		return
	if event.is_action_pressed("interact"):
		_rest()

func _rest() -> void:
	var p := get_tree().get_first_node_in_group("player")
	if p and p.has_node("Vitality"):
		(p.get_node("Vitality") as Vitality).rest_full()
	Game.rest_at(bonfire_id)
	for e in get_tree().get_nodes_in_group("enemy"):
		if e.has_method("rest_full") == false:
			pass
	print("Rested at ", display_name)
