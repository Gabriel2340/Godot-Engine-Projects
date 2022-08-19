extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/inferno/inferno_tower_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/inferno/inferno_tower_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/inferno/inferno_tower_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/inferno/inferno_tower_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/inferno/inferno_tower_5.png")


func _ready() -> void:
	building_name = "Inferno Tower"
	shots_per_attack = 1
	turns_before_attack_max = 2
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 220, "dmg" : -1},
	{"hp": 440, "dmg" : -1},
	{"hp": 770, "dmg" : -1},
	{"hp": 1270, "dmg" : -1},
	{"hp": 2000, "dmg" : -1},
	{"hp": 3100, "dmg" : -1},
	{"hp": 4800, "dmg" : -1},
	{"hp": 7300, "dmg" : -1}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_1_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_5_image
