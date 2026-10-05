class_name WorldGate
extends Area3D

@export var target_scene: String = "res://scenes/world/ash_causeway.tscn"
@export var requires_flag: String = ""
@export var locked_message: String = "The ash gate is sealed. Slay the Cinder Behemoth."

var _lockout: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body)
	collision_mask = 2

func _process(delta: float) -> void:
	_lockout = max(_lockout - delta, 0.0)

func _on_body(body: Node3D) -> void:
	if _lockout > 0.0 or not body.is_in_group("player"):
		return
	if requires_flag != "" and not Game.has_flag(requires_flag):
		Game.toast(locked_message)
		_lockout = 1.4
		return
	get_tree().change_scene_to_file(target_scene)
