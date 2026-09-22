class_name VeilKnight
extends EnemyBase
## Elite humanoid duelist. Readable guard, three tells, no cheap tracking.

enum Move { LIGHT, HEAVY, THRUST }

var _move: Move = Move.LIGHT
var _combo: int = 0

func _ready() -> void:
	enemy_id = "veil_knight"
	aggro_range = 18.0
	attack_range = 2.7
	move_speed = 2.55
	soul_reward = 420
	think_min = 0.55
	think_max = 1.05
	super._ready()
	hitbox.poise_damage = 35.0

func _begin_windup() -> void:
	var dist := 99.0
	if _player:
		var d := _player.global_position - global_position
		d.y = 0
		dist = d.length()
	if dist > 3.4:
		_move = Move.THRUST
	elif _combo >= 2:
		_move = Move.HEAVY
		_combo = 0
	else:
		_move = Move.LIGHT if randf() > 0.35 else Move.HEAVY
	match _move:
		Move.HEAVY:
			windup_time = 0.78
			strike_time = 0.22
			recover_time = 0.85
			hitbox.damage = 210.0
			hitbox.poise_damage = 52.0
		Move.THRUST:
			windup_time = 0.48
			strike_time = 0.16
			recover_time = 0.62
			hitbox.damage = 160.0
			hitbox.poise_damage = 28.0
		_:
			windup_time = 0.52
			strike_time = 0.16
			recover_time = 0.48
			hitbox.damage = 180.0
			hitbox.poise_damage = 35.0
	super._begin_windup()

func strike_clip() -> String:
	return "attack_heavy" if _move == Move.HEAVY else "attack_light"

func _on_strike() -> void:
	if _move == Move.THRUST and _player:
		var d := _player.global_position - global_position
		d.y = 0
		if d.length() > 0.2:
			velocity = d.normalized() * 7.5
	if _move == Move.LIGHT:
		_combo += 1
	else:
		_combo = 0

func _on_recover() -> void:
	velocity = Vector3.ZERO
