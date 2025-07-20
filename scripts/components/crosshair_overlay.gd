extends Node2D

@export var size: Vector2 = Vector2(32, 32)
@export var corner_length := 6.0
@export var color := Color.WHITE

func _draw():
	var corners = [
		Vector2(0, 0),
		Vector2(size.x, 0),
		Vector2(size.x, size.y),
		Vector2(0, size.y),
	]

	for i in range(4):
		var corner = corners[i]
		var horizontal_offset = -corner_length if i in [1, 2] else corner_length
		var vertical_offset = -corner_length if i in [2, 3] else corner_length

		var horizontal = Vector2(corner.x + horizontal_offset, corner.y)
		var vertical = Vector2(corner.x, corner.y + vertical_offset)

		draw_line(corner, horizontal, color, 1.5)
		draw_line(corner, vertical, color, 1.5)
