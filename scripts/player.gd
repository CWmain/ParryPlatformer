extends CharacterBody2D
class_name Player

#Player Stats
@export var health: int = 5


# Ground Speed
const MAX_SPEED = 1000
const ACC = 2000
const DCC = 1500

# Air Speed
const MAX_AIR_SPEED = 2500
const AIR_DIRECTION_CHANGE_MULTI = 2
const AIR_ACC = 600
const AIR_DCC = 400
const GRAPPLE_SPEED = 2000

# Jump Speed
const JUMP_VELOCITY = -1200.0
const WALL_JUMP_SPEED = 1000

@onready var grapple_hook = $GrappleHook
@onready var sword = $Sword
@onready var coyote_time = $coyoteTime
@onready var ledge_detection = $LedgeDetection

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# -1 : 0 : 1
# Left : Right
var wallJumpDirection: int = 0
var _on_ledge: bool = false
var _on_ledge_pos: bool = false


func _ready():
	coyote_time.stop()

func _physics_process(delta):
	
	if is_on_floor():
		coyote_time.start()
	
	# Add the gravity.
	if coyote_time.is_stopped():
		velocity.y += gravity * delta

	# On a wall add drag velocity
	if wallJumpDirection != 0:
		velocity.y = gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and !coyote_time.is_stopped():
		velocity.y = JUMP_VELOCITY
		coyote_time.stop()

	# Handle wall jump
	if Input.is_action_just_pressed("jump") and wallJumpDirection != 0:
		velocity.y = JUMP_VELOCITY
		velocity.x = WALL_JUMP_SPEED * wallJumpDirection

	# Handle hold down
	if Input.is_action_just_pressed("down") and !is_on_floor():
		velocity.y = -JUMP_VELOCITY*2
	# On a ledge set velcoity.y to zero
	if _on_ledge:
		# 64 comes from the height of the player from 0,0
		velocity.y = 0
		if !_on_ledge_pos:
			position.y -= 1 
		

	# Handle Grapple
	if Input.is_action_pressed("grapple"):
		grapple_hook.shoot_grapple()

	if Input.is_action_just_released("grapple"):
		grapple_hook.release_grapple()

	# Handle moving player to grapple location
	if grapple_hook.hooked_loc != Vector2.ZERO:
		print(grapple_hook.hooked_loc)
		velocity = (grapple_hook.hooked_loc - position).normalized() * GRAPPLE_SPEED
		grapple_hook.hooked_loc = Vector2.ZERO
		move_and_slide()
	
	
	place_sword_way_player_is_facing()
	
	# Handle sword swing
	if Input.is_action_just_pressed("attack"):
		sword.attack()


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	if is_on_floor():
		ground_velocity(direction, delta)
	else:
		air_velocity(direction, delta)

	move_and_slide()

func place_sword_way_player_is_facing():
	var _mouse_pos = get_global_mouse_position()
	if _mouse_pos.x > position.x:
		sword.position = Vector2(64, 0)
		sword.scale = Vector2(1,1)
	else:
		sword.scale = Vector2(-1,1)
		sword.position = Vector2(-64, 0)

# Directly modifies velocity.x
func ground_velocity(direction, delta):
	if (direction == 0):
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, DCC * delta)
	
	elif sign(direction) != sign(velocity.x):
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, (DCC+ACC) * delta)
	
	else:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACC * delta)

# Directly modifies velocity.x
func air_velocity(direction, delta):
	if (direction == 0):
		velocity.x = move_toward(velocity.x, direction * MAX_AIR_SPEED, AIR_DCC * delta)
	
	elif sign(direction) != sign(velocity.x):
		velocity.x = move_toward(velocity.x, direction * MAX_AIR_SPEED, (AIR_DCC+AIR_ACC) * AIR_DIRECTION_CHANGE_MULTI * delta)
	
	else:
		velocity.x = move_toward(velocity.x, direction * MAX_AIR_SPEED, AIR_ACC * delta)

func is_shot(damage: int):
	print("Takes %d damage!!!" % damage)

func _on_wall_jump_detector_left_body_entered(body):
	wallJumpDirection = 1
	print("left wall jump entered ", body)

func _on_wall_jump_detector_left_body_exited(body):
	wallJumpDirection = 0
	print("left wall jump exited ", body)

func _on_wall_jump_detector_right_body_entered(body):
	wallJumpDirection = -1
	print("right wall jump entered ", body)

func _on_wall_jump_detector_right_body_exited(body):
	wallJumpDirection = 0
	print("right wall jump exited ", body)


func _on_ledge_detection_on_ledge_change():
	_on_ledge = !_on_ledge



func _on_ledge_detection_correct_position_change():
	_on_ledge_pos != _on_ledge_pos
