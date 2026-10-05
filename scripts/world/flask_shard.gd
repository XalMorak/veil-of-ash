extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body)
	collision_mask = 2
	monitoring = true

func _on_body(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	if Game.has_flag("crypt_shard"):
		queue_free()
		return
	Game.set_flag("crypt_shard")
	Game.add_flask_charge()
	queue_free()
