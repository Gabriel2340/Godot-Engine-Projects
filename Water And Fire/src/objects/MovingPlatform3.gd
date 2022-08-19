extends Node2D

var is_on = false


func _on_Button_turned_off():
	if not $Button.on and not $Button2.on:
		$MovingPlatform.play_animation_backwards()
		is_on = false


func _on_Button_turned_on():
	if not is_on:
		$MovingPlatform.play_animation()
		is_on = true
