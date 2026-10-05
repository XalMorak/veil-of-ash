extends Control

@onready var continue_button: Button = $Center/Continue

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false
	continue_button.disabled = not Game.has_save()
	$Center/NewGame.pressed.connect(_new_game)
	continue_button.pressed.connect(_continue)
	$Center/Quit.pressed.connect(func() -> void: get_tree().quit())

func _new_game() -> void:
	Game.new_game()
	get_tree().change_scene_to_file(Game.SELECT_PATH)

func _continue() -> void:
	if Game.load_game():
		get_tree().change_scene_to_file(Game.last_scene)
