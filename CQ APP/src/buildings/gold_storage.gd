extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/gold storage/gold_storage_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/gold storage/gold_storage_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/gold storage/gold_storage_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/gold storage/gold_storage_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/gold storage/gold_storage_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/gold storage/gold_storage_8.png")
onready var lvl_7_image: = preload("res://assets/images/towers/gold storage/gold_storage_8.png")
onready var lvl_8_image: = preload("res://assets/images/towers/gold storage/gold_storage_8.png")


func _ready() -> void:
	building_name = "Gold Storage"
	shots_per_attack = 0
	turns_before_attack_max = 3
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 70, "dmg" : 0},
	{"hp": 140, "dmg" : 0},
	{"hp": 250, "dmg" : 0},
	{"hp": 400, "dmg" : 0},
	{"hp": 600, "dmg" : 0},
	{"hp": 1000, "dmg" : 0},
	{"hp": 1500, "dmg" : 0},
	{"hp": 2300, "dmg" : 0}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_1_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_6_image
	images_of_lvls[6] = lvl_7_image
	images_of_lvls[7] = lvl_8_image

