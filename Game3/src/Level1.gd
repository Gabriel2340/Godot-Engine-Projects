extends Node2D

onready var tile_map : = $TileMap
onready var lifes_value : = $UILayer/MainUI/HBoxContainer/Lifes/Value
onready var enemies : = $Enemies
onready var player : = $Player
var enemies_number : int


func _ready() -> void:
	player.connect("on_lifes_changed", self, "on_lifes_changed")
	lifes_value.text = str(player.hp)
	enemies_number = enemies.get_child_count()
	for enemy in enemies.get_children():
		enemy.connect("enemy_died", self, "on_enemy_died")

func on_lifes_changed(value : int) -> void:
	lifes_value.text = str(value)


func on_enemy_died():
	enemies_number -= 1
	if enemies_number <= 0:
		$Portal.activated = true


func get_tile_id(position : Vector2) -> int:
	return tile_map.get_cellv(tile_map.world_to_map(position))
