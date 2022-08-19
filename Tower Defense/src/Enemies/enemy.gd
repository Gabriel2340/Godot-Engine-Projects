tool
extends Position2D

class_name Enemy

signal died(object)

onready var n_health_bar: = $HealthBar
onready var n_debug_position: = $DebugPositionBeforeEnd
onready var n_debug_target: = $DebugTarget

export(int, 1, 100000) var health: int = 100 setget health_changed
export(int, 10, 1000) var speed : int = 60

var enemy_name = "Goblin"
var last_point_passed: int = 0
var enemy_value: int = 1
var gold_value: int = 15
var distance_before_finish : float

func _ready() -> void:
	n_health_bar.max_value = health
	n_health_bar.value = health


func health_changed(new_health : int) -> void:
	health = new_health
	n_health_bar.value = health
	if health <= 0:
		# TODO: add dead animation
		emit_signal("died", self)
		queue_free()


func _get_configuration_warning() -> String:
	for child in get_children():
		if child is Area2D:
			return ""
	return "You need to add an area2d to root node!"
