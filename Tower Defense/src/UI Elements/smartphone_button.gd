extends TextureButton


onready var n_tween: = $Tween

onready var default_s: Vector2 = rect_scale
onready var hover_s: Vector2 = rect_scale - default_s * 0.1

func _ready() -> void:
	rect_pivot_offset.x = rect_size.x / 2.0
	rect_pivot_offset.y = rect_size.y / 2.0

func _on_SmartPhoneButton_button_down() -> void:
	n_tween.start()
	n_tween.interpolate_property(self, "rect_scale", default_s, hover_s, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _on_SmartPhoneButton_button_up() -> void:
	n_tween.start()
	n_tween.interpolate_property(self, "rect_scale", hover_s, default_s, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
