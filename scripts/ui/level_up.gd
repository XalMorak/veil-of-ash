extends CanvasLayer

var _labels: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	Game.paused = true
	_build()

func _build() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.62)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(dim)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 460)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -260
	panel.offset_top = -230
	panel.offset_right = 260
	panel.offset_bottom = 230
	root.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	title.text = "Bonfire — kindle the remnant"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var cost := Label.new()
	cost.name = "Cost"
	box.add_child(cost)
	_labels["cost"] = cost
	for stat in ["vigor", "endurance", "strength", "dexterity", "ember"]:
		var row := HBoxContainer.new()
		var name := Label.new()
		name.custom_minimum_size = Vector2(280, 0)
		name.name = stat
		row.add_child(name)
		_labels[stat] = name
		var btn := Button.new()
		btn.text = "Raise"
		var key := stat
		btn.pressed.connect(func() -> void:
			if Game.try_level(key):
				_apply_player()
			_refresh()
		)
		row.add_child(btn)
		box.add_child(row)
	var note := Label.new()
	note.text = "Vigor HP · Endurance stamina · Strength / Dexterity damage · Ember both."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD
	box.add_child(note)
	var leave := Button.new()
	leave.text = "Rise (enemies return)"
	leave.pressed.connect(_leave)
	box.add_child(leave)
	_refresh()

func _refresh() -> void:
	_labels["cost"].text = "Level %d    Souls %d    Next %d" % [Game.level, Game.souls, Game.level_cost()]
	_labels["vigor"].text = "Vigor %d" % Game.vigor
	_labels["endurance"].text = "Endurance %d" % Game.endurance
	_labels["strength"].text = "Strength %d" % Game.strength
	_labels["dexterity"].text = "Dexterity %d" % Game.dexterity
	_labels["ember"].text = "Ember %d" % Game.ember

func _apply_player() -> void:
	var p := get_tree().get_first_node_in_group("player")
	if p:
		Game.apply_build(p)

func _leave() -> void:
	get_tree().paused = false
	Game.paused = false
	Game.save_game()
	queue_free()
	Game.reload_current()
