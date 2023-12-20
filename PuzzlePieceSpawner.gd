extends Node2D

var split : Vector2

var easy = Vector2(5, 3)
var normal = Vector2(10, 6)

var PUZZLE_PIECE = preload("res://puzzle_piece.tscn")

@onready var main = find_parent("Main")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.easy_mode:
		split = easy
	else:
		split = normal
	
	for x in split.x:
		for y in split.y:
			var pos := Vector2(x, y)
			spawn_piece(pos)

func spawn_piece(pos: Vector2):
	var new_piece : PuzzlePiece = PUZZLE_PIECE.instantiate()
	new_piece.split = split
	new_piece.pos = pos
	new_piece.position = random_pos_in_area()
	main.add_child.call_deferred(new_piece)

func random_pos_in_area() -> Vector2:
	var pos : Vector2
	
	pos.x = randf_range($TopLeft.global_position.x, $BottomRight.global_position.x)
	pos.y = randf_range($TopLeft.global_position.y, $BottomRight.global_position.y)
	
	return pos
