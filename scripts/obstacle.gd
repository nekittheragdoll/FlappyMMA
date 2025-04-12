extends Area2D

@export var speed : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	
	if position.x < -100:
		queue_free()
		pass
