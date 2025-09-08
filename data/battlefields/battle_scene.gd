extends Control
class_name BattleScene

# We need to tell the script where to find our card scene blueprints.
const CardDisplayScene = preload("res://data/cards/card_display.gd")
const CardActDisplayScene = preload("res://data/scenes/card_act_display.tscn")
const CardActAttackDisplayScene = preload("res://data/scenes/card_act_attack_display.tscn")
# Commented out until these scenes exist:
#const CardPlotDisplayScene = preload("res://data/scenes/card_plot_display.tscn")
#const CardPlotFoldedDisplayScene = preload("res://data/scenes/card_plot_folded_display.tscn")
#const CardTellDisplayScene = preload("res://data/scenes/card_tell_display.tscn")

# Let's get our nodes ready.
# We are now getting references to our monsters directly.
@onready var ally_monster_1: MonsterDisplay = $AllyMonster1
@onready var ally_monster_2: MonsterDisplay = $AllyMonster2
@onready var enemy_monster_1: MonsterDisplay = $EnemyMonster1
@onready var enemy_monster_2: MonsterDisplay = $EnemyMonster2
@onready var monster_displays: Array[MonsterDisplay] = []
@onready var draw_button: Button = $DrawButton
@onready var draw_button2: Button = $DrawButton2
@onready var draw_button3: Button = $DrawButton3
@onready var draw_button4: Button = $DrawButton4
@onready var battle_manager: BattleManager = $BattleManager # Get a reference to the Referee
@onready var card_zoom_layer = $CardZoomLayer
var zoomed_card = null
var card_zoom_tween_time = 0.15 # How fast the zoom animation is
var is_hovered = false
var default_y_size = 150 # The small, 'in-hand' height of your card
var expanded_y_size = 300 # The full, 'popped-up' height of your card
var prezoom_z_index = 0

func _ready():
	# Tell the BattleManager who the player's monsters are.
	battle_manager.player_monster_left = ally_monster_1
	battle_manager.player_monster_right = ally_monster_2
	battle_manager.enemy_monster_left = enemy_monster_1 
	battle_manager.enemy_monster_right = enemy_monster_2
	
	# This loop will find all the MonsterDisplay nodes that are direct children of this node.
	for monster_display in get_children():
		# Safety check: Make sure the node is actually a MonsterDisplay and has data.
		if monster_display is MonsterDisplay and monster_display.monster_data:
			# Add the valid monster display to our Array of MonsterDisplays:
			monster_displays.append(monster_display)
			# Create a copy of the deck for this monster, then use the inbuilt shuffle:
			monster_display.active_deck = monster_display.monster_data.deck.duplicate(true)
			monster_display.active_deck.shuffle()
			# Now we run the setup function to get the visuals right.
			monster_display.setup()
			# Connect the monster's 'targeted' signal to the BattleManager.
			monster_display.monster_targeted.connect(battle_manager.on_monster_targeted)
			# Now, let's draw the initial hand for this monster.
			for i in range(5):
				await _draw_card_for_monster(monster_display)
	
	# Connect the button's "pressed" signal to our draw function.
	#draw_button.pressed.connect(draw_ally1)
	#draw_button2.pressed.connect(draw_ally2)
	#draw_button3.pressed.connect(draw_opponent1)
	#draw_button4.pressed.connect(draw_opponent2)
	
func _draw_card_for_monster(current_monster: MonsterDisplay):
	if not current_monster.active_deck.is_empty():
		var new_card_display = null
		var card_to_draw_data = current_monster.active_deck.pop_front()
		
		# Now we check the card's type!
		if card_to_draw_data is CardDataActAttack:
			new_card_display = CardActAttackDisplayScene.instantiate()
		elif card_to_draw_data is CardDataAct:
			new_card_display = CardActDisplayScene.instantiate()
		# Commented out until a CardDataPlot.gd script exists:
		#elif card_to_draw_data is CardDataPlot:
			#new_card_display = CardPlotDisplayScene.instantiate()
		# Commented out until a CardDataTell.gd script exists:
		#elif card_to_draw_data is CardDataTell:
			#print("BUG: A monster has just drawn a Tell card.")
			
		# Make sure we actually instantiated a card.
		if new_card_display:
			current_monster.hand_container.add_child(new_card_display)
			current_monster.hand_container.move_child(new_card_display, 0)
			new_card_display.z_index = current_monster.hand_container.get_child_count()
			await new_card_display.setup(card_to_draw_data)
			
			new_card_display.owner_monster = current_monster
			new_card_display.card_selected.connect(battle_manager.on_card_selected)
			
			new_card_display.hovered.connect(_on_card_hovered)
			new_card_display.unhovered.connect(_on_card_unhovered)
	else:
		print("This monster's deck is empty.")
		
# A helper function to reduce repetition.
func _draw_card_from_index(index: int):
	# There are 4 monster_displays (0, 1, 2, 3). If not <4, don't even try, fucker.
	if index < monster_displays.size() and monster_displays[index] and monster_displays[index].monster_data:
		_draw_card_for_monster(monster_displays[index])
	else:
		print("BUG: No monster from which to draw data.")

func _on_card_hovered(card_in_hand):
	# If there's already a card zoomed, get rid of it.
	if zoomed_card:
		zoomed_card.queue_free()

	# Create a new instance of the card scene for zooming.
	zoomed_card = CardActDisplayScene.instantiate()
	# Set its data from the card in the hand.
	zoomed_card.setup(card_in_hand.card_data)
	
	# This is the magic bullet that fixes the flicker!
	# It makes the zoomed card invisible to the mouse.
	zoomed_card.mouse_filter = MOUSE_FILTER_IGNORE

	# Add it to our top layer and position it
	card_zoom_layer.add_child(zoomed_card)
	zoomed_card.global_position = card_in_hand.global_position
	zoomed_card.scale = Vector2(0.5, 0.5) # Start it small

	# Animate!
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(zoomed_card, "scale", Vector2(1, 1), 0.2)
	# You can also tween its position to the center of the screen, etc.
	tween.tween_property(zoomed_card, "global_position", get_viewport_rect().size / 2 - zoomed_card.size / 2, 0.2)


func _on_card_unhovered(card_in_hand):
	if not zoomed_card:
		return

	var card_to_dismiss = zoomed_card
	zoomed_card = null # Clear the reference

	# Animate away and then delete
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(card_to_dismiss, "scale", Vector2(0, 0), 0.2)
	# When the animation is done, queue_free() deletes the node safely.
	tween.finished.connect(card_to_dismiss.queue_free)

func draw_ally1():
	_draw_card_from_index(0)
func draw_ally2():
	_draw_card_from_index(1)
func draw_opponent1():
	_draw_card_from_index(2)
func draw_opponent2():
	_draw_card_from_index(3)
