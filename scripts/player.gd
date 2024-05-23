extends CharacterBody2D


# Ground Speed
const MAX_SPEED = 1000
const ACC = 2000
const DCC = 1500

# Air Speed
const MAX_AIR_SPEED = 2500
const AIR_DIRECTION_CHANGE_MULTI = 2
const AIR_ACC = 600
const AIR_DCC = 400

# Jump Speed
const JUMP_VELOCITY = -800.0
const WALL_JUMP_SPEED = 1000

@onready var speed_label = $SpeedLabel
@onready var grapple_hook = $GrappleHook

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# -1 : 0 : 1
# Left : Right
var wallJumpDirection: int = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if wallJumpDirection != 0:
		velocity.y = gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle wall jump
	if Input.is_action_just_pressed("jump") and wallJumpDirection != 0:
		velocity.y = JUMP_VELOCITY
		velocity.x = WALL_JUMP_SPEED * wallJumpDirection

	# Handle hold down
	if Input.is_action_just_pressed("down") and !is_on_floor():
		velocity.y = -JUMP_VELOCITY

	if Input.is_action_pressed("grapple"):
		grapple_hook.shoot_grapple()

	if Input.is_action_just_released("grapple"):
		grapple_hook.release_grapple()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	if is_on_floor():
		ground_velocity(direction, delta)
	else:
		air_velocity(direction, delta)
	
	speed_label.text = "%v" % velocity
	move_and_slide()

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
