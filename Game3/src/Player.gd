extends KinematicBody2D

signal on_lifes_changed

onready var particles : = preload("res://src/Particles.tscn")

const Gravity = 30
const max_fall_speed = 710
const Maxspeed = 200
const jump_power = 700
const acc = 15

var motion : Vector2 = Vector2.ZERO
var moving : bool
var jumps_left = 2
var snap_normal = Vector2.DOWN
var can_be_damaged : bool = true
var hp : int = 3 setget on_hp_changed


func _ready() -> void:
	pass


func on_hp_changed(new_value : int) -> void:
	hp = new_value
	emit_signal("on_lifes_changed", hp)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and jumps_left > 1:
		var particles_instance = particles.instance()
		particles_instance.position = global_position + Vector2(0, 28 * scale.y)
		particles_instance.emitting = true
		get_parent().add_child(particles_instance)
		motion.y = -jump_power
		jumps_left -= 1
	

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumps_left = 2
		if motion.y > 0:
			motion.y = 0
	motion.y += Gravity
	moving = false
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
	if Input.is_action_pressed("left"):
		motion.x -= acc
		moving = true
	if Input.is_action_pressed("right"):
		motion.x += acc
		moving = true
	if not moving:
		if motion.x != 0:
			if motion.x > 0:
				motion.x -= acc
			else:
				motion.x += acc
			if motion.x <= 30:
				motion.x = 0
	if motion.x >= Maxspeed:
		motion.x = Maxspeed
	elif motion.x <= -Maxspeed:
		motion.x = -Maxspeed
	
	motion = move_and_slide_with_snap(motion, snap_normal, Vector2.UP)


func _on_EnemyDetector_body_entered(body: Node) -> void:
	# if is the enemy
	if can_be_damaged and not body.dead:
		motion.y = -260
		hp -= 1
		emit_signal("on_lifes_changed", hp)
		if hp <= 0:
			queue_free()
		$AnimationPlayer.play("hurt")
		can_be_damaged = false


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	can_be_damaged = true
