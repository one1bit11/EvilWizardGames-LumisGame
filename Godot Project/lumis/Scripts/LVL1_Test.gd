extends Node3D

@export var mango:CharacterBody3D
@export var checkpointPos:Vector3 = Vector3(0,0,0)
@export var uiAnimation:AnimationPlayer
@export var uiAnimationPopUp:AnimationPlayer

#var played1:bool = false
var played2:bool = false
var played3:bool = false
var played4:bool = false

var fadeSewerMusic = false

func reset_mango_to_checkpoint():
	mango.position = checkpointPos

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		uiAnimation.play("Respawn")

func _on_checkpoint_area_entered(area: Area3D, extra_arg_0: Vector3) -> void:
	if area.name == "MangoTrigger":
		checkpointPos = extra_arg_0


func _on_death_trigger_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		uiAnimation.play("Respawn")


func _on_music_replace_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		print("Music Change")
		$Audio/Music/MusicPlayer.volume_db = -80
		$Audio/Music/MusicPlayerAlt.volume_db = 20


func _on_music_play_area_entered(area: Area3D) -> void:
	print("aa2")
	if area.name == "MangoTrigger":
		print("Music Play")
		if $Audio/Music/MusicPlayer.playing == false:
			$Audio/Music/MusicPlayer.playing = true


func _on_ending_trigger_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		get_tree().change_scene_to_file("res://LevelScenes/end_slides.tscn")


func _on_music_stop_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		fadeSewerMusic = true

func _physics_process(delta: float) -> void:
	if fadeSewerMusic == true:
		$Audio/Music/MusicPlayer.volume_db = lerpf($Audio/Music/MusicPlayer.volume_db,-80.0, 0.002)
		pass


func _on_music_play_2_nd_half_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		if $Audio/Music/MusicPlayerAlt.playing == false:
			$Audio/Music/MusicPlayerAlt.playing = true

func _on_pop_up_play_2_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger" && !played2:
		uiAnimationPopUp.stop()
		uiAnimationPopUp.play("2")
		played2 = true


func _on_pop_up_play_3_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger" && !played3:
		uiAnimationPopUp.stop()
		uiAnimationPopUp.play("3")
		played3 = true


func _on_pop_up_play_4_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger" && !played4:
		uiAnimationPopUp.stop()
		uiAnimationPopUp.play("4")
		played4 = true
