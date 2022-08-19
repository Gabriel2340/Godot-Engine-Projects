extends Particles2D


func _ready() -> void:
	pass


func _on_Timer_timeout() -> void:
	queue_free()
