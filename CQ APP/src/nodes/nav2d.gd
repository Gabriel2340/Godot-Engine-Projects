extends Navigation2D


func remove_square(index : int) -> void:
	change_tile(index, 1)


func add_square(index : int) -> void:
	change_tile(index, 0)


func change_tile(index : int, flag: int = 0) -> void:
	var x: int = index % 4
	var y: int = index / 4
	$TileMap.set_cell(x, y, flag)
	$TileMap.update_dirty_quadrants()
