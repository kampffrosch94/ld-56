extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.year_passed.connect(year_passed)

var year_timer = 0
func _process(delta: float) -> void:
	year_timer += delta
	if year_timer > 6:
		Signals.year_passed.emit()
		year_timer = 0
	$CanvasLayer/SoulLabel.text = "Souls: " + str(Signals.souls_collected)


var year = 0
func year_passed():
	year += 1
	$CanvasLayer/YearLabel.text = "Year " + str(year)
	if year >= 200:
		if Signals.souls_collected >= 50:
			get_tree().change_scene_to_file("res://Victory.tscn")
		else:
			get_tree().change_scene_to_file("res://Defeat.tscn")
