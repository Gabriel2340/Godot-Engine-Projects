extends "res://src/spells/spell.gd"


func _ready():
	spell_stats = [
		{"damage" : 90},
		{"damage" : 104},
		{"damage" : 120},
		{"damage" : 138},
		{"damage" : 159},
		{"damage" : 183},
		{"damage" : 210},
		{"damage" : 242},
		{"damage" : 278},
		{"damage" : 320}
	]
	damage = spell_stats[level - 1]["damage"]
	

func action(n_buildings_map : GridContainer, id : int):
	var row : int = id / 4
	var collumn : int = id % 4
	var current_id : int = 0
	for i in range(4):
		if i != collumn:
			current_id = row * 4 + i
			if n_buildings_map.get_child(current_id) is Building:
				deal_damage(n_buildings_map.get_child(current_id))
	for i in range(6):
		current_id = i*4 + collumn
		if n_buildings_map.get_child(current_id) is Building:
			deal_damage(n_buildings_map.get_child(current_id))
	end_of_action()
