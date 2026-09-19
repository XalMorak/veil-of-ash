class_name LocomotionMachine
extends Node
## 8-way locomotion stub. Swap mesh_root animations when a real AnimationTree arrives.

enum State { IDLE, WALK, RUN, DODGE, ATTACK, BLOCK, HIT }

var state: State = State.IDLE

func update_move(planar_speed: float, dodging: bool, acting: bool, blocking: bool) -> void:
	if dodging:
		state = State.DODGE
	elif acting:
		state = State.ATTACK
	elif blocking:
		state = State.BLOCK
	elif planar_speed > 5.2:
		state = State.RUN
	elif planar_speed > 0.4:
		state = State.WALK
	else:
		state = State.IDLE

func state_name() -> String:
	return State.keys()[state]
