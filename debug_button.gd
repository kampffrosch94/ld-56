extends Button

func _on_pressed() -> void:
	Signals.year_passed.emit()
