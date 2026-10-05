extends Control

@onready var continue_button: Button = $Center/Continue

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false
	continue_button.disabled = not Game.has_save()
	$Center/NewGame.pressed.connect(_new_game)
	continue_button.pressed.connect(_continue)
	$Center/Settings.pressed.connect(_settings)
	$Center/How.pressed.connect(_how)
	$Center/Quit.pressed.connect(func() -> void: get_tree().quit())
	_apply_saved()

func _new_game() -> void:
	Game.new_game()
	get_tree().change_scene_to_file(Game.SELECT_PATH)

func _continue() -> void:
	if Game.load_game():
		get_tree().change_scene_to_file(Game.last_scene)

func _settings() -> void:
	Sound.play("ui")
	add_child(preload("res://scripts/ui/settings.gd").new())

func _how() -> void:
	Sound.play("ui")
	var layer := CanvasLayer.new()
	layer.layer = 15
	add_child(layer)
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -280
	panel.offset_top = -160
	panel.offset_right = 280
	panel.offset_bottom = 160
	layer.add_child(panel)
	var box := VBoxContainer.new()
	panel.add_child(box)
	var body := Label.new()
	body.autowrap_mode = TextServer.AUTOWRAP_WORD
	body.text = "WASD / left stick move. Mouse / right stick look. LMB or RB light, RMB or RT heavy. Space or B dodge. Shift or LB block. MMB or R3 lock-on. R or X flask. E or A rest and level up. Esc pause.\n\nRest at a bonfire. Clear the Cinder Crypt to open the Causeway. Extinguish the First Ember."
	box.add_child(body)
	var b := Button.new()
	b.text = "Close"
	b.pressed.connect(layer.queue_free)
	box.add_child(b)

func _apply_saved() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") != OK:
		return
	Sound.set_master(cfg.get_value("audio", "master", 0.8))
	Sound.set_music(cfg.get_value("audio", "music", 0.8))
	Sound.set_sfx(cfg.get_value("audio", "sfx", 0.8))
	Game.mouse_sensitivity = 0.0025 * float(cfg.get_value("input", "sens", 1.0))
	Game.fullscreen = bool(cfg.get_value("display", "fullscreen", true))
	if Game.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
