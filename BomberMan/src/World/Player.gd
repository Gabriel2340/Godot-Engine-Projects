extends KinematicBody2D

signal hp_changed
signal bombs_changed

onready var bomb = preload("res://src/Weapons/Bomb.tscn")
onready var tile_map : TileMap = get_parent().get_node("TileMap")
export(int) var player = 1
var speed : int = 100
var speed_increase = speed / 10
var bombs : int = 0
var max_bombs : int = 1
var force : int = 1 setget on_force_changed
var increase_force : float = 0
var last_direction = Vector2.UP
var hp = 3
var bomb_explosion = 1
var can_get_damage = true
var invulnerable_var = false
var can_move_bombs = false
var is_inside_a_bomb = false
var input_string = ["spawn bomb",
	"up",
	"down",
	"left",
	"right"]

func _ready():
	$Label.text = "Player" + str(player)
	$Invulnerable.visible = false
	if player == 2:
		for i in range(len(input_string)):
			input_string[i] += "2"
	#modulate = Color(1.0, 1.0, 1.0, 1.0)


func _input(event):
	if event.is_action_pressed(input_string[0]):
		if bombs < max_bombs and not is_inside_a_bomb:
			drop_bomb()
	

func _physics_process(delta):
	move_and_slide(get_direction() * speed, Vector2.UP, false, 4, PI / 4, false)
	if can_move_bombs:
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("bodies"):
				collision.collider.apply_central_impulse(-collision.normal * speed * delta * force)

func on_force_changed(new_value):
	if new_value > 40:
		new_value = 40
	force = new_value
	


# drops
func increase_explosion():
	bomb_explosion += 1

func invulnerable():
	$AnimationPlayer.play("invulnerable2")
	can_get_damage_active()
	invulnerable_var = true

func add_bombs():
	max_bombs += 1
	emit_signal("bombs_changed", max_bombs, player)

func increase_speed():
	speed += speed_increase

func increase_health():
	hp += 1
	emit_signal("hp_changed", hp, player)

func move_bombs():
	can_move_bombs = true

# end drops

func invulnerable_off():
	invulnerable_var = false


func get_direction():
	var direction = Vector2.ZERO
	if Input.is_action_pressed(input_string[1]): # UP
		if last_direction == Vector2.DOWN:
			force = 1
		last_direction = Vector2.UP
		direction.y -= 1
		force += increase_force
	if Input.is_action_pressed(input_string[2]): # DOWN
		if last_direction == Vector2.UP:
			force = 1
		last_direction = Vector2.DOWN
		direction.y += 1
		force += increase_force
	if Input.is_action_pressed(input_string[3]): # LEFT
		if last_direction == Vector2.RIGHT:
			force = 1
		last_direction = Vector2.LEFT
		direction.x -= 1
		force += increase_force
	if Input.is_action_pressed(input_string[4]): # RIGHT
		if last_direction == Vector2.LEFT:
			force = 1
		last_direction = Vector2.RIGHT
		direction.x += 1
		force += increase_force
	return direction


func on_bomb_exploded():
	bombs -= 1


func lose_hp():
	hp -= 1
	can_get_damage = false
	$AnimationPlayer.play("invulnerable")
	if hp <= 0:
		hp = 0
	emit_signal("hp_changed", hp, player)


func on_tiles_changed():
	var vec2 = tile_map.world_to_map(global_position)
	if tile_map.get_cell(vec2.x, vec2.y) == 2:
		if can_get_damage and not invulnerable_var:
			lose_hp()


func on_player_exited_bomb():
	is_inside_a_bomb = false


func drop_bomb():
	is_inside_a_bomb = true
	bombs += 1
	var bomb_instance = bomb.instance()
	bomb_instance.connect("exploded", self, "on_bomb_exploded")
	bomb_instance.connect("player_exited_bomb", self, "on_player_exited_bomb")
	bomb_instance.connect("tiles_changed", get_parent(), "on_tiles_changed")
	var a = "2"
	if player == 2:
		a = ""
	bomb_instance.connect("tiles_changed", get_parent().get_node("Player" + a), "on_tiles_changed")
	bomb_instance.connect("tiles_changed", self, "on_tiles_changed")
	bomb_instance.position = global_position
	bomb_instance.explosion_area = bomb_explosion
	bomb_instance.tile_map = tile_map
	get_parent().get_node("Bombs").add_child(bomb_instance)




func can_get_damage_active():
	can_get_damage = true
