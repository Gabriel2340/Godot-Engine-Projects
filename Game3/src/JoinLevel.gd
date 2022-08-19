extends Node2D

export(String) var level_path : String
export(int) var level_value : int


func _ready() -> void:
	$Level.text = "level " + str(level_value)


func _on_Area2D_body_entered(body: Node) -> void:
	get_tree().change_scene(level_path)
