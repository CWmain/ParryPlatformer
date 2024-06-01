extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var parry_box = $ParryBox

func attack():
	#parry_box.collision_mask = _default_collision_mask
	animation_player.play("swing")
	

func _on_parry_box_area_entered(area):
	if area.has_method("parry"):
		area.parry()
