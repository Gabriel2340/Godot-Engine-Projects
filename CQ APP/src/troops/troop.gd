extends TextureButton

class_name Troop

signal hover_started
signal troop_deleted
signal troop_pressed
signal troop_hovered


export(Texture) var first_item_icon_lvl_1 : Texture
export(Texture) var first_item_icon_lvl_2 : Texture
export(Texture) var first_item_icon_lvl_3 : Texture
export(Texture) var first_item_icon_lvl_4 : Texture
export(Texture) var second_item_icon_lvl_1 : Texture
export(Texture) var second_item_icon_lvl_2 : Texture
export(Texture) var second_item_icon_lvl_3 : Texture
export(Texture) var second_item_icon_lvl_4 : Texture
export(Texture) var third_item_icon_lvl_1 : Texture
export(Texture) var third_item_icon_lvl_2 : Texture
export(Texture) var third_item_icon_lvl_3 : Texture
export(Texture) var third_item_icon_lvl_4 : Texture
export(Texture) var first_optional_item : Texture
export(Texture) var second_optional_item : Texture
export(Texture) var third_optional_item : Texture


onready var n_bar = $LifeBar
onready var n_hp = $Hp

enum building_abilities {
	DAMAGE,
	FIRE,
	FIRE2,
	FIRE_WITH_DELAY,
	FREEZE,
	DAMAGE_DELAYED,
}

enum troop_abilities {
	RAGE,
	HEAL
}

enum area {
	BUILDINGS,
	TROOPS
}

onready var n_item_texture: = $ItemTexture
onready var n_hover: = $Hover
onready var red_circle: = preload("res://assets/images/other/red_circle.png")

var alt: bool = false

var level: int = 1
var rage_by_bomber_before: bool = false

var damage_increase: float = 1.0
var item: int = 0
var item_lvl: int = 0
var items_textures: Array = [null, null, null, null, null, null, null, null, null, null, null, null]
var rune: int = 0
var rune_lvl: int = 0
var combo_value: int = 1 setget on_combo_value_changed
var level_stats: Array

var current_combo: bool = false setget current_combo_changed
var current_combo2 : bool = false
var troop_name: String = ""

var hover: bool = false

var has_point = false

var target_order: Array
var hp : int = 0 setget on_hp_changed
var last_attacker_index : int = 1234
var last_damage_done : int = 1234567
var immune_troop : bool = false

var troop_stats : Array
var map = [
		[0,  1,  2,  3],
		[4,  5,  6,  7],
		[8,  9,  10, 11],
		[12, 13, 14, 15],
		[16, 17, 18, 19],
		[20, 21, 22, 23]]

var parent : GridContainer
var n_buildings_map : GridContainer

func _ready() -> void:
	init_items_textures()
	item_changed()
	if Input.is_action_pressed("ctrl"):
		texture_hover = red_circle
	if Input.is_action_pressed("alt"):
		alt = true
	parent = get_parent()
	n_buildings_map = parent.get_parent().get_node("BuildingsContainer")


func on_hp_changed(x : int) -> void:
	if immune_troop:
		return
	hp = x
	n_bar.value = hp
	n_hp.text = str(hp)
	if hp <= 0:
		emit_signal("troop_deleted", get_index())


func defense() -> int:
	return 100


func rune_activation(buildings_map : GridContainer) -> void:
	pass


func current_combo_changed(new_value):
	current_combo = new_value
#	if current_combo == true:
#		$TextureRect.visible = true
#	else:
#		$TextureRect.visible = false


func on_turn_passed(n_buildings_map : GridContainer) -> void:
	pass


func on_combo_value_changed(new_value):
	combo_value = new_value
	$Label.text = str(combo_value)


func get_random_number(x : int) -> int:
	randomize()
	return randi() % x


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ctrl"):
		texture_hover = red_circle
	if event.is_action_released("ctrl"):
		texture_hover = null


	if event.is_action_pressed("alt"):
		alt = true
	if event.is_action_released("alt"):
		alt = false
	
	if event is InputEventMouseMotion:
		if get_global_rect().has_point(event.position):
			if has_point == false:
				if parent.delete_on_hover:
					if Input.is_action_pressed("left_click"):
						emit_signal("troop_deleted", get_index())
				emit_signal("troop_hovered", get_index())
			has_point = true
		else:
			has_point = false


func init_items_textures() -> void:
	items_textures[0] = first_item_icon_lvl_1
	items_textures[1] = first_item_icon_lvl_2
	items_textures[2] = first_item_icon_lvl_3
	items_textures[3] = first_item_icon_lvl_4
	items_textures[4] = second_item_icon_lvl_1
	items_textures[5] = second_item_icon_lvl_2
	items_textures[6] = second_item_icon_lvl_3
	items_textures[7] = second_item_icon_lvl_4
	items_textures[8] = third_item_icon_lvl_1
	items_textures[9] = third_item_icon_lvl_2
	items_textures[10] = third_item_icon_lvl_3
	items_textures[11] = third_item_icon_lvl_4


func item_changed() -> void:
	if item_lvl == 0:
		n_item_texture.texture = null
		return
	var optional_item: Texture = get_optional_item(item)
	if optional_item != null and n_item_texture.texture == optional_item:
		return
	n_item_texture.texture = items_textures[(item - 1) * 4 + item_lvl - 1]


func get_optional_item(index) -> Texture:
	if index == 1:
		return first_optional_item
	if index == 2:
		return second_optional_item
	if index == 3:
		return third_optional_item
	return null


func _on_Troop_button_down() -> void:
	n_hover.start()
	if texture_hover != null:
		emit_signal("troop_deleted", get_index())
		parent.delete_on_hover = true


func _on_Troop_button_up() -> void:
	if not hover:
		n_hover.stop()
	hover = false


func change_optional_item() -> void:
	var optional_item: Texture = get_optional_item(item)
	if optional_item == null:
		return
	if n_item_texture.texture == optional_item:
		n_item_texture.texture = items_textures[(item - 1) * 4 + item_lvl - 1]
	else:
		n_item_texture.texture = optional_item


func _on_Troop_pressed() -> void:
	if alt:
		change_optional_item()
	else:
		emit_signal("troop_pressed", get_index())

# x = 84, y = 63
func make_shortest_points(n_buildings_map : GridContainer, points : PoolVector2Array) -> PoolVector2Array:
	var collision: bool = false
	var i : int = 0
	var len_points = len(points) - 2
	points.invert()
	while i < len_points:
		var start_point: Vector2 = Vector2(round(points[i].x), round(points[i].y))
		var start_point_copy: Vector2 = start_point
		var end_point: Vector2 = Vector2(round(points[i + 2].x), round(points[i + 2].y))
		var y = abs(start_point.y - end_point.y)
		var add_to_y_sign: int
		var add_to_y: float
		if y == 0 or end_point.x - start_point.x == 0:
			add_to_y_sign = 0
			add_to_y = 0
		else:
			add_to_y_sign = float(end_point.y - start_point.y) / y
			add_to_y = 1 / (float(abs(end_point.x - start_point.x)) / y * add_to_y_sign)
		var x: int = abs(start_point.x - end_point.x)
		var add_to_x: float 
		if x == 0:
			add_to_x = 0
		else:
			add_to_x = float(end_point.x - start_point.x) / x
		if end_point.y < 378:
			if not int(start_point.x) / 84 * 84 == int(start_point.x):
				if start_point.y <= 378:
					var tile: int = int(start_point.y - 1) / 63 * 4 + int(start_point.x + add_to_x) / 84
					if n_buildings_map.get_child(tile) is Building:
						collision = true
				start_point.x += 42 * add_to_x
				start_point.y += 42 * add_to_y
			while abs(int(start_point.x) - int(end_point.x)) > 1 and not collision:
				if start_point.y <= 378:
					var tile: int = int(start_point.y - 1) / 63 * 4 + int(start_point.x + add_to_x) / 84
					if n_buildings_map.get_child(tile) is Building:
						collision = true
				start_point.x += 84 * add_to_x
				start_point.y += 84 * add_to_y
			start_point = start_point_copy
			if not int(start_point.y) / 63 * 63 == int(start_point.y):
				if start_point.y <= 378:
					var tile: int = int(start_point.y - 1) / 63 * 4 + int(start_point.x + add_to_x) / 84
					if n_buildings_map.get_child(tile) is Building:
						collision = true
				start_point.x += add_to_x * 32 / abs(add_to_y)
				start_point.y += add_to_y_sign * 32
			while abs(int(start_point.y) - int(end_point.y)) > 1 and not collision:
				if start_point.y <= 378:
					var tile: int = int(start_point.y - 1) / 63 * 4 + int(start_point.x + add_to_x) / 84
					if n_buildings_map.get_child(tile) is Building:
						collision = true
				start_point.x += add_to_x * 63 / abs(add_to_y)
				start_point.y += add_to_y_sign * 63
		if not collision:
			points.remove(i + 1)
			len_points -= 1
			i -= 1
		i += 1
	return points


func len_v_a(vect : PoolVector2Array) -> int:
	var s: float = 0.0
	for i in range(len(vect) - 1):
		s += vect[i].distance_to(vect[i + 1])
	return int(s)


func get_closest_building(n_buildings_map : GridContainer) -> Building:
	var nav_2d : Navigation2D = get_parent().get_parent().get_node("CenterPos/Navigation2D")
	var mini: int = 1234567
	var closest_building: Building = null
	var upper_walls_verified: bool = false
	for j in range(len(target_order)):
		for i in range(24):
			var building = n_buildings_map.get_child(i)
			if building is Building:
				if building.hp <= 0:
					continue
				if building.building_name == "Wall" and target_order[j][0] == "Wall":
					if i > 3:
						if closest_building and not upper_walls_verified:
							return closest_building
						else:
							upper_walls_verified = true
				if building.building_name in target_order[j]:
					var nav_2d_global_position = nav_2d.get_global_position()
					var d = get_global_position() + rect_size / 2 - nav_2d_global_position
					var a = building.get_global_position() + Vector2(0, building.rect_size.y) - nav_2d_global_position
					var b = building.get_global_position() + building.rect_size - nav_2d_global_position
					var c = building.get_global_position() + Vector2(building.rect_size.x, 0) - nav_2d_global_position
					var e = building.get_global_position() - nav_2d_global_position
					var points1 = make_shortest_points(n_buildings_map, nav_2d.get_simple_path(a, d))
					var points2 = make_shortest_points(n_buildings_map, nav_2d.get_simple_path(b, d))
					var points3 = make_shortest_points(n_buildings_map, nav_2d.get_simple_path(c, d))
					var points4 = make_shortest_points(n_buildings_map, nav_2d.get_simple_path(e, d))
					var distance: int = 9999999
					var dis1: int = len_v_a(points1)
					var dis2: int = len_v_a(points2)
					var dis3: int = len_v_a(points3)
					var dis4: int = len_v_a(points4)
					if dis1 != 0 and dis1 < distance:
						distance = dis1
					if dis2 != 0 and dis2 < distance:
						distance = dis2
					if dis3 != 0 and dis3 < distance:
						distance = dis3
					if dis4 != 0 and dis4 < distance:
						distance = dis4
					if distance == 0:
						continue
					if distance < mini:
						closest_building = building
						mini = distance
					elif is_equal_approx(distance, mini):
						if building.get_index() / 4 > closest_building.get_index() / 4:
							closest_building = building
							mini = distance
						if building.get_index() % 4 == get_index() % 4:
							closest_building = building
							mini = distance
		if closest_building:
			return closest_building
	return closest_building


func get_closest_building_without_walls(n_buildings_map : GridContainer) -> Building:
	var mini: int = 123456
	var closest_building: Building = null
	var upper_walls_verified: bool = false
	for j in range(len(target_order)):
		for i in range(24):
			var building = n_buildings_map.get_child(i)
			if building is Building:
				if building.hp <= 0:
					continue
				if building.building_name == "Wall" and target_order[j][0] == "Wall":
					if i > 3:
						if closest_building and not upper_walls_verified:
							return closest_building
						else:
							upper_walls_verified = true
				if building.building_name in target_order[j]:
					var d = get_global_position() + rect_size / 2
					var a = (building.get_global_position() + Vector2(0, building.rect_size.y)).distance_to(d)
					var b = (building.get_global_position() + building.rect_size).distance_to(d)
					var distance: int = min(a, b)
					if distance < mini:
						closest_building = building
						mini = distance
					elif is_equal_approx(distance, mini):
						if building.get_index() / 4 > closest_building.get_index() / 4:
							closest_building = building
							mini = distance
						if building.get_index() % 4 == get_index() % 4:
							closest_building = building
							mini = distance
		if closest_building:
			return closest_building
	return closest_building


# neigbor for buildings
func is_neighbor2(a : int, b : int, area_action: int = area.BUILDINGS) -> bool:
	var i = a / 4
	var j = a % 4
	var c = 5
	if area_action == area.TROOPS:
		c = 3
	if i > 0:
		if j > 0:
			if map[i - 1][j - 1] == b:
				return true
		if j < 3:
			if map[i - 1][j + 1] == b:
				return true
		if map[i - 1][j] == b:
			return true
	if i < c:
		if j > 0:
			if map[i + 1][j - 1] == b:
				return true
		if j < 3:
			if map[i + 1][j + 1] == b:
				return true
		if map[i + 1][j] == b:
			return true
	if j > 0:
		if map[i][j - 1] == b:
			return true
	if j < 3:
		if map[i][j + 1] == b:
			return true
	return false



func deal_damage_to_closest_buildings(n_buildings_map : GridContainer,index : int, damage_taken : int, ability: int = building_abilities.DAMAGE, turns : int = 4):
	var values: Array = [-5, -4, -3, -1, 1, 3, 4, 5]
	for i in values:
		if is_neighbor2(index, index + i):
			var tile = n_buildings_map.get_child(index + i)
			if tile is Building:
				if ability == building_abilities.DAMAGE:
					tile.hp -= damage_taken
				elif ability == building_abilities.FIRE:
					tile.get_fire(damage_taken, turns)
				elif ability == building_abilities.FREEZE:
					tile.get_frozen(turns)
				elif ability == building_abilities.DAMAGE_DELAYED:
					tile.get_damage_with_delay(damage_taken, turns)
				elif ability == building_abilities.FIRE_WITH_DELAY:
					tile.get_fire_with_delay(damage_taken, turns)
				elif ability == building_abilities.FIRE2:
					tile.get_fire2(damage_taken, turns)


func deal_damage_to_closest_buildings2(n_buildings_map2 : GridContainer,index : int, damage_taken : int, ability: int = building_abilities.FIRE, turns : int = 4):
	var values: Array = [-5, -4, -3, -1, 1, 3, 4, 5]
	for i in values:
		if is_neighbor2(index, index + i):
			var tile = n_buildings_map2.get_child(index + i)
			if tile is Building:
				fire_spread(index + i, damage_taken, ability, turns)


func fire_spread(index : int, damage_taken : int, ability: int = building_abilities.FIRE, turns : int = 4) -> void:
	var values: Array = [-5, -4, -3, -1, 1, 3, 4, 5]
	for i in values:
		if is_neighbor2(index, index + i):
			var tile = n_buildings_map.get_child(index + i)
			if tile is Building:
				var random_number : int = get_random_number(100)
				if random_number < 50:
					if ability == building_abilities.FIRE:
						tile.get_fire(damage_taken, 4)
					elif ability == building_abilities.FIRE_WITH_DELAY:
						tile.get_fire_with_delay(damage_taken, turns)



func add_ability_to_closest_troops(index : int, attack_increase : float, ability : int = troop_abilities.RAGE):
	var values: Array = [-5, -4, -3, -1, 1, 3, 4, 5]
	var by_bomber : bool = false
	if troop_name == "Bomber":
		by_bomber = true
	for i in values:
		if is_neighbor2(index, index + i, area.TROOPS):
			var tile = get_parent().get_child(index + i)
			if tile.get_child_count() != 0:
				if ability == troop_abilities.RAGE:
					if not tile.current_combo:
						tile.get_rage(attack_increase, by_bomber)
				elif ability == troop_abilities.HEAL:
					tile.heal(attack_increase)


func heal(x : int) -> void:
	if hp + x > $LifeBar.max_value:
		self.hp = $LifeBar.max_value
	else:
		self.hp += x


func get_a_random_building(n_buildings_map : GridContainer) -> Building:
	randomize()
	var buildings = 0
	for building in n_buildings_map.get_children():
		if building is Building:
			buildings += 1
	if buildings == 0:
		return null
	var buildings_left_to_search = randi()%buildings
	for building in n_buildings_map.get_children():
		if building is Building:
			if buildings_left_to_search == 0:
				return building
			else:
				buildings_left_to_search -= 1
	return null


func get_state() -> Array:
	var optional_item: Texture = get_optional_item(item)
	var c_optional_item : bool = false 
	if optional_item != null and optional_item == n_item_texture.texture:
		c_optional_item = true
	var a: Array = [damage_increase - 1.0, c_optional_item, combo_value, current_combo, hp, n_item_texture.texture]
	
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


func get_rage(attack_increase, by_bomber: bool = true):
	if by_bomber and rage_by_bomber_before:
		return
	if by_bomber:
		rage_by_bomber_before = true
	damage_increase = damage_increase * (attack_increase + 1.0)
	$DebugRage.visible = true


func get_total_damage() -> int:
	var damage_without_combo = troop_stats[level - 1]["damage"] * damage_increase
	return int(damage_without_combo + damage_without_combo * (combo_value - 1) * 0.2)


func _on_hover_timeout() -> void:
	emit_signal("hover_started", get_index())
	hover = true


func attack(_n_buildings_map : GridContainer):
	pass
