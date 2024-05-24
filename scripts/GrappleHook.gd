extends Node2D
class_name grapple_point


@export var _cross_hair_radius : float = 200
@export var _grapple_length : float = 200
@export var _grapple_rope_speed : float = 3000
@export var _grapple_drop_distance: float = 100
@onready var _cross_hair = $CrossHair

@onready var _rope = $Rope
@onready var grapple_cooldown = $GrappleCooldown

var isGrappling: bool = false
var grappleOut: bool = false

# When hooked is true player logic makes the player go towards the hooked location
var hooked: bool = false
var hooked_loc: Vector2 = Vector2(0,0)

var hooked_object: Pullable = null

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
	
	grapple_shoot_and_return(_delta)
	
	#Pull object logic
	if hooked_object:
		if _grapple_tip.position.distance_to(Vector2(0,0)) < _grapple_drop_distance:
			
			hooked_object.follow_hook(to_global(_grapple_tip.position.normalized()*_grapple_drop_distance))
			print("Not Pulling")
			hooked_object = null
		else:
			print("Pulling")
			hooked_object.follow_hook(to_global(_grapple_tip.position))

func collision_logic(collision: KinematicCollision2D) -> void:
	if !collision:
		return
	
	var isTileMap = collision.get_collider().get_class() == "TileMap"
	if isTileMap:
		return

	var isGrapplable = collision.get_collider().collision_layer & 8 == 8
	if isGrapplable:
		# When hooked is set to true, triggers behviour in player
		hooked_loc = collision.get_collider().get_parent().position
		hooked = true
		return

	var isPullable = collision.get_collider().collision_layer & 16 == 16
	if isPullable:
		hooked_object = collision.get_collider()
		return

func grapple_shoot_and_return(_delta):
	if isGrappling:
		
		grappleOut = true
		
		# If grapple hasn't reached max length, increase it
		var grappleReachedMaxLength: bool = _grapple_tip.position.distance_to(Vector2(0,0)) >= _grapple_length
		if !grappleReachedMaxLength:
			
			_grapple_tip.velocity = _grapple_normal * _grapple_rope_speed
			
			#On the occurance of collision
			var collision : KinematicCollision2D = _grapple_tip.move_and_collide(_grapple_tip.velocity * _delta)
			if collision:
				collision_logic(collision)
				release_grapple()
		
		# Reached max length
		grappleReachedMaxLength = _grapple_tip.position.distance_to(Vector2(0,0)) >= _grapple_length
		if _grapple_tip.position.distance_to(Vector2(0,0)) >= _grapple_length:
			_grapple_tip.position = _grapple_normal*_grapple_length
			release_grapple()
	
	# Grapple Returning
	else:
		if _grapple_tip.position.distance_to(Vector2(0,0)) > 50:
			_grapple_tip.velocity = _grapple_tip.position.normalized() * _grapple_rope_speed * -1
			_grapple_tip.move_and_collide(_grapple_tip.velocity * _delta)
		else:
			_grapple_tip.position = Vector2(0,0)
			# Start timer when grapple is fully retracted
			if grapple_cooldown.is_stopped():
				grapple_cooldown.start()

func shoot_grapple():
	if !grappleOut:
		# When grappling enable collision mask on GrappleBlock and Grapple
		_grapple_tip.collision_mask = 28
		_grapple_tip.rotation = _cross_hair.position.angle() + PI / 2
		#Update shoot direction
		_grapple_normal = _mouse_pos_normal.normalized()
		#Toggle is grappling
		isGrappling = true
		
func release_grapple():
	# Turn off collision mask on return to prevent hook from getting stuck 
	_grapple_tip.collision_mask = 0
	isGrappling = false
	


func _on_grapple_cooldown_timeout():
	grappleOut = false
