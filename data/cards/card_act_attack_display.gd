class_name CardActAttackDisplay
extends CardActDisplay

# Drag your Label nodes here in the Inspector.
# Putting all the labels into a single dictionary
# rather than @OnReadying them all individually
# The dictionary for unique attack labels is correct.
@onready var attack_labels = {
	"power": $MarginContainer/VBoxContainer/DeliveranceBar/PowerLabel,
	"stat": $MarginContainer/VBoxContainer/TypeBar/StatIconLabel,
	"element": $MarginContainer/VBoxContainer/ElementBar/ElementLabel,
	#unassigned: $MarginContainer/VBoxContainer/ElementBar/ElementIconLabel,
	#$MarginContainer/VBoxContainer/DeliveranceBar/DeliveranceLabel,
}

func setup():
	super.setup() # This runs the setup from CardActDisplay first
	if not card_data:
		return

	# We can do the same trick for autocompletion here.
	var data: CardDataActAttack = card_data

	if card_data:
		attack_labels.power.text = str(data.display_power)
		attack_labels.stat.text = CardDataActAttack.Stat.keys()[data.card_stat]
		attack_labels.element.text = CardDataActAttack.Element.keys()[data.card_element]
