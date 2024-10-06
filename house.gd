extends Sprite2D
class_name House

var mom: Villager = null
var pop: Villager = null
var villager_scene: PackedScene = load("res://Villager.tscn")

var preg_chance = 0.2

func _ready() -> void:
	Signals.year_passed.connect(on_year_passed)

func on_year_passed():
	if mom == null or pop == null:
		queue_free()
		return
	if mom.age < 40:
		if randf() <= preg_chance:
			var child: Villager = villager_scene.instantiate()
			add_sibling(child)
			child.global_position = global_position
