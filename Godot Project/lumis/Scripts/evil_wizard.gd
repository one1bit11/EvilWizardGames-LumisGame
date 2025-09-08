## This is just the game manager script that will run globally throughout the whole game

extends Node

func _ready() -> void:
	#traps the mouse in the window mwwahahaahah
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _input(event: InputEvent) -> void:
	#frees the mouse, remember to delete this before release this si j
	if Input.is_action_just_pressed("ExitMenu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	## Teleports Mango to a set position
	if Input.is_key_pressed(KEY_0):
		#$Mango.global_position = Vector3(1.609, 3.242, -5.446)
		get_tree().reload_current_scene()
