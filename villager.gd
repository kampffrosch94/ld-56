extends CharacterBody2D
class_name Villager

@export var age: int = 0
var max_age := 60
@export var sex: int = -1

const male = 0
const female = 1

var hp = 100

@onready var aplayer : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var radar: Area2D = $Radar
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sinLabel := $SinLabel
# ideology scores
@export var score = {
	Global.Ideology.Ankh: 0,
	Global.Ideology.Axe: 0,
	Global.Ideology.Hammer: 0,
	Global.Ideology.Maw: 0,
}

var spouse: Villager = null
var ideology: Global.Ideology = Global.Ideology.Ankh

enum State {
	Idle,
	# going to wife
	Marriage,
	# going to fight someone
	Hate,
	# fighting someone
	Fight,
}

# what is the villager doing right now
var state = State.Idle

func _ready() -> void:
	if sex == -1: #unset
		sex = randi_range(0,1)
	#age = randi_range(0,50)
	aplayer.play("walk")
	aplayer.seek(randf()) 
	Signals.year_passed.connect(on_year_passed)
	sprite.region_rect.position.x = 32 + (age / 20) * 32
	sprite.region_rect.position.y = 128 + (sex * 32)

func effective_sin() -> int:
	if sins > 0:
		if ideology == Global.Ideology.Maw:
			return sins
		else:
			return 1
	return 0

func _process(_delta: float) -> void:
	if sins > 0:
		sinLabel.visible = true
		sinLabel.text = str(effective_sin())

func on_year_passed():
	age += 1
	if age >= max_age:
		die()
		return
	sprite.region_rect.position.x = 32 + (age / 20) * 32
	sprite.region_rect.position.y = 128 + (sex * 32)
	
	for key in score.keys():
		score[key] = maxi(0, score[key] - 2)
	
	var material: ShaderMaterial = sprite.material
	ideology = current_ideology()
	var clr : Color = Global.get_color(ideology)
	if score[ideology] >= 5:
		material.set_shader_parameter("shirt_color", clr)
	else:
		material.set_shader_parameter("shirt_color", Color.WHITE)
	
	# find wife if you don't have one
	if age >= 20 and age <= 40 and sex == male and spouse == null:
		for area in radar.get_overlapping_bodies():
			if area.is_in_group("villager") and area.sex == female and area.spouse == null and area.age >= 20 and area.age <= 40 and not Global.is_enemy(current_ideology(), area.current_ideology()):
				print("Found wife")
				var wife := area as Villager
				spouse = wife
				wife.spouse = self
				nav.target_position = wife.position
				nav.navigation_finished.connect(build_home, CONNECT_ONE_SHOT)
				state = State.Marriage
				return
	
	# find target to fight
	if state == State.Idle and score[ideology] > 20:
		for body in radar.get_overlapping_bodies():
			if body.is_in_group("villager"):
				var other: Villager = body as Villager
				if Global.is_enemy(ideology, other.ideology):
					state = State.Hate
					target = other
					nav.target_position = other.position
	
	if state == State.Idle:
		aplayer.play("walk")


var change_direction_timer = 102.0
var drift_direction = Vector2(0,0)

var fight_timer := 1.0
var sins: int = 0

func _physics_process(delta: float) -> void:
	if state == State.Idle:
		change_direction_timer += delta
		if change_direction_timer > 3:
			drift_direction = Vector2(randf() - 0.5, randf() - 0.5)
			change_direction_timer = 0
		#self.translate(drift_direction * delta * 30)
		self.velocity = drift_direction * 50
		move_and_slide()
	if state == State.Marriage:
		var dir = (nav.get_next_path_position() - global_position).normalized()
		self.velocity = dir *  150
		move_and_slide()
	if state == State.Hate:
		var dir = (nav.get_next_path_position() - global_position).normalized()
		self.velocity = dir *  150
		move_and_slide()
	if state == State.Fight:
		if target == null:
			state = State.Idle
			return
		if position.distance_to(target.position) > 50:
			nav.target_position = target.position
			state = State.Hate
			return
		fight_timer += delta
		if fight_timer >= 1.0:
			fight_timer = 0.0
			var killed = target.take_damage(20) # TODO change for fanatics
			if killed:
				sins += 1



var house_scene = preload("res://house.tscn")

func build_home():
	state = State.Idle
	var house: House = house_scene.instantiate()
	house.global_position = global_position
	house.pop = self
	house.mom = spouse
	add_sibling(house)

func current_ideology() -> Global.Ideology:
	var current = null
	for key in score.keys():
		if current == null:
			current = key
		else:
			if score[key] > score[current]:
				current = key
	return current


var target: Villager = null


## true if villager gets killed
func take_damage(amount: int) -> bool:
	hp -= amount
	if hp <= 0:
		die()
		return true
	else:
		aplayer.play("damage")
	return false


func _on_fight_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("villager"):
		var other: Villager = body as Villager
		if score[ideology] > 20 and Global.is_enemy(ideology, other.ideology):
			state = State.Fight
			target = other

func die():
	Signals.souls_collected += effective_sin()
	# TODO grave stone
	queue_free()
