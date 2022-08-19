extends Node2D

signal player_died

onready var bullet : = preload("res://src/Bullet.tscn")
onready var root : = get_tree().get_root()

var speed : int = 5
var velocity : Vector2 = Vector2.ZERO
var hp = 1800 setget on_hp_changed


func _ready():
	$ProgressBar.max_value = hp
	$ProgressBar.value = hp


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		fire()


func on_hp_changed(new_value : int) -> void:
	hp = new_value
	$ProgressBar.value = new_value
	if hp <= 0:
		emit_signal("player_died")

func fire() -> void:
	var left_bullet : = bullet.instance()
	var right_bullet : = bullet.instance()
	left_bullet.position = $Player/LeftShooter.global_position
	right_bullet.position = $Player/RightShooter.global_position
	left_bullet.rotation_degrees = rotation_degrees - 90
	right_bullet.rotation_degrees = rotation_degrees - 90
	
	root.add_child(left_bullet)
	root.move_child(left_bullet, 0)
	root.add_child(right_bullet)
	root.move_child(right_bullet, 0)


func _process(delta: float) -> void:
	if int(position.y) % 10 == 0:
		fire()
	velocity = Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
#	if Input.is_action_pressed("down"):
#		velocity.y += speed
#	if Input.is_action_pressed("up"):
#		velocity.y -= speed
	velocity.y -= 1
	position += velocity


