class_name Hurtbox
extends Area3D

signal hit_received(hitbox: Hitbox, damage: float, poise_damage: float)

@export var owner_group: String = "enemy"
var invulnerable: bool = false

func _ready() -> void:
	monitoring = false
	monitorable = true
	collision_layer = 16
	collision_mask = 0

func receive_hit(hitbox: Hitbox) -> void:
	if invulnerable:
		return
	hit_received.emit(hitbox, hitbox.damage, hitbox.poise_damage)
