extends Pullable

@onready var gun = $Gun
@onready var player_detector_right = $PlayerDetectorRight

var _justSwapped: bool = false
var trackPlayer: Object = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if trackPlayer:
		#If the player has just turned around, the position is already updated to be correct
		if !_justSwapped:
			gun.rotation = (to_global(gun.position).angle_to_point(trackPlayer.position))
		if _justSwapped:
			_justSwapped = false

	move_and_slide()


func _on_player_detector_right_body_entered(body):
	trackPlayer = body



func _on_player_detector_right_body_exited(_body):
	#When exited detection cone, stop tracking player
	trackPlayer = null

func turnAround():
	player_detector_right.scale *= -1
	player_detector_right.position *= -1
	gun.rotation += 2*(3*PI/2 - gun.rotation)
	gun.position *= -1
	_justSwapped = true

func _on_swap_timeout():
	turnAround()
	

