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
var prezoom_z_index: int = 0
var original_position: Vector2

# --- Hover Animation Logic ---
@onready var internal_vbox = $MarginContainer/VBoxContainer

var is_hovered = false
var default_y_size = 150 # The small, 'in-hand' height
var expanded_y_size = 300 # The full, 'popped-up' height

func _ready():
	custom_minimum_size.y = default_y_size
	original_position = position
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
	z_index = 100
	
	var size_change = expanded_y_size - default_y_size
	var target_pos_y = original_position.y - size_change
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "custom_minimum_size:y", expanded_y_size, 0.2)
	tween.tween_property(self, "position:y", target_pos_y, 0.2)
	
	emit_signal("hovered", self)

func _on_mouse_exited():
	if not is_hovered: return
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "custom_minimum_size:y", default_y_size, 0.2)
	tween.tween_property(self, "position:y", original_position.y, 0.2)
	
	await tween.finished
	# Only reset z_index if the mouse hasn't immediately re-entered.
	if not is_hovered:
		z_index = prezoom_z_index
		
	emit_signal("unhovered", self)
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("card_selected", self)
