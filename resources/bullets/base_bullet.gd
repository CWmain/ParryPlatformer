extends Resource
class_name Base_Bullet

@export var damage: int
@export var speed: Vector2

# Extend current function to change hit effect
func hit_effect(body: Player) -> void:
	body.health -= damage
	return
