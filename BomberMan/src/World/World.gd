extends Node2D


func _ready():
	randomize()
	$Player.connect("hp_changed", self, "on_hp_changed")
	$Player2.connect("hp_changed", self, "on_hp_changed")
	$Player.connect("bombs_changed", self, "on_bombs_changed")
	$Player2.connect("bombs_changed", self, "on_bombs_changed")


func on_bombs_changed(max_bombs, player):
	if player == 1:
		$UI/Player1Bombs/BombsLabel.text = "Max Bombs: " + str(max_bombs)
	else:
		$UI/Player2Bombs/BombsLabel.text = "Max Bombs: " + str(max_bombs)
		

func on_hp_changed(hp, player):
	if player == 1:
		$UI/Player1HP/HpLabel.text = "HP: " + str(hp)
		if hp == 0:
			$UI/Control/VBoxContainer/PlayerWon.text = "Player 2 won"
			$UI/Control.visible = true
			$UI/Control/VBoxContainer/RestartLevel.grab_focus()
			
			get_tree().paused = true

	else:
		$UI/Player2HP/HpLabel.text = "HP: " + str(hp)
		if hp == 0:
			$UI/Control/VBoxContainer/PlayerWon.text = "Player 1 won"
			$UI/Control.visible = true
			$UI/Control/VBoxContainer/RestartLevel.grab_focus()
			get_tree().paused = true


func on_tiles_changed():
	for bomb in $Bombs.get_children():
		var vec2 = $TileMap.world_to_map(bomb.global_position)
		if $TileMap.get_cell(vec2.x, vec2.y) == 2:
			bomb.explode()


func _on_RestartLevel_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	#get_tree().change_scene("res://src/World/World.tscn")
