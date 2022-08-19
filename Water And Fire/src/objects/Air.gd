extends Node2D


var bodies = []


func _on_Area2D_body_entered(body):
	bodies.append(body)


func _on_Area2D_body_exited(body):
	bodies.erase(body)


func _process(delta):
	for body in bodies:
		if body.motion.y > 0:
			body.motion.y -= 15
		elif body.motion.y < 0:
			body.motion.y = -12
		var a = global_position.y - body.global_position.y
		# length of the shape + the base
		var b = ($Area2D/AirArea.shape.extents.y * 2 + 30)
		
		body.position.y -= (((b - a) / b) * 220 + 100 - body.motion.y) * delta
		
