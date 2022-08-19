extends Enemy

onready var bullet : = preload("res://src/bullets/BulletEnemy2.tscn")

onready var parent: = get_parent()

func _ready() -> void:
	hp = 140


func fire() -> void:
	var left_bullet : = bullet.instance()
	var right_bullet : = bullet.instance()
	left_bullet.position = $LeftShooter.global_position
	right_bullet.position = $RightShooter.global_position
	left_bullet.rotation_degrees = rotation_degrees - 270
	right_bullet.rotation_degrees = rotation_degrees - 270
	
	parent.add_child(left_bullet)
	parent.move_child(left_bullet, 0)
	parent.add_child(right_bullet)
	parent.move_child(right_bullet, 0)


func _on_Timer_timeout() -> void:
	fire()


func get_random_number(x : int) -> int:
	randomize()
	return randi() % x


func _process(delta: float) -> void:
	position.y -= 1
	if get_global_transform_with_canvas().origin.y > 550:
		emit_signal("lose_life", 1)
		queue_free()
