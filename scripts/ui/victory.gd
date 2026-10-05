extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false
	$Center/TitleBtn.pressed.connect(func() -> void: Game.enter_title())
	$Center/Quit.pressed.connect(func() -> void: get_tree().quit())
