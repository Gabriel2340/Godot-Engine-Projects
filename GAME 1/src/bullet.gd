extends Node2D

class_name Bullet

onready var explosion : = preload("res://src/effects/Explosion.tscn")

export(int) var speed : int = 500
export(int) var damage: int = 20

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta


func deal_damage(damage_value : int, target) -> void:
	target.hp -= damage_value


func _on_Area2D_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	deal_damage(damage, entity)
	var explosion_instance : = explosion.instance()
	explosion_instance.position = global_position
	explosion_instance.emitting = true
	get_tree().get_root().add_child(explosion_instance)
	queue_free()
