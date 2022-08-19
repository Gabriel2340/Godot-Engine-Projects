extends Node2D



func play_animation():
	$AnimationPlayer.play("move")
	$KinematicBody2D/Color.modulate = Color(1.0, 1.0, 1.0, 1.0)

func play_animation_backwards():
	$AnimationPlayer.play_backwards("move")
	$KinematicBody2D/Color.modulate = Color(0.5, 0.5, 0.5, 1.0)
