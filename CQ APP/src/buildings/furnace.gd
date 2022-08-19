extends Building

onready var lvl_2_image: = preload("res://assets/images/towers/furnace/furnace_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/furnace/furnace_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/furnace/furnace_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/furnace/furnace_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/furnace/furnace_6.png")


func _ready() -> void:
	building_name = "Furnace"
	shots_per_attack = 1
	turns_before_attack_max = 3
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 200, "dmg" : 60},
	{"hp": 400, "dmg" : 75},
	{"hp": 700, "dmg" : 90},
	{"hp": 1150, "dmg" : 105},
	{"hp": 1800, "dmg" : 120},
	{"hp": 2800, "dmg" : 135},
	{"hp": 4400, "dmg" : 135},
	{"hp": 2800, "dmg" : 135}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_2_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_6_image
