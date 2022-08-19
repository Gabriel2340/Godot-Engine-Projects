extends KinematicBody2D

signal enemy_died

const Gravity = 30
const max_fall_speed = 710
const Maxspeed = 100

var motion : Vector2 = Vector2.ZERO
var snap_normal = Vector2.DOWN
var direction = 1
onready var main_node : = get_parent().get_parent()
var dead: bool = false
func _physics_process(delta: float) -> void:
	motion.y += Gravity
	if is_on_floor():
		motion.y = 0
	if is_on_wall():
		direction *= -1
	if main_node.get_tile_id(global_position + Vector2(8, 32)) == -1 and direction == 1 or \
		main_node.get_tile_id(global_position + Vector2(-8, 32)) == -1 and direction == -1:
		direction *= -1
	motion.x = Maxspeed * direction
	
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
	if motion.x >= Maxspeed:
		motion.x = Maxspeed
	elif motion.x <= -Maxspeed:
		motion.x = -Maxspeed
	
	motion = move_and_slide_with_snap(motion, snap_normal, Vector2.UP)



func _on_PlayerDetector_body_entered(body: Node) -> void:
	# if is the player
	if body.has_method("_on_EnemyDetector_body_entered") and body.motion.y > 0:
		emit_signal("enemy_died")
		dead = true
		body.motion.y = -400
		queue_free()
