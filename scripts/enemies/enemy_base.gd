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
	if not MeshKitExt.apply_enemy(_mesh_root, enemy_id):
		MeshKit.apply_enemy(_mesh_root, enemy_id)
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
