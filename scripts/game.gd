extends Node2D

@export var player: CharacterBody2D
@export var obstacle_scene: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	obstacle_scene = preload("res://scenes/obstacle.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func _on_obstacle_hit(body: Node2D) -> void:
	if (body == player):
		get_tree().paused = true

func _on_greenline_touch(body: Node2D) -> void:
	print("PASSED")


func _spawn_obstacle() -> void:
	var obstacle = _obstacle_creator(obstacle_scene, 900)
	add_child(obstacle)
	
	
func _obstacle_creator(obstacle_scene:Resource, position: int) -> Area2D:
	var obstacle:Node2D = obstacle_scene.instantiate()
	obstacle.position.x = position
	for part in obstacle.get_children():
		if part is not Area2D:continue
		if part.name == "TopPart" or part.name == "BottomPart":
			part.body_entered.connect(_on_obstacle_hit)
		else:
			part.body_entered.connect(_on_greenline_touch)
	
	#obstacle.body_entered.connect(_on_obstacle_hit)
	
	return obstacle
