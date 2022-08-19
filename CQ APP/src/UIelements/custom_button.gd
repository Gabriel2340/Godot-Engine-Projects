extends VBoxContainer


var hover: bool = false
var hover_color: Color = Color(0.5, 0.5, 0.5, 1.0)
var default_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var pressed: bool = false


func _input(event: InputEvent) -> void:
	mouse_pressed(event)
	if mouse_button_down():
		modulate = hover_color
	else:
		modulate = default_color


func mouse_pressed(event : InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		pressed = true
	if event.is_action_released("left_click"):
		pressed = false


func mouse_button_down() -> bool:
	return hover and pressed


func _on_CustomButton_mouse_entered() -> void:
	hover = true


func _on_CustomButton_mouse_exited() -> void:
	hover = false
