extends GridContainer


var paint_on_hover: bool = false 
var delete_on_hover: bool = false
var count_giant_hits: int = 0 setget on_count_ginat_hits
var count_giant_runes: int = 0 setget on_count_ginat_runes

func on_count_ginat_hits(x : int):
	count_giant_hits = x
	print("giant hits: ", count_giant_hits)

func on_count_ginat_runes(x : int):
	count_giant_runes = x
	print("giant runes: ", count_giant_runes)

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		paint_on_hover = false
	if event.is_action_released("ctrl"):
		delete_on_hover = false
	if event.is_action_pressed("ctrl"):
		paint_on_hover = false


