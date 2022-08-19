extends Bullet



func _ready() -> void:
	speed = 150
	damage = 20

func _process(delta: float) -> void:
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta


func deal_damage(damage_value : int, target) -> void:
	target.hp -= damage_value


func _on_Area2D_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity:
		deal_damage(damage, entity)
		var explosion_instance : = explosion.instance()
		explosion_instance.position = global_position
		explosion_instance.emitting = true
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
