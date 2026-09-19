extends CanvasLayer

@onready var hp: ProgressBar = $Root/Bars/HP
@onready var sta: ProgressBar = $Root/Bars/Stamina
@onready var souls: Label = $Root/Souls
@onready var hint: Label = $Root/Hint

func _ready() -> void:
	Game.souls_changed.connect(_on_souls)
	_on_souls(Game.souls)

func _process(_delta: float) -> void:
	var p := get_tree().get_first_node_in_group("player")
	if p == null or not p.has_node("Vitality"):
		return
	var v: Vitality = p.get_node("Vitality")
	hp.max_value = v.max_hp
	hp.value = v.hp
	sta.max_value = v.max_stamina
	sta.value = v.stamina

func _on_souls(amount: int) -> void:
	souls.text = "%d souls" % amount
