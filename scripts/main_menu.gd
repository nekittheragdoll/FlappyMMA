extends CanvasLayer

@onready var tween : Tween = create_tween()

@onready var active_menu : Control = get_node("Menu")

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Menu/VBoxContainer/btn_play.pressed.connect(func(): emit_signal("start_game"))
	
	for c in get_children():
		c.position.x = -720
	tween.tween_property($Menu, "position:x", 0,0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_btn_back_pressed() -> void:
	if (active_menu == $Menu): return
	_slide_out(active_menu)
	active_menu = $Menu
	await _slide_in(active_menu)


func _on_btn_settings_pressed() -> void:
	_slide_out(active_menu)
	active_menu = $Settings
	await _slide_in(active_menu)

func _on_btn_highscores_pressed() -> void:
	_slide_out(active_menu)
	active_menu = $HighScores
	await _slide_in(active_menu)


func _slide_in(node: Node):
	tween = create_tween()
	tween.tween_property(node, "position:x", 0,0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	

func _slide_out(node: Node):
	tween = create_tween()
	tween.tween_property(node, "position:x", -720,0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	
