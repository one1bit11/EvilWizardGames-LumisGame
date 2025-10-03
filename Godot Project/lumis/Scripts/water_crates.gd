extends Node3D

@export var crateAnimation1:AnimationPlayer
@export var crateAnimation2:AnimationPlayer
@export var crateAnimation3:AnimationPlayer
@export var crateAnimation4:AnimationPlayer
@export var crateAnimation5:AnimationPlayer
@export var crateAnimation6:AnimationPlayer
@export var crateAnimation7:AnimationPlayer

func _ready() -> void:
	print("1")
	crateAnimation1.play("CreateMove")
	await get_tree().create_timer(2.0).timeout
	print("2")
	crateAnimation2.play("CreateMove")
	await get_tree().create_timer(2.0).timeout
	print("3")
	crateAnimation3.play("CreateMove")
	await get_tree().create_timer(2.0).timeout
	print("4")
	crateAnimation4.play("CreateMove")
	await get_tree().create_timer(2.0).timeout
	print("5")
	crateAnimation5.play("CreateMove")
	#await get_tree().create_timer(2.0).timeout
	#print("6")
	#crateAnimation6.play("CreateMove")
	#await get_tree().create_timer(2.0).timeout
	#print("7")
	#crateAnimation7.play("CreateMove")
