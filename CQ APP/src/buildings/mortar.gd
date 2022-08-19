extends Building

onready var lvl_1_image: = preload("res://assets/images/towers/mortar/mortar_1.png")
onready var lvl_2_image: = preload("res://assets/images/towers/mortar/mortar_2.png")
onready var lvl_3_image: = preload("res://assets/images/towers/mortar/mortar_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/mortar/mortar_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/mortar/mortar_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/mortar/mortar_8.png")
onready var lvl_7_image: = preload("res://assets/images/towers/mortar/mortar_8.png")
onready var lvl_8_image: = preload("res://assets/images/towers/mortar/mortar_8.png")


func _ready() -> void:
	building_name = "Mortar"
	shots_per_attack = 1
	turns_before_attack_max = 5
	turns_before_attack_min = 2
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 180, "dmg" : 40},
	{"hp": 360, "dmg" : 60},
	{"hp": 630, "dmg" : 80},
	{"hp": 1040, "dmg" : 110},
	{"hp": 1600, "dmg" : 150},
	{"hp": 2600, "dmg" : 190},
	{"hp": 3900, "dmg" : 240},
	{"hp": 6000, "dmg" : 300}]
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
	var troop_index = get_index() - 4
	var troop = map_container.get_child(troop_index)
	if troop is Troop and troop.hp > 0:
		deal_damage(troop, lvls_stats[lvl - 1]["dmg"])
	deal_damage_to_closest_troops(map_container, troop_index, lvls_stats[lvl - 1]["dmg"])
