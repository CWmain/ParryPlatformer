extends Node2D


@export var _cross_hair_radius : float = 200
@export var _grapple_length : float = 500
@export var _grapple_rope_speed : float = 100
@onready var _cross_hair = $CrossHair

@onready var _rope = $Rope

var isGrappling: bool = false
var _mouse_pos_normal: Vector2 = Vector2(1,0)

func _process(_delta):
	_mouse_pos_normal = get_local_mouse_position().normalized()
	_cross_hair.position = _mouse_pos_normal * _cross_hair_radius
	
func _physics_process(_delta):
	if isGrappling:
		_rope.rotation = _cross_hair.position.angle() + PI/2
		if _rope.size.y < _grapple_length:		
			_rope.size.y += _grapple_rope_speed
			_rope.pivot_offset.y += _grapple_rope_speed
			_rope.position.y -= _grapple_rope_speed
	else:
		if _rope.size.y > 16:		
			_rope.size.y -= _grapple_rope_speed
			_rope.pivot_offset.y -= _grapple_rope_speed
			_rope.position.y += _grapple_rope_speed

	
