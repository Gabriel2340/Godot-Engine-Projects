extends Troop

var items_min_combo: Array = [1, 3, 2]

var items_stats: Array = [[0.75, 1.5, 2.25, 3.0], [0.15, 0.25, 0.35, 0.5], [50, 100, 150, 200]]

var rune_stats: Array = [[150, 230, 350, 500]]

var rune_chance: int = 5

func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow"],
		["Gold Storage", "Spear Goblin", "Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "Giant"
	troop_stats = [
	{"damage" : 80, "hp" : 300},
	{"damage" : 92, "hp" : 345},
	{"damage" : 106, "hp" : 397},
	{"damage" : 122, "hp" : 457},
	{"damage" : 141, "hp" : 526},
	{"damage" : 163, "hp" : 605},
	{"damage" : 188, "hp" : 696},
	{"damage" : 217, "hp" : 801},
	{"damage" : 250, "hp" : 922},
	{"damage" : 288, "hp" : 1061},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])

var count : int = 0
var count2 : int = 0

func on_hp_changed(x : int) -> void:
	if immune_troop:
		return
	hp = x
	n_bar.value = x
	n_hp.text = str(x)
	if hp <= 0:
		emit_signal("troop_deleted", get_index())
	elif hp != $LifeBar.max_value:
		rune_activation(n_buildings_map)


func on_turn_passed(n_buildings_map : GridContainer) -> void:
	if item == 3 and item_lvl and combo_value >= 2:
		add_ability_to_closest_troops(get_index(), items_stats[item - 1][item_lvl - 1], troop_abilities.HEAL)


func rune_activation(n_buildings_map : GridContainer) -> void:
	parent.count_giant_hits += 1
	if get_random_number(100) >= rune_chance:
		return
	if rune_lvl == 0:
		return
	parent.count_giant_runes += 1
	parent.get_parent().rune_activated("Giant rune acvivated")
	for i in range(24):
		var building = n_buildings_map.get_child(i)
		if building is Building:
			building.hp -= rune_stats[rune][rune_lvl - 1]


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
			target.hp -= total_damage + total_damage * items_stats[item - 1][item_lvl - 1]
		if item == 2:
			deal_damage_to_closest_buildings(n_buildings_map, target.get_index(), total_damage * items_stats[item - 1][item_lvl - 1])
			target.hp -= total_damage
		if item == 3:
			target.hp -= total_damage
