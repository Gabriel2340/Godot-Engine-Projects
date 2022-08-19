extends Building

onready var lvl_3_image: = preload("res://assets/images/towers/air defence/air_defence_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/air defence/air_defence_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/air defence/air_defence_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/air defence/air_defence_6.png")


func _ready() -> void:
	building_name = "Air Defence"
	shots_per_attack = 2
	turns_before_attack_max = 2
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 100, "dmg" : 40},
	{"hp": 200, "dmg" : 60},
	{"hp": 350, "dmg" : 80},
	{"hp": 580, "dmg" : 110},
	{"hp": 900, "dmg" : 150},
	{"hp": 1400, "dmg" : 190},
	{"hp": 2200, "dmg" : 240},
	{"hp": 3300, "dmg" : 300}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_3_image
	images_of_lvls[1] = lvl_3_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_6_image
