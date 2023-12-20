extends Node2D

var dragging_piece : PuzzlePiece
var dragging_group #: Array[PuzzlePiece]

var piece_groups : Array #: Array[Array]

var num_of_pieces = 0

func _ready():
	$CanvasLayer/CenterContainer/Label.hide()
	$CanvasLayer/HomeConfirm.hide()
	
	var split = $PuzzlePieceSpawner.split
	num_of_pieces = split.x * split.y


func _process(delta):
	if is_instance_valid(dragging_piece):
		dragging_piece.global_position = get_global_mouse_position()
		dragging_piece.snap_pieces(dragging_group)


func start_dragging_piece(piece: PuzzlePiece):
	dragging_piece = piece
	dragging_group = []
	for group in piece_groups:
		if dragging_piece in group:
			dragging_group = group


func check_for_win():
	var count_groups = 0
	for group in piece_groups:
		if group != null:
			count_groups += 1
	
	if count_groups != 1:
		return
	
	if len(piece_groups[0]) == num_of_pieces:
		$CanvasLayer/CenterContainer/Label.show()


func snap_pieces(piece_a, piece_b):
	var group_a = [piece_a]
	var group_b = [piece_b]
	var indexes_to_remove = []
	for index in range(len(piece_groups)):
		var group = piece_groups[index]
		if piece_a in group && piece_b in group:
			return
		
		if piece_a in group:
			group_a = group 
			indexes_to_remove.append(index)
		if piece_b in group:
			group_b = group
			indexes_to_remove.append(index)
	
	for i in range(len(indexes_to_remove)):
		var index = indexes_to_remove[i] - i
		piece_groups.remove_at(index)
	
	var new_group = group_a + group_b
	piece_groups.append(new_group)
	piece_a.snap_pieces(new_group)
	check_for_win()


func _input(event: InputEvent):
	if event.is_action_released("drag"):
		if is_instance_valid(dragging_piece):
			dragging_piece.stop_dragging()
		dragging_piece = null
		if dragging_group != null:
			for piece in dragging_group:
				piece.stop_dragging()
		dragging_group = []


func _on_home_button_pressed():
	$CanvasLayer/HomeConfirm.show()

func _on_no_button_pressed():
	$CanvasLayer/HomeConfirm.hide()

func _on_yes_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
