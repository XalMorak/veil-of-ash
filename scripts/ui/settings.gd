extends CanvasLayer

const PATH := "user://settings.cfg"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 40
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_build()
	_load()

func _build() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.015, 0.012, 0.92)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(dim)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.offset_left = -240
	box.offset_top = -220
	box.offset_right = 240
	box.offset_bottom = 240
	box.add_theme_constant_override("separation", 10)
	root.add_child(box)
	var title := Label.new()
	title.text = "Settings"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	_slider(box, "Master", "master")
	_slider(box, "Music", "music")
	_slider(box, "Effects", "sfx")
	var sens := HSlider.new()
	sens.name = "sens"
	sens.min_value = 0.4
	sens.max_value = 2.2
	sens.step = 0.05
	sens.value = 1.0
	box.add_child(_label("Mouse sensitivity"))
	box.add_child(sens)
	var full := CheckButton.new()
	full.name = "full"
	full.text = "Fullscreen"
	full.button_pressed = true
	box.add_child(full)
	var back := Button.new()
	back.text = "Back"
	back.pressed.connect(_close)
	box.add_child(back)

func _label(text: String) -> Label:
	var l := Label.new()
	l.text = text
	return l

func _slider(box: VBoxContainer, caption: String, id: String) -> void:
	box.add_child(_label(caption))
	var s := HSlider.new()
	s.name = id
	s.min_value = 0.0
	s.max_value = 1.0
	s.step = 0.01
	s.value = 0.8
	s.value_changed.connect(func(v: float) -> void: _apply_audio(id, v))
	box.add_child(s)

func _apply_audio(id: String, v: float) -> void:
	if id == "master":
		Sound.set_master(v)
	elif id == "music":
		Sound.set_music(v)
	else:
		Sound.set_sfx(v)

func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	var root := get_child(0)
	var box := root.get_child(1)
	for id in ["master", "music", "sfx"]:
		var s := box.find_child(id, true, false) as HSlider
		if s:
			s.value = cfg.get_value("audio", id, 0.8)
			_apply_audio(id, s.value)
	var sens := box.find_child("sens", true, false) as HSlider
	if sens:
		sens.value = cfg.get_value("input", "sens", 1.0)
	var full := box.find_child("full", true, false) as CheckButton
	if full:
		full.button_pressed = cfg.get_value("display", "fullscreen", true)

func _close() -> void:
	var root := get_child(0)
	var box := root.get_child(1)
	var cfg := ConfigFile.new()
	for id in ["master", "music", "sfx"]:
		var s := box.find_child(id, true, false) as HSlider
		if s:
			cfg.set_value("audio", id, s.value)
	var sens := box.find_child("sens", true, false) as HSlider
	var full := box.find_child("full", true, false) as CheckButton
	Game.mouse_sensitivity = 0.0025 * (sens.value if sens else 1.0)
	Game.fullscreen = full.button_pressed if full else true
	cfg.set_value("input", "sens", sens.value if sens else 1.0)
	cfg.set_value("display", "fullscreen", Game.fullscreen)
	cfg.save(PATH)
	if Game.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Sound.play("ui")
	queue_free()
