extends ColorRect

onready var n_sounds_x: = $SettingsMenu/Sonor/SoundsEffectButton/x
onready var n_music_x: = $SettingsMenu/Sonor/MusicButton/x


func _on_SettingsBackground_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if not event.pressed:
				visible = false


func _on_SoundsEffectButton_pressed() -> void:
	n_sounds_x.visible = not n_sounds_x.visible


func _on_MusicButton_pressed() -> void:
	n_music_x.visible = not n_music_x.visible
