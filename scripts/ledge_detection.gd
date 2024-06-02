extends Node2D

signal on_ledge_change(value: bool)


var _is_on_ledge: bool = false

func _physics_process(_delta):
	if _is_on_ledge != (!$AirDectection.is_colliding() and $WallDection.is_colliding()):
		_is_on_ledge = !_is_on_ledge
		on_ledge_change.emit(_is_on_ledge)

