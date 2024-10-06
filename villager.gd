extends Area2D
class_name Villager

var age: int = 0
var max_age := 60
var sex: int = 0

const male = 0
const female = 1

@onready var aplayer : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var radar: Area2D = $Radar
@onready var nav: NavigationAgent2D = $NavigationAgent2D


var axe_score := 0
var maw_score := 0
var ankh_score := 0
var hammer_score := 0

var spouse: Villager = null

enum State {
	Idle,
	# going to wife
	Marriage
}

# what is the villager doing right now
var state = State.Idle

func _ready() -> void:
	sex = randi_range(0,1)
	#age = randi_range(0,50)
	aplayer.play("walk")
	aplayer.seek(randf()) 
	Signals.year_passed.connect(on_year_passed)
	sprite.region_rect.position.x = 32 + (age / 20) * 32
	sprite.region_rect.position.y = 128 + (sex * 32)

func on_year_passed():
	age += 1
	if age >= max_age:
		queue_free()
		return
	sprite.region_rect.position.x = 32 + (age / 20) * 32
	sprite.region_rect.position.y = 128 + (sex * 32)
	if age >= 20 and age <= 40 and sex == male and spouse == null:
		for area in radar.get_overlapping_areas():
			if area.is_in_group("villager") and area.sex == female and area.spouse == null and area.age >= 20 and area.age <= 40:
				print("Found wife")
				var wife := area as Villager
				spouse = wife
				wife.spouse = self
				nav.target_position = wife.position
				nav.navigation_finished.connect(build_home, CONNECT_ONE_SHOT)
				state = State.Marriage
				return

var change_direction_timer = 2.0
var drift_direction = Vector2(0,0)

func _physics_process(delta: float) -> void:
	if state == State.Idle:
		change_direction_timer += delta
		if change_direction_timer > 2:
			drift_direction = Vector2(randf() - 0.5, randf() - 0.5)
			change_direction_timer = 0
		self.translate(drift_direction * delta * 30)
	if state != State.Idle:
		var dir = (nav.get_next_path_position() - global_position).normalized()
		translate(dir * delta * 150 )

var house_scene = preload("res://house.tscn")

func build_home():
	state = State.Idle
	var house: House = house_scene.instantiate()
	house.global_position = global_position
	house.pop = self
	house.mom = spouse
	add_sibling(house)
