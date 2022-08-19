extends Troop


var items_min_combo: Array = [3, 1, 1]

var items_stats: Array = [[0.8, 1.2, 1.6, 2.0], [40, 30, 20, 10], [0.5, 1.0, 1.5, 2.0]]


var rune_stats: Array = [[25, 50, 75, 100]]

var rune_chance: int = 3

var rune_activated: bool = false setget on_rune_activated

var is_raged : bool = false

enum directions {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Gold Storage",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", "Spear Goblin", 
		"Fire Spirit", "Dune Dragon", "Skeleton"],
		["Wall"]]
	troop_name = "Barbarian"
	troop_stats = [
	{"damage" : 40, "hp" : 100},
	{"damage" : 46, "hp" : 115},
	{"damage" : 53, "hp" : 133},
	{"damage" : 61, "hp" : 153},
	{"damage" : 71, "hp" : 176},
	{"damage" : 82, "hp" : 203},
	{"damage" : 95, "hp" : 234},
	{"damage" : 110, "hp" : 270},
	{"damage" : 127, "hp" : 311},
	{"damage" : 147, "hp" : 358},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])


func on_turn_passed(n_buildings_map : GridContainer) -> void:
	if hp > 0:
		rune_activation(n_buildings_map)

func on_rune_activated(x : bool) -> void:
	rune_activated = x
	$TextureRect.visible = rune_activated


func on_hp_changed(x : int) -> void:
	if immune_troop:
		return
	if hp > x:
		is_raged = true
	hp = x
	n_bar.value = hp
	n_hp.text = str(hp)
	if hp <= 0:
		emit_signal("troop_deleted", get_index())


func get_state() -> Array:
	var optional_item: Texture = get_optional_item(item)
	var c_optional_item : bool = false 
	if optional_item != null and optional_item == n_item_texture.texture:
		c_optional_item = true
	var a: Array = [damage_increase - 1.0, c_optional_item, combo_value, current_combo, hp, n_item_texture.texture, is_raged, rune_activated]
	
	return a


func load_state(a : Array):
	if a[0] > 0.0:
		get_rage(a[0])
		rage_by_bomber_before = true
	if a[1] == true:
		change_optional_item()
	combo_value = a[2]
	current_combo = a[3]
	hp = a[4]
	n_item_texture.texture = a[5]
	is_raged = a[6]
	self.rune_activated = a[7]


func get_total_damage() -> int:
	var add : int = 0
	if rune_activated:
		add += rune_stats[rune][rune_lvl - 1]
	var damage_without_combo = (troop_stats[level - 1]["damage"] + add) * damage_increase
	return int(damage_without_combo + damage_without_combo * (combo_value - 1) * 0.2)


func defense() -> int:
	if item == 2 and item_lvl and combo_value >= 2:
		return items_stats[item - 1][item_lvl - 1]
	return 100


func activate_runes(index) -> void:
	var points: Array = [index]
	var new_points: Array = []
	var all_points: Array = []
	var principal_troop_name: String = troop_name
	self.rune_activated = true
	while points != []:
		for point in points:
			all_points.append(point)
			for i in range(4):
				var troop = get_troop(parent, point, i)
				if troop and troop.texture_normal and troop.troop_name == principal_troop_name and not troop.rune_activated:
						troop.rune_activated = true
						new_points.append(troop.get_index())
		points = new_points.duplicate()
		new_points = []


func get_troop(n_map, index : int, direction: int) -> Troop:
	if direction == directions.UP:
		if index - 4 >= 0:
			if not n_map.get_child(index - 4).texture_normal:
				return null
			var troop: Troop = n_map.get_child(index - 4)
			return troop
	if direction == directions.DOWN:
		if index + 4 < 16:
			if not n_map.get_child(index + 4).texture_normal:
				return null
			var troop: Troop = n_map.get_child(index + 4)
			return troop
	if direction == directions.LEFT:
		if index % 4 != 0:
			if not n_map.get_child(index - 1).texture_normal:
				return null
			var troop: Troop = n_map.get_child(index - 1)
			return troop
	if direction == directions.RIGHT:
		if (index + 1) % 4 != 0:
			if not n_map.get_child(index + 1).texture_normal:
				return null
			var troop: Troop = n_map.get_child(index + 1)
			return troop
	return null


func rune_activation(n_buildings_map : GridContainer) -> void:
	if get_random_number(100) >= rune_chance:
		return
	if rune_lvl == 0:
		return
	activate_runes(get_index())


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
			target.hp -= total_damage
		if item == 3:
			if is_raged:
				target.hp -= total_damage + total_damage * items_stats[item - 1][item_lvl - 1]
			else:
				target.hp -= total_damage
				
