extends "res://src/Enemies/Enemy2.gd"

signal boss_died

onready var bullet2 : = preload("res://src/bullets/BulletBoss.tscn")
onready var bullet3 : = preload("res://src/bullets/BulletBoss2.tscn")

var ability_2_shots : int = 0
var ability_2_max_shots : int = 10

var boss_direction = 1

func _ready() -> void:
	hp = 40000


func fire2() -> void:
	var left_bullet : = bullet2.instance()
	var right_bullet : = bullet2.instance()
	left_bullet.position = $LeftShooter2.global_position
	right_bullet.position = $RightShooter2.global_position
	left_bullet.rotation_degrees = rotation_degrees - 270
	right_bullet.rotation_degrees = rotation_degrees - 270
	
	parent.add_child(left_bullet)
	parent.move_child(left_bullet, 0)
	parent.add_child(right_bullet)
	parent.move_child(right_bullet, 0)


func fire3() -> void:
#	var left_bullet : = bullet3.instance()
#	var right_bullet : = bullet3.instance()
#	left_bullet.position = $LeftShooter3.global_position
#	right_bullet.position = $RightShooter3.global_position
#	left_bullet.rotation_degrees = rotation_degrees - 270
#	right_bullet.rotation_degrees = rotation_degrees - 270
#
#	parent.add_child(left_bullet)
#	parent.move_child(left_bullet, 0)
#	parent.add_child(right_bullet)
#	parent.move_child(right_bullet, 0)
	$LeftLaser.is_casting = true
	$RightLaser.is_casting = true


func _process(delta: float) -> void:
	$ProgressBar.value = hp
	if get_global_transform_with_canvas().origin.y > 150:
		position.y -= 0.5
		position.x += 1 * boss_direction
		if position.x > 800:
			boss_direction = -1
		elif position.x < 224:
			boss_direction = 1
	

func _on_Timer3_timeout() -> void: # every 12 seconds
	#if get_random_number(5) > 0:
	$Ability2Timer.start()


func _on_Timer2_timeout() -> void: # every 7 seconds
	fire3()
	$Ability3Timer.start()


func _on_Timer4_timeout() -> void:
	fire2()
	ability_2_shots += 1
	if ability_2_shots >= ability_2_max_shots:
		ability_2_shots = 0
		$Ability2Timer.stop()


func hp_changed(new_value : int) -> void:
	hp = new_value
	if hp <= 0:
		var explosion_instance : = explosion.instance()
		explosion_instance.position = global_position
		explosion_instance.lifetime = 1
		explosion_instance.emitting = true
		get_tree().get_root().add_child(explosion_instance)
		emit_signal("boss_died")
		queue_free()


func _on_Ability3Timer_timeout():
	$LeftLaser.is_casting = false
	$RightLaser.is_casting = false
