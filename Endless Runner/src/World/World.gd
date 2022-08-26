extends Node2D

onready var platform = preload("res://src/Objects/Platform.tscn")
onready var gem = preload("res://src/Drops/Gem.tscn")
onready var hearth = preload("res://src/Drops/Hearth.tscn")

onready var n_distance_value = $CanvasLayer/Control/HBoxContainer/DistanceValue
onready var n_score_value = $CanvasLayer/Control/HBoxContainer/ScoreValue


onready var current_tile = $TileMap.world_to_map($Camera2D.position)
onready var previous_tile
onready var next_appearance = current_tile.x + 1



class Obstacle:
	var data : Array
	var position : Vector2
	
	func _init(_data : Array, _position : Vector2) -> void:
		data = _data
		position = _position

var obs1 = Obstacle.new([
			[3, -1, -1, -1, -1, -1, -1, -1],
			[0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0],
				], Vector2(17, 7))

var obs2 = Obstacle.new([
		[-1, 3, 2, 2, 2, 2, -1, -1],
		[-1, 0, 0, 0, 0, 0, 0, -1],
		[-1, 0, 0, 0, 0, 0, 0, -1],
], Vector2(17, 4))

var obs3 = Obstacle.new([
	[-1, -1, -1, -1, -1,  0,  0, -1,  0,  0, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1,  0,  0, -1,  0,  0, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1,  0,  0, -1,  0,  0, -1, 3, -1, -1, -1],
	[-1, -1, 0,  0,  -1,  0,  0, -1,  0,  0, -1,  0,  0, -1, -1],
	[-1, -1, 0,  0,  -1,  0,  0, -1,  0,  0, -1,  0,  0, -1, -1],
	[-1, -1, 0,  0,  -1,  0,  0, -1,  0,  0, -1,  0,  0, -1, -1],
	[0, 0, 0,  0,  -1,  0,  0, -1,  0,  0, -1,  0,  0, 0, 0],
	[0, 0, 0,  0,  -1,  0,  0, -1,  0,  0, -1,  0,  0, 0, 0],
], Vector2(17, 2))

var obs4 = Obstacle.new([
	[-1, -1, -1, -1, -1, -1, 0, 0, 1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  -1, -1, 0, 0, 0, -1],
	[-1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1],
	[3, -1,  0,  0, -1, -1, 0, 0, -1, -1, -1, -1, -1,  2,  2,  2,  2, -1, -1, -1, -1, -1, -1, 0, 0, -1],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
], Vector2(17, 5))

var obs5 = Obstacle.new([
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, -1,  2,  2,  2, -1, -1, -1, -1, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, 0, 0, 0, 1, -1, -1, 0, 0, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, 0, 0, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ],
	[-1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, ],
	[-1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ],
	[3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ]
], Vector2(17, -7))

var obs6 = Obstacle.new([
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2, 2, 2, -1, -1, -1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  1, -1, -1,  0,  0,  1, -1, -1,  0,  0],
	[-1, -1, -1, -1, -1, -1, -1, -1,  0,  0, -1, -1, -1,  0,  0, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1,  0,  0, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1,  0,  0, -1, 2, 2, 2, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1,  0,  0, -1, -1, -1,  0,  0, 0, 0, 0, 0, 0],
	[-1, -1, -1, -1, -1, -1, -1, -1,  0,  0, -1, -1, -1,  0,  0, 0, 0, 0, 0, 0],
	[-1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, 0, 0, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
], Vector2(17, -7))


var obs7 = Obstacle.new([
	[-1, -1, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1],
	[-1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1,  2,  2, -1, -1,  2,  2, -1, -1, -1, -1],
	[ 0,  0, -1, -1,  0,  0, -1, -1,  0,  0, -1, -1,  0,  0],
	[ 0,  0, -1, -1,  0,  0, -1, -1,  0,  0, -1, -1,  0,  0]
], Vector2(17, 3))


var obs8 = Obstacle.new([
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, 2, 2, 2, 0, 0, 0, 0, 0, -1, -1, -1],
	[-1, -1, -1, -1, -1,  0,  0,  0, 1, -1, -1, 0, 0, 0, 0, 0, 0, -1, -1],
	[-1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, 0, 0, 0, 0, 0, 0, -1, -1],
	[-1, -1, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1],
	[-1, -1, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
], Vector2(17, 0))


var obstacles = [obs1, obs2, obs3, obs4, obs5, obs6, obs7, obs8]


func _ready() -> void:
	get_tree().paused = false
	randomize()
	$Player.connect("hp_changed", self, "on_hp_changed")
#	var _start_pos = Vector2(42, 9)
#	var _end_pos = Vector2(60, 18)
#	show_obstacle(Rect2(_start_pos.x, _start_pos.y, _end_pos.x - _start_pos.x + 1, _end_pos.y - _start_pos.y + 1))


func on_hp_changed(hp : int, direction : int) -> void:
	if hp <= 0:
		$CanvasLayer/Control/LoseContainer.visible = true
		get_tree().paused = true
	for child in $CanvasLayer/Control/HpContainer.get_children():
		child.visible = false
	for i in range(hp):
		$CanvasLayer/Control/HpContainer.get_child(i).visible = true
	#spawn player back
	if direction < 0:
		spawn_player()


func spawn_player() -> void:
	var tile_rect = $TileMap.get_used_rect()
	for i in range(tile_rect.size.x):
		for j in range(tile_rect.size.y):
			if $TileMap.get_cell(tile_rect.position.x + i, tile_rect.position.y + j) == 3:
				$Player.global_position = $TileMap.map_to_world(Vector2(tile_rect.position.x + i, tile_rect.position.y + j))
				return


func show_obstacle(rect : Rect2):
	for i in range(rect.size.y):
		var output = "["
		for j in range(rect.size.x):
			output += str($TileMap.get_cell(rect.position.x + j, rect.position.y + i)) + ", "
		output.erase(output.length() - 2, 2)
		output += "],"
		print(output)


func add_score(x : int) -> void:
	n_score_value.text = "Score: " + str(int(n_score_value.text) + x)


func add_distance() -> void:
	add_score(int($Player.position.x / 40) - int(n_distance_value.text))
	n_distance_value.text = "Distance: " + str(int($Player.position.x / 40))


func _physics_process(delta: float) -> void:
	# camera and player movement
	$Camera2D.position.x += ($Player.speed + sqrt($Player.position.x)) * delta
	var dif : float = $Player.position.x - $Camera2D.position.x
	if dif < -270.0:
		$Player.increase_speed = true
	else:
		$Player.increase_speed = false
	# adding obstacles
	current_tile = $TileMap.world_to_map($Camera2D.position)
	#print(current_tile, " ", next_appearance)
	if current_tile != previous_tile:
		# add ceiling
		$TileMap.set_cell(current_tile.x + 17, current_tile.y - 8, 0)
		$TileMap.set_cell(current_tile.x + 17, current_tile.y - 9, 0)
		$TileMap.update_bitmask_area(Vector2(current_tile.x + 17, current_tile.y - 8))
		$TileMap.update_bitmask_area(Vector2(current_tile.x + 17, current_tile.y - 9))
		
		# add obstacle
		if current_tile.x == next_appearance:
			var obstacle : Obstacle = obstacles[randi() % len(obstacles)]
			for i in range(len(obstacle.data)):
				for j in range(len(obstacle.data[0])):
					# spawn a platform
					if obstacle.data[i][j] == 1:
						var platform_instance = platform.instance()
						platform_instance.global_position = $TileMap.map_to_world(Vector2(current_tile.x + obstacle.position.x + j, current_tile.y + obstacle.position.y + i))
						add_child(platform_instance)
					elif obstacle.data[i][j] == 2:
						var _instance
						if randi() % 100 >= 95:
							_instance = hearth.instance()
						else:
							_instance = gem.instance()
						_instance.global_position = $TileMap.map_to_world(Vector2(current_tile.x + obstacle.position.x + j, current_tile.y + obstacle.position.y + i)) + Vector2(16, 0)
						add_child(_instance)
						_instance.set_owner(self)
					else:
						$TileMap.set_cell(current_tile.x + obstacle.position.x + j, current_tile.y + obstacle.position.y + i, obstacle.data[i][j])
			$TileMap.update_bitmask_region(obstacle.position + current_tile, current_tile + obstacle.position + Vector2(len(obstacle.data[0]), len(obstacle.data)))
			next_appearance = current_tile.x + len(obstacle.data[0])
		
		
		# remove cells
		for i in range(-9, 10):
			$TileMap.set_cell(current_tile.x - 17, current_tile.y + i, -1)
	
	add_distance()
	previous_tile = current_tile
	


func _on_RestartButton_pressed() -> void:
	$CanvasLayer/Control/LoseContainer.visible = false
	get_tree().change_scene("res://src/World/World.tscn")
