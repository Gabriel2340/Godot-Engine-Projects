extends Node2D

signal exploded
signal tiles_changed
signal player_exited_bomb

onready var tween = $Tween
onready var vertical = $Explosion/Vertical
onready var horizontal = $Explosion/Horizontal
onready var drop = preload("res://src/World/Drop.tscn")

var explosion_area = 3
var tile_map : TileMap = null
var old_position
var exploding = false

func _ready():
	$CollisionShape2D.position.x = 10000


func explode():
	if exploding:
		return
	exploding = true
	emit_signal("exploded")
	$CollisionShape2D.position.x = 10000
	$Sprite.visible = false
	set_tiles(-1, 2)
	$Timer.start()

func set_tiles(var from : int, var to : int):
	old_position = global_position
	var pos : Vector2 = tile_map.world_to_map(old_position)
	if tile_map.get_cell(pos.x, pos.y) == from:
		tile_map.set_cell(pos.x, pos.y, to)
	for left in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x - left, pos.y) == from:
			tile_map.set_cell(pos.x - left, pos.y, to)
		else:
			if tile_map.get_cell(pos.x - left, pos.y) == 1:
				tile_map.set_cell(pos.x - left, pos.y, to)
				drop_something(Vector2(pos.x - left + 0.5, pos.y + 0.5) * 32)
			break
	for right in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x + right, pos.y) == from:
			tile_map.set_cell(pos.x + right, pos.y, to)
		else:
			if tile_map.get_cell(pos.x + right, pos.y) == 1:
				tile_map.set_cell(pos.x + right, pos.y, to)
				drop_something(Vector2(pos.x + right + 0.5, pos.y + 0.5) * 32)
			break
	for up in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x, pos.y - up) == from:
			tile_map.set_cell(pos.x, pos.y - up, to)
		else:
			if tile_map.get_cell(pos.x, pos.y - up) == 1:
				tile_map.set_cell(pos.x, pos.y - up, to)
				drop_something(Vector2(pos.x + 0.5, pos.y - up + 0.5) * 32)
			break
	for down in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x, pos.y + down) == from:
			tile_map.set_cell(pos.x, pos.y + down, to)
		else:
			if tile_map.get_cell(pos.x, pos.y + down) == 1:
				tile_map.set_cell(pos.x, pos.y + down, to)
				drop_something(Vector2(pos.x + 0.5, pos.y + down + 0.5) * 32)
			break
	emit_signal("tiles_changed")


func drop_something(pos):
	# 30% chance to happen
	if randi() % 100 < 40:
		var drop_instance = drop.instance()
		drop_instance.position = pos
		get_parent().get_parent().get_node("Drops").add_child(drop_instance)



func clear_tiles(var from : int, var to : int):
	var pos : Vector2 = tile_map.world_to_map(old_position)
	if tile_map.get_cell(pos.x, pos.y) == from:
		tile_map.set_cell(pos.x, pos.y, to)
	for left in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x - left, pos.y) == from:
			tile_map.set_cell(pos.x - left, pos.y, to)
	for right in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x + right, pos.y) == from:
			tile_map.set_cell(pos.x + right, pos.y, to)
	for up in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x, pos.y - up) == from:
			tile_map.set_cell(pos.x, pos.y - up, to)
	for down in range(1, explosion_area + 1):
		if tile_map.get_cell(pos.x, pos.y + down) == from:
			tile_map.set_cell(pos.x, pos.y + down, to)



func _on_Timer_timeout():
	clear_tiles(2, -1)
	queue_free()
	

func _on_Area2D_body_exited(body):
	$Area2D.queue_free()
	emit_signal("player_exited_bomb")
	$CollisionShape2D.position.x = 0
