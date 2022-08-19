extends Node2D

var player_is_inside : bool = false


func _on_Area2D_body_entered(body):
	$AnimationPlayer.play("Open")


func _on_Area2D_body_exited(body):
	player_is_inside = false
	$AnimationPlayer.play_backwards("Open")


func player_gets_inside():
	player_is_inside = true
	
