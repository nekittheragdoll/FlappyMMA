extends CanvasLayer

var ScoreLabel:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreLabel = get_node("Control/lbl_score")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func UpdateScore(newscore:int) ->void:
	ScoreLabel.text = str(newscore)
