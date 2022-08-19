extends Node2D

onready var enemy : = preload("res://src/Enemies/Enemy.tscn")
onready var enemy2 : = preload("res://src/Enemies/Enemy2.tscn")
onready var boss : = preload("res://src/Enemies/Boss1.tscn")
onready var player : = $Player

var chance_to_spam_a_building : int = 1
var count : int = 0
var boss_alive: bool = false

func _ready() -> void:
	$CanvasLayer2/MainUI.connect("restart_level", self, "on_restart_level")
	player.connect("player_died", self, "on_player_died")

func _process(delta: float) -> void:
	count += 1
	if boss_alive:
		if chance_to_spam_a_building > get_random_number(240) or count % 200 == 0:
			var enemy_instance : Enemy
			if get_random_number(5) > 2: # 40% chances
				enemy_instance = enemy.instance()
			else: # 60% chances
				enemy_instance = enemy2.instance()
			enemy_instance.position.x = get_random_number(940) + 42
			enemy_instance.position.y = player.global_position.y - 430
			enemy_instance.connect("lose_life", self, "lose_lifes")
			add_child(enemy_instance)
	elif chance_to_spam_a_building > get_random_number(171 - int(count / 360) % 36000) or count % 100 == 0:
		var enemy_instance : Enemy
		if get_random_number(5) > 3: # 20% chances
			enemy_instance = enemy2.instance()
		else: # 80% chances
			enemy_instance = enemy.instance()
		enemy_instance.position.x = get_random_number(940) + 42
		enemy_instance.position.y = player.global_position.y - 430
		enemy_instance.connect("lose_life", self, "lose_lifes")
		add_child(enemy_instance)


func delete_enemies() -> void:
	for child in get_children():
		if child is Enemy:
			child.hp = 0


func on_restart_level() -> void:
	delete_enemies()
	$BossComingTimer.start()
	$Player.hp = $Player/ProgressBar.max_value
	boss_alive = false

func on_boss_died():
	$CanvasLayer2/MainUI.win()


func get_random_number(x : int) -> int:
	randomize()
	return randi() % x

func lose_lifes(value : int) -> void:
	$CanvasLayer2/MainUI.lose_lifes(value)

func on_player_died():
	$CanvasLayer2/MainUI.lose()


func _on_BossComingTimer_timeout() -> void:
	boss_alive = true
	var enemy_instance : Enemy = boss.instance()
	enemy_instance.position.x = 512
	enemy_instance.position.y = player.global_position.y - 430
	enemy_instance.connect("boss_died", self, "on_boss_died")
	add_child(enemy_instance)
