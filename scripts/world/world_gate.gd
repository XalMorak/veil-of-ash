class_name WorldGate
extends Area3D

@export var target_scene: String = "res://scenes/world/ash_causeway.tscn"

func _ready() -> void:
	body_entered.connect(_on_body)
	collision_mask = 2

func _on_body(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(target_scene)
