extends Troop

var items_min_combo: Array = [5, 3, 1]

var items_stats: Array = [[0.2, 0.3, 0.4, 0.5], [0.35, 0.7, 1.05, 1.5], [50, 70, 80, 90]]

var rune_stats: Array = [[50, 100, 150, 200]]
var rune_stats2: Array = [[40, 80, 140, 200]]

var rune_chance: int = 5

func _ready() -> void:
	target_order = [
		["Gold Storage"],
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Spear Goblin",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", 
		"Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "Goblin"
	troop_stats = [
	{"damage" : 30, "hp" : 70},
	{"damage" : 36, "hp" : 81},
	{"damage" : 44, "hp" : 94},
	{"damage" : 51, "hp" : 109},
	{"damage" : 59, "hp" : 126},
	{"damage" : 67, "hp" : 145},
	{"damage" : 75, "hp" : 167},
	{"damage" : 84, "hp" : 193},
	{"damage" : 93, "hp" : 222},
	{"damage" : 103, "hp" : 256},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func on_turn_passed(n_buildings_map : GridContainer) -> void:
	rune_activation(n_buildings_map)


func rune_activation(n_buildings_map : GridContainer) -> void:
	if get_random_number(100) >= rune_chance:
		return
	if rune_lvl == 0:
		return
	var random_building = get_a_random_building(n_buildings_map)
	parent.get_parent().rune_activated("Goblin rune acvivated")
	if random_building is Building and random_building.hp > 0:
		var building_index : int = random_building.get_index()
		random_building.hp -= rune_stats2[0][rune_lvl - 1]
		deal_damage_to_closest_buildings(n_buildings_map, building_index, rune_stats2[0][rune_lvl - 1])
		random_building.get_fire2(rune_stats[0][rune_lvl - 1], 999)
		deal_damage_to_closest_buildings(n_buildings_map, building_index, rune_stats[rune][rune_lvl - 1], building_abilities.FIRE2)


func on_hp_changed(x : int) -> void:
	if immune_troop:
		immune_troop = false
		return
	if x != n_bar.max_value and item == 3 and get_random_number(100) < items_stats[item - 1][item_lvl - 1]:
		return
	hp = x
	n_bar.value = x
	n_hp.text = str(x)
	if hp <= 0:
		emit_signal("troop_deleted", get_index())

func attack(n_buildings_map : GridContainer) -> void:
	if combo_value > 11:
		combo_value = 11
	damage(n_buildings_map)
	emit_signal("troop_deleted", get_index())


func damage(n_buildings_map : GridContainer) -> void:
	var target = get_closest_building(n_buildings_map)
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
			target.hp -= total_damage
			for _i in range(2):
				target = get_closest_building(n_buildings_map)
				if target:
					target.hp -= total_damage
		if item == 2:
			var building_is_dead = target.hp <= total_damage
			target.hp -= total_damage
			if building_is_dead:
				target = get_closest_building(n_buildings_map)
				if target:
					target -= total_damage * items_stats[item - 1][item_lvl - 1]
		if item == 3:
			target.hp -= total_damage
