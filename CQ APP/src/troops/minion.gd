extends Troop

var items_min_combo: Array = [3, 2, 3]

var items_stats: Array = [[0.5, 1.0, 1.5, 2.0], [0.4, 0.6, 0.8, 1.0], [0.25, 0.5, 0.75, 1.0]]
var items_stats_2 : Array = [50, 70, 80, 90]
var rage : bool = false


func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Spear Goblin",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", "Gold Storage", 
		"Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "Minion"
	troop_stats = [
	{"damage" : 50, "hp" : 70},
	{"damage" : 58, "hp" : 81},
	{"damage" : 67, "hp" : 94},
	{"damage" : 78, "hp" : 109},
	{"damage" : 90, "hp" : 126},
	{"damage" : 104, "hp" : 145},
	{"damage" : 120, "hp" : 167},
	{"damage" : 138, "hp" : 193},
	{"damage" : 159, "hp" : 222},
	{"damage" : 183, "hp" : 256},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func attack(n_buildings_map : GridContainer) -> void:
	if combo_value > 11:
		combo_value = 11
	damage(n_buildings_map)
	emit_signal("troop_deleted", get_index())

func on_hp_changed(x : int) -> void:
	if immune_troop:
		immune_troop = false
		return
	if combo_value >= 2 and x != n_bar.max_value and item == 2 and get_random_number(100) < items_stats_2[item_lvl - 1]:
		get_rage(items_stats[item - 1][item_lvl - 1] * 3)
		return
	hp = x
	n_bar.value = x
	n_hp.text = str(x)
	if hp <= 0:
		emit_signal("troop_deleted", get_index())


func damage(n_buildings_map : GridContainer) -> void:
	var target = get_closest_building_without_walls(n_buildings_map)
	if target is Building:
		var total_damage: int = get_total_damage()
		var no_item_active : bool = false
		var optional_item: Texture = get_optional_item(item)
		if optional_item != null:
			if n_item_texture.texture == optional_item or combo_value < items_min_combo[item - 1]:
				no_item_active = true
		if item_lvl == 0 or no_item_active:
			target.hp -= total_damage
			return
		if item == 1:
			var targets = [target.get_a_random_neighbor(n_buildings_map), target.get_a_random_neighbor(n_buildings_map)]
			while targets[0] == targets[1]:
				targets[1] = target.get_a_random_neighbor(n_buildings_map)
			for j in targets:
				var tile = n_buildings_map.get_child(target.get_index() + j)
				if tile is Building:
					tile.hp -= total_damage * items_stats[item - 1][item_lvl - 1]
			
			target.hp -= total_damage
		if item == 2:
			if rage:
				target.hp -= total_damage * items_stats[item - 1][item_lvl - 1]
			else:
				target.hp -= total_damage
		if item == 3:
			target.hp -= total_damage * items_stats[item - 1][item_lvl - 1] + total_damage
