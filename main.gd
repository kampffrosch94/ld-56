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
