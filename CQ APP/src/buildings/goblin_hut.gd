extends Building

onready var lvl_2_image: = preload("res://assets/images/towers/goblin hut/goblin_hut_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/goblin hut/goblin_hut_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/goblin hut/goblin_hut_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/goblin hut/goblin_hut_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/goblin hut/goblin_hut_6.png")


func _ready() -> void:
	building_name = "Goblin Hut"
	shots_per_attack = 2
	turns_before_attack_max = 2
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 150, "dmg" : 40},
	{"hp": 300, "dmg" : 46},
	{"hp": 530, "dmg" : 53},
	{"hp": 860, "dmg" : 61},
	{"hp": 1400, "dmg" : 71},
	{"hp": 2100, "dmg" : 82},
	{"hp": 3300, "dmg" : 95},
	{"hp": 5000, "dmg" : 110}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_2_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_6_image
