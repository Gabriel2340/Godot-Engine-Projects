extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/dune dragon/dune_dragon_1.png")



func _ready() -> void:
	building_name = "Dune Dragon"
	shots_per_attack = 1
	turns_before_attack_max = 2
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 190, "dmg" : 50},
	{"hp": 380, "dmg" : 80},
	{"hp": 670, "dmg" : 110},
	{"hp": 1090, "dmg" : 140},
	{"hp": 1700, "dmg" : 180},
	{"hp": 2700, "dmg" : 240},
	{"hp": 4100, "dmg" : 300},
	{"hp": 6300, "dmg" : 370}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_1_image
	images_of_lvls[1] = lvl_1_image
	images_of_lvls[2] = lvl_1_image
	images_of_lvls[3] = lvl_1_image
	images_of_lvls[4] = lvl_1_image
	images_of_lvls[5] = lvl_1_image

func attack(map_container : GridContainer):
	var troop_index = get_index() - 4
	var troop = map_container.get_child(troop_index)
	if troop is Troop and troop.hp > 0:
		deal_damage(troop, lvls_stats[lvl - 1]["dmg"])
