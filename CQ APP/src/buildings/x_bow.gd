extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/x bow/x_bow_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/x bow/x_bow_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/x bow/x_bow_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/x bow/x_bow_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/x bow/x_bow_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/x bow/x_bow_5.png")
onready var lvl_7_image: = preload("res://assets/images/towers/x bow/x_bow_8.png")
onready var lvl_8_image: = preload("res://assets/images/towers/x bow/x_bow_8.png")

func _ready() -> void:
	building_name = "X Bow"
	shots_per_attack = 2
	turns_before_attack_max = 2
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 200, "dmg" : 30},
	{"hp": 400, "dmg" : 50},
	{"hp": 700, "dmg" : 60},
	{"hp": 1150, "dmg" : 80},
	{"hp": 1800, "dmg" : 110},
	{"hp": 2840, "dmg" : 140},
	{"hp": 4400, "dmg" : 180},
	{"hp": 6600, "dmg" : 220}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_1_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_6_image
	images_of_lvls[6] = lvl_7_image
	images_of_lvls[7] = lvl_8_image

func attack(map_container : GridContainer):
	var building_lane = get_index() % 4
	for j in range(shots_per_attack):
		for i in range(4):
			var troop = map_container.get_child(i * 4 + building_lane)
			if troop is Troop and troop.hp > 0:
				deal_damage(troop, lvls_stats[lvl - 1]["dmg"])
				break
