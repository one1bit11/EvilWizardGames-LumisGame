extends CharacterBody3D





@export_group("Movement")
#speed value, adjust in the inspector
@export var speed := 1.0
#the value for rotation when rolling
@export var rotVal:float
#acceleration variable
@export var acc := 1.0
#turning speed 
@export var turnSpeed := 12.0
#Mango mesh
@export var mesh:Node3D
#jump velocity
@export var jumpVelocity := 10.0

@export_subgroup("Sticking")
#raycast to detect surface details
@export var faceChecker:ShapeCast3D
#the length of the raycast to stick to something, keep negative
@export var FCLength := -1.5
#used to get the surfaces that are being stuck to to have the FC target them
@export var stickRadius:Area3D
#sticky mode toggle
var stickyMode = false
#is actively sticking to something
var isSticking = false
#used later to move along walls or the floor


var stickTarget:Node3D







@export_group("Camera")
#camera control relevant gameobjects
@export var camPivot:Node3D

@export var cam:Camera3D
#camera control settings
@export_range(0.0,1.0) var mouseSensitivity = 0.01
#the limit to tilting the camera up or down
@export var tiltLimit := deg_to_rad(75)
# the hight the camera pivot point is above the character
@export var camPivotHeight := 2


@export_group("Other")







func _get_move_input(delta):
	#declare dir as a variable
	var dir:Vector3
	#declare rot as a variable
	var rot:float
	#save velocity.y
	var vy = velocity.y
	#prevent movement in the vertical based on camera
	velocity.y = 0
	#assign a value to each input, should work with controller too
	var input = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
	#set the diraction based on the value and the camera rotation
	if stickyMode:
		rot = -(atan2(faceChecker.get_collision_normal(1).z, faceChecker.get_collision_normal(1).x) -PI/2)
		var fInput = Input.get_action_strength("MoveForward") - Input.get_action_strength("MoveBackwards")
		var hInput = Input.get_action_strength("MoveRight") -  Input.get_action_strength("MoveLeft")
		dir = Vector3(hInput, fInput, 0).rotated(Vector3.UP,rot).normalized()
	else:
		rot = camPivot.rotation.y
		
		dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, rot)
	
	#lerp the velocity for smoother movement and acceleration
	velocity = lerp(velocity, dir * speed, acc * delta)
	#set the vertical velocity to the same as it was
	velocity.y = vy
	#rotate in the right direction
	##rotate(-dir.normalized(),rotVal)
	

func _physics_process(delta: float) -> void:
	
	#call the climb function each frame, we don't have to worry that much about hardware efficiency rn
	_stick()
	if stickyMode:
		velocity += faceChecker.get_collision_point(0) - global_position
	
	#Because the camera is top level, this allows it to still follow the player without inheriting the rotation
	camPivot.global_position = Vector3(global_position.x,global_position.y + camPivotHeight, global_position.z)
	_get_move_input(delta)
	velocity += get_gravity()
	move_and_slide()
	#allows the movement angles to be more consistent and sets rotation to a set speed for the character
	if velocity.length() > 1.0:
		rotation.y = lerp_angle(rotation.y, camPivot.rotation.y, turnSpeed * delta)


func _process(delta: float) -> void:
	#move the face checker to check the surface the player is on
	
	
	if stickTarget != null:
		faceChecker.look_at(stickTarget.global_position)
		#print((stickTarget.global_position))
	
	
	#if is_on_floor():
	#	faceChecker.target_position = Vector3(0,FCLength,0)
	#elif is_on_wall():
	#	faceChecker.target_position = Vector3(0,0,FCLength)
	#elif is_on_ceiling():
	#	faceChecker.target_position = Vector3(0,-FCLength,0)





#Camera control with mouse, currently researching controller as well. I don't have a controller to test with 
func _unhandled_input(event: InputEvent) -> void:
	
	
	
	if event is InputEventMouseMotion:
		#Move the camera with the mouse in proportion to sensitivity
		camPivot.rotation.x -= event.relative.y * mouseSensitivity * get_process_delta_time()
		#rotate the camera same as before
		camPivot.rotation.y -= event.relative.x * mouseSensitivity * get_process_delta_time()
		#clamp the values so the camera doesn't spin
		camPivot.rotation.x = clampf(camPivot.rotation.x, -tiltLimit, tiltLimit)
		
		

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y += jumpVelocity


func _on_stick_radius_body_entered(body: Node3D) -> void:
	
	if body!= self:
		stickTarget = body
		


#func _on_stick_radius_body_exited(body: Node3D) -> void:
	#if body == stickTarget:
	#	stickTarget = null


func _stick():
	# set sticky mode to true while button is held, can be changed to toggle if/when we add settings
	if Input.is_action_pressed("StickMode"):
		stickyMode = true
	else:
		stickyMode = false
	
	
	
	pass


func _on_stick_radius_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
