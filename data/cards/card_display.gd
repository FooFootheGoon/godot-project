# This is our base script for all visual cards.
class_name CardDisplay
extends Control

# This function will be defined in the child scripts.
func setup():
	pass

var owner_monster: MonsterDisplay = null

signal card_selected(card_display_node)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# When clicked, emit our custom signal, sending a reference to itself.
		emit_signal("card_selected", self)
