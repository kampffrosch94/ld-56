extends TextureButton

var dropper_scene = preload("res://mouse_drop_sprite.tscn")

@export var ideology: Global.Ideology

func _ready() -> void:
	connect("pressed", _on_pressed)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_pressed() -> void:
	var dropper: Dropper = dropper_scene.instantiate()
	dropper.change_sprite(ideology)
	get_parent().get_parent().get_parent().get_parent().add_child(dropper)

func _on_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)

func _on_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)
