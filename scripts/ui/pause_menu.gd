extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 30
	visible = false
	Game.pause_changed.connect(_on_pause)
	_build()

func _build() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)
	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.01, 0.01, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(dim)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.offset_left = -160
	box.offset_top = -120
	box.offset_right = 160
	box.offset_bottom = 140
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 12)
	root.add_child(box)
	var title := Label.new()
	title.text = "VEIL OF ASH"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var resume := Button.new()
	resume.text = "Resume"
	resume.pressed.connect(func() -> void: Game.toggle_pause())
	box.add_child(resume)
	var title_btn := Button.new()
	title_btn.text = "Title"
	title_btn.pressed.connect(func() -> void:
		Game.save_game()
		Game.enter_title()
	)
	box.add_child(title_btn)

func _on_pause(paused: bool) -> void:
	visible = paused
