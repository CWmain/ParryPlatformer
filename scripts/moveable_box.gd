extends CharacterBody2D
class_name Pullable

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func follow_hook(hook_position: Vector2):
	velocity.y = 0 
	position = hook_position

