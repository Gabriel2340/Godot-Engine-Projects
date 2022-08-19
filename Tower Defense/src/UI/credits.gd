extends ColorRect

var credits : String = """
Credits
Producer - Gabi
Programmer - Gabi
LeadProgrammer - Gabi
Artist - Gabi
Sounds Effects - Gabi
All rights deserved (c) 2021
"""

var text_h: int = 180

func _ready() -> void:
	$Label.text = credits
	reset()

func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		visible = false

func _process(delta: float) -> void:
	$Label.rect_position.y -= 60 * delta


func _on_Credits_visibility_changed() -> void:
	if visible == false:
		reset()
	else:
		start()


func start() -> void:
	$Label.rect_position.y = OS.get_window_safe_area().size.y - 10
	set_process_input(true)
	set_process(true)


func reset() -> void:
	set_process_input(false)
	set_process(false)
