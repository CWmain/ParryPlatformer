extends Node2D

var rotation_speed = 5
var bullet_type = preload("res://objects/bullet.tscn") 

func fire_gun():
	var b = bullet_type.instantiate()
	add_child(b)
	b.velocity = b.velocity.length() * Vector2.from_angle(b.rotation)
	


func _on_fire_gun_timer_timeout():
	fire_gun()
