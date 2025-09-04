class_name CardActDisplay
extends CardDisplay

# --- Node References ---
# A dictionary to hold all our labels for easy access.
@onready var labels = {
	"name": $MarginContainer/VBoxContainer/NameBar/NameLabel,
	"cost": $MarginContainer/VBoxContainer/NameBar/CostLabel,
	"type": $MarginContainer/VBoxContainer/TypeBar/TypeLabel,
	"description": $MarginContainer/VBoxContainer/DescriptionContainer/DescriptionLabel,
	"deliverance": $MarginContainer/VBoxContainer/DeliveranceBar/DeliveranceLabel,
}

@onready var name_bar = $MarginContainer/VBoxContainer/NameBar
@onready var description_container = $MarginContainer/VBoxContainer/DescriptionContainer

func _ready():
	# Connect mouse signals for hover effects later.
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

# The main function to set up the card with data.
func setup(data: CardData):
	await super.setup(data) # <<< This runs the setup() from CardDisplay first!
	
	if not card_data:
		return

	await get_tree().process_frame

	# Populate the common labels.
	labels.name.text = card_data.display_name
	labels.cost.text = card_data.display_cost
	labels.type.text = "Act"
	labels.deliverance.text = "Deliverance" # Placeholder
	
	labels.description.set_shrinking_text(card_data.display_description)

func _on_mouse_entered():
	# Run the original animation from the parent script first
	super._on_mouse_entered()
	# Now add our Act-card-specific logic
	name_bar.size_flags_stretch_ratio = 1.0
	description_container.size_flags_stretch_ratio = 4.0

func _on_mouse_exited():
	# Run the original animation from the parent script first
	super._on_mouse_exited()
	# Now add our Act-card-specific logic
	name_bar.size_flags_stretch_ratio = 4.0
	description_container.size_flags_stretch_ratio = 1.0
