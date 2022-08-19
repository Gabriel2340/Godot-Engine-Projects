extends Node2D

onready var n_blue_gate = $Gates/BlueGate
onready var n_red_gate = $Gates/RedGate
onready var n_diamonds = $Diamonds

export(String) var next_lvl : String


func _process(delta):
	if n_blue_gate.player_is_inside and n_red_gate.player_is_inside:
		if n_diamonds.get_child_count() == 0:
			get_tree().change_scene(next_lvl)
