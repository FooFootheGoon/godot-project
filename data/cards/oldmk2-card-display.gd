## This is our base script for all visual cards.
#class_name CardDisplay
#extends Control
#
#@onready var description_label = $MarginContainer/VBoxContainer/MarginContainer/DescriptionLabel
#@export var card_data: CardData
#
## This function will be defined in the child scripts.
#func setup():
	## Wait for the next frame to ensure all containers are properly sized
	#await get_tree().process_frame
	#if not card_data:
		#return
	## As long as a DescriptionLabel was found, we call the shrinking function on it.
	#if description_label:
		#description_label.set_shrinking_text(card_data.display_description)
	#else:
		## A little warning for you in case you forget to add the label later.
		#print("Warning: Card '", card_data.display_name, "' has no DescriptionLabel at the expected path.")
#
#var owner_monster: MonsterDisplay = null
#
#signal card_selected(card_display_node)
#func _gui_input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		## When clicked, emit our custom signal, sending a reference to itself.
		#emit_signal("card_selected", self)
