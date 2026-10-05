extends CanvasLayer

@onready var hp: ProgressBar = $Root/Bars/HP
@onready var stamina: ProgressBar = $Root/Bars/Stamina
@onready var souls: Label = $Root/Souls
@onready var hint: Label = $Root/Hint

var _toast: Label
var _objective: Label
var _flask: Label
var _toast_time: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_node("Vitality"):
		var v: Vitality = player.get_node("Vitality")
		v.hp_changed.connect(_on_hp)
		v.stamina_changed.connect(_on_stamina)
		_on_hp(v.hp, v.max_hp)
		_on_stamina(v.stamina, v.max_stamina)
	Game.souls_changed.connect(_on_souls)
	_on_souls(Game.souls)
	Game.toast_requested.connect(_show_toast)
	Game.flask_changed.connect(_on_flask)
	_flask = Label.new()
	_flask.position = Vector2(48, 132)
	_flask.add_theme_font_size_override("font_size", 18)
	$Root.add_child(_flask)
	_on_flask(Game.flask_charges, Game.flask_max)
	_objective = Label.new()
	_objective.position = Vector2(48, 164)
	_objective.custom_minimum_size = Vector2(760, 40)
	_objective.autowrap_mode = TextServer.AUTOWRAP_WORD
	_objective.text = Game.objective
	$Root.add_child(_objective)
	Game.objective_changed.connect(func(t: String) -> void: _objective.text = t)
	_toast = Label.new()
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_toast.offset_top = 80
	_toast.offset_left = -320
	_toast.offset_right = 320
	_toast.offset_bottom = 120
	$Root.add_child(_toast)
	var pause := preload("res://scripts/ui/pause_menu.gd").new()
	pause.name = "PauseMenu"
	add_child(pause)
	hint.text = "LMB light  RMB heavy  Space dodge  Shift block  R flask  E rest  Esc pause"

func _process(delta: float) -> void:
	if _toast_time > 0.0:
		_toast_time -= delta
		if _toast_time <= 0.0:
			_toast.text = ""

func _on_hp(current: float, max_hp: float) -> void:
	hp.max_value = max_hp
	hp.value = current

func _on_stamina(current: float, max_stamina: float) -> void:
	stamina.max_value = max_stamina
	stamina.value = current

func _on_souls(amount: int) -> void:
	souls.text = "Lv %d    %d souls" % [Game.level, amount]

func _on_flask(charges: int, maximum: int) -> void:
	if _flask:
		_flask.text = "Flask %d / %d" % [charges, maximum]

func _show_toast(text: String) -> void:
	_toast.text = text
	_toast_time = 3.2
