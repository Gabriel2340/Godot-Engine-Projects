extends Troop

var items_min_combo: Array = [3, 5, 2]

var items_stats: Array = [[0.3, 0.5, 0.7, 0.9], [0.3, 0.4, 0.5, 0.6], [40, 30, 20, 10]]

var rune_stats: Array = [[100, 200, 350, 600]]

var rune_chance: int = 3

func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Spear Goblin",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", "Gold Storage", 
		"Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "Wizard"
	troop_stats = [
	{"damage" : 20, "hp" : 90},
	{"damage" : 23, "hp" : 104},
	{"damage" : 27, "hp" : 120},
	{"damage" : 32, "hp" : 138},
	{"damage" : 37, "hp" : 159},
	{"damage" : 43, "hp" : 183},
	{"damage" : 50, "hp" : 211},
	{"damage" : 58, "hp" : 243},
	{"damage" : 67, "hp" : 280},
	{"damage" : 78, "hp" : 322},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])

func defense() -> int:
	if item == 3 and item_lvl and combo_value >= 2:
		return items_stats[item - 1][item_lvl - 1]
	return 100


func on_turn_passed(n_buildings_map : GridContainer) -> void:
	rune_activation(n_buildings_map)


func rune_activation(n_buildings_map : GridContainer) -> void:
	if get_random_number(100) >= rune_chance:
		return
	if rune_lvl == 0:
		return
	parent.get_parent().rune_activated("Wizard rune acvivated")
	for i in range(3):
		var random_building = get_a_random_building(n_buildings_map)
		if random_building is Building and random_building.hp > 0:
			random_building.hp -= rune_stats[0][rune_lvl - 1]



func attack(n_buildings_map : GridContainer) -> void:
	if combo_value > 11:
		combo_value = 11
	damage(n_buildings_map)
	emit_signal("troop_deleted", get_index())


func damage(n_buildings_map : GridContainer) -> void:
	var target = get_closest_building_without_walls(n_buildings_map)
	if target is Building:
		var target_index: int = target.get_index()
		var total_damage: int = get_total_damage()
		var no_item_active : bool = false
		var optional_item: Texture = get_optional_item(item)
		if optional_item != null:
			if n_item_texture.texture == optional_item:
				no_item_active = true
		if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
			target.hp -= total_damage
			deal_damage_to_closest_buildings(n_buildings_map, target_index, total_damage)
			return
		if item == 1:
			target.hp -= total_damage
			deal_damage_to_closest_buildings(n_buildings_map, target_index, total_damage)
			target.get_fire(total_damage * items_stats[item - 1][item_lvl - 1], 4)
			deal_damage_to_closest_buildings(n_buildings_map, target_index, total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.FIRE)
			deal_damage_to_closest_buildings2(n_buildings_map, target_index, total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.FIRE)
		elif item == 2:
			target.hp -= total_damage
			deal_damage_to_closest_buildings(n_buildings_map, target_index, total_damage)
			target = get_a_random_building(n_buildings_map)
			total_damage = total_damage * items_stats[item - 1][item_lvl - 1]
			if target is Building:
				target.hp -= total_damage
				deal_damage_to_closest_buildings(n_buildings_map, target.get_index(), total_damage)
				target = get_a_random_building(n_buildings_map)
				if target is Building:
					target.hp -= total_damage
					deal_damage_to_closest_buildings(n_buildings_map, target.get_index(), total_damage)
			else:
				return
		elif item == 3:
			target.hp -= total_damage
			deal_damage_to_closest_buildings(n_buildings_map, target_index, total_damage)
