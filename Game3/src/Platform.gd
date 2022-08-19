extends KinematicBody2D


var relative_position : int = 0
var min_range : int = -100
var max_range : int = 100
var direction = 1
var speed = 1

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# change direction when it reaches the limit
	if relative_position >= max_range or relative_position <= min_range:
		direction *= -1
	position.x += speed * direction
	relative_position += speed * direction
