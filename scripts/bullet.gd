extends Area2D


@onready var sprite_2d = $Sprite2D

@export var bullet_stats: Base_Bullet
var velocity: Vector2 = Vector2.ZERO

func _ready():
	velocity = bullet_stats.speed

func _physics_process(delta):
	position += velocity*delta

func parry():
	velocity *= -5
	sprite_2d.modulate = Color("blue")
	

func _on_body_entered(body):

	if body.has_method("is_shot"):
		bullet_stats.hit_effect(body)

	queue_free()

