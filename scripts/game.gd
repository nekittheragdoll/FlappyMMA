extends Node2D

var player: CharacterBody2D
var obstacle_scene: Resource

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


func _spawn_obstacle() -> void:
	var obstacle_bot = _obstacle_creator(obstacle_scene, Vector2(800,900))
	var obstacle_top = _obstacle_creator(obstacle_scene, Vector2(800,0))
	add_child(obstacle_top)
	add_child(obstacle_bot)
	
	
func _obstacle_creator(obstacle_scene:Resource, position: Vector2) -> Area2D:
	var obstacle:Area2D = obstacle_scene.instantiate()
	obstacle.position = position
	obstacle.body_entered.connect(_on_obstacle_hit)
	return obstacle
