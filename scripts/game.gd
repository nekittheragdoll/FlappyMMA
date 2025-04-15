extends Node2D

@export var player: CharacterBody2D
@export var obstacle_scene: Resource

var Score: int = 0;
var HUD : CanvasLayer

enum State{START,PLAY,GAMEOVER}
var current_state = State.START

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HUD = get_node("HUD")
	player = get_node("Player")
	obstacle_scene = preload("res://scenes/obstacle.tscn")
	#get_tree().paused = true
	
func _input(event: InputEvent) -> void:
	if (current_state == State.START and Input.is_action_just_pressed("jump")):
		print("wtf")
		current_state = State.PLAY
		get_tree().paused = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
		

func _on_obstacle_hit(body: Node2D) -> void:
	if (body == player):
		get_tree().paused = true

func _on_greenline_touch(body: Node2D) -> void:
	Score += 1
	HUD.UpdateScore(Score)


func _spawn_obstacle() -> void:
	var obstacle = _obstacle_creator(obstacle_scene, 900)
	add_child(obstacle)
	
	
func _obstacle_creator(obstacle_scene:Resource, position: int) -> Area2D:
	var obstacle:Node2D = obstacle_scene.instantiate()
	obstacle.process_mode = Node.PROCESS_MODE_PAUSABLE
	obstacle.position.x = position
	for part in obstacle.get_children():
		if part is not Area2D:continue
		if part.name == "TopPart" or part.name == "BottomPart":
			part.body_entered.connect(_on_obstacle_hit)
		else:
			part.body_entered.connect(_on_greenline_touch)
	
	#obstacle.body_entered.connect(_on_obstacle_hit)
	
	return obstacle
