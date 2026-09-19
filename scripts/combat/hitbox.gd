class_name Hitbox
extends Area3D

signal landed(hurtbox: Hurtbox, damage: float, poise_damage: float)

@export var damage: float = 100.0
@export var poise_damage: float = 20.0
@export var stamina_cost: float = 18.0
@export var attack_type: CombatDefs.AttackType = CombatDefs.AttackType.LIGHT
@export var owner_group: String = "player"

var _active: bool = false
var _already_hit: Array[Hurtbox] = []

func _ready() -> void:
	monitoring = false
	monitorable = false
	area_entered.connect(_on_area_entered)

func activate() -> void:
	_already_hit.clear()
	_active = true
	monitoring = true

func deactivate() -> void:
	_active = false
	monitoring = false
	_already_hit.clear()

func _on_area_entered(area: Area3D) -> void:
	if not _active:
		return
	if area is Hurtbox:
		var hb := area as Hurtbox
		if hb.owner_group == owner_group:
			return
		if _already_hit.has(hb):
			return
		_already_hit.append(hb)
		hb.receive_hit(self)
		landed.emit(hb, damage, poise_damage)
