extends Node2D



func _on_Lever_turned_on():
	$MovingPlatform.play_animation()


func _on_Lever_turned_off():
	$MovingPlatform.play_animation_backwards()
