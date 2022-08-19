extends Node2D

export(Vector2) var _center: Vector2
export(int) var _radius: int
export(int) var _angle_from: int
export(int) var _angle_to: int
export(Color) var _color: Color

var max_angle: int = 360

func percent_remain(percent : float) -> void:
	_angle_to = int(percent * max_angle)
	update()


func draw_circle_arc(center, radius, angle_from, angle_to, color) -> void:
	var nb_points: int = 32
	var points_arc: PoolVector2Array = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point: float = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


func _draw() -> void:
	draw_circle_arc(_center, _radius, _angle_from, _angle_to, _color)
