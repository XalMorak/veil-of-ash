class_name WeaponDB
extends RefCounted

static func load_all() -> Dictionary:
	var file := FileAccess.open("res://data/weapons.json", FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	var out := {}
	if typeof(parsed) != TYPE_DICTIONARY:
		return out
	for w in parsed.get("weapons", []):
		out[str(w.get("id", ""))] = w
	return out

static func for_character(starting_weapon: String) -> Dictionary:
	var all := load_all()
	if all.has(starting_weapon):
		return all[starting_weapon]
	return all.get("ashen_longsword", {
		"light": 110, "heavy": 175, "poise_light": 18, "poise_heavy": 36,
		"stamina_light": 18, "stamina_heavy": 34
	})
