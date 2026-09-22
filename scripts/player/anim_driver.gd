class_name AnimDriver
extends Node
## Mixamo AnimationPlayer first. PoseDriver fallback if clips missing.

@export var default_fade := 0.12

@onready var loco: LocomotionMachine = get_parent().get_node_or_null("LocomotionMachine")

var _ap: AnimationPlayer
var _pose: PoseDriver
var _last := ""

func _ready() -> void:
	var root := get_parent()
	_ap = root.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if _ap == null:
		_ap = root.find_child("AnimationPlayer", true, false) as AnimationPlayer
	_pose = root.get_node_or_null("PoseDriver") as PoseDriver
	if _pose == null:
		_pose = PoseDriver.new()
		_pose.name = "PoseDriver"
		root.add_child(_pose)

func _process(_delta: float) -> void:
	if loco == null:
		return
	var clip := _clip_for(loco.state)
	if clip == _last:
		return
	_last = clip
	if _ap and _ap.has_animation(clip):
		var fade := 0.04 if clip in ["dodge", "attack_light", "attack_heavy", "hit", "death"] else default_fade
		_ap.play(clip, fade)
	elif _pose:
		_pose.set_from_name(clip)

func play_oneshot(clip: String) -> void:
	_last = clip
	if _ap and _ap.has_animation(clip):
		_ap.play(clip, 0.04)
	elif _pose:
		_pose.set_from_name(clip)

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
		LocomotionMachine.State.DEATH:
			return "death"
		_:
			return "idle"
