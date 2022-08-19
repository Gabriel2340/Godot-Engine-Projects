extends "res://src/Players/Player.gd"

var player_name = "water"


func _ready():
	Key = {
	UP = "up2",
	LEFT = "left2",
	RIGHT = "right2"
}


func die():
	queue_free()
