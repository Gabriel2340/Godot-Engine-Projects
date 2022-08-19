extends "res://src/spells/spell.gd"



func _ready():
	spell_stats = [
		{"damage" : 500},
		{"damage" : 575},
		{"damage" : 661},
		{"damage" : 760},
		{"damage" : 874},
		{"damage" : 1005},
		{"damage" : 1156},
		{"damage" : 1329},
		{"damage" : 1528},
		{"damage" : 1757}
	]
	damage = spell_stats[level - 1]["damage"]

func action(n_buildings_map : GridContainer, id : int):
	if n_buildings_map.get_child(id) is Building:
		deal_damage(n_buildings_map.get_child(id))
	end_of_action()
