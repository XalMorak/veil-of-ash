extends Node3D

const PLAYER_SCENE := preload("res://scenes/actors/player.tscn")
const ACOLYTE_SCENE := preload("res://scenes/actors/cinder_acolyte.tscn")
const SENTINEL_SCENE := preload("res://scenes/actors/ash_sentinel.tscn")
const SHADE_SCENE := preload("res://scenes/actors/veil_shade.tscn")
const BEHEMOTH_SCENE := preload("res://scenes/actors/cinder_behemoth.tscn")
const SOUL_SCENE := preload("res://scenes/world/soul_pickup.tscn")

@onready var spawn: Marker3D = $Spawn

func _ready() -> void:
	Game.mark_scene("res://scenes/world/cinder_crypt.tscn")
	Game.set_objective("Break the Cinder Behemoth. The Causeway stays sealed until it falls.")
	WorldPalette.apply_to_tree(self)
	Atmosphere.apply(self)
	Atmosphere.colonnade(self, -8.2, -2.0, -40.0, 6.0)
	Atmosphere.colonnade(self, 8.2, -2.0, -40.0, 6.0)
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
	for s in [Vector3(-4, 1, -8), Vector3(5, 1, -12), Vector3(0, 1, -16)]:
		var a := ACOLYTE_SCENE.instantiate() as Node3D
		add_child(a)
		a.global_position = s
	var shade := SHADE_SCENE.instantiate() as Node3D
	add_child(shade)
	shade.global_position = Vector3(6, 1, -22)
	var sentinel := SENTINEL_SCENE.instantiate() as Node3D
	add_child(sentinel)
	sentinel.global_position = Vector3(-2, 1, -28)
	if not Game.has_flag("behemoth_slain"):
		var boss := BEHEMOTH_SCENE.instantiate() as Node3D
		add_child(boss)
		boss.global_position = Vector3(0, 1, -40)
	if not Game.has_flag("crypt_shard"):
		var shard := preload("res://scenes/world/flask_shard.tscn").instantiate() as Node3D
		add_child(shard)
		shard.global_position = Vector3(-8, 1, -20)
