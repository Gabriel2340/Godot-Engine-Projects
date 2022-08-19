extends Troop

var items_min_combo: Array = [2, 1, 1]

var items_stats: Array = [[0.25, 0.4, 0.55, 0.7], [0.2, 0.4, 0.6, 0.8], [0.3, 0.6, 0.9, 1.2]]

var delay_for_attack: int = 1
var turns_alive: int = 0

var items_images: Array = [
	[preload("res://assets/images/items/bomb_miner1_1.png"),
	preload("res://assets/images/items/bomb_miner2_1.png"),
	preload("res://assets/images/items/bomb_miner3_1.png"),
	preload("res://assets/images/items/bomb_miner4_1.png")],
	[preload("res://assets/images/items/bomb_miner1_2.png"),
	preload("res://assets/images/items/bomb_miner2_2.png"),
	preload("res://assets/images/items/bomb_miner3_2.png"),
	preload("res://assets/images/items/bomb_miner4_2.png")],
	[preload("res://assets/images/items/bomb_miner1_3.png"),
	preload("res://assets/images/items/bomb_miner2_3.png"),
	preload("res://assets/images/items/bomb_miner3_3.png"),
	preload("res://assets/images/items/bomb_miner4_3.png")]
]


func _ready() -> void:
	target_order = [
		["Archer Tower", "Air Defence", "Cannon",
		"Furnace", "Goblin Hut", "Spear Goblin",
		"Inferno Tower", "Mortar", "Tesla", 
		"Wizard Tower", "X Bow", "Gold Storage", 
		"Fire Spirit"],
		["Wall"]]
	troop_name = "Bomb Miner"
	troop_stats = [
	{"damage" : 100, "hp" : 200},
	{"damage" : 115, "hp" : 230},
	{"damage" : 133, "hp" : 265},
	{"damage" : 153, "hp" : 305},
	{"damage" : 176, "hp" : 351},
	{"damage" : 203, "hp" : 404},
	{"damage" : 234, "hp" : 465},
	{"damage" : 270, "hp" : 535},
	{"damage" : 311, "hp" : 616},
	{"damage" : 358, "hp" : 709},
	]
	n_bar.max_value = troop_stats[level - 1]["hp"]
	on_hp_changed(troop_stats[level - 1]["hp"])

func attack(n_buildings_map : GridContainer) -> void:
	if combo_value > 11:
		combo_value = 11
	damage(n_buildings_map)
	emit_signal("troop_deleted", get_index())


func get_state() -> Array:
	var optional_item: Texture = get_optional_item(item)
	var c_optional_item : bool = false 
	if optional_item != null and optional_item == n_item_texture.texture:
		c_optional_item = true
	var a: Array = [damage_increase - 1.0, c_optional_item, combo_value, current_combo, hp, n_item_texture.texture, turns_alive]
	
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
	if item == 2:
		update_turns_alive(a[6])

func _on_Troop_pressed() -> void:
	if alt:
		if item == 2:
			turns_alive += 1
			if turns_alive > 3:
				update_turns_alive(0)
			else:
				update_turns_alive(turns_alive)
		else:
			change_optional_item()
	else:
		emit_signal("troop_pressed", get_index())

func update_turns_alive(turns):
	turns_alive = turns
	if turns_alive > 3:
		turns_alive = 3
	elif turns_alive == 0:
		n_item_texture.texture = items_textures[3 + item_lvl]
		return
	n_item_texture.texture = items_images[turns_alive - 1][item_lvl - 1]


func damage(n_buildings_map : GridContainer) -> void:
	#print(turns_alive)
	var current_lane : int = get_index() % 4
	for i in range(4):
		var current_index : int = current_lane + i * 4 + 4
		var target = n_buildings_map.get_child(current_index)
		if target is Building:
			var total_damage: int = get_total_damage()
			var no_item_active : bool = false
			var optional_item: Texture = get_optional_item(item)
			if optional_item != null:
				if n_item_texture.texture == optional_item:
					no_item_active = true
			if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
				target.get_damage_with_delay(total_damage, delay_for_attack)
				deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.DAMAGE_DELAYED, delay_for_attack)
				return
			if item == 1:
				target.get_fire_with_delay(total_damage * items_stats[item - 1][item_lvl - 1], 4)
				deal_damage_to_closest_buildings(n_buildings_map, target.get_index(), total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.FIRE_WITH_DELAY, 1)
				deal_damage_to_closest_buildings2(n_buildings_map, target.get_index(), total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.FIRE_WITH_DELAY, 1)
				target.get_damage_with_delay(total_damage, delay_for_attack)
				deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.DAMAGE_DELAYED, delay_for_attack)
			if item == 2:
				target.get_damage_with_delay(total_damage + turns_alive * total_damage * items_stats[item - 1][item_lvl - 1], delay_for_attack)
				deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage + turns_alive * total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.DAMAGE_DELAYED, delay_for_attack)
			if item == 3:
				target.hp -= total_damage * items_stats[item - 1][item_lvl - 1]
				target.get_frozen(2)
				target.get_damage_with_delay(total_damage, delay_for_attack)
				deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.DAMAGE_DELAYED, delay_for_attack)
			return
	var total_damage: int = get_total_damage()
	var current_index: int = current_lane + 4
	var no_item_active : bool = false
	var optional_item: Texture = get_optional_item(item)
	if optional_item != null:
		if n_item_texture.texture == optional_item:
			no_item_active = true
	if item_lvl == 0 or no_item_active or combo_value < items_min_combo[item - 1]:
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.DAMAGE_DELAYED, delay_for_attack)
		return
	if item == 1:
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.FIRE_WITH_DELAY, 1)
		deal_damage_to_closest_buildings2(n_buildings_map, current_index, total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.FIRE_WITH_DELAY, 1)
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.DAMAGE_DELAYED, delay_for_attack)
	if item == 2:
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage + turns_alive * total_damage * items_stats[item - 1][item_lvl - 1], building_abilities.DAMAGE_DELAYED, delay_for_attack)
	if item == 3:
		deal_damage_to_closest_buildings(n_buildings_map, current_index, total_damage, building_abilities.DAMAGE_DELAYED, delay_for_attack)
