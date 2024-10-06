extends Area2D
class_name Villager

var age: int = 0
var max_age := 60
var sex: int = 0

@onready var aplayer : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var axe_score := 0
var maw_score := 0
var ankh_score := 0
var hammer_score := 0


func _ready() -> void:
	sex = randi_range(0,1)
	age = randi_range(0,50)
	aplayer.play("walk")
	aplayer.seek(randf()) 
	Signals.year_passed.connect(on_year_passed)

func _process(delta: float) -> void:
	self.translate(Vector2(randf() - 0.5, randf() - 0.5))
	sprite.region_rect.position.x = 32 + (age / 20) * 32
	sprite.region_rect.position.y = 128 + (sex * 32)

func on_year_passed():
	age += 1
	if age >= max_age:
		queue_free()
