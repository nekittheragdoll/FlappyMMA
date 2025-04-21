extends Node

@onready var sc_main_menu : PackedScene = preload("res://scenes/main_menu.tscn")
@onready var sc_game : PackedScene = preload("res://scenes/game.tscn")

var active_scene : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_highscore()
	_load_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _load_game():
	if active_scene != null: active_scene.queue_free()
	active_scene = sc_game.instantiate()
	active_scene.game_ended.connect(_load_menu)
	active_scene.game_ended.connect(save_highscore)
	active_scene.reload_request.connect(_load_game)
	$GameScenes.add_child(active_scene)

func _load_menu():
	Global.trim_highscores()
	if active_scene != null: active_scene.queue_free()
	active_scene = sc_main_menu.instantiate()
	active_scene.start_game.connect(_load_game)
	$GameScenes.add_child(active_scene)

const SAVE_PATH = "user://highscore.json"
const seed = "fhae4io23fxg45u4308k"  # Patriku, nedelej to! >:(

func save_highscore() -> void:
	if not OS.has_feature("android"): return
	
	var json_string = JSON.stringify(Global.PlayerScore)
	
	var save_file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, seed)
	save_file.store_string(json_string)
	save_file.close()
	#print("SAVED")

func load_highscore() -> void:
	if not OS.has_feature("android"): return
	
	if not FileAccess.file_exists(SAVE_PATH): return
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.READ, seed)
	if file == null: return
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	if data == null: return
	
	Global.PlayerScore = _fix_scores(data)

func _fix_scores(data : Dictionary):
	for i in data:
		data[i] = int(data[i])
	return data
	
func _http_submit():
	var url = "https://webhook.site/"
	var headers = ["Content-Type: application/json"]
	var json_body = JSON.stringify(Global.PlayerScore)
	
	$HTTPRequest.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		json_body,
	)
	
	


func _on_btn_mute_toggled() -> void:
	if $sound_canvas/btn_sound.button_pressed:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
