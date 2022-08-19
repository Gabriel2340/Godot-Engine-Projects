extends Control


onready var n_settings_background: = $SettingsBackground
onready var n_pause_button: = $PauseButton

onready var pause_false_texture: Texture = preload("res://assets/textures/pause_false.png")
onready var pause_true_texture: Texture = preload("res://assets/textures/pause_true.png")

func _on_PauseButton_pressed() -> void:
	n_settings_background.visible = true
	n_pause_button.icon = pause_true_texture
	get_tree().paused = true

func _on_SettingsBackground_hide() -> void:
	n_pause_button.icon = pause_false_texture
	get_tree().paused = false
