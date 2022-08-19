extends "res://src/Players/Player.gd"

var player_name = "fire"

func die():
	queue_free()
