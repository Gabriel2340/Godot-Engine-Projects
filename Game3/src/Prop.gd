extends Node2D


func _ready() -> void:
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	action(body)
	queue_free()


func action(body : Node) -> void:
	pass
