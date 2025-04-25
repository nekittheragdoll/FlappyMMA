extends Node2D

@export var speed = 200
var TopPart:Area2D
var BottomPart:Area2D
var rng=RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TopPart = get_node("TopPart")
	BottomPart = get_node("BottomPart")

	var offset = rng.randi_range(-32,32)*10
	TopPart.position.y += offset
	BottomPart.position.y += offset
	
	var distance = rng.randi_range(-3,3) * 10
	TopPart.position.y += distance
	BottomPart.position.y -= distance
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	
	if position.x < -500:
		queue_free()
		pass
