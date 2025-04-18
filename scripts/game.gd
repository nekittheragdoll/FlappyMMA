extends Node2D

@export var player: CharacterBody2D
@export var obstacle_scene: Resource
var menu_pause : Control

var Score: int = 0;
var HUD : CanvasLayer


enum State{START,PLAY,PAUSED,GAMEOVER}
var current_state = State.START
var next_state = current_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HUD = get_node("HUD")
	menu_pause = get_node("HUD/PauseMenu")
	player = get_node("Player")
	obstacle_scene = preload("res://scenes/obstacle.tscn")
	
	
	menu_pause.visible = false
	get_tree().paused = true
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_state = next_state
	if (current_state == State.START and Input.is_action_just_pressed("jump")):
		next_state = State.PLAY
	
	match current_state:
		State.START:
			get_tree().paused = true
			menu_pause.visible = false
		State.PLAY:
			get_tree().paused = false
			menu_pause.visible = false
		State.PAUSED:
			get_tree().paused = true
			menu_pause.visible = true
		State.GAMEOVER:
			get_tree().paused = true
			menu_pause.visible = false
			get_tree().reload_current_scene()
	
	if menu_pause.visible:
		menu_pause.mouse_filter = Control.MOUSE_FILTER_STOP
		menu_pause.focus_mode = Control.FOCUS_ALL
	else:
		menu_pause.mouse_filter = Control.MOUSE_FILTER_IGNORE
		menu_pause.focus_mode = Control.FOCUS_NONE
			
		

func _on_obstacle_hit(body: Node2D) -> void:
	if (body == player):
		next_state = State.GAMEOVER

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
	
func _pause_the_game():
	if (current_state == State.PLAY):
		next_state = State.PAUSED
		
func _continue_the_game():
	if (current_state == State.PAUSED):
		next_state = State.PLAY
