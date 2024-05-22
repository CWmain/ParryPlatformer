extends CharacterBody2D


const SPEED = 300.0
const AIR_SPEED = 5.0
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
		velocity.x = JUMP_VELOCITY * wallJumpDirection

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if is_on_floor():
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_SPEED)

	move_and_slide()

func _on_wall_jump_detector_left_body_entered(body):
	wallJumpDirection = -1
	print("left wall jump entered ", body)
	



func _on_wall_jump_detector_left_body_exited(body):
	wallJumpDirection = 0
	print("left wall jump exited ", body)


func _on_wall_jump_detector_right_body_entered(body):
	wallJumpDirection = 1
	print("right wall jump entered ", body)


func _on_wall_jump_detector_right_body_exited(body):
	wallJumpDirection = 0
	print("right wall jump exited ", body)



