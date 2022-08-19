extends "res://src/books/book.gd"


func action(n_map : GridContainer, id : int) -> void:
	while id + 4 < 16:
		swap(n_map, id + 4, id)
		id += 4
	var troop: Troop = n_map.get_child(id)
	troop.emit_signal("troop_deleted", troop.get_index())
	end_of_action()
