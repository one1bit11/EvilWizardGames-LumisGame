extends Node3D


func _ready() -> void:
	#traps the mouse in the window mwwahahaahah
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _input(event: InputEvent) -> void:
	#frees the mouse, remember to delete this before release this si j
	if Input.is_action_just_pressed("ExitMenu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
