class_name LockOnSystem
extends Node3D

@export var max_distance: float = 18.0
var target: Node3D = null

func toggle() -> void:
	if target:
		clear()
	else:
		acquire()

func has_target() -> bool:
	return target != null and is_instance_valid(target)

func acquire() -> void:
	var best: Node3D = null
	var best_d := max_distance
	for n in get_tree().get_nodes_in_group("lockable"):
		if n is Node3D:
			var d := global_position.distance_to((n as Node3D).global_position)
			if d < best_d:
				best_d = d
				best = n
	target = best

func clear() -> void:
	target = null

func _process(_delta: float) -> void:
	if target == null:
		return
	if not is_instance_valid(target):
		clear()
		return
	if global_position.distance_to(target.global_position) > max_distance * 1.25:
		clear()
