extends Node2D

var bullet_type = preload("res://objects/bullet.tscn")
## The minimum amount of time between shots
@export var shotResetTimer: float  = 1
@onready var gun_sprite = $GunSprite
@onready var fire_gun_timer = $FireGunTimer

var _canShoot: bool = true

func _ready():
	fire_gun_timer.wait_time = shotResetTimer

func fire_gun():
	if !_canShoot:
		return
	_canShoot = false
	fire_gun_timer.start()
	var b = bullet_type.instantiate()
	
	# Add as child of parent (which would be the level scene) to avoid the bullet rotating with gun	
	get_tree().get_root().add_child(b)

	# Set the velocity to be at the correct angle from the gun
	var mult = -1 if scale.x < 0 else 1
	b.velocity = b.velocity.length() * Vector2.from_angle(rotation) * mult
	
	
	# Set the position to be the front of the gun in the global space (otherwise spawns at (0,0))
	var gunLength: int = gun_sprite.get_rect().size.x
	b.position.x += gunLength
	b.position = to_global(b.position)

	


func _on_fire_gun_timer_timeout():
	_canShoot = true
