extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Souls collected: " + str(Signals.souls_collected)
