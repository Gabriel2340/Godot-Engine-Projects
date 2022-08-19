extends "res://src/books/book.gd"


func _ready() -> void:
	utility_name = "Charge"


func action(n_map : GridContainer, id : int) -> void:
	var id_troop_name: String = n_map.get_child(id).troop_name
	var combo_value: int = 0
	var parent: = n_map.get_parent()
	parent.save_state()
	# find the combo value first, then make the troops attack
	for i in range(16):
		if not n_map.get_child(i) is Troop:
			continue
		var troop: Troop = n_map.get_child(i)
		if troop.troop_name == id_troop_name:
			troop.current_combo = true
			combo_value += 1
	for i in range(16):
		if not n_map.get_child(i) is Troop:
			continue
		var troop: Troop = n_map.get_child(i)
		if troop.current_combo:
			troop.combo_value = combo_value
			troop.attack(parent.n_buildings_map)
	parent.fill_the_board()
	parent.set_combos_values2()
	parent.next_turn()
	parent.set_combos_values2()
	# after troops attacked, fill the board
	parent.fill_the_board()
	end_of_action()
