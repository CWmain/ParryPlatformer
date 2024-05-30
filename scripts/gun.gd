extends Node2D

var rotation_speed = PI/8
var bullet_type = preload("res://objects/bullet.tscn") 
@export var firerate: float  = 1
@onready var gun_sprite = $GunSprite
@onready var fire_gun_timer = $FireGunTimer

func _ready():
	fire_gun_timer.wait_time = firerate

func _physics_process(delta):
	pass#rotation += rotation_speed*delta

func fire_gun():
	var b = bullet_type.instantiate()
	
	# Add as child of parent (which would be the level scene) to avoid the bullet rotating with gun	
	get_tree().get_root().add_child(b)

	# Set the velocity to be at the correct angle from the gun
	b.velocity = b.velocity.length() * Vector2.from_angle(rotation)
	
	
	# Set the position to be the front of the gun in the global space (otherwise spawns at (0,0))
	var gunLength: int = gun_sprite.get_rect().size.x
	b.position.x += gunLength
	b.position = to_global(b.position)

	


func _on_fire_gun_timer_timeout():
	fire_gun()
