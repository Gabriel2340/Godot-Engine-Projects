extends "res://src/books/book.gd"

signal attack

func action(n_map : GridContainer, id : int) -> void:
	var troop: Troop = n_map.get_child(id)
	n_map.get_parent().save_state()
	troop.get_rage(2.0)
	emit_signal("attack", id)
	while id + 4 < 16:
		swap(n_map, id + 4, id)
		id += 4
	end_of_action()
