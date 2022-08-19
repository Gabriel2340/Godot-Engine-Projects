extends Utility

signal spell_lvl_changed

onready var n_level_edit = $LevelEdit
onready var n_level = $Level

var level: int = 10
var damage: int

var spell_stats: Array

func _ready():
	area_action = area.BUILDINGS


func deal_damage(building : Building) -> void:
	building.hp -= damage


func change_lvl(new_lvl):
	level = new_lvl
	n_level.text = str(level)
	damage = spell_stats[level - 1]["damage"]


func _on_NumberEdit_enter_pressed() -> void:
	change_lvl(int(n_level_edit.text))
	n_level_edit.visible = false
	emit_signal("spell_lvl_changed", get_index(), level)


func _on_Level_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		n_level_edit.visible = true
		n_level_edit.text = str(level)
		n_level_edit.grab_focus()
		n_level_edit.select_all()
