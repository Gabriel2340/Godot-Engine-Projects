extends Node2D


export(Texture) var increase_explosion
export(Texture) var invulnerable
export(Texture) var more_bombs
export(Texture) var move_your_bombs
export(Texture) var speed
export(Texture) var more_health


func _ready():
	choose_ability()


func choose_ability():
	var ri = randi() % 100
	if ri < 20:
		$Sprite.texture = increase_explosion
		$Label.text = "increase explosion"
	elif ri < 35:
		$Sprite.texture = invulnerable
		$Label.text = "invulnerable"
	elif ri < 55:
		$Sprite.texture = more_bombs
		$Label.text = "more bombs"
	elif ri < 70:
		$Sprite.texture = move_your_bombs
		$Label.text = "move your bombs"
	elif ri < 85:
		queue_free()
		#$Sprite.texture = more_health
		#$Label.text = "more health"
	else:
		$Label.text = "more speed"
		$Sprite.texture = speed


func _on_Area2D_body_entered(body):
	if $Sprite.texture == increase_explosion:
		body.increase_explosion()
	elif $Sprite.texture == invulnerable:
		body.invulnerable()
	elif $Sprite.texture == more_bombs:
		body.add_bombs()
	elif $Sprite.texture == move_your_bombs:
		body.move_bombs()
	elif $Sprite.texture == speed:
		body.increase_speed()
	elif $Sprite.texture == more_health:
		body.increase_health()
	queue_free()
