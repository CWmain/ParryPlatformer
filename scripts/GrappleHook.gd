extends Node2D
class_name grapple_point


@export var _cross_hair_radius : float = 200
@export var _grapple_length : float = 200
@export var _grapple_rope_speed : float = 5000
@onready var _cross_hair = $CrossHair

@onready var _rope = $Rope
@onready var grapple_cooldown = $GrappleCooldown

var isGrappling: bool = false
var grappleOut: bool = false
var hooked: bool = false

var _mouse_pos_normal: Vector2 = Vector2(1,0)
var _grapple_normal: Vector2 = Vector2(1,0)

@onready var _grapple_tip = $GrappleTip

func _ready():
	grapple_cooldown.stop()

func _process(_delta):
	_mouse_pos_normal = get_local_mouse_position().normalized()
	_cross_hair.position = _mouse_pos_normal * _cross_hair_radius
	
	#print(_rope.position.distance_to(_grapple_tip.position))
	#print("Rope Size: ", _rope.size.y)
	var distance_to_tip = _rope.position.distance_to(_grapple_tip.position)
	if _rope.size.y != distance_to_tip:
		_rope.rotation = _rope.position.angle_to(_grapple_tip.position) + PI/2
		_rope.size.y = distance_to_tip
	
func _physics_process(_delta):
	if isGrappling:
		if _grapple_tip.position.distance_to(Vector2(0,0)) < _grapple_length:

			grappleOut = true
			_grapple_tip.velocity = _grapple_normal * _grapple_rope_speed
			var collision : KinematicCollision2D = _grapple_tip.move_and_collide(_grapple_tip.velocity * _delta)
			if collision:
				if collision.get_collider().collision_layer == 8:
					print("Pull Player")
					hooked = true
				print("Collision Parent: ", collision.get_collider().get_parent().name)
				print("Collision Parent: ", collision.get_collider().collision_layer)

				release_grapple()
		
		# Reached max length
		if _grapple_tip.position.distance_to(Vector2(0,0)) >= _grapple_length:
			_grapple_tip.position = _grapple_normal*_grapple_length
			release_grapple()

	elif hooked:
		print("pull player")
	
	else:
		if _grapple_tip.position.distance_to(Vector2(0,0)) > 50:
			#_grapple_tip.rotation = _grapple_tip.position.angle_to(to_local(Vector2(0,0))) - PI/4
			_grapple_tip.velocity = _grapple_tip.position.normalized() * -_grapple_rope_speed
			_grapple_tip.move_and_collide(_grapple_tip.velocity * _delta)
		else:
			_grapple_tip.position = Vector2(0,0)
			if grapple_cooldown.is_stopped():
				grapple_cooldown.start()
	

func shoot_grapple():
	if !grappleOut:
		_grapple_tip.collision_mask = 12
		_grapple_tip.rotation = _cross_hair.position.angle() + PI / 2
		#Update shoot direction
		_grapple_normal = _mouse_pos_normal.normalized()
		#Toggle is grappling
		isGrappling = true
		
func release_grapple():
	#_grapple_tip.rotation = _grapple_tip.position.angle_to(Vector2(0,0)) + PI/2
	isGrappling = false
	_grapple_tip.collision_mask = 0
	


func _on_grapple_cooldown_timeout():
	grappleOut = false
