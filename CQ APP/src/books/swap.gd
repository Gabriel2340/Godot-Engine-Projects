extends "res://src/books/book.gd"

var id1: int = -1


func action(n_map : GridContainer, id : int) -> void:
	if id1 == -1:
		id1 = id
		return
	else:
		if is_neighbor(id, id1):
			swap(n_map, id, id1)
		id1 = -1
	end_of_action()
