extends Sprite2D
class_name PuzzlePiece

# Set when instanced
var split : Vector2
var pos : Vector2

# Set at run time
var piece_size : Vector2

var adjacent_pieces = {
	Vector2.UP: null,
	Vector2.DOWN: null,
	Vector2.LEFT: null,
	Vector2.RIGHT: null,
}

var CHECKER = preload("res://adjacent_checker.tscn")

# Set to change look
var panel_padding := Vector2(1, 1)

signal start_dragging(piece)

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = Global.puzzle_image
	
	connect("start_dragging", get_parent().start_dragging_piece)
	set_image()
	resize_collision()
	position_direction_checkers()

func position_direction_checkers():
	for dir in adjacent_pieces.keys():
		var new_checker = CHECKER.instantiate()
		add_child(new_checker)
		new_checker.position = piece_size * dir
		new_checker.direction = dir
		
		new_checker.connect("adjacent_enter", adjacent_enter)
		new_checker.connect("adjacent_exit", adjacent_exit)


func adjacent_exit(puzzle_piece: PuzzlePiece, direction: Vector2):
	if adjacent_pieces[direction] == puzzle_piece:
		adjacent_pieces[direction] = null

func adjacent_enter(puzzle_piece: PuzzlePiece, direction: Vector2):
	adjacent_pieces[direction] = puzzle_piece

func resize_collision():
	var shape_size = $Area2D/CollisionShape2D.shape.size
	$Area2D.scale = piece_size / shape_size

func set_image():
	var image_size = texture.get_size()
	
	piece_size = image_size / split
	
	
	var top_left = piece_size * pos
	
	var new_rect = Rect2(top_left, piece_size)
	set_region_rect(new_rect)


func snap_single(piece: PuzzlePiece):
	var off_set = piece.pos - pos
	
	piece.global_position = (piece.pos - pos) * piece_size * scale + global_position

func snap_pieces(pieces):
	for piece in pieces:
		snap_single(piece)

func stop_dragging():	
	for dir in adjacent_pieces.keys():
		var puzzle_piece = adjacent_pieces[dir]
		if is_instance_valid(puzzle_piece):
			var needed_piece = pos + dir
			var piece_have = puzzle_piece.pos
			if piece_have == needed_piece:
				get_parent().snap_pieces(self, puzzle_piece)


func _on_static_body_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("drag"):
		emit_signal("start_dragging", self)
