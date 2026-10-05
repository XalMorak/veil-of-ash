extends Node3D

const PLAYER_SCENE := preload("res://scenes/actors/player.tscn")
const HOLLOW_SCENE := preload("res://scenes/actors/ash_hollow.tscn")
const KNIGHT_SCENE := preload("res://scenes/actors/veil_knight.tscn")
const SOUL_SCENE := preload("res://scenes/world/soul_pickup.tscn")

@onready var spawn: Marker3D = $Spawn

func _ready() -> void:
	Game.mark_scene("res://scenes/world/hub.tscn")
	WorldPalette.apply_to_tree(self)
	Atmosphere.apply(self)
	_dress_hearth()
	var player := PLAYER_SCENE.instantiate() as Node3D
	add_child(player)
	player.global_position = spawn.global_position
	add_child(preload("res://scenes/ui/hud.tscn").instantiate())
	for offset in [Vector3(-6, 1, -8), Vector3(5, 1, -10), Vector3(0, 1, -14)]:
		var hollow := HOLLOW_SCENE.instantiate() as Node3D
		add_child(hollow)
		hollow.global_position = offset
	var knight := KNIGHT_SCENE.instantiate() as Node3D
	add_child(knight)
	knight.global_position = Vector3(8, 1, -18)
	if Game.has_dropped_souls:
		var gem := SOUL_SCENE.instantiate() as Node3D
		add_child(gem)
		gem.global_position = Game.dropped_souls_pos
	var causeway: WorldGate = $ToCauseway
	causeway.requires_flag = "behemoth_slain"
	causeway.locked_message = "The Causeway is sealed. The Behemoth still burns in the Crypt."
	_add_crypt_gate()
	if Game.has_flag("behemoth_slain"):
		Game.set_objective("Cross the far arch. The First Ember waits on the Causeway.")
	else:
		Game.set_objective("Take the side arch into the Cinder Crypt. Break the Behemoth.")

func _dress_hearth() -> void:
	Atmosphere.fire_ring(self, Vector3.ZERO)
	Atmosphere.tree(self, Vector3(-11.5, 0, 3.5))
	Atmosphere.tree(self, Vector3(13, 0, 6))
	for i in 4:
		var z := -8.0 - float(i) * 5.5
		Atmosphere.arch(self, Vector3(-9.5, 0, z), 0.95)
		Atmosphere.arch(self, Vector3(9.5, 0, z), 0.85)
	Atmosphere.arch(self, Vector3(0, 0, -27), 1.45)

func _add_crypt_gate() -> void:
	var gate := preload("res://scenes/world/gate.tscn").instantiate() as WorldGate
	add_child(gate)
	gate.global_position = Vector3(18, 0, -6)
	gate.target_scene = Game.CRYPT_PATH
	gate.requires_flag = ""
	var mark := Label3D.new()
	mark.text = "Cinder Crypt"
	mark.font_size = 48
	mark.position = Vector3(0, 4.6, 0)
	gate.add_child(mark)
