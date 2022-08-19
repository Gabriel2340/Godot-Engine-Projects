extends Control


#signal create_troop
#signal delete_troop
#signal create_building
#signal delete_building
signal change_map 

var max_items: int = 100
var current_item: int = -1
var data: Array = []
var save: bool = true

func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("redo"):
		redo()
	elif event.is_action_pressed("undo"):
		undo()


func undo() -> void:
	if save:
		get_parent().save_state(true)
		save = false
	if current_item - 1 == -1:
		return
	current_item -= 1
	if data[current_item][0] == "turn passed":
		emit_signal("change_map", data[current_item][1])


func redo() -> void:
	if current_item + 1 >= len(data):
		return
	current_item += 1
	if data[current_item][0] == "turn passed":
		emit_signal("change_map", data[current_item][1])


func remove_from(start : int) -> void:
	for _i in range(start + 1, len(data)):
		data.pop_back()


func remove_last(nr_of_elements : int) -> void:
	for _i in range(len(data) - nr_of_elements, len(data)):
		data.pop_back()


func action(name : String, value : Array, on_undo_or_redo = false) -> void:
	if not on_undo_or_redo:
		remove_from(current_item)
		save = true
	data.append([name, value])
	current_item = len(data) - 1


func _on_SmartPhoneButton_pressed() -> void:
	undo()


func _on_RedoButton_pressed() -> void:
	redo()
