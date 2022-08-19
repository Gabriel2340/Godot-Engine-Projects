extends GridContainer

signal troop_selected(troop_count)
signal selecting_a_troop

var current_troop: int = 0
var state: String = "default"

var troop_names = [
	"Archer",
	"Barbarian",
	"Wizard",
	"Prince",
	"Giant",
	"Goblin",
	"Pekka",
	"Bomber",
	"Baby Dragon",
	"Minion",
	"Bomb Miner",
]

var troops_value = [15, 15, 15, 12, 8, 18, 5, 12, 12, 18, 8]


func _ready() -> void:
	connect_buttons()


func connect_buttons():
	for i in range(get_child_count()):
		get_child(i).connect("pressed", self, "on_troop_button_pressed", [i])

func show_buttons():
	for button in get_children():
		button.visible = true

func hide_buttons_except(index : int):
	for i in range(get_child_count()):
		if i != index:
			get_child(i).visible = false
		else:
			get_child(i).visible = true

func change_current_troop(index):
	state = "default"
	hide_buttons_except(index)
	rect_size = Vector2(60, 60)
	current_troop = index
	emit_signal("troop_selected", troops_value[index])


func on_troop_button_pressed(index : int):
	if state == "default":
		state = "selecting"
		emit_signal("selecting_a_troop")
		show_buttons()
	else:
		change_current_troop(index)
