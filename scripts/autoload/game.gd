extends Node
## Global game state for Veil of Ash.

signal character_selected(id: String)
signal player_died
signal bonfire_rested(bonfire_id: String)

var selected_character_id: String = "ash_warden"
var souls: int = 0
var last_bonfire: String = "hub_hearth"

func select_character(id: String) -> void:
	selected_character_id = id
	character_selected.emit(id)

func add_souls(amount: int) -> void:
	souls += max(amount, 0)

func spend_souls(amount: int) -> bool:
	if souls < amount:
		return false
	souls -= amount
	return true
