extends Node2D


var water_inside = false
var fire_inside = false
var camera_is_moved = false

func _on_Area2D_body_entered(body):
	if body.player_name == "fire":
		fire_inside = true
	else:
		water_inside = true
	if fire_inside and water_inside:
		if not camera_is_moved:
			$AnimationPlayer.play("CameraMove")
			camera_is_moved = true

func _on_Area2D_body_exited(body):
	if body.player_name == "fire":
		fire_inside = false
	else:
		water_inside = false
	if not fire_inside and  not water_inside:
		if camera_is_moved:
			$AnimationPlayer.play_backwards("CameraMove")
			camera_is_moved = false
	
