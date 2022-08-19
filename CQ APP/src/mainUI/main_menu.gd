extends Control

onready var n_settings: = $SettingsMenu
onready var n_stats: = $Stats
onready var n_starting_animaion: = $StartingAnimation
onready var n_first_time_using_the_app: = $FirstTimeUsingTheApp
onready var n_item_activation: = $HBoxContainer/VBoxContainer/ItemActivationButton
onready var n_delete_troop: = $HBoxContainer/VBoxContainer2/DeleteTroopButton
onready var n_nav2d: = $CenterPos/Navigation2D
onready var n_map: = $MapContainer
onready var n_buildings_map: = $BuildingsContainer
onready var n_troops: = $SelectionTab/Troops/Troops
onready var n_buildings_1: = get_node("SelectionTab/Buildings/1/Buildings")
onready var n_buildings_2: = get_node("SelectionTab/Buildings/2/Buildings")
onready var n_buildings_3: = get_node("SelectionTab/Buildings/3/Buildings")
onready var n_buildings_4: = get_node("SelectionTab/Buildings/4/Buildings")
onready var n_buildings_5: = get_node("SelectionTab/Buildings/5/Buildings")
onready var n_buildings_6: = get_node("SelectionTab/Buildings/6/Buildings")
onready var n_buildings_7 = get_node("SelectionTab/Buildings/7/Buildings")
onready var n_buildings_8: = get_node("SelectionTab/Buildings/8/Buildings")
onready var n_unit_proprieties: = $SettingsMenu/VBoxContainer/UnitProprieties
onready var n_utilities: = $UtilityContainer
onready var n_info_menu: = $InfoMenu
onready var n_redo: = $Redo
onready var n_on_troop_attack_timer: = $OnTroopAttackTimer
onready var n_play_single_troops: = $PlaySingleTroops
onready var n_troops_count: = $TroopsCount
onready var n_rune_log_text : = $RunesLog/Text
onready var n_runes_log : = $RunesLog
onready var runes_log_scrollbar = n_runes_log.get_v_scrollbar()
onready var save_containter : = $SaveContainer
onready var load_container_files : = $LoadContainer/Files

onready var clash_regular_16 = preload("res://assets/fonts/Clash-Regular-16.tres")
onready var utilities: Array = [$UtilityContainer/Fireball,
		$UtilityContainer/Rocket,
		$UtilityContainer/Zap,
		$UtilityContainer/Log,
		$UtilityContainer/Bless,
		$UtilityContainer/Earthquake,
		$UtilityContainer/Swap,
		$UtilityContainer/Charge,
		$UtilityContainer/Rush,
		$UtilityContainer/Retreat,
		$UtilityContainer/Frontline,
		$UtilityContainer/Switch]
onready var troops: Array = [preload("res://src/troops/Archer.tscn"), 
		preload("res://src/troops/Barbarian.tscn"),
		preload("res://src/troops/Wizard.tscn"),
		preload("res://src/troops/Prince.tscn"),
		preload("res://src/troops/Giant.tscn"),
		preload("res://src/troops/Goblin.tscn"),
		preload("res://src/troops/Pekka.tscn"),
		preload("res://src/troops/Bomber.tscn"),
		preload("res://src/troops/BabyDragon.tscn"),
		preload("res://src/troops/Minion.tscn"),
		preload("res://src/troops/BombMiner.tscn")
		]
onready var buildings: Array = [preload("res://src/buildings/Cannon.tscn"),
		preload("res://src/buildings/WizardTower.tscn"),
		preload("res://src/buildings/ArcherTower.tscn"),
		preload("res://src/buildings/Mortar.tscn"),
		preload("res://src/buildings/XBow.tscn"),
		preload("res://src/buildings/InfernoTower.tscn"),
		preload("res://src/buildings/Tesla.tscn"),
		preload("res://src/buildings/Furnace.tscn"),
		preload("res://src/buildings/GoblinHut.tscn"),
		preload("res://src/buildings/AirDefence.tscn"),
		preload("res://src/buildings/GoldStorage.tscn"),
		preload("res://src/buildings/Wall.tscn"),
		preload("res://src/buildings/DuneDragon.tscn"),
		preload("res://src/buildings/Skeleton.tscn")
		]
onready var buildings_name = [
		"Cannon",
		"Wizard Tower",
		"Archer Tower",
		"Mortar",
		"X Bow",
		"Inferno Tower",
		"Tesla",
		"Furnace",
		"Goblin Hut",
		"Air Defence",
		"Gold Storage",
		"Wall",
		"Dune Dragon",
		"Skeleton"
]
onready var blue_circle: = preload("res://assets/images/other/blue_circle.png")
onready var nav_resource: NavigationPolygon = preload("res://src/navigations resources/new_navigationpolygon.tres")
onready var trash_can_icon: = preload("res://assets/images/other/trash.png")
#onready var debug: = preload("res://assets/images/other/fog.png")

var units_stats_file: String = OS.get_user_data_dir() + "units_stats.txt"
var globals_file: String = OS.get_user_data_dir() +  "globals.txt"
var maps_file: String = OS.get_user_data_dir() + "/"


var current_troop: int = 0
var current_building: int = 14
var current_utility: Utility = null

var free_tile_script: Script = preload("res://src/mainUI/free_tile.gd")
var buildings_group: ButtonGroup = preload("res://src/groups/map_buildings_group.tres")

var hover_started: bool = false

var nr_buildings: int
var nr_troops: int 
var nr_utilities : int
var nr_spells : int

var data_to_delete : int = 1
var undo_to_delete : int = 1

var map_area: Vector2
var mode = modes.SIMULATING
var max_scroll = 0
var building_turn : Building = null

enum modes {
	SIMULATING,
	PLAYING
}

var globals: Dictionary = {"first time using the app" : true,
		"see_dead_buildings" : false,
		"deselect_book/spells_manually" : false,
		"spells" : [10, 10, 10, 10, 10, 10],
		"only_1_troop_attacks" : false,
		"show_hp" : false
		}


enum directions {
	LEFT,
	RIGHT,
	UP,
	DOWN
}


func _ready() -> void:
	n_buildings_1.get_child(0).get_child(0).pressed = true
	n_troops.get_child(0).get_child(0).pressed = true
	nr_buildings = len(buildings)
	nr_troops = len(troops)
	nr_utilities = len(utilities)
	nr_spells = nr_utilities / 2
	connect_nodes()
	var file: File = File.new()
	if file.file_exists(units_stats_file):
		n_unit_proprieties.troops = load_json_data(units_stats_file)
	n_unit_proprieties.on_troop_changed("Archer")
	set_process_input(false)
	if file.file_exists(globals_file):
		globals = load_json_data(globals_file)
#	prints(globals)
	load_settings()
	randomize()
	runes_log_scrollbar.connect("changed", self, "scroll_to_bottom")
	max_scroll = runes_log_scrollbar.max_value 
	create_map_buttons()

func scroll_to_bottom(): 
	if max_scroll != runes_log_scrollbar.max_value:
		max_scroll = runes_log_scrollbar.max_value
		n_runes_log.scroll_vertical = runes_log_scrollbar.max_value


func load_settings():
	n_settings.get_node("VBoxContainer/SeeDeadBuildingsCheckButton").pressed = globals["see_dead_buildings"]
	n_settings.get_node("VBoxContainer/DeselectUtilityCheckButton").pressed = globals["deselect_book/spells_manually"]
	n_settings.get_node("VBoxContainer/SeeTheTroopsAttackingCheckButton").pressed = globals["only_1_troop_attacks"]
	n_settings.get_node("VBoxContainer/ShowHpOfTroopsAsNumbers").pressed = globals["show_hp"]
	for i in range(5):
		n_utilities.get_child(i).change_lvl(globals["spells"][i])


func _input(event : InputEvent) -> void:
	if event.is_action_released("left_click"):
		hover_started = false
		reset_combos_values()
		set_process_input(false)


func on_troop_hovered(index : int) -> void:
	if hover_started:
		set_combos_values(index)


func on_hover_started(index : int) -> void:
	hover_started = true
	set_process_input(true)
	set_combos_values(index)


func on_tile_of_troops_pressed(tile : int, custom_troop_index: int = -1, load_state_troop: Array = []) -> void:
	if current_troop == -1 and custom_troop_index == -1:
		return # TODO: Warning, no troop selected
	if current_utility and current_utility.name == "Swap" and custom_troop_index == -1:
		current_utility.action(n_map, tile)
		return
	var free_tile: = n_map.get_child(tile)
	n_map.remove_child(free_tile)
	free_tile.queue_free()
	var new_child: Troop = create_troop(custom_troop_index)
	if custom_troop_index == -1:
		#n_redo.action("create troop", [tile, current_troop])
		pass
	n_map.add_child(new_child)
	n_map.move_child(new_child, tile)
	if load_state_troop != []:
		new_child.load_state(load_state_troop)
	
	if not globals["show_hp"]:
		new_child.n_hp.visible = false
	new_child.connect("troop_deleted", self, "delete_troop")
	new_child.connect("troop_pressed", self, "on_troop_pressed")
	new_child.connect("troop_hovered", self, "on_troop_hovered")
	new_child.connect("hover_started", self, "on_hover_started")


func path(a):
	$CenterPos/Position2D/Line2D.points = a


func on_tile_of_buildings_pressed(tile : int, custom_building : int = -1, load_building_state : Array = []) -> void:
	if current_building == -1 and custom_building == -1:
		return # TODO: Warning, no building selected
	if current_utility and current_utility.area_action == current_utility.area.BUILDINGS and custom_building == -1:
		save_state()
		current_utility.action(n_buildings_map, tile)
		return
	
	if custom_building == -1:
		custom_building = current_building
		#n_redo.action("create building", [tile, custom_building])
		pass
	var free_tile: = n_buildings_map.get_child(tile)
	n_buildings_map.remove_child(free_tile)
	free_tile.queue_free()
	var new_child: Building = create_building(custom_building)
	n_buildings_map.add_child(new_child)
	n_buildings_map.move_child(new_child, tile)
	n_nav2d.remove_square(tile)
	new_child.lvl = custom_building / nr_buildings
	if load_building_state != []:
		new_child.load_state(load_building_state)
	new_child.connect("building_deleted", self, "delete_building")
	new_child.connect("building_pressed", self, "on_building_pressed")


func on_troop_pressed(index : int) -> void:
	if current_utility != null:
		if current_utility.utility_name == "Charge":
			save_state()
		current_utility.action(n_map, index)
	else:
		save_state()
		set_combos_values(index)
		for i in range(4):
			for j in range(4):
				var troop = n_map.get_child(j * 4 + i)
				if troop is Troop:
					if troop.current_combo:
						var combo = troop.combo_value
						troop.attack(n_buildings_map)
						if globals["only_1_troop_attacks"]:
							data_to_delete = combo
							n_on_troop_attack_timer.start()
							return
		fill_the_board()
		set_combos_values2(index)
		next_turn()
		set_combos_values2(index)
		# after troops attacked, fill the board
		fill_the_board()


func on_1_troop_attack() -> void:
	save_state()
	undo_to_delete += 1
	for i in range(4):
		for j in range(4):
			var troop = n_map.get_child(j * 4 + i)
			if troop is Troop:
				if troop.current_combo:
					troop.attack(n_buildings_map)
					return
	next_turn()
	# after troops attacked, fill the board
	fill_the_board()
	n_redo.remove_last(data_to_delete)
	data_to_delete = 1
	n_on_troop_attack_timer.stop()


func fill_the_board() -> void:
	move_the_troops()
	if mode == modes.PLAYING:
		var troops_values : Array = [int(n_troops_count.get_node("TroopCount1").text), int(n_troops_count.get_node("TroopCount2").text),
				int(n_troops_count.get_node("TroopCount3").text), int(n_troops_count.get_node("TroopCount4").text)]
		if troops_values[0] + troops_values[1] + troops_values[2] + troops_values[3] == 0:
			return
		var free_spaces: int = 0
		for i in range(16):
			if map_area.x == 3:
				if (i + 1) % 4 == 0:
					continue
			if map_area.y == 3:
				if i > 11:
					continue
			if not n_map.get_child(i) is Troop:
				free_spaces += 1
		for _i in range(free_spaces):
			var random_number: int = get_random_number(free_spaces) + 1
			#print(random_number, " ", free_spaces)
			var k : int = 0
			if troops_values[0] + troops_values[1] + troops_values[2] + troops_values[3] == 0:
				break
			for j in range(16):
				if map_area.x == 3:
					if (j + 1) % 4 == 0:
						continue
				if map_area.y == 3:
					if j > 11:
						continue
				if not n_map.get_child(j) is Troop:
					k += 1
					if k == random_number:
						var troop_id : int = select_a_troop(troops_values)
						troops_values[troop_id] -= 1
						on_tile_of_troops_pressed(j, n_troops_count.get_node("TroopOption" + str(troop_id + 1)).current_troop)
						break
			free_spaces -= 1
		for i in range(1, 5):
			n_troops_count.get_node("TroopCount" + str(i)).text = str(troops_values[i - 1])
	move_the_troops()


func rune_activated(text):
	n_rune_log_text.text += text + "\n"
	#n_runes_log.scroll_vertical = n_runes_log.get_v_scrollbar().max_value


func get_random_number(x : int) -> int:
	randomize()
	return randi() % x


func select_a_troop(troop_values : Array) -> int:
	var s: int = 0
	for i in troop_values:
		s += i
	var random_number : int = get_random_number(s) + 1
	var x : int = 0
	for i in troop_values:
		random_number -= i
		if random_number <= 0:
			return x
		x += 1
	print("ERROR, function: select_a_troop")
	return 0


func move_the_troops() -> void:
	var id = 4
	while id < 16:
		for i in range(4):
			var id2 = id + i
			if n_map.get_child(id2) is Troop:
				while id2 >= 4 and not n_map.get_child(id2 - 4) is Troop:
					n_utilities.get_node("Swap").swap(n_map, id2 - 4, id2)
					id2 -= 4
		id += 4
	


func single_troop_attack(id):
	var troop : Troop = n_map.get_child(id)
	troop.attack(n_buildings_map)


func save_state(on_undo_or_redo: bool = false) -> void:
	n_stats.get_node("Wasted/Damage").text = "0"
	var troops_map : Array = []
	var buildings_map : Array = []
	var troops_values : Array = [int(n_troops_count.get_node("TroopCount1").text), int(n_troops_count.get_node("TroopCount2").text),
				int(n_troops_count.get_node("TroopCount3").text), int(n_troops_count.get_node("TroopCount4").text)]
	for i in range(16):
		var child = n_map.get_child(i)
		if child is Troop:
			troops_map.append([child.get_state(), n_unit_proprieties.troops_names.find(child.troop_name)])
		else:
			troops_map.append([])
	for i in range(24):
		var child = n_buildings_map.get_child(i)
		if child is Building:
			var child_state: Array = child.get_state()
			buildings_map.append([child_state, buildings_name.find(child.building_name) + nr_buildings * child_state[3]])
		else:
			buildings_map.append([])
	var map : Array = [troops_map, buildings_map, troops_values, n_troops_count.get_troops_index()]
	n_redo.action("turn passed", map, on_undo_or_redo)


func change_map(last_map : Array):
	for i in range(16):
		var troop = last_map[0][i]
		if troop != []:
			on_tile_of_troops_pressed(i, troop[1], troop[0])
		else:
			delete_troop(i)
	for i in range(24):
		var building = last_map[1][i]
		if building != []:
			on_tile_of_buildings_pressed(i, building[1], building[0].duplicate())
		else:
			delete_building(i)
	for i in range(1, 5):
		n_troops_count.get_node("TroopOption" + str(i)).change_current_troop(last_map[3][i - 1])
		n_troops_count.get_node("TroopCount" + str(i)).text = str(last_map[2][i - 1])
	on_troop_proprieties_changed()
	$LoadContainer.visible = false


func next_turn():
	for i in range(4):
		for j in range(6):
			var building = n_buildings_map.get_child(i + j * 4)
			if building is Building:
				building_turn = building
				building.on_turn_passed()
	for i in range(4):
		for j in range(4):
			var troop = n_map.get_child(i + j * 4)
			if troop is Troop:
				troop.on_turn_passed(n_buildings_map)


func on_building_pressed(building : Building) -> void:
	if current_utility and current_utility.area_action == current_utility.area.BUILDINGS:
		save_state()
		current_utility.action(n_buildings_map, building.get_index())


func create_troop(custom_troop_index : int) -> Troop:
	if custom_troop_index == -1:
		custom_troop_index = current_troop
	var new_troop : Troop = troops[custom_troop_index].instance()
	var troop_name: String = n_unit_proprieties.troops_names[custom_troop_index]
	var current_item_index: int = n_unit_proprieties.troops[troop_name]["item"]
	
	new_troop.item_lvl = n_unit_proprieties.troops[troop_name]["items_lvl"][current_item_index]
	new_troop.item = current_item_index + 1
	new_troop.rune_lvl = n_unit_proprieties.troops[troop_name]["rune_lvl"]
	new_troop.level = n_unit_proprieties.troops[troop_name]["lvl"]
	return new_troop


func create_building(custom_building : int) -> Building:
	var new_building: Building = buildings[custom_building % nr_buildings].instance()
	return new_building


func delete_troop(id : int, redo : bool = true) -> void:
	var child = n_map.get_child(id)
	if redo:
		#n_redo.action("delete troop", [id, n_unit_proprieties.troops_names.find(child.troop_name)])
		pass
	n_map.remove_child(child)
	child.queue_free()
	var new_texture_button: TextureButton = create_texture_button()
	n_map.add_child(new_texture_button)
	n_map.move_child(new_texture_button, id)
	new_texture_button.connect("empty_tile_pressed", self, "on_tile_of_troops_pressed")


func delete_building(id : int, hp = 0) -> void:
	n_stats.get_node("Wasted/Damage").text = str(int(n_stats.get_node("Wasted/Damage").text) + hp)
	var child = n_buildings_map.get_child(id)
	n_buildings_map.remove_child(child)
	child.queue_free()
	n_nav2d.add_square(id)
	var new_texture_button: TextureButton = create_texture_button()
	n_buildings_map.add_child(new_texture_button)
	n_buildings_map.move_child(new_texture_button, id)
	new_texture_button.connect("empty_tile_pressed", self, "on_tile_of_buildings_pressed")


func create_texture_button() -> TextureButton:
	var new_texture_button: TextureButton = TextureButton.new()
	new_texture_button.expand = true
	new_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	new_texture_button.texture_hover = blue_circle
	#new_texture_button.texture_normal = debug
	new_texture_button.rect_min_size = Vector2(84, 63)
	new_texture_button.set_script(free_tile_script)
	return new_texture_button


func on_troop_button_pressed(index : int) -> void:
	current_troop = index


func on_building_button_pressed(index : int, lvl : int) -> void:
	current_building = index + lvl * nr_buildings


func on_utility_button_selected(index) -> void:
	current_utility = utilities[index]


func on_utility_button_deselected() -> void:
	current_utility = null


func on_spell_lvl_changed(index, level) -> void:
	globals["spells"][index] = level


func connect_nodes() -> void:
	for i in range(16):
		n_map.get_child(i).connect("empty_tile_pressed", self, "on_tile_of_troops_pressed")
	for i in range(24):
		n_buildings_map.get_child(i).connect("empty_tile_pressed", self, "on_tile_of_buildings_pressed")
	for i in range(nr_troops):
		n_troops.get_child(i).get_child(0).connect("pressed", self, "on_troop_button_pressed", [i])
	for i in range(nr_utilities):
		n_utilities.get_child(i).connect("selected", self, "on_utility_button_selected", [i])
		n_utilities.get_child(i).connect("deselected", self, "on_utility_button_deselected")
	for i in range(nr_buildings):
		n_buildings_1.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 1])
		n_buildings_2.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 2])
		n_buildings_3.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 3])
		n_buildings_4.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 4])
		n_buildings_5.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 5])
		n_buildings_6.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 6])
		n_buildings_7.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 7])
		n_buildings_8.get_child(i).get_child(0).connect("pressed", self, "on_building_button_pressed", [i, 8])
		
	for i in range(nr_spells):
		n_utilities.get_child(i).connect("spell_lvl_changed", self, "on_spell_lvl_changed")
	n_unit_proprieties.get_node("SaveButton").connect("pressed", self, "on_UnitProprieties_SaveButton_pressed")
	n_unit_proprieties.connect("troop_proprieties_changed", self, "on_troop_proprieties_changed")
	n_redo.connect("change_map", self, "change_map")
	n_utilities.get_child(n_utilities.get_node("Rush").get_index()).connect("attack", self, "single_troop_attack")
	n_troops_count.get_node("HBoxContainer/StartButton").connect("pressed", self, "on_start_pressed")


func on_start_pressed() -> void:
	map_area = Vector2(int(n_troops_count.get_node("HBoxContainer/AreaX").text), int(n_troops_count.get_node("HBoxContainer/AreaY").text))
	mode = modes.PLAYING
	fill_the_board()



func on_troop_proprieties_changed() -> void:
	for troop in n_map.get_children():
		if troop is Troop:
			troop.item_lvl = n_unit_proprieties.troops[troop.troop_name]["items_lvl"][n_unit_proprieties.troops[troop.troop_name]["item"]]
			troop.item = n_unit_proprieties.troops[troop.troop_name]["item"] + 1
			troop.level = n_unit_proprieties.troops[troop.troop_name]["lvl"]
			troop.rune_lvl = n_unit_proprieties.troops[troop.troop_name]["rune_lvl"]
			troop.item_changed()


func on_troop_stats_changed(status : String) -> void:
	for troop in n_map.get_children():
		if troop is Troop:
			if status == "show_hp":
				troop.n_hp.visible = globals["show_hp"]



func set_combos_values(index) -> void:
	reset_combos_values()
	var points: Array = [index]
	var new_points: Array = []
	var all_points: Array = []
	var combo_value: int = 1
	var principal_troop_name: String = n_map.get_child(index).troop_name
	n_map.get_child(index).current_combo = true
	while points != []:
		for point in points:
			all_points.append(point)
			for i in range(4):
				var troop : Troop = get_troop(point, i)
				if troop and not troop.current_combo:
					if troop.troop_name == principal_troop_name:
						troop.current_combo = true
						combo_value += 1
						new_points.append(troop.get_index())
		points = new_points.duplicate()
		new_points = []
	for i in all_points:
		n_map.get_child(i).combo_value = combo_value


func set_combos_values2(index : int = 0) -> void:
	reset_combos_values()
	var entire_field: Array = [0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0]
	var free_spaces: int = 16
	for g in range(16):
		if entire_field[g] == 1:
			continue
		if n_map.get_child(g).texture_normal == null:
			entire_field[g] = 1
			continue
		var points: Array = [g]
		var new_points: Array = []
		var all_points: Array = []
		var combo_value: int = 1
		var principal_troop_name: String = n_map.get_child(g).troop_name
		n_map.get_child(g).current_combo2 = true
		while points != []:
			for point in points:
				all_points.append(point)
				for i in range(4):
					var troop : Troop = get_troop(point, i)
					if troop and not troop.current_combo2:
						if troop.troop_name == principal_troop_name:
							troop.current_combo2 = true
							combo_value += 1
							new_points.append(troop.get_index())
			points = new_points.duplicate()
			new_points = []
		for i in all_points:
			entire_field[i] = 1
			n_map.get_child(i).combo_value = combo_value




func get_troop(index : int, direction: int) -> Troop:
	if direction == directions.UP:
		if index - 4 >= 0:
			if not n_map.get_child(index - 4) is Troop:
				return null
			var troop: Troop = n_map.get_child(index - 4)
			return troop
	if direction == directions.DOWN:
		if index + 4 < 16:
			if not n_map.get_child(index + 4) is Troop:
				return null
			var troop: Troop = n_map.get_child(index + 4)
			return troop
	if direction == directions.LEFT:
		if index % 4 != 0:
			if not n_map.get_child(index - 1) is Troop:
				return null
			var troop: Troop = n_map.get_child(index - 1)
			return troop
	if direction == directions.RIGHT:
		if (index + 1) % 4 != 0:
			if not n_map.get_child(index + 1) is Troop:
				return null
			var troop: Troop = n_map.get_child(index + 1)
			return troop
	return null

func reset_combos_values() -> void:
	for troop in n_map.get_children():
		if troop is Troop:
			troop.combo_value = 1
			troop.current_combo = false
			troop.current_combo2 = false


func on_UnitProprieties_SaveButton_pressed() -> void:
	save(JSON.print(n_unit_proprieties.troops, "\t"), units_stats_file)
	_on_MainMenu_tree_exited()


func load_json_data(file_name : String) -> Dictionary:
	var file: File = File.new()
	file.open(file_name, File.READ)
	var content: String = file.get_as_text()
	file.close()
	return parse_json(content)

func load_var(file_name : String) :
	var file: File = File.new()
	file.open(file_name, File.READ)
	var content: Array = file.get_var()
	file.close()
	return content

# if the file it's json, add JSON.print(string, "\t") as content var
func save(content: String, file_name: String) -> void:
	var file: File = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(content)
	file.close()

func save_var(content, file_name: String) -> void:
	var file: File = File.new()
	file.open(file_name, File.WRITE)
	file.store_var(content)
	file.close()


func _on_InfoButton_pressed() -> void:
	n_info_menu.visible = true


func simulate_action(action : String, pressed : bool) -> void:
	var a = InputEventAction.new()
	a.action = action
	a.pressed = pressed
	Input.parse_input_event(a)

func _on_DeleteTroopButton_pressed() -> void:
	if n_delete_troop.pressed:
		simulate_action("ctrl", true)
	else:
		simulate_action("ctrl", false)
	if n_item_activation.pressed:
		n_item_activation.pressed = false
		simulate_action("alt", false)


func _on_ItemActivationButton_pressed() -> void:
	if n_item_activation.pressed:
		simulate_action("alt", true)
	else:
		simulate_action("alt", false)
	if n_delete_troop.pressed:
		n_delete_troop.pressed = false
		simulate_action("ctrl", false)


func _on_Button_pressed() -> void:
	globals["first time using the app"] = false
	save(JSON.print(globals, "\t"), globals_file)
	n_first_time_using_the_app.queue_free()


func _on_StartingAnimation_tree_exited() -> void:
	if globals["first time using the app"]:
		n_first_time_using_the_app.visible = true


func _on_BackButton_pressed() -> void:
	n_settings.visible = false


func _on_SettingsButton_pressed() -> void:
	n_settings.visible = true


func _on_SeeDeadBuildingsCheckButton_toggled(button_pressed: bool) -> void:
	globals["see_dead_buildings"] = button_pressed
	if globals["see_dead_buildings"] == false:
		for child in n_buildings_map.get_children():
			if child is Building:
				if child.hp <= 0:
					child.emit_signal("building_deleted", child.get_index())


func dir_contents(path):
	var dir = Directory.new()
	var folder_content = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				folder_content.append(file_name)
			file_name = dir.get_next()
		return folder_content
	else:
		print("An error occurred when trying to access the path.")


func _on_MainMenu_tree_exited() -> void:
	save(JSON.print(globals, "\t"), globals_file)


func _on_DeselectUtilityCheckButton_toggled(button_pressed: bool) -> void:
	globals["deselect_book/spells_manually"] = button_pressed
	


func _on_OnTroopAttackTimer_timeout() -> void:
	on_1_troop_attack()


func _on_ChangeStateButton_toggled(button_pressed: bool) -> void:
	if button_pressed: # paused
		n_on_troop_attack_timer.paused = true
	else:
		n_on_troop_attack_timer.paused = false


func _on_HSlider_value_changed(value: float) -> void:
	n_on_troop_attack_timer.wait_time = value / 1000.0
	n_play_single_troops.get_child(2).text = str(n_on_troop_attack_timer.wait_time) + "s"


func _on_PlayBackButton_pressed() -> void:
	if data_to_delete == 1:
		return
	n_redo.undo()
	undo_to_delete -= 1
	if undo_to_delete == 0:
		data_to_delete = 1
		undo_to_delete = 1


func _on_PlayNextButton_pressed() -> void:
	if data_to_delete == 1:
		return
	on_1_troop_attack()



func _on_SeeTheTroopsAttackingCheckButton_toggled(button_pressed: bool) -> void:
	globals["only_1_troop_attacks"] = button_pressed


func _on_ShowHpOfTroopsAsNumbers_toggled(button_pressed: bool) -> void:
	globals["show_hp"] = button_pressed
	on_troop_stats_changed("show_hp")


func _on_SaveMapButton_pressed() -> void:
	save_containter.visible = true


func _on_LoadMapButton_pressed() -> void:
	$LoadContainer.visible = true


func create_map_buttons():
	for file in dir_contents(OS.get_user_data_dir()):
		if file.ends_with(".map"):
			create_map_button(file.substr(0, len(file) - 4))
		

func create_map_button(name):
	var hboxconrtainer = HBoxContainer.new()
	var button = Button.new()
	var texture_button = TextureButton.new()
	texture_button.texture_normal = trash_can_icon
	button.text = name
	button.add_font_override("font", clash_regular_16)
	button.connect("pressed", self, "map_button_pressed", [name])
	texture_button.connect("pressed", self, "delete_map_pressed", [name])
	button.rect_min_size.y = 30
	button.rect_min_size.x = 170
	hboxconrtainer.add_child(button)
	hboxconrtainer.add_child(texture_button)
	load_container_files.add_child(hboxconrtainer)
	load_container_files.move_child(hboxconrtainer, 0)

func map_button_pressed(file_name : String):
	change_map(load_var(maps_file + file_name + ".map"))



func delete_map_pressed(name : String) -> void:
	
	for hboxcontainer in load_container_files.get_children():
		if hboxcontainer.get_child(0).text == name:
			hboxcontainer.queue_free()
			var dir = Directory.new()
			dir.remove(maps_file + name + ".map")
			return


func _on_SaveMapButton2_pressed() -> void:
	if save_containter.get_node("LineEdit").text == "":
		return
	var troops_map : Array = []
	var buildings_map : Array = []
	var troops_values : Array = [int(n_troops_count.get_node("TroopCount1").text), int(n_troops_count.get_node("TroopCount2").text),
				int(n_troops_count.get_node("TroopCount3").text), int(n_troops_count.get_node("TroopCount4").text)]
	
	for i in range(16):
		var child = n_map.get_child(i)
		if child is Troop:
			troops_map.append([child.get_state(), n_unit_proprieties.troops_names.find(child.troop_name)])
		else:
			troops_map.append([])
	for i in range(24):
		var child = n_buildings_map.get_child(i)
		if child is Building:
			var child_state: Array = child.get_state()
			buildings_map.append([child_state, buildings_name.find(child.building_name) + nr_buildings * child_state[3]])
		else:
			buildings_map.append([])
	var map : Array = [troops_map, buildings_map, troops_values, n_troops_count.get_troops_index()]
	create_map_button(save_containter.get_node("LineEdit").text)
	save_var(map, maps_file + save_containter.get_node("LineEdit").text + ".map")
	save_containter.get_node("LineEdit").text = ""
	save_containter.visible = false


func _on_CancelSaveMapButton_pressed() -> void:
	save_containter.get_node("LineEdit").text = ""
	save_containter.visible = false


func _on_CancelLoadingFilessButton_pressed() -> void:
	$LoadContainer.visible = false
