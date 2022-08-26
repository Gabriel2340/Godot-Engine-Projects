extends StaticBody2D

var player_inside = false
var player

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("down") and player_inside:
		$CollisionShape2D.set_deferred("disabled", true)
		player.motion.y += 70




func _on_Area2D_body_entered(body: Node) -> void:
	player_inside = true
	player = body


func _on_Area2D_body_exited(body: Node) -> void:
	player_inside = false
	$CollisionShape2D.set_deferred("disabled", false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	print("free platform")
	queue_free()
