extends "res://src/books/book.gd"


func action(n_map : GridContainer, id : int) -> void:
	var id2 : int = id % 4
	n_map.move_child(n_map.get_child(id), id2)
	while id2 < id:
		n_map.move_child(n_map.get_child(id2 + 1), id2 + 4)
		id2 += 4
	end_of_action()
