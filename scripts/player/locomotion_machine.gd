class_name LocomotionMachine
extends Node
## 8-way / action states. AnimDriver maps these to Mixamo clip names.

enum State { IDLE, WALK, RUN, DODGE, ATTACK, BLOCK, HIT, DEATH }

var state: State = State.IDLE

func update_move(planar_speed: float, dodging: bool, acting: bool, blocking: bool) -> void:
	if state == State.DEATH:
		return
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

func hit() -> void:
	if state != State.DEATH:
		state = State.HIT

func die() -> void:
	state = State.DEATH

func state_name() -> String:
	return State.keys()[state]
