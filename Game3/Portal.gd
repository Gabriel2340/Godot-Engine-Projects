extends Node2D

export(String) var next_level_path : String

var activated : bool = false



func _on_Area2D_body_entered(body: Node) -> void:
	if activated:
		get_tree().change_scene(next_level_path)
