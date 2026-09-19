class_name SoulPickup
extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body)
	if not Game.has_dropped_souls:
		queue_free()
		return
	global_position = Game.dropped_souls_pos + Vector3(0, 0.6, 0)

func _on_body(body: Node3D) -> void:
	if body.is_in_group("player"):
		Game.retrieve_dropped_souls()
		queue_free()
