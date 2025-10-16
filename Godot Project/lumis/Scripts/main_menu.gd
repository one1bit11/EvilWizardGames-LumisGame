extends Control

var inCredits := false;

func transition_to_lv():
	get_tree().change_scene_to_file("res://LevelScenes/start_slides.tscn")


func _on_start_button_pressed() -> void:
	$FadeAnimationPlayer.play("StartFadeOut")
	$CreditsRect.mouse_filter = MOUSE_FILTER_STOP


func _on_quit_button_pressed() -> void:
	$FadeAnimationPlayer.play("QuitFadeOut")
	$CreditsRect.mouse_filter = MOUSE_FILTER_STOP

func quit_game():
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	$CreditsRect.mouse_filter = MOUSE_FILTER_STOP
	$CreditsRect/AnimationPlayer.stop()
	$CreditsRect/AnimationPlayer.play("FadeInCredits")
	inCredits = true

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if inCredits:
			$CreditsRect.mouse_filter = MOUSE_FILTER_IGNORE
			$CreditsRect/AnimationPlayer.stop()
			$CreditsRect/AnimationPlayer.play("FadeOutCredits")
			inCredits = false
