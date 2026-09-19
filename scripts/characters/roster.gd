class_name Roster
extends RefCounted

var playable: Array[CharacterData] = []
var enemies: Array[Dictionary] = []

func load_from_json(path: String = "res://data/characters.json") -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Roster: cannot open %s" % path)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Roster: invalid JSON")
		return
	playable.clear()
	for entry in parsed.get("playable", []):
		playable.append(CharacterData.from_dict(entry))
	enemies = parsed.get("enemies", [])

func get_playable(id: String) -> CharacterData:
	for c in playable:
		if c.id == id:
			return c
	return playable[0] if playable.size() > 0 else CharacterData.new()
