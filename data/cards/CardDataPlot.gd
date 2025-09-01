# Child of CardData
# Establish the blueprint for cards that are specifically Plots

# Name it so that children can call on it
class_name CardDataPlot
# Define this as an extension to the blueprint for cards in general:
extends CardData

# Define subtypes:
enum Subtype{
	At,
	Back,
	Through,
	On,
	Off,
	Over,
	Under,
	Up,
	Down,
	To,
	From,
	In,
	Out
}

@export var subtype: Subtype = Subtype.At
