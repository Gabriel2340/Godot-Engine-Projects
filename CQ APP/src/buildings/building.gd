extends TextureButton

class_name Building

signal building_pressed
signal building_deleted

onready var n_hp: = $Hp
onready var n_bar: = $LifeBar
onready var n_hp_edit: = $HpEdit
onready var n_turns_before_attack_edit: = $TurnsBeforeAttackEdit

var got_fired_this_turn: bool = false
var got_frozen_this_turn: bool = false

var hp: int setget hp_changed
var lvl: int setget lvl_changed
var shots_per_attack: int
var lvls_stats: Array
var turns_before_attack_min: int
var turns_before_attack_max: int
var turns_left_before_attack: int setget turns_left_before_attack_changed

var emit_signal_on_mouse_up: bool = false

var stacked_fire: Array = []
var delayed_damage: Array = []
var delayed_fire: Array = []
var building_name: String = "no name"
var has_point: bool = false
var parent: GridContainer
var ctrl: bool = false
var b_damage : int
var map_container : GridContainer

var map = [
		[0,  1,  2,  3],
		[4,  5,  6,  7],
		[8,  9,  10, 11],
		[12, 13, 14, 15]]


var map2 = [
		[0,  1,  2,  3],
		[4,  5,  6,  7],
		[8,  9,  10, 11],
		[12, 13, 14, 15],
		[16, 17, 18, 19],
		[20, 21, 22, 23]]

onready var images_of_lvls: Array = [null, null, null, null, null, null, null, null]


func _ready() -> void:
	parent = get_parent()
	if Input.is_action_pressed("ctrl"):
		ctrl = true
	map_container = parent.get_parent().get_node("MapContainer")


func get_state() -> Array:
	var a: Array = [stacked_fire.duplicate(), turns_left_before_attack, hp, lvl, got_fired_this_turn, got_frozen_this_turn, delayed_damage.duplicate(), delayed_fire.duplicate()]
	return a


func load_state(a : Array) -> void:
	stacked_fire = a[0]
	if stacked_fire:
		self_modulate = Color(1.0, 0.0, 0.0, 1.0)
	turns_left_before_attack_changed(a[1])
	lvl_changed(a[3])
	hp_changed(a[2])
	got_fired_this_turn = a[4]
	got_frozen_this_turn = a[5]
	delayed_damage = a[6]
	delayed_fire = a[7]


func turns_left_before_attack_changed(new_value):
	turns_left_before_attack = new_value
	if turns_left_before_attack == 1:
		$TurnsBeforeAttack.add_color_override("font_color", Color(0.0, 1.0, 0.0, 1.0))
	else:
		$TurnsBeforeAttack.add_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	$TurnsBeforeAttack.text = str(turns_left_before_attack)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if get_global_rect().has_point(event.position):
			if has_point == false:
				if parent.delete_on_hover:
					if Input.is_action_pressed("left_click"):
						emit_signal("building_deleted", get_index())
			has_point = true
		else:
			has_point = false

	if event.is_action_pressed("ctrl"):
		ctrl = true
	if event.is_action_released("ctrl"):
		ctrl = false


func hp_changed(new_value):
	if hp <= 0:
		return
	hp = new_value
	n_hp.text = str(hp)
	n_bar.value = hp
	if hp <= 0:
		if not get_parent().get_parent().globals["see_dead_buildings"]:
			emit_signal("building_deleted", get_index(), -hp)


func lvl_changed(new_value):
	lvl = new_value
	b_damage = lvls_stats[lvl - 1]["dmg"]
	hp = lvls_stats[lvl - 1]["hp"]
	n_hp_edit.max_range = hp
	n_hp.text = str(hp)
	n_bar.max_value = hp
	n_bar.value = hp
	texture_normal = images_of_lvls[lvl - 1]


func set_turns_left_before_attack():
	randomize()
	turns_left_before_attack_changed(randi() % (turns_before_attack_max - turns_before_attack_min + 1) + turns_before_attack_min)


func on_turn_passed():
	turns_left_before_attack_changed(turns_left_before_attack - 1)
	for i in range(len(stacked_fire) - 1, -1, -1):
		if hp <= 0:
			return
		hp_changed(hp - stacked_fire[i][0])
		stacked_fire[i][1] -= 1
		if stacked_fire[i][1] <= 0:
			stacked_fire.pop_front()
	for i in range(len(delayed_damage) - 1, -1, -1):
		if hp <= 0:
			return
		delayed_damage[i][1] -= 1
		if delayed_damage[i][1] < 0:
			hp_changed(hp - delayed_damage[i][0])
			delayed_damage.remove(i)
	for i in range(len(delayed_fire) - 1, -1, -1):
		if hp <= 0:
			return
		delayed_fire[i][1] -= 1
		if delayed_fire[i][1] < 0:
			get_fire(delayed_fire[i][0], 4)
			delayed_fire.remove(i)
	if turns_left_before_attack == 0:
		turns_left_before_attack_changed(turns_before_attack_max)
		attack(map_container)
	got_fired_this_turn = false
	got_frozen_this_turn = false


func is_neighbor_to(a : int, b : int, current_map = map) -> bool:
	var i = a / 4
	var j = a % 4
	var c = 3
	if i > 0:
		if j > 0:
			if current_map[i - 1][j - 1] == b:
				return true
		if j < 3:
			if current_map[i - 1][j + 1] == b:
				return true
		if current_map[i - 1][j] == b:
			return true
	if i < c:
		if j > 0:
			if current_map[i + 1][j - 1] == b:
				return true
		if j < 3:
			if current_map[i + 1][j + 1] == b:
				return true
		if current_map[i + 1][j] == b:
			return true
	if j > 0:
		if current_map[i][j - 1] == b:
			return true
	if j < 3:
		if current_map[i][j + 1] == b:
			return true
	return false


func deal_damage_to_closest_troops(troops_map : GridContainer,index : int, damage_taken : int):
	var values: Array = [-5, -4, -3, -1, 1, 3, 4, 5]
	for i in values:
		if is_neighbor_to(index, index + i):
			var tile = troops_map.get_child(index + i)
			if tile.texture_normal:
				deal_damage(tile, damage_taken)

func get_a_random_neighbor(troops_map : GridContainer):
	var values: Array = [-5, -4, -3, -1, 1, 3, 4, 5]
	var i : int = values[get_random_number(8)]
	var index : int = get_index()
	while not is_neighbor_to(index, index + i, map2):
		i = values[get_random_number(8)]
	return i

func get_random_number(x : int) -> int:
	randomize()
	return randi() % x

func deal_damage(troop, damage : int):
	troop.last_attacker_index = get_index()
	troop.last_damage_done = damage
	troop.hp -= damage * troop.defense() / 100



func attack(map_grid : GridContainer):
	pass
	#print(get_index())


func get_fire(damage_per_turn : int, turns : int):
	turns = 999
	if not got_fired_this_turn:
		self_modulate = Color(1.0, 0.0, 0.0, 1.0)
		stacked_fire.append([damage_per_turn, turns])
		got_fired_this_turn = true


func get_fire2(damage_per_turn : int, turns : int):
	turns = 999
	self_modulate = Color(1.0, 0.0, 0.0, 1.0)
	stacked_fire.append([damage_per_turn, turns])


func get_fire_with_delay(damage : int, delay : int):
	delayed_fire.append([damage, delay])

func get_damage_with_delay(damage : int, delay : int):
	delayed_damage.append([damage, delay])


func get_frozen(turns : int):
	if not got_frozen_this_turn:
		turns_left_before_attack_changed(turns_left_before_attack + turns)
		got_frozen_this_turn = true


#func get_frozen2(turns : int):
#	turns_left_before_attack_changed(turns_left_before_attack + turns)




func _on_Hp_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		n_hp_edit.visible = true
		n_hp_edit.text = str(hp)
		n_hp_edit.grab_focus()
		n_hp_edit.select_all()


func _on_TurnsBeforeAttack_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		n_turns_before_attack_edit.visible = true
		n_turns_before_attack_edit.text = str(turns_left_before_attack)
		n_turns_before_attack_edit.grab_focus()
		n_turns_before_attack_edit.select_all()


func _on_HpEdit_enter_pressed():
	if int(n_hp_edit.text) == 0:
		n_hp_edit.visible = false
	hp_changed(int(n_hp_edit.text))
	n_hp_edit.visible = false


func _on_TurnsBeforeAttackEdit_enter_pressed():
	turns_left_before_attack_changed(int(n_turns_before_attack_edit.text))
	n_turns_before_attack_edit.visible = false


func _on_Building_pressed():
	emit_signal("building_pressed", self)


func _on_Building_button_down() -> void:
	if ctrl:
		parent.delete_on_hover = true
		emit_signal("building_deleted", get_index())
