extends RayCast2D

var is_casting : bool = false setget set_is_casting


func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO


#func _input(event):
#	if event.is_action_pressed("shoot"):
#		set_is_casting(true)
#	if event.is_action_released("shoot"):
#		set_is_casting(false)



func _physics_process(delta : float) -> void:
	var cast_point := cast_to
	force_raycast_update()
	
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		get_collider().get_parent().hp -= 4
	$CollisionParticles2D.global_rotation = get_collision_normal().angle()
	$CollisionParticles2D.position = cast_point
	$Line2D.points[1] = cast_point
	$BeamParticles2D.position = cast_point * 0.5
	$BeamParticles2D.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(new_value : bool) -> void:
	is_casting = new_value
	$BeamParticles2D.emitting = is_casting
	$CastingParticles2D.emitting = is_casting
	$CollisionParticles2D.emitting = is_casting
	if is_casting:
		appear()
	else:
		disappear()
	set_physics_process(is_casting)


func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 40.0, 0.2)
	$Tween.start()

func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 40.0, 0, 0.1)
	$Tween.start()

