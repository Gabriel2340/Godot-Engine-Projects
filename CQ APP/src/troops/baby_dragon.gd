extends Troop

var items_min_combo: Array = [4, 2, 1]

var items_stats = [[0.1, 0.2, 0.3, 0.4], [0.25, 0.4, 0.55, 0.7], [0.5, 1.0, 1.5, 2.0]]

var rune_stats: Array = [[100, 200, 350, 600]]

var rune_chance: int = 3

func _ready() -> void:
	troop_name = "Baby Dragon"
	troop_stats = [
	{"damage" : 45, "hp" : 80},
	{"damage" : 52, "hp" : 92},
	{"damage" : 60, "hp" : 106},
	{"damage" : 69, "hp" : 122},
	{"damage" : 80, "hp" : 141},
	{"damage" : 92, "hp" : 163},
	{"damage" : 106, "hp" : 188},
	{"damage" : 122, "hp" : 217},
	{"damage" : 141, "hp" : 250},
	{"damage" : 163, "hp" : 288},
]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func attack(n_buildings_map : GridContainer):
	var current_lane: int = get_index() % 4
	if combo_value > 11:
		combo_value = 11
	damage(current_lane, n_buildings_map)
	emit_signal("troop_deleted", get_index())


func damage(current_lane : int, n_buildings_map : GridContainer):
	var once: bool = false
	for i in range(5, -1, -1):
		var total_damage = get_total_damage()
		var no_item_active : bool = false
		var optional_item: Texture = get_optional_item(item)
		if optional_item != null:
			if n_item_texture.texture == optional_item:
				no_item_active = true
		if n_buildings_map.get_child(current_lane + i * 4) is Building:
			var building: Building = n_buildings_map.get_child(current_lane + i * 4)
			if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
				building.hp -= total_damage
				continue
			
			if item == 3:
				if not once:
					once = true
					building.hp -= int(total_damage + total_damage * items_stats[item - 1][item_lvl - 1])
				else:
					building.hp -= total_damage
			if item == 2:
				fire_spread(building.get_index(), total_damage * items_stats[item - 1][item_lvl - 1])
				building.hp -= total_damage
				if building:
					building.get_fire(int(total_damage * items_stats[item - 1][item_lvl - 1]), 4)
		if item == 1:
			if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
				continue
			if current_lane > 0:
				if n_buildings_map.get_child(current_lane - 1 + i * 4) is Building:
					n_buildings_map.get_child(current_lane - 1 + i * 4).hp -= int(total_damage * items_stats[item - 1][item_lvl - 1])
			if current_lane < 3:
				if n_buildings_map.get_child(current_lane + 1 + i * 4) is Building:
					n_buildings_map.get_child(current_lane + 1 + i * 4).hp -= int(total_damage * items_stats[item - 1][item_lvl - 1])
			if n_buildings_map.get_child(current_lane + i * 4) is Building:
				n_buildings_map.get_child(current_lane + i * 4).hp -= total_damage
