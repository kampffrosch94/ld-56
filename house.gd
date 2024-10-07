extends Sprite2D
class_name House

var mom: Villager = null
var pop: Villager = null
var villager_scene: PackedScene = load("res://Villager.tscn")


var preg_chance := {
	Global.Ideology.Ankh: 0.35,
	Global.Ideology.Axe: 0.2,
	Global.Ideology.Hammer: 0.2,
	Global.Ideology.Maw: 0.0,
}

func _ready() -> void:
	Signals.year_passed.connect(on_year_passed)

func on_year_passed():
	if mom == null or pop == null:
		queue_free()
		return
	if mom.age < 40:
		if randf() <= preg_chance[mom.current_ideology()]:
			var child: Villager = villager_scene.instantiate()
			add_sibling(child)
			child.global_position = global_position
	else:
		queue_free()
