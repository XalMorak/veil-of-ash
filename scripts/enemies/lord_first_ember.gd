class_name LordFirstEmber
extends EnemyBase
## Three-phase lord. Phase 2 slam after recover. Phase 3 shorter windup.

var phase: int = 1
var _slam: bool = false

func _ready() -> void:
	enemy_id = "the_first_ember"
	aggro_range = 28.0
	attack_range = 3.4
	move_speed = 2.1
	soul_reward = 8000
	windup_time = 0.85
	strike_time = 0.24
	recover_time = 0.9
	think_min = 0.8
	think_max = 1.4
	super._ready()
	vitality.hp_changed.connect(_on_hp)

func _on_hp(current: float, max_hp: float) -> void:
	var pct := current / maxf(max_hp, 1.0)
	if pct <= 0.33:
		phase = 3
		move_speed = 3.4
		attack_range = 3.8
		windup_time = 0.48
		think_min = 0.35
		think_max = 0.7
	elif pct <= 0.66:
		phase = 2
		move_speed = 2.6
		windup_time = 0.7
		think_min = 0.55
		think_max = 1.0

func strike_clip() -> String:
	return "attack_heavy" if phase >= 2 else "attack_light"

func _on_strike() -> void:
	hitbox.damage = 240.0 if phase == 1 else (300.0 if phase == 2 else 320.0)
	hitbox.poise_damage = 50.0 * float(phase)
	_slam = phase >= 2

func _on_recover() -> void:
	if _slam and not vitality.dead:
		_slam = false
		_pose_name("attack_heavy")
		hitbox.damage *= 1.15
		hitbox.activate()
		get_tree().create_timer(0.22).timeout.connect(hitbox.deactivate)
