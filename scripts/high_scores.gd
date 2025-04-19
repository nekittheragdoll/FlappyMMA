extends Control

var name_theme : Theme
var score_theme : Theme
var layout_preset : LayoutPreset

@onready var score_list : GridContainer = $CenterContainer/score_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_theme = score_list.get_child(0).theme
	score_theme = score_list.get_child(1).theme
	
	for lbl in score_list.get_children():
		lbl.queue_free()
	
	_update_scores()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_scores():
	for i in Global.PlayerScore:
		var name = Label.new()
		name.text = i
		name.theme = name_theme
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		score_list.add_child(name)
		
		var score = Label.new()
		score.text = str(Global.PlayerScore[i])
		score.theme = score_theme
		score.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		score_list.add_child(score)
		
