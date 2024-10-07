extends Area2D
class_name Symbol
@onready var sprite: Sprite2D = $Sprite2D
var ideology: Global.Ideology
@onready var mouse_area: Area2D = $MouseArea
@onready var radius = $EffectShape.shape.radius

func change_sprite(ideology: Global.Ideology):
	# print(ideology)
	self.sprite.region_rect.position.x = 32 * (ideology + 1)
	self.ideology = ideology

func _ready() -> void:
	mouse_area.connect("mouse_entered", mouse_entered)
	mouse_area.connect("mouse_exited", mouse_exit)
	Signals.year_passed.connect(on_year_passed)

func mouse_entered():
	sprite.scale = Vector2(1.2, 1.2)
	
func mouse_exit() -> void:
	sprite.scale = Vector2(1, 1)


func _on_mouse_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("right_click"):
		queue_free()


func _draw() -> void:
	var color = Global.get_color(ideology)
	draw_circle(Vector2.ZERO, radius, color, false, 2, true)


func on_year_passed():
	for area in get_overlapping_bodies():
		if area.is_in_group("villager"):
			var villager := area as Villager
			var material: ShaderMaterial = villager.sprite.material
			var clr : Color = Global.get_color(ideology) # or whatever
			material.set_shader_parameter("shirt_color", clr)
