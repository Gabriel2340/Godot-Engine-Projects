extends Troop

var items_min_combo: Array = [3, 1, 2]

var items_stats = [[0.3, 0.4, 0.5, 0.6], [0.5, 1.0, 1.5, 2.0], [0.2, 0.3, 0.4, 0.5]]

var rune_stats: Array = [[100, 200, 350, 600]]

var rune_chance: int = 3

func _ready() -> void:
	troop_name = "Bomber"
	troop_stats = [
	{"damage" : 35, "hp" : 120},
	{"damage" : 44, "hp" : 138},
	{"damage" : 53, "hp" : 159},
	{"damage" : 62, "hp" : 183},
	{"damage" : 71, "hp" : 211},
	{"damage" : 80, "hp" : 243},
	{"damage" : 89, "hp" : 280},
	{"damage" : 98, "hp" : 322},
	{"damage" : 107, "hp" : 371},
	{"damage" : 116, "hp" : 427},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func attack(n_buildings_map : GridContainer):
	if combo_value > 11:
		combo_value = 11
	damage(n_buildings_map)
	emit_signal("troop_deleted", get_index())


func damage(n_buildings_map : GridContainer):
	var current_index: int = get_index() + 4
	var target = n_buildings_map.get_child(current_index)
	var total_damage: int = get_total_damage()
	var no_item_active : bool = false
	var optional_item: Texture = get_optional_item(item)
	if optional_item != null:
		if n_item_texture.texture == optional_item:
			no_item_active = true
	if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
		if target is Building:
			target.hp -= total_damage
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage)
		return
	if item == 1:
		if target is Building:
			target.hp -= total_damage
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage)
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.FREEZE, 2)

	elif item == 2:
		if target is Building:
			target.hp -= total_damage + total_damage * items_stats[item - 1][item_lvl - 1]
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage)
	elif item == 3:
		if target is Building:
			target.hp -= total_damage
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage)
		add_ability_to_closest_troops(current_index - 4, items_stats[item - 1][item_lvl - 1])
