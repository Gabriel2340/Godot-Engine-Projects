extends KinematicBody2D

const Gravity : int = 11
const max_fall_speed : int = 300
const Maxspeed : int = 160
const jump_power : int = 360
const acc : int = 10

var motion : Vector2 = Vector2.ZERO
var snap_normal : Vector2 = Vector2.DOWN
var max_jumps : int = 1
var jumps_left : int = max_jumps
var jumped_this_frame : bool = false
var moving : bool


var Key = {
	UP = "up",
	LEFT = "left",
	RIGHT = "right"
}



func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Key.UP) and jumps_left >= 1:
		motion.y = -jump_power
		jumps_left -= 1
		jumped_this_frame = true
	

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		if not jumped_this_frame:
			jumps_left = max_jumps
			if motion.y > 0:
				motion.y = 0
		
	motion.y += Gravity
	moving = false
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
	if Input.is_action_pressed(Key.LEFT):
		$AnimationPlayer.play("move")
		$Sprite.flip_h = true
		motion.x -= acc
		moving = true
	if Input.is_action_pressed(Key.RIGHT):
		$AnimationPlayer.play("move")
		$Sprite.flip_h = false
		motion.x += acc
		moving = true
	if not moving:
		if is_on_floor():
			$AnimationPlayer.play("idle")
		elif motion.y > 0:
			$AnimationPlayer.play("fall")
		elif motion.y < 0:
			$AnimationPlayer.play("jump")
		if motion.x != 0:
			if motion.x > 0:
				motion.x -= acc
			else:
				motion.x += acc
			# if the character is moving just a bit without pressing a key 
			# change the value from 5 to 15 or higher
			if motion.x <= 5 and motion.x >= -5:
				motion.x = 0
	if motion.x >= Maxspeed:
		motion.x = Maxspeed
	elif motion.x <= -Maxspeed:
		motion.x = -Maxspeed
	jumped_this_frame = false
	
	
	motion = move_and_slide_with_snap(motion, snap_normal, Vector2.UP, false, 4, PI / 4, false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			#print(collision.position)
			#if collision.collider.linear_velocity.length() < 5:
			if collision.normal.y < 0 and collision.normal.angle() > -1.4:
				jumps_left = max_jumps
				#print("on floor: ", OS.get_ticks_msec())
			collision.collider.apply_impulse(global_position - collision.collider.global_position, -collision.normal * 10)
			#collision.collider.linear_velocity.y = clamp(collision.collider.linear_velocity.y, -1, 1)
