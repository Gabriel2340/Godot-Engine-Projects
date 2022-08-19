extends "res://src/spells/spell.gd"



func _ready():
	spell_stats = [
		{"damage" : 80},
		{"damage" : 92},
		{"damage" : 106},
		{"damage" : 122},
		{"damage" : 140},
		{"damage" : 161},
		{"damage" : 185},
		{"damage" : 213},
		{"damage" : 245},
		{"damage" : 282}
	]
	damage = spell_stats[level - 1]["damage"]
	

func action(n_buildings_map : GridContainer, id : int):
	#var lane: int = id % 4
	#var collumn: int = id / 4
	# TODO: for loop...
	if is_neighbor2(id, id - 4):
		if n_buildings_map.get_child(id - 4) is Building:
			deal_damage(n_buildings_map.get_child(id - 4))
	if is_neighbor2(id, id - 3):
		if n_buildings_map.get_child(id - 3) is Building:
			deal_damage(n_buildings_map.get_child(id - 3))
	if is_neighbor2(id, id - 1):
		if n_buildings_map.get_child(id - 1) is Building:
			deal_damage(n_buildings_map.get_child(id - 1))
	if is_neighbor2(id, id - 5):
		if n_buildings_map.get_child(id - 5) is Building:
			deal_damage(n_buildings_map.get_child(id - 5))
	if is_neighbor2(id, id + 4):
		if n_buildings_map.get_child(id + 4) is Building:
			deal_damage(n_buildings_map.get_child(id + 4))
	if is_neighbor2(id, id + 3):
		if n_buildings_map.get_child(id + 3) is Building:
			deal_damage(n_buildings_map.get_child(id + 3))
	if is_neighbor2(id, id + 1):
		if n_buildings_map.get_child(id + 1) is Building:
			deal_damage(n_buildings_map.get_child(id + 1))
	if is_neighbor2(id, id + 5):
		if n_buildings_map.get_child(id + 5) is Building:
			deal_damage(n_buildings_map.get_child(id + 5))
	if n_buildings_map.get_child(id) is Building:
		deal_damage(n_buildings_map.get_child(id))
	end_of_action()
