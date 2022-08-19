extends Node2D

class_name Enemy

signal lose_life


onready var explosion : = preload("res://src/effects/Explosion.tscn")
var hp : int = 70 setget hp_changed

func _ready() -> void:
	pass


func hp_changed(new_value : int) -> void:
	hp = new_value
	if hp <= 0:
		var explosion_instance : = explosion.instance()
		explosion_instance.position = global_position
		explosion_instance.lifetime = 1
		explosion_instance.emitting = true
		get_tree().get_root().add_child(explosion_instance)
		queue_free()

func _process(delta: float) -> void:
	position.y += 0.5
	if get_global_transform_with_canvas().origin.y > 550:
		emit_signal("lose_life", 1)
		queue_free()
