class_name AnimDriver
extends Node
## Drives AnimationPlayer using LocomotionMachine states.
## Expected clip names (Mixamo import contract):
## idle, walk, run, dodge, attack_light, attack_heavy, block, hit, death

@export var player_path: NodePath
@export var default_fade := 0.12

@onready var loco: LocomotionMachine = get_parent().get_node_or_null("LocomotionMachine")

var _ap: AnimationPlayer
var _last := ""

func _ready() -> void:
	var root := get_parent()
	_ap = root.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if _ap == null:
		_ap = root.find_child("AnimationPlayer", true, false) as AnimationPlayer

func _process(_delta: float) -> void:
	if _ap == null or loco == null:
		return
	var clip := _clip_for(loco.state)
	if clip == _last:
		return
	if not _ap.has_animation(clip):
		return
	var fade := 0.04 if clip in ["dodge", "attack_light", "attack_heavy", "hit", "death"] else default_fade
	_ap.play(clip, fade)
	_last = clip

func play_oneshot(clip: String) -> void:
	if _ap and _ap.has_animation(clip):
		_ap.play(clip, 0.04)
		_last = clip

func _clip_for(state: LocomotionMachine.State) -> String:
	match state:
		LocomotionMachine.State.WALK:
			return "walk"
		LocomotionMachine.State.RUN:
			return "run"
		LocomotionMachine.State.DODGE:
			return "dodge"
		LocomotionMachine.State.ATTACK:
			return "attack_light"
		LocomotionMachine.State.BLOCK:
			return "block"
		LocomotionMachine.State.HIT:
			return "hit"
		_:
			return "idle"
