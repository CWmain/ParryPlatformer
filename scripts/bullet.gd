extends CharacterBody2D

@export var bullet_stats: Base_Bullet

func _ready():
	velocity = bullet_stats.speed

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		var collision_object: Object = collision.get_collider()
		if collision_object.has_method("is_shot"):
			collision_object.is_shot(bullet_stats.damage)
		queue_free()
