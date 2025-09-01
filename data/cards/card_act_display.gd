class_name CardActDisplay
extends CardDisplay

@onready var labels = {
	"name": $MarginContainer/VBoxContainer/NameBar/NameLabel,
	"cost": $MarginContainer/VBoxContainer/NameBar/CostLabel,
	"type": $MarginContainer/VBoxContainer/TypeBar/TypeLabel,
	"subtype": $MarginContainer/VBoxContainer/TypeBar/SubtypeLabel,
	"deliverance": $MarginContainer/VBoxContainer/DeliveranceBar/DeliveranceLabel,
	"description": $MarginContainer/VBoxContainer/MarginContainer/DescriptionLabel,
	}

func setup():
	super.setup() # Calls the setup() from CardDisplay (good practice)
	if not card_data:
		return

	# Now, we populate all the common labels.
	labels.name.text = card_data.display_name
	labels.cost.text = card_data.display_cost
	labels.type.text = "Act"
	labels.subtype.text = CardDataAct.Subtype.keys()[card_data.card_subtype]
	labels.description.set_shrinking_text(card_data.display_description)
