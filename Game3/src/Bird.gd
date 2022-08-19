extends Node2D

signal enemy_died

var dead = false

func _ready() -> void:
	$AnimationPlayer.playback_speed *= rand_range(0.4, 1.0)
	$KinematicBody2D/PlayerDetector


func _on_PlayerDetector_body_entered(body: Node) -> void:
	# if is the player
	if body.has_method("_on_EnemyDetector_body_entered") and body.motion.y > 0:
		emit_signal("enemy_died")
		$KinematicBody2D.dead = true
		body.motion.y = -450
		queue_free()
