extends Node2D

signal turned_on
signal turned_off


onready var n_left_limit = $LeftLimit
onready var n_right_limit = $RightLimit

var on = false


func _ready():
	$Lever.apply_central_impulse(Vector2(-100, 0))


func _on_Lever_body_entered(body):
	if n_left_limit == body:
		if on:
			on = false
			emit_signal("turned_off")
	if n_right_limit == body:
		if not on:
			on = true
			emit_signal("turned_on")

