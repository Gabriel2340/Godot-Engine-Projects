extends Control


func _ready() -> void:
	pass


func _on_troop_selected(troop_count, index: int) -> void:
	get_child(index - 1).text = str(troop_count)
	get_child((4 - index) * 2 + 5).visible = false


func _on_selecting_a_troop(index: int) -> void:
	get_child((4 - index) * 2 + 5).visible = true


func get_troops_index():
	var troops_index = []
	for i in range(1, 5):
		troops_index.append(get_node("TroopOption" + str(i)).current_troop)
	return troops_index
