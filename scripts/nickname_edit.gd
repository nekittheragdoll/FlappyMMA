extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = Global.PlayerName
	text_changed.connect(_update_name)
	

func _update_name(new_text : String):
	Global.PlayerName = new_text
		
