extends Node2D


@export var _cross_hair_radius : float = 200
@export var _grapple_length : float = 200
@export var _grapple_rope_speed : float = 5000
@onready var _cross_hair = $CrossHair

@onready var _rope = $Rope

var isGrappling: bool = false
var grappleOut: bool = false
var _mouse_pos_normal: Vector2 = Vector2(1,0)
var _grapple_normal: Vector2 = Vector2(1,0)

@onready var _grapple_tip = $GrappleTip

func _process(_delta):
	_mouse_pos_normal = get_local_mouse_position().normalized()
	_cross_hair.position = _mouse_pos_normal * _cross_hair_radius
	
	#print(_rope.position.distance_to(_grapple_tip.position))
	#print("Rope Size: ", _rope.size.y)
	var distance_to_tip = _rope.position.distance_to(_grapple_tip.position)
	if _rope.size.y != distance_to_tip:
		_rope.rotation = _grapple_tip.rotation + PI
		_rope.size.y = distance_to_tip
	
func _physics_process(_delta):
	
	if isGrappling:
		if _grapple_tip.position.distance_to(Vector2(0,0)) < _grapple_length:

			grappleOut = true
			_grapple_tip.velocity = _grapple_normal * _grapple_rope_speed
			_grapple_tip.move_and_slide()
		
		if _grapple_tip.is_on_floor():
			isGrappling = false
		# Reached max length
		if _grapple_tip.position.distance_to(Vector2(0,0)) >= _grapple_length:
			_grapple_tip.position = _grapple_normal*_grapple_length
			isGrappling = false

	else:
		if _grapple_tip.position.distance_to(Vector2(0,0)) > 50:
			_grapple_tip.velocity = _grapple_normal * -_grapple_rope_speed
			_grapple_tip.move_and_slide()
		else:
			_grapple_tip.position = Vector2(0,0)
			grappleOut = false
	

func shoot_grapple():
	if !grappleOut:
		_grapple_tip.rotation = _cross_hair.position.angle() + PI/2
		#Update shoot direction
		_grapple_normal = _mouse_pos_normal.normalized()
		#Toggle is grappling
		isGrappling = true
		
func release_grapple():
	isGrappling = false
	
