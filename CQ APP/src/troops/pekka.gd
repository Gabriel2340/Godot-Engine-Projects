extends Troop

var items_min_combo: Array = [1, 2, 2]

var items_stats: Array = [[100, 150, 200, 300], [60, 50, 40, 30], [0.2, 0.3, 0.4, 0.5]]
var items_stats_3_damage : Array = [100, 150, 200, 250]
var rune_stats: Array = [[60, 90, 120, 200]]

var rune_chance: int = 4

func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Spear Goblin",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", "Gold Storage", 
		"Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "P.E.K.K.A"
	troop_stats = [
	{"damage" : 500, "hp" : 250},
	{"damage" : 575, "hp" : 288},
	{"damage" : 662, "hp" : 332},
	{"damage" : 762, "hp" : 382},
	{"damage" : 877, "hp" : 440},
	{"damage" : 1009, "hp" : 506},
	{"damage" : 1161, "hp" : 582},
	{"damage" : 1336, "hp" : 670},
	{"damage" : 1537, "hp" : 771},
	{"damage" : 1768, "hp" : 887},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func on_turn_passed(n_buildings_map : GridContainer) -> void:
	rune_activation(n_buildings_map)

func defense() -> int:
	if item == 2 and item_lvl and combo_value >= 2:
		return items_stats[item - 1][item_lvl - 1]
	return 100

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
	parent.get_parent().rune_activated("P.E.K.K.A rune acvivated")
	for i in range(24):
		var building = n_buildings_map.get_child(i)
		if building is Building:
			building.get_frozen(3)
			building.hp -= rune_stats[rune][rune_lvl - 1]


func on_hp_changed(x : int) -> void:
	if immune_troop:
		return
	if item == 2:
		if x != n_bar.max_value and get_random_number(100) >= items_stats[item - 1][item_lvl - 1]:
			var building = parent.get_parent().building_turn
			if building:
				building.hp -= items_stats_3_damage[item_lvl - 1]
				building.get_frozen(2)
			
		
	hp = x
	n_bar.value = hp
	n_hp.text = str(hp)
	if hp <= 0:
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
			target = get_closest_building(n_buildings_map)
			target.hp -= items_stats[item - 1][item_lvl - 1]
			target.get_frozen(2)
		elif item == 2:
			target.hp -= total_damage
		elif item == 3:
			target.hp -= total_damage
			target = get_closest_building(n_buildings_map)
			if target:
				target.hp -= total_damage
