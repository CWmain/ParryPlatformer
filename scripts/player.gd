extends CharacterBody2D

const MAX_SPEED = 1000
const ACC = 2000
const DCC = 1500

const MAX_AIR_SPEED = 2000
const AIR_ACC = 1000
const AIR_DCC = 500



const SPEED = 50000.0
const AIR_SPEED = 50000.0
const JUMP_VELOCITY = -800.0

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

	if Input.is_action_just_pressed("jump") and wallJumpDirection != 0:
		velocity.y = JUMP_VELOCITY
		velocity.x = SPEED  * wallJumpDirection * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	if is_on_floor():
		ground_velocity(direction, delta)
	
	

	move_and_slide()

func ground_velocity(direction, delta):
	if (direction == 0):
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, DCC * delta)
	
	elif sign(direction) != sign(velocity.x):
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, (DCC+ACC) * delta)
	
	else:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACC * delta)


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



