class_name PlayerController
extends CharacterBody3D

const WALK_SPEED := 4.2
const RUN_SPEED := 6.4
const DODGE_SPEED := 11.0
const ROTATE_SPEED := 10.0
const GRAVITY := 22.0

@onready var vitality: Vitality = $Vitality
@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var lock_system: LockOnSystem = $LockOnSystem
@onready var light_hitbox: Hitbox = $Hitboxes/Light
@onready var heavy_hitbox: Hitbox = $Hitboxes/Heavy
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var loco: LocomotionMachine = $LocomotionMachine
@onready var anim: AnimDriver = $AnimDriver
@onready var mesh_root: Node3D = $MeshRoot

var _iframe_timer: float = 0.0
var _action_lock: float = 0.0
var _move_input: Vector2 = Vector2.ZERO
var _blocking: bool = false
var _mouse_captured: bool = true
var _light_cost: float = 18.0
var _heavy_cost: float = 36.0

func _ready() -> void:
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var roster := Roster.new()
	roster.load_from_json()
	var data := roster.get_playable(Game.selected_character_id)
	vitality.max_hp = data.hp
	vitality.max_stamina = data.stamina
	vitality.max_poise = data.poise
	var w := WeaponDB.for_character(data.starting_weapon)
	light_hitbox.damage = float(w.get("light", 110))
	light_hitbox.poise_damage = float(w.get("poise_light", 18))
	heavy_hitbox.damage = float(w.get("heavy", 175))
	heavy_hitbox.poise_damage = float(w.get("poise_heavy", 36))
	_light_cost = float(w.get("stamina_light", 18))
	_heavy_cost = float(w.get("stamina_heavy", 34))
	MeshKit.apply_playable(mesh_root, data.id)
	vitality.rest_full()
	vitality.died.connect(_on_died)
	vitality.poise_broken.connect(_on_poise_broken)
	hurtbox.owner_group = "player"
	hurtbox.hit_received.connect(_on_hit)
	light_hitbox.owner_group = "player"
	heavy_hitbox.owner_group = "player"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _mouse_captured and not lock_system.has_target():
		camera_pivot.rotate_y(-event.relative.x * 0.0025)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x - event.relative.y * 0.0025, -0.9, 0.45)
	if event.is_action_pressed("ui_cancel"):
		_mouse_captured = not _mouse_captured
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if _mouse_captured else Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	_iframe_timer = max(_iframe_timer - delta, 0.0)
	_action_lock = max(_action_lock - delta, 0.0)
	hurtbox.invulnerable = _iframe_timer > 0.0

	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	_move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	_blocking = Input.is_action_pressed("block") and _action_lock <= 0.0

	if lock_system.has_target():
		var t: Node3D = lock_system.target
		var look := t.global_position
		look.y = camera_pivot.global_position.y
		camera_pivot.look_at(look, Vector3.UP)

	if _action_lock <= 0.0:
		_handle_actions()
		_handle_movement(delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, 18.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 18.0 * delta)

	move_and_slide()
	var planar := Vector2(velocity.x, velocity.z).length()
	loco.update_move(planar, _iframe_timer > 0.0, _action_lock > 0.0, _blocking)

func _handle_movement(delta: float) -> void:
	var cam_yaw := camera_pivot.rotation.y
	var wish := Vector3(_move_input.x, 0.0, _move_input.y).rotated(Vector3.UP, cam_yaw)
	if wish.length() > 0.1:
		wish = wish.normalized()
		var target := atan2(wish.x, wish.z)
		rotation.y = lerp_angle(rotation.y, target, ROTATE_SPEED * delta)
		var speed := (RUN_SPEED if _move_input.length() > 0.7 else WALK_SPEED)
		if _blocking:
			speed *= 0.45
		velocity.x = wish.x * speed
		velocity.z = wish.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, 20.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 20.0 * delta)

func _handle_actions() -> void:
	if Input.is_action_just_pressed("dodge"):
		_try_dodge()
	elif Input.is_action_just_pressed("light_attack"):
		_try_attack(light_hitbox, 0.42, _light_cost, false)
	elif Input.is_action_just_pressed("heavy_attack"):
		_try_attack(heavy_hitbox, 0.78, _heavy_cost, true)
	elif Input.is_action_just_pressed("lock_on"):
		lock_system.toggle()

func _try_dodge() -> void:
	if not vitality.spend_stamina(22.0):
		return
	_iframe_timer = CombatDefs.IFRAME_DODGE
	_action_lock = 0.38
	var dir := -transform.basis.z
	if _move_input.length() > 0.2:
		var cam_yaw := camera_pivot.rotation.y
		dir = Vector3(_move_input.x, 0, _move_input.y).rotated(Vector3.UP, cam_yaw).normalized()
	velocity = dir * DODGE_SPEED

func _try_attack(box: Hitbox, lock: float, cost: float, heavy: bool) -> void:
	if not vitality.spend_stamina(cost):
		return
	_action_lock = lock
	box.activate()
	get_tree().create_timer(0.16).timeout.connect(box.deactivate)
	if heavy:
		anim.play_oneshot("attack_heavy")

func _on_hit(hitbox: Hitbox, damage: float, poise_damage: float) -> void:
	if _iframe_timer > 0.0:
		return
	var incoming := damage
	var poise := poise_damage
	if _blocking:
		if vitality.spend_stamina(incoming * 0.25):
			incoming *= 0.35
			poise *= 0.4
		else:
			_blocking = false
	vitality.apply_damage(incoming, poise)
	loco.hit()

func _on_poise_broken() -> void:
	_action_lock = 0.9
	loco.hit()

func _on_died() -> void:
	loco.die()
	anim.play_oneshot("death")
	Game.drop_souls_at(global_position)
	Game.player_died.emit()
	await get_tree().create_timer(1.6).timeout
	Game.respawn()
