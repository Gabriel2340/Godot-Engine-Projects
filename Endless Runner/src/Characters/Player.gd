extends KinematicBody2D

signal hp_changed

const gravity : int = 35
const max_fall_speed : int = 850
const speed : int = 200
const jump_power : int = 850

var motion : Vector2 = Vector2.ZERO
var max_jumps : int = 1
var jumps_left : int = max_jumps
var jumped_this_frame : bool = false
var increase_speed = false

var hp = 3 setget hp_changed


var Key = {
	UP = "up",
	DOWN = "down"
}


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Key.UP) and jumps_left >= 1:
		motion.y = -jump_power
		jumps_left -= 1
		jumped_this_frame = true

func hp_changed(new_value : int) -> void:
	var direction = new_value - hp
	hp = new_value
	if hp > 3:
		hp = 3
	emit_signal("hp_changed", hp, direction)


func _physics_process(delta: float) -> void:
	var tilemap = owner.get_node("TileMap")
	var player_pos = tilemap.world_to_map(global_position + Vector2(0, 16))
	if is_on_floor():
		if not jumped_this_frame:
			jumps_left = max_jumps
			if motion.y > 0:
				motion.y = 0
		if Input.is_action_just_pressed(Key.DOWN):
			if tilemap.get_cell(player_pos.x, player_pos.y + 1) == 9:
				tilemap.get_cell(player_pos.x, player_pos.y + 1)
	motion.x = speed + sqrt(position.x)
	if increase_speed:
		motion.x += 100
	motion.y += gravity
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
#	elif motion.y > 0:
#		$AnimationPlayer.play("fall")
#	elif motion.y < 0:
#		$AnimationPlayer.play("jump")
	jumped_this_frame = false
	
	motion = move_and_slide(motion, Vector2.UP)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	hp_changed(hp - 1)
