extends Area2D

@export var bullet_stats: Base_Bullet
var velocity: Vector2 = Vector2.ZERO

func _ready():
	velocity = bullet_stats.speed

func _physics_process(delta):
	position += velocity*delta



func _on_body_entered(body):

	if body.has_method("is_shot"):
		bullet_stats.hit_effect(body)

	queue_free()

