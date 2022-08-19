extends Position2D

onready var n_animation_player: = $AnimationPlayer
onready var n_build_towers_place: = $BuildTowersPlace

onready var bomb_tower: = preload("res://src/Towers/BombTower.tscn")
onready var arch_tower: = preload("res://src/Towers/ArchTower.tscn")
onready var wiz_tower: = preload("res://src/Towers/WizTower.tscn")
onready var fortress: = preload("res://src/Towers/Fortress.tscn")
onready var house: = preload("res://src/Towers/House.tscn")

onready var towers: Dictionary = {"BombTower" : bomb_tower, "ArchTower" : arch_tower,
		"WizTower" : wiz_tower, "Fortress" : fortress, "House" : house}

var towers_id: Array = ["BombTower", "ArchTower", "WizTower", "Fortress", "House"]
var on: bool = false
var last_tower_pressed : int = -1
var changed: bool = false

var pressed_inside: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		if not pressed_inside:
			turn_off()
		pressed_inside = false


func _on_TextureButton_pressed() -> void:
	turn_off() if on else turn_on()


func turn_off() -> void:
	n_animation_player.play("build_towers_place_off")
	if last_tower_pressed != -1:
		n_build_towers_place.get_node(towers_id[last_tower_pressed]).pressed = false
		last_tower_pressed = -1
	on = false


func turn_on() -> void:
	n_animation_player.play("build_towers_place_on")
	on = true


func on_type_of_tower_pressed(id: int) -> void:
	print(id)
	if last_tower_pressed == id:
		n_build_towers_place.get_node(towers_id[last_tower_pressed]).pressed = false
		var a = towers[towers_id[id]].instance()
		get_tree().current_scene.add_child(a)
		a.position = position
		queue_free()
	last_tower_pressed = id
	


func _on_button_down() -> void:
	pressed_inside = true
