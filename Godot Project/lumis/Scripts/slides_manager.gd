extends Node2D

func transition_to_lv():
	get_tree().change_scene_to_file("res://LevelScenes/0. Evil Wizard.tscn")

func transition_to_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://LevelScenes/Main Menu.tscn")
