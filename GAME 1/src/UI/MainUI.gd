extends Control

onready var heart_value: = $Heart/Value

signal restart_level

var time : int = 0

func _ready() -> void:
	pass


func _on_Timer_timeout() -> void:
	time += 1
	var a : String = str(time % 60)
	if len(a) == 1:
		a = "0" + a
	$Heart/Time.text = str(time / 60) + ":" + a


func lose_lifes(value : int) -> void:
	heart_value.text = str(int(heart_value.text) - value)
	if int(heart_value.text) <= 0:
		lose()

func lose() -> void:
	get_tree().paused = true
	$LoseContainer.visible = true

func win() -> void:
	get_tree().paused = true
	$WinContainer.visible = true


func _on_TryAgainButton_pressed() -> void:
	$LoseContainer.visible = false
	$WinContainer.visible = false
	get_tree().paused = false
	heart_value.text = "30"
	time = 0
	emit_signal("restart_level")
	

func _on_MainMenuButton_pressed() -> void:
	get_tree().paused = false
	queue_free()
	get_tree().change_scene("res://src/Main Menu/Main Menu.tscn")
