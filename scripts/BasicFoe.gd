extends Pullable


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 2
	
	move_and_slide()
