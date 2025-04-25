extends Node2D

@export var player: CharacterBody2D
@export var obstacle_scene: Resource
var menu_pause : Control
@onready var game_over_menu : Control = $HUD/GameOverMenu

var obst_cnt = 0
var obst_speed = 0
var Score: int = 0
var HUD : CanvasLayer


enum State{START,PLAY,PAUSED,GAMEOVER}
var current_state
var next_state = State.START

signal game_ended
signal reload_request

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HUD = get_node("HUD")
	menu_pause = get_node("HUD/PauseMenu")
	player = get_node("Player")
	obstacle_scene = preload("res://scenes/obstacle.tscn")
	$HUD/PauseMenu/MenuItems/btn_quit.pressed.connect(func(): emit_signal("game_ended"))
	$HUD/GameOverMenu/CenterContainer/VBoxContainer/btn_restart.pressed.connect(func(): emit_signal("reload_request"))
	$HUD/GameOverMenu/CenterContainer/VBoxContainer/btn_quit.pressed.connect(func(): emit_signal("game_ended"))
	
	menu_pause.visible = false
	get_tree().paused = true
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if next_state != current_state:
		current_state = next_state
		_change_state()
	if (current_state == State.START and Input.is_action_just_pressed("jump")):
		next_state = State.PLAY
	
	
	if menu_pause.visible:
		menu_pause.mouse_filter = Control.MOUSE_FILTER_STOP
		menu_pause.focus_mode = Control.FOCUS_ALL
	else:
		menu_pause.mouse_filter = Control.MOUSE_FILTER_IGNORE
		menu_pause.focus_mode = Control.FOCUS_NONE
	
	if game_over_menu.visible:
		game_over_menu.mouse_filter = Control.MOUSE_FILTER_STOP
		game_over_menu.focus_mode = Control.FOCUS_ALL
	else:
		game_over_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
		game_over_menu.focus_mode = Control.FOCUS_NONE
		
		
func _change_state():
	match current_state:
		State.START:
			get_tree().paused = true
			menu_pause.visible = false
			game_over_menu.visible = false
		State.PLAY:
			get_tree().paused = false
			menu_pause.visible = false
			game_over_menu.visible = false
		State.PAUSED:
			get_tree().paused = true
			game_over_menu.visible = false
			menu_pause.visible = true
		State.GAMEOVER:
			$ded_sound.playing = true
			add_score()
			game_over_menu.visible = true
			menu_pause.visible = false
			get_tree().paused = true
			#emit_signal("game_ended")

func _on_obstacle_hit(body: Node2D) -> void:
	if (body == player):
		next_state = State.GAMEOVER

func _on_greenline_touch(body: Node2D) -> void:
	$score_sound.playing = true
	Score += 1
	HUD.UpdateScore(Score)


func _spawn_obstacle() -> void:
	var obstacle = _obstacle_creator(obstacle_scene, 900)
	obst_cnt += 1
	if obst_cnt > 5:
		$Spawn_Timer.paused = true
		if $Spawn_Timer.wait_time > 2:
			$Spawn_Timer.wait_time -= 0.5
		await get_tree().create_timer(1).timeout
		
		obst_speed+=1
		obst_cnt = 1
		$Spawn_Timer.paused = false
		print("INCREASE")
	obstacle.speed += obst_speed*50
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

func add_score():
	if (Global.PlayerScore.has(Global.PlayerName) and Global.PlayerScore[Global.PlayerName] >= Score): return
	else: Global.PlayerScore[Global.PlayerName] = Score
	
