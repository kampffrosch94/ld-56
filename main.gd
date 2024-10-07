extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var year_timer = 0
func _process(delta: float) -> void:
	year_timer += delta
	if year_timer > 6:
		Signals.year_passed.emit()
		year_timer = 0
