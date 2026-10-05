extends Node
## Global game state for Veil of Ash. Campaign, build, save.

signal character_selected(id: String)
signal player_died
signal bonfire_rested(bonfire_id: String)
signal souls_changed(amount: int)
signal souls_dropped(world_pos: Vector3, amount: int)
signal flask_changed(charges: int, maximum: int)
signal build_changed
signal toast_requested(text: String)
signal pause_changed(paused: bool)
signal objective_changed(text: String)

const SAVE_PATH := "user://veil_of_ash.save"
const HUB_PATH := "res://scenes/world/hub.tscn"
const SELECT_PATH := "res://scenes/ui/character_select.tscn"
const TITLE_PATH := "res://scenes/ui/title.tscn"
const VICTORY_PATH := "res://scenes/ui/victory.tscn"
const CRYPT_PATH := "res://scenes/world/cinder_crypt.tscn"
const CAUSEWAY_PATH := "res://scenes/world/ash_causeway.tscn"

var selected_character_id: String = "ash_warden"
var souls: int = 0
var level: int = 1
var vigor: int = 10
var endurance: int = 10
var strength: int = 10
var dexterity: int = 10
var ember: int = 10
var flask_charges: int = 3
var flask_max: int = 3
var last_bonfire: String = "hub_hearth"
var last_scene: String = HUB_PATH
var dropped_souls: int = 0
var dropped_souls_pos: Vector3 = Vector3.ZERO
var has_dropped_souls: bool = false
var flags: Dictionary = {}
var paused: bool = false
var objective: String = "Rest at the hearth, then enter the Cinder Crypt."
var run_active: bool = false
var mouse_sensitivity: float = 0.0025
var fullscreen: bool = true

func _ready() -> void:
	_bind_pad()

func _bind_pad() -> void:
	_joy_button("light_attack", JOY_BUTTON_RIGHT_SHOULDER)
	_joy_button("heavy_attack", JOY_BUTTON_RIGHT_STICK)
	_joy_button("dodge", JOY_BUTTON_B)
	_joy_button("block", JOY_BUTTON_LEFT_SHOULDER)
	_joy_button("lock_on", JOY_BUTTON_RIGHT_STICK)
	_joy_button("interact", JOY_BUTTON_A)
	_joy_button("ui_cancel", JOY_BUTTON_START)
	var heal := InputEventKey.new()
	heal.physical_keycode = KEY_R
	if not InputMap.has_action("flask"):
		InputMap.add_action("flask")
	InputMap.action_add_event("flask", heal)
	_joy_button("flask", JOY_BUTTON_X)
	_joy_axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	_joy_axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	_joy_axis("move_forward", JOY_AXIS_LEFT_Y, -1.0)
	_joy_axis("move_back", JOY_AXIS_LEFT_Y, 1.0)

func _joy_axis(action: String, axis: JoyAxis, direction: float) -> void:
	var ev := InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = direction
	InputMap.action_add_event(action, ev)

func _joy_button(action: String, button: JoyButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var ev := InputEventJoypadButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)

func new_game() -> void:
	souls = 0
	level = 1
	vigor = 10
	endurance = 10
	strength = 10
	dexterity = 10
	ember = 10
	flask_charges = 3
	flask_max = 3
	last_bonfire = "hub_hearth"
	last_scene = HUB_PATH
	dropped_souls = 0
	has_dropped_souls = false
	flags = {}
	paused = false
	objective = "Rest at the hearth, then enter the Cinder Crypt."
	run_active = true
	selected_character_id = "ash_warden"
	get_tree().paused = false
	souls_changed.emit(souls)
	flask_changed.emit(flask_charges, flask_max)
	objective_changed.emit(objective)

func select_character(id: String) -> void:
	selected_character_id = id
	run_active = true
	character_selected.emit(id)
	save_game()

func add_souls(amount: int) -> void:
	souls += max(amount, 0)
	souls_changed.emit(souls)

func spend_souls(amount: int) -> bool:
	if souls < amount:
		return false
	souls -= amount
	souls_changed.emit(souls)
	return true

func level_cost() -> int:
	return 80 + level * 40

func try_level(stat: String) -> bool:
	var cost := level_cost()
	if not spend_souls(cost):
		toast("Need %d souls." % cost)
		return false
	match stat:
		"vigor":
			vigor += 1
		"endurance":
			endurance += 1
		"strength":
			strength += 1
		"dexterity":
			dexterity += 1
		"ember":
			ember += 1
		_:
			souls += cost
			return false
	level += 1
	build_changed.emit()
	save_game()
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
	flask_charges = flask_max
	flask_changed.emit(flask_charges, flask_max)
	bonfire_rested.emit(bonfire_id)
	save_game()

func try_drink() -> bool:
	if flask_charges <= 0:
		toast("Flask empty. Rest at a bonfire.")
		return false
	flask_charges -= 1
	flask_changed.emit(flask_charges, flask_max)
	return true

func add_flask_charge() -> void:
	flask_max += 1
	flask_charges = flask_max
	flask_changed.emit(flask_charges, flask_max)
	toast("Flask shard. Charges: %d" % flask_max)
	save_game()

func mark_scene(path: String) -> void:
	last_scene = path

func has_flag(id: String) -> bool:
	return bool(flags.get(id, false))

func set_flag(id: String) -> void:
	flags[id] = true

func set_objective(text: String) -> void:
	objective = text
	objective_changed.emit(text)

func toast(text: String) -> void:
	toast_requested.emit(text)

func toggle_pause() -> void:
	paused = not paused
	get_tree().paused = paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED
	pause_changed.emit(paused)

func enter_hub() -> void:
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file(HUB_PATH)

func enter_title() -> void:
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file(TITLE_PATH)

func respawn() -> void:
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file(last_scene if last_scene != "" else HUB_PATH)

func reload_current() -> void:
	get_tree().paused = false
	paused = false
	get_tree().reload_current_scene()

func notify_kill(enemy_id: String) -> void:
	if enemy_id == "cinder_behemoth" and not has_flag("behemoth_slain"):
		set_flag("behemoth_slain")
		set_objective("The ash gate is open. Cross the Causeway and extinguish the First Ember.")
		toast("Cinder Behemoth falls. The Causeway opens.")
		save_game()
	elif enemy_id == "the_first_ember" and not has_flag("ember_slain"):
		set_flag("ember_slain")
		set_objective("The last fire is still.")
		save_game()
		toast("The First Ember goes dark.")
		get_tree().create_timer(2.4).timeout.connect(func() -> void:
			get_tree().paused = false
			paused = false
			get_tree().change_scene_to_file(VICTORY_PATH)
		)

func scaled_hp(base_hp: float) -> float:
	return base_hp + float(vigor - 10) * 48.0

func scaled_stamina(base_stamina: float) -> float:
	return base_stamina + float(endurance - 10) * 6.0

func damage_multiplier(weapon_class: String) -> float:
	var stat := float(strength if weapon_class != "dual" else dexterity)
	return 1.0 + (stat - 10.0) * 0.035 + float(ember - 10) * 0.02

func apply_build(player: Node) -> void:
	if player == null or not player.has_node("Vitality"):
		return
	var vitality = player.get_node("Vitality")
	var roster = load("res://scripts/characters/roster.gd").new()
	roster.load_from_json()
	var data = roster.get_playable(selected_character_id)
	vitality.max_hp = scaled_hp(float(data.hp))
	vitality.max_stamina = scaled_stamina(data.stamina)
	vitality.max_poise = data.poise + float(vigor - 10) * 2.0
	var w = load("res://scripts/combat/weapon_db.gd").for_character(data.starting_weapon)
	var mult := damage_multiplier(str(w.get("class", "straight_sword")))
	if player.has_node("Hitboxes/Light"):
		var light = player.get_node("Hitboxes/Light")
		var heavy = player.get_node("Hitboxes/Heavy")
		light.damage = float(w.get("light", 110)) * mult
		light.poise_damage = float(w.get("poise_light", 18))
		heavy.damage = float(w.get("heavy", 175)) * mult
		heavy.poise_damage = float(w.get("poise_heavy", 36))
	vitality.rest_full()
	build_changed.emit()

func save_game() -> void:
	if not run_active:
		return
	var payload := {
		"character": selected_character_id,
		"souls": souls,
		"level": level,
		"vigor": vigor,
		"endurance": endurance,
		"strength": strength,
		"dexterity": dexterity,
		"ember": ember,
		"flask_charges": flask_charges,
		"flask_max": flask_max,
		"last_bonfire": last_bonfire,
		"last_scene": last_scene,
		"flags": flags,
		"objective": objective,
		"has_dropped_souls": has_dropped_souls,
		"dropped_souls": dropped_souls,
		"dropped_pos": [dropped_souls_pos.x, dropped_souls_pos.y, dropped_souls_pos.z],
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(payload))

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func load_game() -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var d: Dictionary = parsed
	selected_character_id = str(d.get("character", "ash_warden"))
	souls = int(d.get("souls", 0))
	level = int(d.get("level", 1))
	vigor = int(d.get("vigor", 10))
	endurance = int(d.get("endurance", 10))
	strength = int(d.get("strength", 10))
	dexterity = int(d.get("dexterity", 10))
	ember = int(d.get("ember", 10))
	flask_charges = int(d.get("flask_charges", 3))
	flask_max = int(d.get("flask_max", 3))
	last_bonfire = str(d.get("last_bonfire", "hub_hearth"))
	last_scene = str(d.get("last_scene", HUB_PATH))
	flags = d.get("flags", {})
	objective = str(d.get("objective", objective))
	has_dropped_souls = bool(d.get("has_dropped_souls", false))
	dropped_souls = int(d.get("dropped_souls", 0))
	var pos: Array = d.get("dropped_pos", [0, 0, 0])
	dropped_souls_pos = Vector3(float(pos[0]), float(pos[1]), float(pos[2]))
	run_active = true
	paused = false
	get_tree().paused = false
	return true
