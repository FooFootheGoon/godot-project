# The brain for the battle.
extends Node
class_name BattleManager

var lane_initiative_left: int = 0
var lane_initiative_right: int = 0
@onready var initiative_slider_left: VSlider = $"../InitiativeSliderLeft"
@onready var initiative_slider_right: VSlider = $"../InitiativeSliderRight"

var selected_card: CardDisplay = null

# We need to know who the monsters are.
var player_monster_left: MonsterDisplay = null
var player_monster_right: MonsterDisplay = null
var enemy_monster_left: MonsterDisplay = null
var enemy_monster_right: MonsterDisplay = null

func _ready():
	_update_initiative_displays()

func _update_initiative_displays():
	initiative_slider_left.value = -1 * lane_initiative_left
	initiative_slider_right.value = -1 * lane_initiative_right

func on_card_selected(card_node):
	self.selected_card = card_node
	print("Selected card: ", card_node.card_data.display_name)

func on_monster_targeted(monster_node):
	var card = self.selected_card
	if card:
		_play_card(card, monster_node)
	else:
		print("No card selected. Cannot target monster.")

func _unhandled_input(event):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selected_card:
			selected_card = null
			print("Card deselected.")

func _play_card(card: CardDisplay, target_monster: MonsterDisplay):
	# The first thing we do is build the live version of the card data.
	var live_card_data = _build_live_card_data(card.card_data, card.owner_monster, target_monster)
	
	if card.card_data is CardDataAct:
		# We check which monster the card belongs to.
		var card_owner = card.owner_monster
		var initiative_track_to_use = 0
		
		# Now we figure out which initiative track to use
		if card_owner == player_monster_left:
			initiative_track_to_use = self.lane_initiative_left
		elif card_owner == player_monster_right:
			initiative_track_to_use = self.lane_initiative_right
		else:
			print("Tried to play an opposing card.")
			# TODO: Allow opposing monsters to play cards.
		
		if initiative_track_to_use >= 0 and (initiative_track_to_use - live_card_data.cost) >= -6:
			print("Playing card ", live_card_data.name, " targeting ", target_monster.monster_data.monster_name)
			
			if card_owner == player_monster_left:
				self.lane_initiative_left -= live_card_data.cost
				self.lane_initiative_left = clamp(self.lane_initiative_left, -6, 6)
				print("Left lane Initiative remaining: ", self.lane_initiative_left)
			elif card_owner == player_monster_right:
				self.lane_initiative_right -= live_card_data.cost
				self.lane_initiative_right = clamp(self.lane_initiative_right, -6, 6)
				print("Right lane Initiative remaining: ", self.lane_initiative_right)
			else:
				print("BUG: No card owner?")
			
			_update_initiative_displays()
				
				# 1. In the case of Attack cards:
			if card.card_data is CardDataActAttack:
				var attacker_stat = 0.0
				var defender_stat = 0.0
				var card_power = live_card_data.power
				var card_stat_type = live_card_data.stat
				# Figure out which stats to use based on the card's stat type.
				# A 'match' statement; cleaner version of a big if/elif/else block.
				match card_stat_type:
					CardDataActAttack.Stat.Heart:
						attacker_stat = card_owner.monster_data.heart_attack
						defender_stat = target_monster.monster_data.heart_defence
					CardDataActAttack.Stat.Mind:
						attacker_stat = card_owner.monster_data.mind_attack
						defender_stat = target_monster.monster_data.mind_defence
					CardDataActAttack.Stat.Soul:
						attacker_stat = card_owner.monster_data.soul_attack
						defender_stat = target_monster.monster_data.soul_defence
				
				var total_damage = 0.0
				var multiplier = 1.0 #TODO: Add multipliers' logic.
				
				# 4. Safeguard! We can't divide by zero, so we check the defender's stat first.
				if defender_stat >= 1:
					total_damage = (attacker_stat * card_power * multiplier) / defender_stat
				else:
					print("BUG: Defender stat is %s. Shouldn't be under 1." % defender_stat)
					total_damage = (attacker_stat * card_power * multiplier)
				
				# This is our new line for rounding the damage.
				total_damage = round(total_damage * 1000) / 1000.0
				
				# Make sure we don't accidentally HEAL the target if their defence is super high!
				total_damage = max(total_damage, 1.0)
				
				target_monster.take_damage(total_damage)
			
			card.queue_free()
			self.selected_card = null
		else:
			print("Not enough Initiative in this lane.")
	else:
		print("Not an Act.")

# This is the new brain of the Deliverance system.
# It takes a card's blueprint and the battle context, then returns a Dictionary
# containing the final, "live" card data.
func _build_live_card_data(card_blueprint: CardDataAct, card_owner: MonsterDisplay, _target_monster: MonsterDisplay) -> Dictionary:
	# --- Step 1: Create the 'live_card_data' and load it with base stats. ---
	var live_card_data = {
		"name": card_blueprint.base_name,
		"description": card_blueprint.base_description,
		"cost": card_blueprint.base_cost,
		"power": 0, # Will be replaced if it's an Attack card
		"element": null,
		"stat": null
	}
	if card_blueprint is CardDataActAttack:
		live_card_data["power"] = card_blueprint.base_power
		live_card_data["element"] = card_blueprint.card_element
		live_card_data["stat"] = card_blueprint.card_stat
		
	var name_prefixes: Array[String] = []
	var name_suffixes: Array[String] = []
	var name_format_args: Dictionary = {}
	var description_appends: Array[String] = []

	# --- Step 2: Loop through every potential effect on the card. ---
	for effect in card_blueprint.deliverance_effects:
		var condition_met = false
		
		# --- Step 3: Check if the condition for this effect is met. ---
		match effect.condition_type:
				DeliveranceEffect.ConditionType.SYNERGY:
					# First, we need to figure out who the card owner's teammate is.
					var teammate: MonsterDisplay = null
					if player_monster_right and card_owner == player_monster_left:
						teammate = player_monster_right
					elif player_monster_left and card_owner == player_monster_right:
						teammate = player_monster_left
					# Now, check if that teammate exists and if its element matches.
					if teammate and teammate.monster_data.monster_main_element == effect.condition_element:
						condition_met = true
						
				DeliveranceEffect.ConditionType.SAP:
					# --- DEBUG PRINTS: Let's see what the code is thinking ---
					print("--- Checking SAP condition ---")
					print("Effect is looking for element: ", MonsterData.elements.find_key(effect.condition_element))
					if enemy_monster_left:
						print("Enemy Left exists. Their element is: ", MonsterData.elements.find_key(enemy_monster_left.monster_data.monster_main_element))
					else:
						print("Enemy Left does NOT exist (is null).")

					if enemy_monster_right:
						print("Enemy Right exists. Their element is: ", MonsterData.elements.find_key(enemy_monster_right.monster_data.monster_main_element))
					else:
						print("Enemy Right does NOT exist (is null).")
					# --- END DEBUG PRINTS ---

					if (enemy_monster_left and enemy_monster_left.monster_data.monster_main_element == effect.condition_element) or \
					(enemy_monster_right and enemy_monster_right.monster_data.monster_main_element == effect.condition_element):
						condition_met = true
						print(">>> SAP CONDITION MET! <<<") # A success message
					# Check if either of the enemy monsters has the required element for Sap.
					# We must check if the monster exists (is not null) BEFORE checking its element.
					if (enemy_monster_left and enemy_monster_left.monster_data.monster_main_element == effect.condition_element) or \
					(enemy_monster_right and enemy_monster_right.monster_data.monster_main_element == effect.condition_element):
						condition_met = true
						
				DeliveranceEffect.ConditionType.CONDITIONAL:
					# We'll handle custom conditionals later.
					pass
		
		# --- Step 4: If the condition was met, apply the effect. ---
		if condition_met:
			# This match statement directs the effect to the right logic based on its target.
			match effect.affected_property:
				DeliveranceEffect.AffectedProperty.COST:
					if effect.action_type == DeliveranceEffect.ActionType.ADD:
						# We convert the 'value' from a string (e.g., "-1") to an integer to do math.
						live_card_data.cost += int(effect.value)
				
				DeliveranceEffect.AffectedProperty.POWER:
					if effect.action_type == DeliveranceEffect.ActionType.ADD:
						live_card_data.power += int(effect.value)
				
				# --- NEW: Collect the text fragments instead of applying them immediately ---
				DeliveranceEffect.AffectedProperty.NAME_PREFIX:
					name_prefixes.append(effect.value)
				DeliveranceEffect.AffectedProperty.NAME_SUFFIX:
					name_suffixes.append(effect.value)
				DeliveranceEffect.AffectedProperty.NAME_FORMAT:
					# Only add the piece if its index is valid (0 or more).
					if effect.format_arg_index >= 0:
						name_format_args[effect.format_arg_index] = effect.value
				DeliveranceEffect.AffectedProperty.DESCRIPTION_APPEND:
					description_appends.append(effect.value)
			
	# --- Step 5: After the loop, assemble any formatted text. ---
	# Build the final name
	if not name_format_args.is_empty():
		# If we're using the advanced template system...
		var final_args = []
		if name_format_args.keys().size() > 0:
			final_args.resize(name_format_args.keys().max() + 1)
		final_args.fill("") # Fill with empty strings to avoid errors
		for index in name_format_args:
			final_args[index] = name_format_args[index]
		live_card_data.name = live_card_data.name.format(final_args, "%s")
	else:
		# If we're using the simple prefix/suffix system...
		var final_name = "".join(name_prefixes) + live_card_data.name + "".join(name_suffixes)
		live_card_data.name = final_name

	# Build the final description
	for text_to_append in description_appends:
		live_card_data.description += "\n" + text_to_append # Add a new line for each part

	# Finally, apply our perfect capitalization to the name
	live_card_data.name = live_card_data.name.strip_edges().capitalize()

	# --- Step 6: Return the final, resolved card data. ---
	return live_card_data
