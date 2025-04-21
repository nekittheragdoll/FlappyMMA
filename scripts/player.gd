extends CharacterBody2D

const GRAVITY = 2000
const JUMP_STRENGTH = 700

@onready var sprite = $Sprite2D

var is_frozen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_skin_adjust()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_frozen:
		return
	
	if (Input.is_action_just_pressed("jump")):
		velocity.y = JUMP_STRENGTH * -1
		$flap_sound.playing = true
	
	velocity.y += GRAVITY * delta;
	position += velocity * delta
	
	
	sprite.rotation_degrees = (velocity.y/JUMP_STRENGTH) * 30 if sprite.rotation_degrees < 90 else 90
	
func _skin_adjust():
	sprite.texture = Global.skins[Global.skin_pointer]
	sprite.scale = Vector2(1,1)
	match Global.skin_pointer:
		0: sprite.scale = Vector2(0.5,0.5)
	
	
