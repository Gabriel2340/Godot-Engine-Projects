extends TextureButton

signal empty_tile_pressed

var parent: GridContainer = null
var cant_pain: bool = false
var buttond_down: bool = true

func _ready() -> void:
	connect("button_down", self, "_on_TextureButton_down")
	parent = get_parent()


func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		buttond_down = true
	if parent.paint_on_hover:
		if get_global_rect().has_point(event.position):
			if buttond_down:
				emit_signal("empty_tile_pressed", get_index())
			buttond_down = false



func _on_TextureButton_down() -> void:
	if not parent.delete_on_hover:
		parent.paint_on_hover = true
		#emit_signal("empty_tile_pressed", get_index())
