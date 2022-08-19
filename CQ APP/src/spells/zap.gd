extends "res://src/spells/spell.gd"


func _ready():
	spell_stats = [
		{"damage" : 100, "effect" : 2},
		{"damage" : 115, "effect" : 2},
		{"damage" : 132, "effect" : 3},
		{"damage" : 152, "effect" : 3},
		{"damage" : 175, "effect" : 3},
		{"damage" : 201, "effect" : 4},
		{"damage" : 231, "effect" : 4},
		{"damage" : 266, "effect" : 4},
		{"damage" : 306, "effect" : 4},
		{"damage" : 352, "effect" : 4}
	]
	damage = spell_stats[level - 1]["damage"]

func action(n_buildings_map : GridContainer, id : int):
	if n_buildings_map.get_child(id) is Building:
		var building: Building = n_buildings_map.get_child(id)
		deal_damage(building)
		building.get_frozen(spell_stats[level - 1]["effect"])
	end_of_action()
