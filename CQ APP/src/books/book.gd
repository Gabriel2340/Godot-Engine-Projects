extends Utility



func _ready():
	area_action = area.TROOPS


func action(_n_map : GridContainer, _id : int) -> void:
	pass


func swap(n_map, id2, id):
	var max_id = max(id, id2)
	var min_id = min(id, id2)
	n_map.move_child(n_map.get_child(max_id), min_id)
	n_map.move_child(n_map.get_child(min_id + 1), max_id)
