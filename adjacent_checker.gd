extends Area2D

signal adjacent_enter(puzzle_piece, direction)
signal adjacent_exit(puzzle_piece, direction)

var direction : Vector2


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var puzzle_piece : PuzzlePiece = area.get_parent()
	
	emit_signal("adjacent_enter", puzzle_piece, direction)


func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var puzzle_piece : PuzzlePiece = area.get_parent()
	
	emit_signal("adjacent_exit", puzzle_piece, direction)
