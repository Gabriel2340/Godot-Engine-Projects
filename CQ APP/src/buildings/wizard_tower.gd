extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_8.png")
onready var lvl_7_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_8.png")
onready var lvl_8_image: = preload("res://assets/images/towers/wizard tower/wizard_tower_8.png")

func _ready() -> void:
	building_name = "Wizard Tower"
	shots_per_attack = 1
	turns_before_attack_max = 3
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 150, "dmg" : 30},
	{"hp": 300, "dmg" : 45},
	{"hp": 530, "dmg" : 63},
	{"hp": 860, "dmg" : 85},
	{"hp": 1400, "dmg" : 110},
	{"hp": 2100, "dmg" : 140},
	{"hp": 3300, "dmg" : 180},
	{"hp": 5000, "dmg" : 220}]
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
	for i in range(4):
		var troop = map_container.get_child(i * 4 + building_lane)
		if troop is Troop and troop.hp > 0:
			deal_damage(troop, lvls_stats[lvl - 1]["dmg"])
			deal_damage_to_closest_troops(map_container, i * 4 + building_lane, lvls_stats[lvl - 1]["dmg"])
			break
