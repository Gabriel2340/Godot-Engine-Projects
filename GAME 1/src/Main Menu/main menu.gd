extends Control


func _ready() -> void:
	pass


func _on_Button_pressed() -> void:
	queue_free()
	get_tree().change_scene("res://src/World/World.tscn")


func _on_SettingsButton_pressed() -> void:
	$VBoxContainer.visible = false
	$Settings.visible = true


func _on_GoBackButton2_pressed() -> void:
	$Settings.visible = false
	$VBoxContainer.visible = true
