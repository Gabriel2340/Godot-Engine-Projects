extends Node2D



func _on_Area2D_body_entered(body: Node) -> void:
	body.hp += 1
	$AnimationPlayer.play("dissapear")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
