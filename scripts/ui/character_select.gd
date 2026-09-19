extends Control

@onready var list: VBoxContainer = $Center/Panel/List

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var roster := Roster.new()
	roster.load_from_json()
	for c in roster.playable:
		var b := Button.new()
		b.text = "%s  —  %s\nHP %d   STA %d   POISE %d" % [c.display_name, c.archetype, c.hp, int(c.stamina), int(c.poise)]
		b.custom_minimum_size = Vector2(520, 72)
		var id := c.id
		b.pressed.connect(func() -> void:
			Game.select_character(id)
			Game.enter_hub()
		)
		list.add_child(b)
