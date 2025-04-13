extends Node2D

@export var speed : float = 100
var TopPart:Area2D
var BottomPart:Area2D
var rng=RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TopPart = get_node("TopPart")
	BottomPart = get_node("BottomPart")

	TopPart.position.y -= rng.randi_range(-20,200)
	BottomPart.position.y += rng.randi_range(-20,200)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	
	if position.x < -500:
		queue_free()
		pass
