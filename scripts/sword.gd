extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var parry_box = $ParryBox

var _default_collision_mask = 64

func attack():
	#parry_box.collision_mask = _default_collision_mask
	animation_player.play("swing")
	

func _on_parry_box_area_entered(area):
	if area.has_method("parry"):
		area.parry()


func _on_animation_player_animation_finished(anim_name):
	return
	if anim_name == "swing":
		parry_box.collision_mask = 0
