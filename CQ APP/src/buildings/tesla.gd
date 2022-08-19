extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/tesla/tesla_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/tesla/tesla_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/tesla/tesla_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/tesla/tesla_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/tesla/tesla_5.png")

func _ready() -> void:
	building_name = "Tesla"
	shots_per_attack = 1
	turns_before_attack_max = 3
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 150, "dmg" : 80},
	{"hp": 300, "dmg" : 120},
	{"hp": 530, "dmg" : 170},
	{"hp": 860, "dmg" : 230},
	{"hp": 1400, "dmg" : 290},
	{"hp": 2100, "dmg" : 380},
	{"hp": 3300, "dmg" : 480},
	{"hp": 5000, "dmg" : 600}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_1_image
	images_of_lvls[1] = lvl_2_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_5_image

func attack(map_container : GridContainer):
	var building_lane = get_index() % 4
	for i in range(4):
		var troop = map_container.get_child(i * 4 + building_lane)
		if troop is Troop and troop.hp > 0:
			deal_damage(troop, lvls_stats[lvl - 1]["dmg"])
			break
