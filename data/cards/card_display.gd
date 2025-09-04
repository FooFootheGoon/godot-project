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
var prezoom_z_index = 0

# --- Hover Animation Logic ---
@onready var internal_vbox = $MarginContainer/VBoxContainer

var is_hovered = false
var default_y_size = 150 # The small, 'in-hand' height
var expanded_y_size = 300 # The full, 'popped-up' height

func _ready():
	pivot_offset = Vector2(custom_minimum_size.x / 2.0, default_y_size)
	custom_minimum_size.y = default_y_size
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

# This is a 'virtual' function. Child scripts will override it.
func setup(data: CardData):
	self.card_data = data
	# Any other setup common to ALL cards would go here.

func _on_mouse_entered():
	if is_hovered: return
	is_hovered = true
	prezoom_z_index = z_index
	z_index = 10 
	
	# Child scripts will need to define which containers to swap ratios for.
	# We'll handle that in the child script.
	
	var target_scale = expanded_y_size / default_y_size
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale:y", target_scale, 0.2)
	emit_signal("hovered", self)

func _on_mouse_exited():
	is_hovered = false
	z_index = prezoom_z_index
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale:y", 1.0, 0.2)
	
	await tween.finished
	if not is_hovered:
		z_index = 0
	emit_signal("unhovered", self)
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("card_selected", self)
