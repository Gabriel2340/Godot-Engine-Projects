extends Position2D


# n_ is for nodes
onready var n_timer: = $CanShotTimer
onready var n_range: = $Range/CollisionShape2D

export(float, 0.0, 5.0) var shoot_delay : float = 1.0
export(float, 10.0, 500.0) var tower_range : float = 100.0
export(int, 0, 6000) var damage : int = 100

var enemies_in_range : Array = []
var current_target : Enemy = null


func _ready() -> void:
	n_timer.wait_time = shoot_delay
	n_range.shape.radius = tower_range
	

func shoot() -> void:
	get_closest_enemy_to_finish()
	if current_target.health <= 0:
		enemies_in_range.erase(current_target)
		n_timer.stop()
		return
	current_target.health -= damage
	


func _on_CanShotTimer_timeout() -> void:
	if enemies_in_range == []:
		n_timer.stop()
		return
	shoot()


func _on_enemy_entered(area: Area2D) -> void:
	var enemy: Enemy = area.get_parent()
	enemies_in_range.append(enemy)
	if n_timer.is_stopped():
		n_timer.start()
		if len(enemies_in_range) == 1:
			shoot()


func _on_enemy_exited(area: Area2D) -> void:
	var enemy: Enemy = area.get_parent()
	enemy.n_debug_target.visible = false
	enemies_in_range.erase(enemy)


# it modifies current_target global variable
# current_target should be read only, except for this case
func get_closest_enemy_to_finish() -> void:
	# put some high value
	var closest_distance : int = 99999
	for enemy in enemies_in_range:
		enemy.n_debug_target.visible = false
		if closest_distance > enemy.distance_before_finish:
			current_target = enemy
			closest_distance = enemy.distance_before_finish

	current_target.n_debug_target.visible = true
	if closest_distance == 99999:
		current_target.n_debug_target.visible = false
		current_target = null


func _on_tower_pressed() -> void:
	pass # Replace with function body.
