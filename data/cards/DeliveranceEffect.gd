# This script defines a custom data packet for a single Deliverance effect.
# It extends Resource, which means we can create and save these as separate .tres files.
class_name DeliveranceEffect
extends Resource

# --- The "IF" Part: What condition must be met? ---

enum ConditionType { 
	SYNERGY, 
	SAP, 
	CONDITIONAL 
}

# This variable will hold our condition type, chosen from the enum above.
@export var condition_type: ConditionType

# For Synergy and Sap, we need to know which element to look for.
# We can borrow the existing 'elements' enum from our MonsterData script.
@export var condition_element: MonsterData.elements = MonsterData.elements.None

# For Conditional effects, we'll need a way to identify them.
# For now, a simple string ID will do the trick.
@export var conditional_id: String = ""

# --- The "THEN" Part: What happens when the condition is met? ---

# An enum for what part of the card we're going to change.
enum AffectedProperty {
	COST,
	POWER,
	NAME_PREFIX, # Text to add to the start of the name
	NAME_SUFFIX, # Text to add to the end of the name
	NAME_FORMAT,
	DESCRIPTION_APPEND, # Text to add to the description
	DESCRIPTION_FORMAT,
	ELEMENT,
}
# This variable will hold our target property.
@export var affected_property: AffectedProperty

# An enum for how we're going to change the section.
enum ActionType {
	APPEND, # For adding text
	ADD, # For numbers (Cost, Power)
	SET, # To completely replace a value
}
# This variable holds the action we'll perform.
@export var action_type: ActionType

# The actual value of the change.
# A Variant can hold anything: an int for power, a string for a name, etc.
@export var value: String = ""

# For advanced name construction, this specifies which blank in the template to fill.
@export var format_arg_index: int = -1
