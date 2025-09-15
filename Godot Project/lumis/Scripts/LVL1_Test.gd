extends Node3D

@export var mango:CharacterBody3D
@export var checkpointPos:Vector3 = Vector3(0,0,0)

func reset_mango_to_checkpoint():
	mango.position = checkpointPos

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		reset_mango_to_checkpoint()

func _on_checkpoint_area_entered(area: Area3D, extra_arg_0: Vector3) -> void:
	if area.name == "MangoTrigger":
		checkpointPos = extra_arg_0


func _on_death_trigger_area_entered(area: Area3D) -> void:
	if area.name == "MangoTrigger":
		reset_mango_to_checkpoint()
