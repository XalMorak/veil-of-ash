class_name Vitality
extends Node

signal hp_changed(current: float, max_hp: float)
signal stamina_changed(current: float, max_stamina: float)
signal poise_broken
signal died

@export var max_hp: float = 1000.0
@export var max_stamina: float = 120.0
@export var max_poise: float = 80.0

var hp: float
var stamina: float
var poise: float
var _stamina_lock: float = 0.0
var dead: bool = false

func _ready() -> void:
	hp = max_hp
	stamina = max_stamina
	poise = max_poise

func _process(delta: float) -> void:
	if dead:
		return
	_stamina_lock = max(_stamina_lock - delta, 0.0)
	if _stamina_lock <= 0.0:
		stamina = min(stamina + CombatDefs.STAMINA_REGEN * delta, max_stamina)
		stamina_changed.emit(stamina, max_stamina)
	poise = min(poise + CombatDefs.POISE_REGEN * delta, max_poise)

func can_spend_stamina(cost: float) -> bool:
	return stamina >= cost and not dead

func spend_stamina(cost: float) -> bool:
	if not can_spend_stamina(cost):
		return false
	stamina -= cost
	_stamina_lock = CombatDefs.STAMINA_REGEN_DELAY
	stamina_changed.emit(stamina, max_stamina)
	return true

func apply_damage(amount: float, poise_dmg: float) -> void:
	if dead:
		return
	hp = max(hp - amount, 0.0)
	poise = max(poise - poise_dmg, 0.0)
	hp_changed.emit(hp, max_hp)
	if poise <= 0.0:
		poise_broken.emit()
		poise = max_poise * 0.35
	if hp <= 0.0:
		dead = true
		died.emit()

func rest_full() -> void:
	dead = false
	hp = max_hp
	stamina = max_stamina
	poise = max_poise
	hp_changed.emit(hp, max_hp)
	stamina_changed.emit(stamina, max_stamina)
