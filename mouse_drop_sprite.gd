extends Sprite2D
class_name Dropper

var ideology: Global.Ideology
var symbol_scene = preload("res://Symbol.tscn")

func change_sprite(ideology: Global.Ideology):
	# print(ideology)
	self.region_rect.position.x = 32 * (ideology + 1)
	self.ideology = ideology

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click"):
		var symbol: Symbol = symbol_scene.instantiate()
		get_parent().add_sibling(symbol)
		symbol.global_position = global_position
		symbol.change_sprite(ideology)
		queue_free()
	if Input.is_action_just_pressed("right_click"):
		queue_free()
