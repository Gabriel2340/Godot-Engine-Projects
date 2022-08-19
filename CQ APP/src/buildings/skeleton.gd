extends Building


onready var lvl_3_image: = preload("res://assets/images/towers/skeleton/skeleton_3.png")
onready var lvl_4_image: = preload("res://assets/images/towers/skeleton/skeleton_4.png")
onready var lvl_5_image: = preload("res://assets/images/towers/skeleton/skeleton_5.png")
onready var lvl_6_image: = preload("res://assets/images/towers/skeleton/skeleton_6.png")

onready var lvl_3_image_down: = preload("res://assets/images/towers/skeleton/skeleton_3_down.png")
onready var lvl_4_image_down: = preload("res://assets/images/towers/skeleton/skeleton_5_down.png")
onready var lvl_5_image_down: = preload("res://assets/images/towers/skeleton/skeleton_4_down.png")
onready var lvl_6_image_down: = preload("res://assets/images/towers/skeleton/skeleton_6_down.png")

var is_down : bool = false
onready var images_of_lvls_down = [lvl_3_image_down,
		lvl_3_image_down,
		lvl_3_image_down,
		lvl_4_image_down,
		lvl_5_image_down,
		lvl_6_image_down]

func _ready() -> void:
	building_name = "Skeleton"
	shots_per_attack = 1
	turns_before_attack_max = 3
	turns_before_attack_min = 1
	set_turns_left_before_attack()
	lvls_stats = [
	{"hp": 30, "dmg" : 60},
	{"hp": 60, "dmg" : 90},
	{"hp": 110, "dmg" : 130},
	{"hp": 170, "dmg" : 170},
	{"hp": 300, "dmg" : 220},
	{"hp": 430, "dmg" : 280},
	{"hp": 650, "dmg" : 360},
	{"hp": 1000, "dmg" : 450}]
	lvl_changed(1)
	images_of_lvls[0] = lvl_3_image
	images_of_lvls[1] = lvl_3_image
	images_of_lvls[2] = lvl_3_image
	images_of_lvls[3] = lvl_4_image
	images_of_lvls[4] = lvl_5_image
	images_of_lvls[5] = lvl_6_image


func hp_changed(new_value):
	if hp <= 0:
		return
	if is_down:
		new_value = hp - (hp - new_value) / 10
	hp = new_value
	n_hp.text = str(hp)
	n_bar.value = hp
	if hp <= 0:
		if not get_parent().get_parent().globals["see_dead_buildings"]:
			emit_signal("building_deleted", get_index(), -hp)


func get_state() -> Array:
	var a: Array = [stacked_fire.duplicate(), turns_left_before_attack, hp, lvl, got_fired_this_turn, got_frozen_this_turn, delayed_damage.duplicate(), delayed_fire.duplicate(), is_down]
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
	is_down = a[8]
	state_changed()


func state_changed():
	if is_down:
		texture_normal = images_of_lvls_down[lvl -1]
	else:
		texture_normal = images_of_lvls[lvl - 1]


func get_fire(damage_per_turn : int, turns : int):
	if is_down:
		return
	if not got_fired_this_turn:
		stacked_fire.append([damage_per_turn, turns])
		got_fired_this_turn = true


func _on_Skeleton_building_pressed(_x) -> void:
	is_down = not is_down
	state_changed()
