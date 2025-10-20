extends Node3D

@export var mango:CharacterBody3D
@export var checkpointPos:Vector3 = Vector3(0,-37,4)
@export var uiAnimation:AnimationPlayer
@export var uiAnimationPopUp:AnimationPlayer

#var played1:bool = false
var played2:bool = false
var played3:bool = false
var played4:bool = false

@export var fadeSewerMusic = false

@export var transSewerMusic:bool = false

var transCityMusic:bool = false
var fadeCityMusic:bool = false

func _ready() -> void:
	uiAnimation.play("LongBlackFadeIn")

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
			$Audio/Music/MusicPlayer1Alt.playing = true


func _on_ending_trigger_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		play_ending()


func _on_music_stop_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		fadeSewerMusic = true

func _physics_process(delta: float) -> void:
	if fadeSewerMusic == true:
		$Audio/Music/MusicPlayer1Alt.volume_linear = lerpf($Audio/Music/MusicPlayer1Alt.volume_linear,0.0, 0.05)
	if transSewerMusic == true && !fadeSewerMusic:
		$Audio/Music/MusicPlayer.volume_linear = lerpf($Audio/Music/MusicPlayer.volume_linear,0.0, 0.05)
		$Audio/Music/MusicPlayer1Alt.volume_linear = lerpf($Audio/Music/MusicPlayer1Alt.volume_linear,10.0, 0.05)
		
	if fadeCityMusic == true:
		$Audio/Music/MusicPlayerAlt2Alt.volume_linear = lerpf($Audio/Music/MusicPlayerAlt2Alt.volume_linear,0.0, 0.05)
	if transCityMusic == true && !fadeCityMusic:
		$Audio/Music/MusicPlayerAlt.volume_linear = lerpf($Audio/Music/MusicPlayerAlt.volume_linear,0.0, 0.05)
		$Audio/Music/MusicPlayerAlt2Alt.volume_linear = lerpf($Audio/Music/MusicPlayerAlt2Alt.volume_linear,10.0, 0.05)


func _on_music_play_2_nd_half_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		if $Audio/Music/MusicPlayerAlt.playing == false:
			$Audio/Music/MusicPlayerAlt.playing = true
			$Audio/Music/MusicPlayerAlt2Alt.playing = true

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


func _on_music_replace_2_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger" && !transSewerMusic:
		transSewerMusic = true


func _on_music_replace_3_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger" && !transCityMusic:
		transCityMusic = true


func _on_music_stop_2_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		fadeCityMusic = true

func change_tram_texture(tram_node_path):
	## Randomizes tram texture code below:
	
	#var tramNode:MeshInstance3D = get_node(tram_node_path)
	#
	#var newMaterial:StandardMaterial3D
	#
	#var randomTexture:int = randi_range(0,4)
	#match randomTexture:
		#0:
			#newMaterial = load("res://Textures/Other/SolidColours/Orange.tres")
		#1:
			#newMaterial = load("res://Textures/Other/SolidColours/Pink.tres")
		#2:
			#newMaterial = load("res://Textures/Other/SolidColours/Purple.tres")
		#3:
			#newMaterial = load("res://Textures/Other/SolidColours/Blue.tres")
		#4:
			#newMaterial = load("res://Textures/Other/SolidColours/BrownAlt.tres")
	#
	#tramNode.set_surface_override_material(0, newMaterial)
	
	pass

func play_ending():
	$UI/WhiteRect/WhiteAnimationPlayer.play("LongWhiteFadeOut")

func transition_to_end_slides():
	get_tree().change_scene_to_file("res://LevelScenes/end_slides.tscn")


func _on_w_death_trigger_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		SignalBus.emit_signal("playSplash")
		uiAnimation.play("Respawn")

func lock_controls():
	SignalBus.emit_signal("controlLock")

func unlock_controls():
	SignalBus.emit_signal("controlUnlock")
