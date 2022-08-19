extends Control


func _ready() -> void:
	visible = true
	$AnimationPlayer.play("start_app")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		queue_free()
