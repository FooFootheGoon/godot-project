# This script sits on our monster scene and connects
# the visuals (Labels) to the data (MonsterData resource).

class_name MonsterDisplay
extends Node2D

# We can drag the monster .tres file here in the editor:
@export var monster_data: MonsterData

# Linking our label nodes so the script can talk to them:
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var stats_label: Label = $VBoxContainer/StatsLabel
@onready var life_bar: ProgressBar = $VBoxContainer/LifeBar
@onready var life_label: Label = $VBoxContainer/LifeBar/LifeLabel
# This variable will hold a reference to this monster's hand display:
@export var hand_container: HBoxContainer
# This is the active deck mid-battle:
var active_deck: Array = []

func _ready():
	# We need to find the Area2D node to get its signals
	var area_2d = $Area2D
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)

# Helper function. Check if the number is a whole number or a float; return correct string:
func _format_stat(stat_value: float) -> String:
	if stat_value == int(stat_value):
		return str(int(stat_value))
	else:
		return str(stat_value)

# This function will be called to set everything up:
func setup():
	# First, check if the data has come through:
	if monster_data:
		# Now we use our new helper function to format all the stats at once:
		name_label.text = monster_data.monster_name
		stats_label.text = "HA:%s / MA:%s / SA:%s / HD:%s / MD:%s / SD:%s" %[
			_format_stat(monster_data.heart_attack),
			_format_stat(monster_data.mind_attack),
			_format_stat(monster_data.soul_attack),
			_format_stat(monster_data.heart_defence),
			_format_stat(monster_data.mind_defence),
			_format_stat(monster_data.soul_defence),
			]
		stats_label.hide() # <-- Hides the label by default
		life_bar.max_value = monster_data.max_life
		life_bar.value = monster_data.current_life
		_update_life_display()
	else:
		# If the data did not come through:
		name_label.text = "BUG: No monster data pulled."

func _on_mouse_entered():
	stats_label.show() # Make the stats visible!
# This function will be called by the "mouse_exited" signal.
func _on_mouse_exited():
	stats_label.hide() # Make 'em disappear again.

signal monster_targeted(monster_display_node)

func take_damage(damage_amount: float):
	# Subtract the damage from the monster's health data.
	monster_data.current_life -= damage_amount
	monster_data.current_life = clamp(monster_data.current_life, 0, monster_data.max_life)
		
	_update_life_display()
	print("%s took %s damage. %s life left." % [monster_data.monster_name, damage_amount, monster_data.current_life])

func _update_life_display():
	life_bar.value = monster_data.current_life
	life_label.text = _format_stat(monster_data.current_life) + " / " + _format_stat(monster_data.max_life)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("monster_targeted", self)
