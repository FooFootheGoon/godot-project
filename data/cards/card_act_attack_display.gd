class_name CardActAttackDisplay
extends CardActDisplay

# A dictionary for the labels that are UNIQUE to the Attack card.
@onready var attack_labels = {
	"stat": $MarginContainer/VBoxContainer/TypeBar/StatIconLabel,
	"element": $MarginContainer/VBoxContainer/ElementBar/ElementLabel,
	# Based on your scene file, PowerLabel is on the DeliveranceBar.
	"power": $MarginContainer/VBoxContainer/DeliveranceBar/PowerLabel 
}

# We override the setup function to add more functionality.
func setup(data: CardData):
	# CRITICAL: This line runs the setup() function from the parent script first.
	# This populates all the common labels like name, cost, etc.
	await super.setup(data)
	
	if not card_data:
		return

	# This is a neat trick to help Godot's autocompletion know what kind of
	# data we're working with, since we know it's an attack card.
	var attack_data: CardDataActAttack = card_data

	# Now, populate the attack-specific labels.
	attack_labels.stat.text = CardDataActAttack.Stat.keys()[attack_data.card_stat]
	attack_labels.element.text = CardDataActAttack.Element.keys()[attack_data.card_element]
	attack_labels.power.text = str(attack_data.display_power)
	
	# We can also update the generic "Type" label from the base script.
	labels.type.text = "Act - Attack"
