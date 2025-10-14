extends Control

func transition_to_lv():
	get_tree().change_scene_to_file("res://LevelScenes/start_slides.tscn")


func _on_start_button_pressed() -> void:
	$FadeAnimationPlayer.play("StartFadeOut")


func _on_quit_button_pressed() -> void:
	$FadeAnimationPlayer.play("QuitFadeOut")

func quit_game():
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	print("not yet...")
