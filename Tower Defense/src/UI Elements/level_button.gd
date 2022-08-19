extends VBoxContainer

export(int) var level : int = 1

onready var n_stars : HBoxContainer = $Stars as HBoxContainer
onready var n_level: Button = $Level as Button

var stars_completed: int = 0 setget stars_changed

func _ready() -> void:
	n_level.text = str(level)


func stars_changed(new_value : int) -> void:
	if new_value > stars_completed:
		for i in range(stars_completed, new_value):
			n_stars.get_child(i).visible = true
		stars_completed = new_value

func load_stars_completed():
	pass
