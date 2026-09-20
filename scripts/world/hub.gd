extends Node3D

const PLAYER_SCENE := preload("res://scenes/actors/player.tscn")
const HOLLOW_SCENE := preload("res://scenes/actors/ash_hollow.tscn")
const KNIGHT_SCENE := preload("res://scenes/actors/veil_knight.tscn")
const SOUL_SCENE := preload("res://scenes/world/soul_pickup.tscn")

@onready var spawn: Marker3D = $Spawn

func _ready() -> void:
	Game.mark_scene("res://scenes/world/hub.tscn")
	WorldPalette.apply_to_tree(self)
	var player := PLAYER_SCENE.instantiate() as Node3D
	add_child(player)
	player.global_position = spawn.global_position
	var hud := preload("res://scenes/ui/hud.tscn").instantiate()
	add_child(hud)
	_spawn_pack()
	if Game.has_dropped_souls:
		add_child(SOUL_SCENE.instantiate())
	Game.bonfire_rested.connect(_on_rest)

func _spawn_pack() -> void:
	for n in get_tree().get_nodes_in_group("enemy"):
		n.queue_free()
	var spots := [Vector3(8, 1, -6), Vector3(11, 1, -2), Vector3(-9, 1, -8)]
	for s in spots:
		var h := HOLLOW_SCENE.instantiate() as Node3D
		add_child(h)
		h.global_position = s
	var k := KNIGHT_SCENE.instantiate() as Node3D
	add_child(k)
	k.global_position = Vector3(0, 1, -16)

func _on_rest(_id: String) -> void:
	_spawn_pack()
