extends Control

var inCredits := false
var musicFade := false

func transition_to_lv():
	get_tree().change_scene_to_file("res://LevelScenes/start_slides.tscn")

func _physics_process(delta: float) -> void:
	if musicFade:
		$MusicPlayer.volume_linear = lerpf($MusicPlayer.volume_linear,0.0, 0.05)

func _on_start_button_pressed() -> void:
	$UIPress.pitch_scale = randf_range(0.9, 1.1)
	$UIPress.play()
	$FadeAnimationPlayer.play("StartFadeOut")
	$CreditsRect.mouse_filter = MOUSE_FILTER_STOP
	musicFade = true


func _on_quit_button_pressed() -> void:
	$UIPress.pitch_scale = randf_range(0.9, 1.1)
	$UIPress.play()
	$FadeAnimationPlayer.play("QuitFadeOut")
	$CreditsRect.mouse_filter = MOUSE_FILTER_STOP
	musicFade = true

func quit_game():
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	$UIPress.pitch_scale = randf_range(0.9, 1.1)
	$UIPress.play()
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

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_start_button_mouse_entered() -> void:
	$UIHover.pitch_scale = randf_range(0.9, 1.1)
	$UIHover.play()


func _on_credits_button_mouse_entered() -> void:
	$UIHover.pitch_scale = randf_range(0.9, 1.1)
	$UIHover.play()


func _on_quit_button_mouse_entered() -> void:
	$UIHover.pitch_scale = randf_range(0.9, 1.1)
	$UIHover.play()


func _on_quit_button_mouse_exited() -> void:
	$UIHover.pitch_scale = randf_range(0.6, 0.8)
	$UIHover.play()


func _on_credits_button_mouse_exited() -> void:
	$UIHover.pitch_scale = randf_range(0.6, 0.8)
	$UIHover.play()


func _on_start_button_mouse_exited() -> void:
	$UIHover.pitch_scale = randf_range(0.6, 0.8)
	$UIHover.play()
