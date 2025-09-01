# Child of CardData
# Establish the blueprint for cards that are specifically Acts

class_name CardDataAct
extends CardData

enum Subtype{
	Attack,
	Utility
}

@export var card_subtype: Subtype = Subtype.Utility

@export var display_cost: String = "1 {+2}"
@export var base_cost: int = 1

# This creates a list that will hold all DeliveranceEffect resources for this card.
@export var deliverance_effects: Array[DeliveranceEffect]
