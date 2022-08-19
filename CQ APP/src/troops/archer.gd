extends Troop


var items_min_combo: Array = [3, 5, 2]

var items_stats: Array = [[0.25, 0.4, 0.55, 0.7], [0.3, 0.5, 0.7, 0.9], [0.25, 0.4, 0.55, 0.7]]

var rune_stats: Array = [[200, 400, 800, 1600]]

var rune_chance: int = 5

func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Spear Goblin",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", "Gold Storage", 
		"Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "Archer"
	troop_stats = [
	{"damage" : 35, "hp" : 55},
	{"damage" : 41, "hp" : 64},
	{"damage" : 48, "hp" : 74},
	{"damage" : 56, "hp" : 86},
	{"damage" : 65, "hp" : 99},
	{"damage" : 75, "hp" : 114},
	{"damage" : 87, "hp" : 132},
	{"damage" : 101, "hp" : 152},
	{"damage" : 117, "hp" : 175},
	{"damage" : 135, "hp" : 202},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func attack(n_buildings_map : GridContainer) -> void:
	if combo_value > 11:
		combo_value = 11
	damage(n_buildings_map)
	emit_signal("troop_deleted", get_index())


func rune_activation(n_buildings_map : GridContainer) -> void:
	if get_random_number(100) >= rune_chance:
		return
	if rune_lvl == 0:
		return
	var lane : int = get_index() % 4
	parent.get_parent().rune_activated("Archer rune acvivated on lane: " + str(lane + 1))
	for i in range(6):
		var building = n_buildings_map.get_child(lane + i * 4)
		if building is Building:
			if rune_lvl == 0:
				break
			building.hp -= rune_stats[rune][rune_lvl - 1]


func damage(n_buildings_map : GridContainer) -> void:
	rune_activation(n_buildings_map)
	var target = get_closest_building_without_walls(n_buildings_map)
	if target is Building:
		var total_damage: int = get_total_damage()
		var no_item_active : bool = false
		var optional_item: Texture = get_optional_item(item)
		if optional_item != null:
			if n_item_texture.texture == optional_item:
				no_item_active = true
		if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
			target.hp -= total_damage
			return
		if item == 1:
			fire_spread(target.get_index(), total_damage * items_stats[item - 1][item_lvl - 1])
			target.hp -= total_damage
			target.get_fire(int(total_damage * items_stats[item - 1][item_lvl - 1]), 4)
		if item == 2:
			target.hp -= total_damage
			target = get_closest_building_without_walls(n_buildings_map)
			target.hp -= total_damage
		if item == 3:
			target.hp -= total_damage * items_stats[item - 1][item_lvl - 1] + total_damage
