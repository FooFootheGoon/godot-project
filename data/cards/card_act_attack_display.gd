class_name CardActAttackDisplay
extends CardDisplay

@export var card_data: CardDataActAttack

# Drag your Label nodes here in the Inspector.
# Putting all the labels into a single dictionary
# rather than @OnReadying them all individually
@onready var labels = {
	"name":$VBoxContainer/CardNameLabel ,
	"cost": $VBoxContainer/CardCostLabel,
	"type": $VBoxContainer/CardTypeLabel,
	"subtype": $VBoxContainer/CardSubtypeLabel,
	"power": $VBoxContainer/CardPowerLabel,
	"stat": $VBoxContainer/CardStatLabel,
	"element": $VBoxContainer/CardElementLabel,
	"description": $VBoxContainer/CardDescriptionLabel
}

func setup():
	if card_data:
		labels.name.text = card_data.display_name
		labels.cost.text = str(card_data.display_cost)
		# The keys function looks up the name of an entry in an enum or dictionary:
		labels.type.text = CardDataActAttack.CardType.keys()[card_data.card_type]
		labels.subtype.text = CardDataActAttack.Subtype.keys()[card_data.card_subtype]
		labels.power.text = str(card_data.display_power)
		labels.stat.text = CardDataActAttack.Stat.keys()[card_data.card_stat]
		labels.element.text = CardDataActAttack.Element.keys()[card_data.card_element]
		labels.description.text = card_data.display_description
