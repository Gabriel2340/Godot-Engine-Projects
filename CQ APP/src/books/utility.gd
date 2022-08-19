extends Control

class_name Utility

signal selected
signal deselected

onready var image: = $Image
onready var n_animation_player: = $AnimationPlayer

var utility_name: String = ""
var area_action: int

var anim_shoud_stop: bool = false

var last_time: bool = false

var map = [
		[0,  1,  2,  3],
		[4,  5,  6,  7],
		[8,  9,  10, 11],
		[12, 13, 14, 15],
		[16, 17, 18, 19],
		[20, 21, 22, 23]]

enum area {
	BUILDINGS,
	TROOPS
}

func reset_stats() -> void:
	image.rect_position = Vector2(0, 0)
	image.rect_min_size = Vector2(42, 50)
	image.rect_size = Vector2(42, 50)


func _on_Image_toggled(button_pressed: bool) -> void:
	if last_time == button_pressed and last_time == true:
		deselect_button()
		emit_signal("deselected")
		return
	if button_pressed:
		n_animation_player.play("book_pressed")
		emit_signal("selected")
	else:
		deselect_button()
	last_time = button_pressed


func end_of_action() -> void:
	if not get_parent().get_parent().globals["deselect_book/spells_manually"]:
		deselect_button()
		emit_signal("deselected")


func deselect_button() -> void:
	image.pressed = false
	n_animation_player.stop()
	reset_stats()


func is_neighbor(a : int, b : int) -> bool:
	var i = a / 4
	var j = a % 4
	if i > 0:
		if map[i - 1][j] == b:
			return true
	if i < 3:
		if map[i + 1][j] == b:
			return true
	if j > 0:
		if map[i][j - 1] == b:
			return true
	if j < 3:
		if map[i][j + 1] == b:
			return true
	return false

func is_neighbor2(a : int, b : int) -> bool:
	var i = a / 4
	var j = a % 4
	if i > 0:
		if j > 0:
			if map[i - 1][j - 1] == b:
				return true
		if j < 3:
			if map[i - 1][j + 1] == b:
				return true
		if map[i - 1][j] == b:
			return true
	if i < 5:
		if j > 0:
			if map[i + 1][j - 1] == b:
				return true
		if j < 3:
			if map[i + 1][j + 1] == b:
				return true
		if map[i + 1][j] == b:
			return true
	if j > 0:
		if map[i][j - 1] == b:
			return true
	if j < 3:
		if map[i][j + 1] == b:
			return true
	return false
