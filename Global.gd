class_name Global
extends Node

# sprite order on x axis
enum Ideology {
	Ankh = 0,
	Axe = 1,
	Hammer = 2,
	Maw = 3,
}

static func get_color(ideo: Ideology):
	match ideo:
		Ideology.Ankh:
			return Color.GREEN
		Ideology.Axe:
			return Color.RED 
		Ideology.Hammer:
			return Color.BLUE
		Ideology.Maw:
			return Color.REBECCA_PURPLE 

static func is_enemy(me: Ideology, other: Ideology) -> bool:
	match me:
		Ideology.Ankh:
			return false
		Ideology.Hammer:
			return other == Ideology.Axe
		Ideology.Axe:
			return other == Ideology.Hammer
		Ideology.Maw:
			return other == Ideology.Ankh
	return false
 
