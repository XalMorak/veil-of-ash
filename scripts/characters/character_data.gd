class_name CharacterData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var archetype: String = "balanced"
@export var hp: int = 1000
@export var stamina: float = 100.0
@export var poise: float = 60.0
@export var equip_load: float = 40.0
@export var strength: int = 10
@export var dexterity: int = 10
@export var mind: int = 10
@export var starting_weapon: String = ""
@export var lore: String = ""

static func from_dict(d: Dictionary) -> CharacterData:
	var c := CharacterData.new()
	c.id = str(d.get("id", ""))
	c.display_name = str(d.get("name", ""))
	c.archetype = str(d.get("archetype", "balanced"))
	c.hp = int(d.get("hp", 1000))
	c.stamina = float(d.get("stamina", 100))
	c.poise = float(d.get("poise", 60))
	c.equip_load = float(d.get("equip_load", 40))
	c.strength = int(d.get("strength", 10))
	c.dexterity = int(d.get("dexterity", 10))
	c.mind = int(d.get("mind", 10))
	c.starting_weapon = str(d.get("starting_weapon", ""))
	c.lore = str(d.get("lore", ""))
	return c
