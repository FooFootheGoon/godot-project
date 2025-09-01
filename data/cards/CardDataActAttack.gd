# Child of CardDataAct

extends CardDataAct
class_name CardDataActAttack

enum Element{
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
	Gas
}
@export var card_element: Element = Element.None

enum Stat{
	Heart,
	Mind,
	Soul,
	Heart_fakeout,
	Mind_fakeout,
	Soul_fakeout,
}
@export var card_stat: Stat = Stat.Heart

@export var display_power: String = "0 [+3]"
@export var base_power: int = 0
