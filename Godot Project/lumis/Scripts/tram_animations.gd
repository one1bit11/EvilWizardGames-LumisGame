extends Node

@export var tramAnimation1:AnimationPlayer
@export var tramAnimation2:AnimationPlayer
@export var tramAnimation3:AnimationPlayer
@export var tramAnimation4:AnimationPlayer

func _ready() -> void:
	#print("1")
	tramAnimation1.play("Move")
	await get_tree().create_timer(0.75).timeout
	#print("2")
	tramAnimation2.play("Move")
	await get_tree().create_timer(0.75).timeout
	#print("3")
	tramAnimation3.play("Move")
	await get_tree().create_timer(0.75).timeout
	tramAnimation4.play("Move")
