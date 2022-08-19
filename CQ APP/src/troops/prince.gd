extends Troop

var items_min_combo: Array = [3, 5, 1]

var items_stats = [[0.3, 0.5, 0.75, 1.0], [0.1, 0.2, 0.3, 0.4], [40, 30, 20, 10]]

var rune_stats: Array = [[150, 250, 400, 600]]

var rune_chance: int = 5

func _ready() -> void:
	troop_name = "Prince"
	troop_stats = [
	{"damage" : 80, "hp" : 150},
	{"damage" : 92, "hp" : 173},
	{"damage" : 106, "hp" : 199},
	{"damage" : 122, "hp" : 229},
	{"damage" : 141, "hp" : 264},
	{"damage" : 163, "hp" : 304},
	{"damage" : 188, "hp" : 350},
	{"damage" : 217, "hp" : 403},
	{"damage" : 250, "hp" : 464},
	{"damage" : 288, "hp" : 534},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])



func rune_activation(n_buildings_map : GridContainer) -> void:
	if last_attacker_index == 1234:
		return
	var row: int = last_attacker_index - last_attacker_index % 4
	if get_random_number(100) >= rune_chance:
		return
	if rune_lvl == 0:
		return
	immune_troop = true
	parent.get_parent().rune_activated("Prince rune acvivated on row: " + str(row / 4))
	for i in range(row, row + 4):
		var building = n_buildings_map.get_child(i)
		if building is Building:
			building.hp -= rune_stats[rune][rune_lvl - 1]


func on_hp_changed(x : int) -> void:
	rune_activation(n_buildings_map)
	if immune_troop:
		immune_troop = false
		return
	hp = x
	n_bar.value = x
	n_hp.text = str(x)
	if hp <= 0:
		emit_signal("troop_deleted", get_index())


func defense() -> int:
	if item == 3 and item_lvl and combo_value >= 2:
		return items_stats[item - 1][item_lvl - 1]
	return 100


func attack(n_buildings_map : GridContainer):
	var current_lane: int = get_index() % 4
	if combo_value > 11:
		combo_value = 11
	damage(current_lane, n_buildings_map)
	emit_signal("troop_deleted", get_index())


func damage(current_lane : int, n_buildings_map : GridContainer):
	var index: int = current_lane + 20
	var once: bool = false
	for i in range(6):
		var current_index = index - i * 4
		var target = n_buildings_map.get_child(current_index)
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
				var target_hp: int = target.hp 
				target.hp -= total_damage
				if target_hp <= total_damage and not once:
					once = true
					continue
			if item == 2:
				target.hp -= total_damage
				deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage * items_stats[item - 1][item_lvl - 1])
			if item == 3:
				target.hp -= total_damage
			return
