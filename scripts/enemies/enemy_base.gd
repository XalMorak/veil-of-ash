class_name EnemyBase
extends CharacterBody3D

@export var enemy_id: String = "ash_hollow"
@export var aggro_range: float = 14.0
@export var attack_range: float = 2.2
@export var move_speed: float = 3.2
@export var soul_reward: int = 50

@onready var vitality: Vitality = $Vitality
@onready var hitbox: Hitbox = $Hitboxes/Light
@onready var hurtbox: Hurtbox = $Hurtbox

var _player: Node3D
var _think: float = 0.0
var _lock: float = 0.0

func _ready() -> void:
	add_to_group("enemy")
	add_to_group("lockable")
	var roster := Roster.new()
	roster.load_from_json()
	for e in roster.enemies:
		if e.get("id") == enemy_id:
			vitality.max_hp = float(e.get("hp", 300))
			vitality.max_poise = float(e.get("poise", 30))
			hitbox.damage = float(e.get("damage", 90))
			vitality.rest_full()
			break
	vitality.died.connect(_on_died)
	vitality.poise_broken.connect(func() -> void: _lock = 1.1)
	hurtbox.owner_group = "enemy"
	hurtbox.hit_received.connect(_on_hit)
	hitbox.owner_group = "enemy"

func _physics_process(delta: float) -> void:
	_lock = max(_lock - delta, 0.0)
	_player = get_tree().get_first_node_in_group("player") as Node3D
	if _player == null:
		return
	var to_player := _player.global_position - global_position
	to_player.y = 0
	var dist := to_player.length()
	if dist > aggro_range:
		velocity.x = 0
		velocity.z = 0
		velocity.y -= 22.0 * delta
		move_and_slide()
		return
	if to_player.length() > 0.01:
		look_at(_player.global_position, Vector3.UP)
	rotation.x = 0
	rotation.z = 0
	if _lock > 0.0:
		velocity.x = 0
		velocity.z = 0
	elif dist > attack_range:
		var dir := to_player.normalized()
		velocity.x = dir.x * move_speed
		velocity.z = dir.z * move_speed
	else:
		velocity.x = 0
		velocity.z = 0
		_think -= delta
		if _think <= 0.0:
			_think = 1.35
			_attack()
	velocity.y -= 22.0 * delta
	move_and_slide()

func _attack() -> void:
	_lock = 0.55
	hitbox.activate()
	get_tree().create_timer(0.18).timeout.connect(hitbox.deactivate)

func _on_hit(_hitbox: Hitbox, damage: float, poise_damage: float) -> void:
	vitality.apply_damage(damage, poise_damage)
	_lock = max(_lock, 0.2)

func _on_died() -> void:
	Game.add_souls(soul_reward)
	queue_free()
