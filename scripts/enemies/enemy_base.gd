class_name EnemyBase
extends CharacterBody3D
## Shared souls-like enemy loop: approach → readable windup → strike → recover.
## Tracking stops on windup/strike so positioning matters.

enum Phase { IDLE, APPROACH, WINDUP, STRIKE, RECOVER, STAGGER }

@export var enemy_id: String = "ash_hollow"
@export var aggro_range: float = 14.0
@export var attack_range: float = 2.2
@export var move_speed: float = 3.2
@export var soul_reward: int = 50
@export var windup_time: float = 0.55
@export var strike_time: float = 0.18
@export var recover_time: float = 0.55
@export var think_min: float = 0.7
@export var think_max: float = 1.4

@onready var vitality: Vitality = $Vitality
@onready var hitbox: Hitbox = $Hitboxes/Light
@onready var hurtbox: Hurtbox = $Hurtbox

var _player: Node3D
var _phase: Phase = Phase.IDLE
var _timer: float = 0.0
var _think: float = 0.4
var _pose: PoseDriver
var _mesh_root: Node3D
var _facing_lock: bool = false

func _ready() -> void:
	add_to_group("enemy")
	add_to_group("lockable")
	_mesh_root = get_node_or_null("MeshRoot") as Node3D
	if _mesh_root == null:
		_mesh_root = Node3D.new()
		_mesh_root.name = "MeshRoot"
		add_child(_mesh_root)
		for child in get_children():
			if child is CSGPrimitive3D or child is OmniLight3D:
				child.queue_free()
	AssetLoader.apply_enemy(_mesh_root, enemy_id)
	_pose = get_node_or_null("PoseDriver") as PoseDriver
	if _pose == null:
		_pose = PoseDriver.new()
		_pose.name = "PoseDriver"
		add_child(_pose)
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
	vitality.poise_broken.connect(_on_poise_broken)
	hurtbox.owner_group = "enemy"
	hurtbox.hit_received.connect(_on_hit)
	hitbox.owner_group = "enemy"

func _physics_process(delta: float) -> void:
	_timer = max(_timer - delta, 0.0)
	_player = get_tree().get_first_node_in_group("player") as Node3D
	if not is_on_floor():
		velocity.y -= 22.0 * delta
	if _player == null or vitality.dead:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	var to_player := _player.global_position - global_position
	to_player.y = 0
	var dist := to_player.length()
	if not _facing_lock and dist > 0.05:
		var look := _player.global_position
		look.y = global_position.y
		look_at(look, Vector3.UP)
	match _phase:
		Phase.IDLE:
			_pose_name("idle")
			velocity.x = 0
			velocity.z = 0
			if dist <= aggro_range:
				_phase = Phase.APPROACH
		Phase.APPROACH:
			if dist > aggro_range * 1.15:
				_phase = Phase.IDLE
			elif dist > attack_range:
				_pose_name("walk" if move_speed < 3.4 else "run")
				var dir := to_player.normalized()
				velocity.x = dir.x * move_speed
				velocity.z = dir.z * move_speed
			else:
				velocity.x = 0
				velocity.z = 0
				_think -= delta
				if _think <= 0.0:
					_begin_windup()
		Phase.WINDUP:
			_pose_name("windup")
			velocity.x = 0
			velocity.z = 0
			if _timer <= 0.0:
				_begin_strike()
		Phase.STRIKE:
			velocity.x = 0
			velocity.z = 0
			if _timer <= 0.0:
				hitbox.deactivate()
				_begin_recover()
		Phase.RECOVER:
			_pose_name("idle")
			velocity.x = 0
			velocity.z = 0
			if _timer <= 0.0:
				_facing_lock = false
				_phase = Phase.APPROACH
				_think = randf_range(think_min, think_max)
		Phase.STAGGER:
			_pose_name("hit")
			velocity.x = 0
			velocity.z = 0
			if _timer <= 0.0:
				_facing_lock = false
				_phase = Phase.APPROACH
				_think = 0.35
	move_and_slide()

func _begin_windup() -> void:
	_phase = Phase.WINDUP
	_facing_lock = true
	_timer = windup_time
	_on_windup()

func _begin_strike() -> void:
	_phase = Phase.STRIKE
	_timer = strike_time
	_pose_name(strike_clip())
	hitbox.activate()
	_on_strike()

func _begin_recover() -> void:
	_phase = Phase.RECOVER
	_timer = recover_time
	_on_recover()

func strike_clip() -> String:
	return "attack_light"

func _on_windup() -> void:
	pass

func _on_strike() -> void:
	pass

func _on_recover() -> void:
	pass

func _pose_name(clip: String) -> void:
	if _pose:
		_pose.set_from_name(clip)

func _on_hit(_hitbox: Hitbox, damage: float, poise_damage: float) -> void:
	vitality.apply_damage(damage, poise_damage)
	if _phase == Phase.WINDUP:
		_timer = max(_timer - 0.12, 0.05)

func _on_poise_broken() -> void:
	hitbox.deactivate()
	_phase = Phase.STAGGER
	_timer = 1.1
	_facing_lock = true
	_pose_name("hit")

func _on_died() -> void:
	hitbox.deactivate()
	_pose_name("death")
	Game.add_souls(soul_reward)
	await get_tree().create_timer(0.9).timeout
	queue_free()
