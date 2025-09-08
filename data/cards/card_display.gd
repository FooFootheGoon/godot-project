# card_display.gd
# The new "grandparent" script for ALL card types.

class_name CardDisplay
extends PanelContainer

# --- Signals ---
signal hovered(card)
signal unhovered(card)
signal card_selected(card)

# --- Common Properties ---
var card_data: CardData
var owner_monster: MonsterDisplay
var default_y_size = 150

# --- Hover Animation Logic ---
@onready var internal_vbox = $MarginContainer/VBoxContainer

func _ready():
	custom_minimum_size.y = default_y_size
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

# This is a 'virtual' function. Child scripts will override it.
func setup(data: CardData):
	self.card_data = data
	# Any other setup common to ALL cards would go here.

func _on_mouse_entered():
	emit_signal("hovered", self)
	print ("Hovered")

func _on_mouse_exited():
	emit_signal("unhovered", self)
	print ("Unhovered")
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("card_selected", self)
