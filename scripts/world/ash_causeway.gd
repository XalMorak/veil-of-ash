extends Node3D

const PLAYER_SCENE := preload("res://scenes/actors/player.tscn")
const HOLLOW_SCENE := preload("res://scenes/actors/ash_hollow.tscn")
const ACOLYTE_SCENE := preload("res://scenes/actors/cinder_acolyte.tscn")
const SHADE_SCENE := preload("res://scenes/actors/veil_shade.tscn")
const SENTINEL_SCENE := preload("res://scenes/actors/ash_sentinel.tscn")
const KNIGHT_SCENE := preload("res://scenes/actors/veil_knight.tscn")
const LORD_SCENE := preload("res://scenes/actors/first_ember.tscn")
const SOUL_SCENE := preload("res://scenes/world/soul_pickup.tscn")

@onready var spawn: Marker3D = $Spawn

func _ready() -> void:
	Game.mark_scene("res://scenes/world/ash_causeway.tscn")
	Game.set_objective("Climb the causeway. Extinguish the First Ember.")
	WorldPalette.apply_to_tree(self)
	var player := PLAYER_SCENE.instantiate() as Node3D
	add_child(player)
	player.global_position = spawn.global_position
	add_child(preload("res://scenes/ui/hud.tscn").instantiate())
	_populate()
	if Game.has_dropped_souls:
		var gem := SOUL_SCENE.instantiate() as Node3D
		add_child(gem)
		gem.global_position = Game.dropped_souls_pos

func _populate() -> void:
	for s in [Vector3(4, 1, -8), Vector3(-5, 1, -14)]:
		var h := HOLLOW_SCENE.instantiate() as Node3D
		add_child(h)
		h.global_position = s
	var ac := ACOLYTE_SCENE.instantiate() as Node3D
	add_child(ac)
	ac.global_position = Vector3(-4, 1, -6)
	var sh := SHADE_SCENE.instantiate() as Node3D
	add_child(sh)
	sh.global_position = Vector3(6, 6, -28)
	var se := SENTINEL_SCENE.instantiate() as Node3D
	add_child(se)
	se.global_position = Vector3(0, 6, -26)
	var k := KNIGHT_SCENE.instantiate() as Node3D
	add_child(k)
	k.global_position = Vector3(0, 8, -36)
	if not Game.has_flag("ember_slain"):
		var lord := LORD_SCENE.instantiate() as Node3D
		add_child(lord)
		lord.global_position = Vector3(0, 12, -58)
