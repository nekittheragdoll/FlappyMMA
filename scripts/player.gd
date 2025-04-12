extends CharacterBody2D

const GRAVITY = 2000
const JUMP_STRENGTH = 700

var is_frozen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_frozen:
		return
	
	if (Input.is_action_just_pressed("jump")):
		velocity.y = JUMP_STRENGTH * -1
	
	velocity.y += GRAVITY * delta;
	position += velocity * delta
	
	
