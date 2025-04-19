extends Node

@onready var sc_main_menu : PackedScene = preload("res://scenes/main_menu.tscn")
@onready var sc_game : PackedScene = preload("res://scenes/game.tscn")

var active_scene : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _load_game():
	if active_scene != null: active_scene.queue_free()
	active_scene = sc_game.instantiate()
	active_scene.game_ended.connect(_load_menu)
	active_scene.reload_request.connect(_load_game)
	$GameScenes.add_child(active_scene)

func _load_menu():
	if active_scene != null: active_scene.queue_free()
	active_scene = sc_main_menu.instantiate()
	active_scene.start_game.connect(_load_game)
	$GameScenes.add_child(active_scene)
