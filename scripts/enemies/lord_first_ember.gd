class_name LordFirstEmber
extends EnemyBase

## Three-phase lord. Phase 2 adds slam. Phase 3 shortens think time.

var phase: int = 1

func _ready() -> void:
	enemy_id = "the_first_ember"
	aggro_range = 28.0
	attack_range = 3.4
	move_speed = 2.1
	soul_reward = 8000
	super._ready()
	vitality.hp_changed.connect(_on_hp)

func _on_hp(current: float, max_hp: float) -> void:
	var pct := current / maxf(max_hp, 1.0)
	if pct <= 0.33:
		phase = 3
		move_speed = 3.4
		attack_range = 3.8
	elif pct <= 0.66:
		phase = 2
		move_speed = 2.6

func _attack() -> void:
	_lock = 0.7 if phase < 3 else 0.45
	hitbox.damage = 240.0 if phase == 1 else (300.0 if phase == 2 else 320.0)
	hitbox.poise_damage = 50.0 * phase
	hitbox.activate()
	get_tree().create_timer(0.22).timeout.connect(hitbox.deactivate)
	if phase >= 2:
		get_tree().create_timer(0.55).timeout.connect(_slam)

func _slam() -> void:
	if vitality.dead:
		return
	hitbox.damage *= 1.15
	hitbox.activate()
	get_tree().create_timer(0.2).timeout.connect(hitbox.deactivate)
