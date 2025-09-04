##class_name CardActDisplay
#extends CardDisplay
#
#@onready var labels = {
	#"name": $MarginContainer/VBoxContainer/NameBar/NameLabel,
	#"cost": $MarginContainer/VBoxContainer/NameBar/CostLabel,
	#"type": $MarginContainer/VBoxContainer/TypeBar/TypeLabel,
	#"subtype": $MarginContainer/VBoxContainer/TypeBar/SubtypeLabel,
	#"deliverance": $MarginContainer/VBoxContainer/DeliveranceBar/DeliveranceLabel,
	#"description": $MarginContainer/VBoxContainer/MarginContainer/DescriptionLabel,
	#}
#@onready var description_container = $MarginContainer/VBoxContainer/MarginContainer
#
#signal hovered(card)
#signal unhovered()
#
##var hover_scale = 1.5 # How big it gets
##var normal_scale = 1.0 # Its normal size
##var tween_time = 0.1 # How fast the animation is, in seconds
##var prezoom_z_index = 0
#
#func _ready():
	## --- ADDED CODE START ---
	## Set the vertical size flags for the description's container to FILL and EXPAND.
	## This tells the VBoxContainer to give this element all available vertical space.
	## We're doing this in code to bypass any confusion with the editor's Inspector.
	#description_container.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
	## We'll do the same for the label itself for good measure.
	#labels.description.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
	## --- ADDED CODE END ---
#
	## Connect the signals when the card is created.
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)
	#resized.connect(_on_resized)
	#_on_resized()
	## Connect the signals when the card is created.
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)
	#resized.connect(_on_resized)
	#_on_resized()
#
#func _on_mouse_entered():
	#emit_signal("hovered", self)
	##prezoom_z_index = z_index
	##z_index = 10 
	### A Tween is a little animator. We create one, tell it what to animate,
	### and it handles the smooth transition for us.
	##var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	##tween.tween_property(self, "scale", Vector2(hover_scale, hover_scale), tween_time)
#
#func _on_mouse_exited():
	#emit_signal("unhovered")
	##z_index = prezoom_z_index
	### Same again, but tweening back to its original size.
	##var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	##tween.tween_property(self, "scale", Vector2(normal_scale, normal_scale), tween_time)
	#
#func _on_resized():
	## Update the pivot offset to be the new bottom-centre.
	#pivot_offset = Vector2(size.x / 2.0, size.y)
#
#func setup():
	#await super.setup() # Calls the setup() from CardDisplay (good practice)
	#if not card_data:
		#return
#
	## Now, we populate all the common labels.
	#labels.name.text = card_data.display_name
	#labels.cost.text = card_data.display_cost
	#labels.type.text = "Act"
	#labels.subtype.text = CardDataAct.Subtype.keys()[card_data.card_subtype]
	#labels.description.set_shrinking_text(card_data.display_description)
