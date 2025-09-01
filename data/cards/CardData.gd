class_name CardData
extends Resource



@export var display_name: String = "[Ex] Unnamed"
@export var base_name: String = "Unnamed"

# Defining an enum with the three card types:
enum CardType{
	Act,
	Tell,
	Plot
}
@export var card_type: CardType = CardType.Act


@export_multiline var display_description: String = """Card effect.
(Earth Synergy.)"""
@export_multiline var base_description: String = "Card effect."


## -------------------- TAGS -------------------- ##
enum FlavourTags {
	alive,
	animal,
	body,
	clothing,
	colours,
	combat_sports,
	creatures,
	deja_vu,
	food,
	games,
	heavenly,
	hellish,
	individuals,
	job,
	lane,
	letters,
	literature,
	literalism,
	loan,
	locations,
	luck,
	mortality,
	music,
	mythical,
	numbers,
	question,
	settings,
	shapes,
	speed,
	sports,
	stage,
	status,
	substances,
	time,
	tools,
	vulgar,
	wealth,
	weapons
}
enum AffectionTags {
	buff_ha,
	buff_hd,
	buff_ma,
	buff_md,
	buff_sa,
	buff_sd,
	buff_variable,
	buff_opp,
	debuff_ha,
	debuff_hd,
	debuff_ma,
	debuff_md,
	debuff_sa,
	debuff_sd,
	debuff_variable,
	debuff_self,
	overcharged,
	undercharged,
	amped,
	tapped,
	focused,
	distracted,
	regenerative,
	poisoned,
	synchronised,
	evasive,
	enraged,
	wounded,
	purged,
	fortified,
	isolated
}
enum KeywordTags {
	modal,
	silver_bullet,
	fake_out,
	multi_hit,
	multi_target,
	red_tape,
	red_carpet,
	flyleaf,
	targetless,
	two_evils
}
enum AbilityTags {
	free_switch,
	force_switch,
	draw,
	seek,
	scry,
	generate,
	draw_opp,
	recover,
	mill_self,
	mill_opp,
	discard_self,
	discard_opp,
	burn_self,
	burn_opp,
	tension_self,
	tension_opp,
	tension_lower,
	initiative_take,
	cleanse,
	reveal,
	plot,
	thread,
	tell,
	crit,
	glance,
	resonance,
	dissonance,
	free_play,
	force_play,
	shuffle,
	damage_self
}
# Using an Array of Enums as a workaround for the broken @export_flags.
@export var flavour_tags: Array[FlavourTags]
@export var affection_tags: Array[AffectionTags]
@export var keyword_tags: Array[KeywordTags]
@export var ability_tags: Array[AbilityTags]
