extends Node3D

const PLAYER_SCENE := preload("res://scenes/actors/player.tscn")
const HOLLOW_SCENE := preload("res://scenes/actors/ash_hollow.tscn")
const KNIGHT_SCENE := preload("res://scenes/actors/veil_knight.tscn")
const LORD_SCENE := preload("res://scenes/actors/first_ember.tscn")
const SOUL_SCENE := preload("res://scenes/world/soul_pickup.tscn")

@onready var spawn: Marker3D = $Spawn

func _ready() -> void:
	var player := PLAYER_SCENE.instantiate() as Node3D
	add_child(player)
	player.global_position = spawn.global_position
	add_child(preload("res://scenes/ui/hud.tscn").instantiate())
	_populate()
	if Game.has_dropped_souls:
		add_child(SOUL_SCENE.instantiate())

func _populate() -> void:
	for s in [Vector3(4, 1, -8), Vector3(-5, 1, -14), Vector3(10, 6, -22)]:
		var h := HOLLOW_SCENE.instantiate() as Node3D
		add_child(h)
		h.global_position = s
	var k := KNIGHT_SCENE.instantiate() as Node3D
	add_child(k)
	k.global_position = Vector3(0, 8, -36)
	var lord := LORD_SCENE.instantiate() as Node3D
	add_child(lord)
	lord.global_position = Vector3(0, 12, -58)
