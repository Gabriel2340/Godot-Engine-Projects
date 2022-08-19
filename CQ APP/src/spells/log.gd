extends "res://src/spells/spell.gd"


func _ready():
	spell_stats = [
		{"damage" : 100},
		{"damage" : 115},
		{"damage" : 132},
		{"damage" : 152},
		{"damage" : 175},
		{"damage" : 201},
		{"damage" : 231},
		{"damage" : 266},
		{"damage" : 306},
		{"damage" : 352}
	]
	damage = spell_stats[level - 1]["damage"]


func action(n_buildings_map : GridContainer, id : int):
	var lane: int = id % 4
	for i in range(6 - (23 - id) / 4):
		if n_buildings_map.get_child(lane + i * 4) is Building:
			deal_damage(n_buildings_map.get_child(lane + i * 4))
	end_of_action()
