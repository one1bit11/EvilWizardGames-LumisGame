extends Control

func transition_to_lv():
	get_tree().change_scene_to_file("res://LevelScenes/start_slides.tscn")


func _on_start_button_pressed() -> void:
	transition_to_lv()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	print("not yet...")
