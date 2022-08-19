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
	area_action = area.TROOPS

func action(_n_map : GridContainer, _id : int) -> void:
	end_of_action()
