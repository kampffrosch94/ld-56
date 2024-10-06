extends Area2D

@onready var nav: NavigationAgent2D = $NavigationAgent2D
var navigation_finished = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav.target_position = Vector2(400, 400)

func _physics_process(delta: float) -> void:
	if not navigation_finished:
		var dir = (nav.get_next_path_position() - global_position).normalized()
		translate(dir * delta * 250 )


func _on_navigation_agent_2d_navigation_finished() -> void:
	navigation_finished = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		nav.target_position = get_global_mouse_position()
		navigation_finished = false
