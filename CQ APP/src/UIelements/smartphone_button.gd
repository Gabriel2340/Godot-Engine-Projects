extends TextureButton


onready var n_tween: = $Tween

onready var power_of_resize = 0.25

onready var default_s: Vector2 = rect_scale
onready var hover_s: Vector2 = rect_scale - default_s * power_of_resize

func _ready() -> void:
	rect_pivot_offset.x = rect_size.x / 2.0
	rect_pivot_offset.y = rect_size.y / 2.0

func _on_SmartPhoneButton_button_down() -> void:
	if toggle_mode:
		return
	texture_smaller()

func _on_SmartPhoneButton_button_up() -> void:
	if toggle_mode:
		return
	texture_to_normal()

func _on_SmartPhoneButton_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		texture_to_normal()
	else:
		texture_smaller()

func texture_smaller():
	self_modulate = Color(0.5, 0.5, 0.5, 1.0)
	n_tween.interpolate_property(self, "rect_scale", default_s, hover_s, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	n_tween.start()


func texture_to_normal():
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	n_tween.interpolate_property(self, "rect_scale", hover_s, default_s, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	n_tween.start()
