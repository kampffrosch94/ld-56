extends Node2D

@onready var aplayer : AnimationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aplayer.play("walk")
	# not everyone should walk in sync
	aplayer.seek(randf()) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.translate(Vector2(randf() - 0.5, randf() - 0.5))
