extends Node
## Global game state for Veil of Ash.

signal character_selected(id: String)
signal player_died
signal bonfire_rested(bonfire_id: String)
signal souls_changed(amount: int)
signal souls_dropped(world_pos: Vector3, amount: int)

var selected_character_id: String = "ash_warden"
var souls: int = 0
var last_bonfire: String = "hub_hearth"
var last_scene: String = "res://scenes/world/hub.tscn"
var dropped_souls: int = 0
var dropped_souls_pos: Vector3 = Vector3.ZERO
var has_dropped_souls: bool = false

const HUB_PATH := "res://scenes/world/hub.tscn"
const SELECT_PATH := "res://scenes/ui/character_select.tscn"

func select_character(id: String) -> void:
	selected_character_id = id
	character_selected.emit(id)

func add_souls(amount: int) -> void:
	souls += max(amount, 0)
	souls_changed.emit(souls)

func spend_souls(amount: int) -> bool:
	if souls < amount:
		return false
	souls -= amount
	souls_changed.emit(souls)
	return true

func drop_souls_at(world_pos: Vector3) -> void:
	if souls <= 0:
		return
	dropped_souls = souls
	dropped_souls_pos = world_pos
	has_dropped_souls = true
	souls = 0
	souls_changed.emit(souls)
	souls_dropped.emit(world_pos, dropped_souls)

func retrieve_dropped_souls() -> int:
	if not has_dropped_souls:
		return 0
	var n := dropped_souls
	has_dropped_souls = false
	dropped_souls = 0
	add_souls(n)
	return n

func lose_dropped_souls() -> void:
	has_dropped_souls = false
	dropped_souls = 0

func rest_at(bonfire_id: String) -> void:
	last_bonfire = bonfire_id
	bonfire_rested.emit(bonfire_id)

func mark_scene(path: String) -> void:
	last_scene = path

func enter_hub() -> void:
	get_tree().change_scene_to_file(HUB_PATH)

func respawn() -> void:
	get_tree().change_scene_to_file(last_scene if last_scene != "" else HUB_PATH)
