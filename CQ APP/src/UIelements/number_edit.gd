extends LineEdit

signal enter_pressed
signal text_changed2

export(int) var min_range = 0
export(int) var max_range = 0

var is_focused: bool = false

func _on_NumberEdit_text_changed(new_text):
	var integer_text = ""
	
	# add integers from new_text
	for i in range(len(new_text)):
		if new_text[i] >= '0' and new_text[i] <= '9':
			integer_text += new_text[i]
	# restrict integer_text to his min and max range
	if new_text.is_valid_integer():
		integer_text = int(integer_text)
		integer_text = clamp(integer_text, min_range, max_range)
	
	# cursor_pos will be 0 after text assignment
	# save it and set it back after assignment
	var cursor_pos = get_cursor_position()
	text = str(integer_text)
	set_cursor_position(cursor_pos)
	if text != "":
		emit_signal("text_changed2", text)



func _input(event) -> void:
	if is_focused:
		if event.is_action_pressed("enter"):
			emit_signal("enter_pressed")
			release_focus()
		if event.is_action_pressed("left_click"):
			release_focus()


func _on_NumberEdit_focus_entered() -> void:
	is_focused = true


func _on_NumberEdit_focus_exited() -> void:
	is_focused = false
