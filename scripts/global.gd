extends Node

var PlayerName : String = "Player"

var player_skin : Texture2D
var skin_pointer : int = 0

@onready var skins : Array[Texture2D] = [
	preload("res://assets/sprites/chicken_jockey.png"),
	preload("res://assets/sprites/bombardiro_crocodilo.png")
	]

var PlayerScore : Dictionary = {"placeholder" : 1}

func trim_highscores():
	var highscores = PlayerScore
	var entries = []
	
	# Convert to array of dictionaries
	for plr in highscores.keys():
		entries.append({ "name": plr, "score": highscores[plr] })
	
	# Sort descending by score
	entries.sort_custom(func(a, b): return b["score"] - a["score"])
	
	# Keep top 5
	entries = entries.slice(0, 5)
	
	# Convert back to dictionary
	var trimmed = {}
	for entry in entries:
		trimmed[entry["name"]] = entry["score"]
	
	PlayerScore = trimmed
	#return trimmed
