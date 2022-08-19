extends Control

onready var n_levels: = $Levels

var current_lvl: int = 5

func _ready() -> void:
	init_level_buttons()

func init_level_buttons() -> void:
	var i: int = 0
	var limit: int = current_lvl
	while i < limit:
		var child: = n_levels.get_child(i)
		if child is VBoxContainer:
			child.n_level.disabled = false
			child.n_level.connect("pressed", self, "on_level_button_pressed", [child.n_level.text])
		else:
			limit += 1
		i += 1

func on_level_button_pressed(lvl) -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/Levels/Level" + lvl + ".tscn")
	queue_free()


func _on_GoBackButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/UI/MainMenu.tscn")
	queue_free()
