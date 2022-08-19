extends Node2D

signal turned_on
signal turned_off

var fire_inside = false
var water_inside = false
var water = null
var fire = null
var on = false

func _on_Area2D_body_entered(body):
	if body.player_name == "fire":
		fire_inside = true
		fire = body
	else:
		water_inside = true
		water = body


func _on_Area2D_body_exited(body):
	if body.player_name == "fire":
		fire_inside = false
	else:
		water_inside = false


func _process(delta):
	var distance = 0.0
	if fire_inside:
		distance = (fire.global_position - global_position).length()
	if water_inside:
		if distance == 0.0:
			distance = (water.global_position - global_position).length()
		else:
			distance = min((water.global_position - global_position).length(), distance)
	
	if distance != 0.0:
		if distance < 20:
			if not on:
				on = true
				emit_signal("turned_on")
		$Sprite.position.y = (25 - clamp(distance, 0, 25))
	else:
		if on:
			on = false
			emit_signal("turned_off")
		$Sprite.position.y = 0
	
