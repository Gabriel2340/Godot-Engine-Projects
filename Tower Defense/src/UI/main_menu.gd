extends Control

onready var n_credits: = $Credits
onready var n_settings_background = $SettingsBackground

func _on_Credits_pressed() -> void:
	n_credits.visible = true


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://src/UI/LevelsMenu.tscn")
	queue_free()


func _on_SettingsButton_pressed() -> void:
	n_settings_background.visible = true
