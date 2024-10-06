extends Sprite2D
class_name Dropper

func change_sprite(ideology: Global.Ideology):
	# print(ideology)
	self.region_rect.position.x = 32 * (ideology + 1)

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click"):
		queue_free()
