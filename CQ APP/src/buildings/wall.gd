extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/wall/wall_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/wall/wall_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/wall/wall_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/wall/wall_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/wall/wall_5.png")



func _ready() -> void:
	building_name = "Wall"
	shots_per_attack = 0
	turns_before_attack_max = 3
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 80, "dmg" : 30},
	{"hp": 110, "dmg" : 50},
	{"hp": 150, "dmg" : 60},
	{"hp": 210, "dmg" : 80},
	{"hp": 270, "dmg" : 110},
	{"hp": 330, "dmg" : 140},
	{"hp": 330, "dmg" : 140},
	{"hp": 330, "dmg" : 140}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_1_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_5_image
