class_name PlayerController
extends CharacterBody3D

const WALK_SPEED := 4.2
const RUN_SPEED := 6.4
const DODGE_SPEED := 11.0
const ROTATE_SPEED := 10.0
const GRAVITY := 22.0

@onready var vitality: Vitality = $Vitality
@onready var camera_pivot: Node3D = $CameraPivot
@onready var lock_system: LockOnSystem = $LockOnSystem
@onready var light_hitbox: Hitbox = $Hitboxes/Light
@onready var heavy_hitbox: Hitbox = $Hitboxes/Heavy

var _iframe_timer: float = 0.0
var _action_lock: float = 0.0
var _move_input: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("player")
	var roster := Roster.new()
	roster.load_from_json()
	var data := roster.get_playable(Game.selected_character_id)
	vitality.max_hp = data.hp
	vitality.max_stamina = data.stamina
	vitality.max_poise = data.poise
	vitality.rest_full()
	vitality.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	_iframe_timer = max(_iframe_timer - delta, 0.0)
	_action_lock = max(_action_lock - delta, 0.0)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	_move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	if _action_lock <= 0.0:
		_handle_actions()
		_handle_movement(delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, 18.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 18.0 * delta)

	move_and_slide()

func _handle_movement(delta: float) -> void:
	var cam_yaw := camera_pivot.rotation.y if camera_pivot else 0.0
	var wish := Vector3(_move_input.x, 0.0, _move_input.y).rotated(Vector3.UP, cam_yaw)
	if wish.length() > 0.1:
		wish = wish.normalized()
		var target := atan2(wish.x, wish.z)
		rotation.y = lerp_angle(rotation.y, target, ROTATE_SPEED * delta)
		var speed := RUN_SPEED if _move_input.length() > 0.7 else WALK_SPEED
		velocity.x = wish.x * speed
		velocity.z = wish.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, 20.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 20.0 * delta)

func _handle_actions() -> void:
	if Input.is_action_just_pressed("dodge"):
		_try_dodge()
	elif Input.is_action_just_pressed("light_attack"):
		_try_attack(light_hitbox, 0.42, 18.0)
	elif Input.is_action_just_pressed("heavy_attack"):
		_try_attack(heavy_hitbox, 0.78, 36.0)
	elif Input.is_action_just_pressed("lock_on"):
		lock_system.toggle()

func _try_dodge() -> void:
	if not vitality.spend_stamina(22.0):
		return
	_iframe_timer = CombatDefs.IFRAME_DODGE
	_action_lock = 0.38
	var dir := -transform.basis.z
	if _move_input.length() > 0.2:
		dir = Vector3(_move_input.x, 0, _move_input.y).normalized()
	velocity = dir * DODGE_SPEED

func _try_attack(box: Hitbox, lock: float, cost: float) -> void:
	if not vitality.spend_stamina(cost):
		return
	_action_lock = lock
	box.activate()
	get_tree().create_timer(0.16).timeout.connect(box.deactivate)

func is_invulnerable() -> bool:
	return _iframe_timer > 0.0

func _on_died() -> void:
	Game.player_died.emit()
