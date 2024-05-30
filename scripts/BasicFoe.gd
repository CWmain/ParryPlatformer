extends Pullable

@onready var gun = $Gun

var trackPlayer: Object = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if trackPlayer:
		print(trackPlayer.position)
		gun.rotation = to_global(gun.position).angle_to_point(trackPlayer.position)
	move_and_slide()


func _on_player_detector_right_body_entered(body):
	trackPlayer = body



func _on_player_detector_right_body_exited(body):
	#When exited detection cone, stop tracking player
	trackPlayer = null
