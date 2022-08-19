extends Node2D

onready var n_enemies1: = $EnemiesGroup1
onready var n_enemies2: = $EnemiesGroup2
onready var n_path1: = $Path1
onready var n_path2: = $Path2
onready var n_gold: = $CanvasLayer/LevelUI/UI/HBoxContainer/Gold/Value
onready var n_lifes: = $CanvasLayer/LevelUI/UI/HBoxContainer/Lifes/Value
onready var n_waves: = $CanvasLayer/LevelUI/UI/Waves/Value
onready var n_spawn_tour_delay: = $SpawnToursDelay
onready var n_next_wave_delay: = $NextWaveDelay
onready var n_spawn_enemies_delay: = $SpawnEnemiesDelay
onready var n_lose: = $CanvasLayer/LevelUI/Lose
onready var n_next_wave_button: = $CanvasLayer/NextWaveButton
onready var n_next_wave_button2: = $CanvasLayer/NextWaveButton2
onready var n_wave_coming_1: = $CanvasLayer/NextWaveButton/WaveComing
onready var n_wave_coming_2: = $CanvasLayer/NextWaveButton2/WaveComing
onready var n_wave_time_left = $CanvasLayer/NextWaveButton/CircleArc
onready var n_wave_time_left2 = $CanvasLayer/NextWaveButton2/CircleArc

# enemies for this lvl
onready var enemy1: = preload("res://src/Enemies/Enemy.tscn")

# distance of the paths
onready var path1_d: float = path_distance(n_path1)
onready var path2_d: float = path_distance(n_path2)



onready var waves: Array = [
# wave1
		{ "wave" : [
		{"enemy" : enemy1, "enemies_left" : 8, "enemy_group" : n_enemies1, "start_position" : n_path1.points[0]}, 
		{"enemy" : enemy1, "enemies_left" : 6, "enemy_group" : n_enemies2, "start_position" : n_path2.points[0]}],
		"time_before_next_wave" : 3,},
# wave2
		{ "wave" : [
		{"enemy" : enemy1, "enemies_left" : 8, "enemy_group" : n_enemies1, "start_position" : n_path1.points[0]}, 
		{"enemy" : enemy1, "enemies_left" : 6, "enemy_group" : n_enemies2, "start_position" : n_path2.points[0]}],
		"time_before_next_wave" : 6,},
# wave3
		{ "wave" : [
		{"enemy" : enemy1, "enemies_left" : 8, "enemy_group" : n_enemies1, "start_position" : n_path1.points[0]}, 
		{"enemy" : enemy1, "enemies_left" : 6, "enemy_group" : n_enemies2, "start_position" : n_path2.points[0]}],
		"time_before_next_wave" : 0,},
		]


onready var waves_nr: int = len(waves)

var current_wave: int = 0
var current_spawns: int = 0

var enemies_waves : Array = []

func _ready() -> void:
	n_lifes.text = "200"
	n_enemies1.position = n_path1.position
	n_enemies2.position = n_path2.position
	n_waves.text = "Wave: 1/" + str(waves_nr)
	connect_signals_to_level_ui()
	# return result in enemies_waves var
	get_enemies_left()
	add_enemies_name()
	set_process(false)


func _physics_process(delta: float) -> void:
	for enemy in n_enemies1.get_children():
		move_along_the_path(enemy, delta, n_path1.points)
	for enemy in n_enemies2.get_children():
		move_along_the_path(enemy, delta, n_path2.points)


func _process(delta: float) -> void:
	var percent_remain: float = (n_next_wave_delay.time_left / n_next_wave_delay.wait_time)
	n_wave_time_left.percent_remain(percent_remain)
	n_wave_time_left2.percent_remain(percent_remain)


func add_enemy_to_path(enemy : Enemy, enemy_group : Node2D, start_position : Vector2) -> void:
	if enemy_group.name == "EnemiesGroup1":
		enemy.distance_before_finish = path1_d
	else:
		enemy.distance_before_finish = path2_d
	enemy_group.add_child(enemy)
	enemy.position = start_position
	enemy.connect("died", self, "on_enemy_died")


func move_along_the_path(enemy : Enemy, delta : float, points : Array) -> void:
	# if is going to last point, check if reached it
	if len(points) - 2 == enemy.last_point_passed:
		if close(enemy.position, points[-1], enemy.speed * 3):
			enemy.queue_free()
			n_lifes.text = str(int(n_lifes.text) - enemy.enemy_value)
			if int(n_lifes.text) <= 0:
				lost()
				get_tree().paused = true
			return
	if close(enemy.position, points[enemy.last_point_passed + 1], enemy.speed):
		enemy.last_point_passed += 1
	var vel: Vector2 = (points[enemy.last_point_passed + 1] - points[enemy.last_point_passed]).normalized() * enemy.speed * delta
	enemy.position += vel
	enemy.distance_before_finish -= vel.length()
	enemy.n_debug_position.text = "pos: " + str(int(enemy.distance_before_finish / 30) * 30)


func connect_signals_to_level_ui() -> void:
	n_lose.get_node("Menu/Buttons/PlayAgain").connect("pressed", self, "restart")
	n_lose.get_node("Menu/Buttons/Quit").connect("pressed", self, "quit")


func restart() -> void:
	current_wave = 0
	current_spawns = 0
	n_lifes.text = "20"
	n_waves.text = "Wave: 1/" + str(waves_nr)
	n_lose.visible = false
	get_tree().paused = false
	delete_children(n_enemies1)
	delete_children(n_enemies2)
	set_enemies_left()
	n_spawn_enemies_delay.start()


func quit() -> void:
	get_tree().change_scene("res://src/UI/LevelsMenu.tscn")
	queue_free()
	get_tree().paused = false


func lost() -> void:
	n_lose.visible = true

#################################
# finished functions (probably) #
#################################

# not efficient but it's called only one time when lvl is loaded
func add_enemies_name() -> void:
	for wave in waves:
		for turn in wave["wave"]:
			turn["enemy_name"] = turn["enemy"].instance().enemy_name


func path_distance(path : Line2D) -> float:
	var d: float = 0
	var i: int = 1
	while i < len(path.points):
		d += (path.points[i] - path.points[i - 1]).length()
		i += 1
	return d


func _on_SpawnEnemiesDelay_timeout() -> void:
	if waves[current_wave]["wave"][current_spawns].enemies_left == 0:
		current_spawns += 1
		if current_spawns >= len(waves[current_wave]["wave"]):
			current_spawns = 0
			current_wave += 1
			n_spawn_enemies_delay.stop()
			if current_wave >= len(waves):
				return # TODO : WON
			dc()
			n_next_wave_delay.wait_time = waves[current_wave - 1]["time_before_next_wave"];
			n_next_wave_delay.start()
			n_waves.text = "Wave:" + str(current_wave + 1) + "/" + str(waves_nr)
			return
		n_spawn_enemies_delay.stop()
		n_spawn_tour_delay.start()
		return

	add_enemy_to_path(
		waves[current_wave]["wave"][current_spawns].enemy.instance(),
		waves[current_wave]["wave"][current_spawns].enemy_group,
		waves[current_wave]["wave"][current_spawns].start_position)
	waves[current_wave]["wave"][current_spawns].enemies_left -= 1


func _on_SpawnToursDelay_timeout() -> void:
	n_spawn_tour_delay.stop()
	n_spawn_enemies_delay.start()


func _on_NextWaveDelay_timeout() -> void:
	n_next_wave_delay.stop()
	n_spawn_enemies_delay.start()
	n_next_wave_button.visible = false
	n_next_wave_button2.visible = false
	set_process(false)


func dc() -> void:
	n_wave_coming_1.text = ""
	n_wave_coming_2.text = ""
	for turn in waves[current_wave]["wave"]:
		if turn["enemy_group"] == n_enemies1:
			n_next_wave_button.visible = true
			n_wave_coming_1.text += turn["enemy_name"] + " x " + str(turn["enemies_left"]) + "\n"
		else:
			n_wave_coming_2.text += turn["enemy_name"] + " x " + str(turn["enemies_left"]) + "\n"
			n_next_wave_button2.visible = true
	set_process(true)


func on_enemy_died(enemy : Enemy) -> void:
	n_gold.text = str(int(n_gold.text) + enemy.gold_value)


func close(vec1 : Vector2, vec2 : Vector2, speed : int) -> bool:
	return vec1.distance_to(vec2) < speed / 100.0


func delete_children(node) -> void:
	for n in node.get_children():
		n.queue_free()


func get_enemies_left() -> void:
	for wave in waves:
		for tour in wave["wave"]:
			enemies_waves.append(tour.enemies_left)


func set_enemies_left() -> void:
	var i: int = 0
	for wave in waves:
		for tour in wave:
			tour.enemies_left = enemies_waves[i]
			i += 1


func _on_NextWaveButton_mouse_entered() -> void:
	n_wave_coming_1.visible = true


func _on_NextWaveButton_mouse_exited() -> void:
	n_wave_coming_1.visible = false


func _on_NextWaveButton2_mouse_entered() -> void:
	n_wave_coming_2.visible = true


func _on_NextWaveButton2_mouse_exited() -> void:
	n_wave_coming_2.visible = false


func next_wave_pressed() -> void:
	var time_left : float = n_next_wave_delay.time_left
	_on_NextWaveDelay_timeout()
	# TODO : give bonus money based on time_left


####################
# unused functions #
####################
func get_visible_children(node : Node) -> Array:
	var visible_nodes: Array = []
	for child in node.get_children():
		if child.visible:
			visible_nodes.append(child)
	return visible_nodes
