extends Node2D

var player_in : bool = false
var current_portal : int = 0
var player

func _input(event):
	if event.is_action_pressed("space"):
		if player_in:
			player.global_position = get_node("Teleport" + str(current_portal)).global_position




func _on_Area2D_body_entered(body, portal_index):
	player = body
	player_in = true
	current_portal = portal_index


func _on_Area2D_body_exited(body):
	player_in = false
