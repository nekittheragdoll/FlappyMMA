extends Node

var PlayerName : String = "Player"
var LastScore : int = 0;

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
