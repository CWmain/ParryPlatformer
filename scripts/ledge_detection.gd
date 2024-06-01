extends Node2D

signal on_ledge_change
signal correct_position_change


var _is_on_ledge: bool = false
var _correct_position: bool = false

func _physics_process(_delta):
	if _is_on_ledge != (!$AirDectection.is_colliding() and $WallDection.is_colliding()):
		on_ledge_change.emit()
		_is_on_ledge = !_is_on_ledge
		
	if _correct_position != ($PosSet.is_colliding() and $WallDection.is_colliding()):
		correct_position_change.emit()
		_correct_position = !_correct_position
