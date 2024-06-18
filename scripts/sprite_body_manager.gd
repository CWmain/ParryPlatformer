extends Node2D

@export var Head: Texture2D
@export var Body: Texture2D
@export var LArm: Texture2D
@export var RArm: Texture2D
@export var LLeg: Texture2D
@export var RLeg: Texture2D

@onready var animation_player = $AnimationPlayer

@onready var body = $Body
@onready var head = $Body/Head
@onready var l_arm = $Body/LArm
@onready var r_arm = $Body/RArm
@onready var l_leg = $Body/LLeg
@onready var r_leg = $Body/RLeg

func _ready():
	body.texture = Body
	head.texture = Head
	l_arm.texture = LArm
	r_arm.texture = RArm
	l_leg.texture = LLeg
	r_leg.texture = RLeg
