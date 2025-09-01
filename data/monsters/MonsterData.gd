# MonsterData.gd
# This file is a blueprint for all monster-specific data.

class_name MonsterData
extends Resource

# Defining an enum with the elements:
enum elements{
	None,
	Air,
	Fire,
	Light,
	Earth,
	Water,
	Dark,
	Blight,
	Electricity,
	Automata,
	Magic,
	Plant,
	Ice,
	Sound,
	Energy,
	Aether,
	Gemstone,
	Gas,
	Placeholder,
}

# The monster's name:
# From goo to you, by way of the zoo
@export var monster_name = "primordial soup"
# The monster's elements:
@export var monster_main_element: elements = elements.None
@export var heart_attack: int = 2
@export var heart_defence: int = 2
@export var mind_attack: int = 2
@export var mind_defence: int = 2
@export var soul_attack: int = 2
@export var soul_defence: int = 2

@export var current_life: float = 100
@export var max_life: float = 100
@export var deck: Array[Resource]
