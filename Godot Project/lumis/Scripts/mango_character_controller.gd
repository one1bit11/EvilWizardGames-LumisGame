extends CharacterBody3D





@export_group("Movement")
##speed value
@export var speed := 1.0
##the value for rotation when rolling
@export var rotVal:float
##acceleration variable
@export var acc := 1.0
##turning speed 
@export var turnSpeed := 12.0
##Mango mesh
@export var mesh:Node3D
##jump velocity
@export var jumpVelocity := 10.0
##how steep down a ramp can be to allign (without sticking)
@export var allignRampDown := 0.5
##how steep up a ramp can be to allign (without sticking)
@export var allignRampUp := 1.5
##gravity strength (keep negative)
@export var gravityStr := -2
##sprint speed modifyer
@export var sprintSpeed := 1.3
##coyote time timer
@export var coyoteTimer:Timer


##gravity
var grav := Vector3(0,-2,0)
##average normals of the surfaces nearby
var avgnormal := Vector3.ZERO
##Is sprinting
var sprinting := false
##if the player is able to jump
var canJump := true

@export_subgroup("Sticking")
##raycast to detect surface details
@export var faceChecker:ShapeCast3D
##the length of the raycast to stick to something, keep negative
@export var FCLength := -1.5
##how much force is applied to stick in one spot
@export var stickStrength:float
##the value that modifies movement speed while sticking
@export var stickSlow := 2.0
##the forward direction
@export var upwards:RayCast3D

##sticky mode toggle
var stickyMode = false
##is actively sticking to something
var isSticking = false
#used later to move along walls or the floor
##checks which of the objects facechecker is colliding with is the one that is best
var currentSurface:Node3D
##which of the surfaces is it
var currentSurfaceVal:int
##the point at which the force is aiming
var stickPoint:Vector3
##the direction to the stick point
var stickPointDir:Vector3
##which body is the most recent one contacted
var currentBody
##the average of sticking surfaces
var currentSurfacesAvr : Vector3
##the total values before being averaged of sticking surfaces
var currentSurfacesTot : Vector3








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

## Mango Eyes:
@export var mangoEyeR:MeshInstance3D
@export var mangoEyeL:MeshInstance3D

var squeezedBefore = false
var squeezedBeforeAlt = false

var mangoShadow:Node3D
@export var eyesNode:Node3D

var lerpWeight:float = 0.5

var camFOVMode:int = 1


func _get_move_input(delta):
	#declare dir as a variable
	var dir:Vector3
	#declare rot as a variable
	var rot:float
	#the vector 3 rot for rotating
	var stickRot:Vector3
	#save velocity.y
	var vy = velocity.y
	#assign a value to each input, should work with controller too
	var input = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
	var input3 := Vector3(input.x,0,input.y)
	if isSticking:
		stickRot = currentSurfacesAvr
		
		velocity = Vector3.ZERO
		input = Vector3.ZERO
		input = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
		#var forwardDir = 

		
		
		
		
		rot = -(atan2(faceChecker.get_collision_normal(currentSurfaceVal).z, faceChecker.get_collision_normal(currentSurfaceVal).x) - PI/2)
		
		var test = faceChecker.get_collision_normal(currentSurfaceVal).y
		var ygreater : bool
		var yequal : bool
		
		if !is_on_floor():
			#if Input.is_action_pressed("MoveForward"):
				#dir = avgnormal.cross(forwardDir).normalized().rotated(avgnormal.normalized(), - PI/2)
			#if Input.is_action_pressed("MoveBackwards"):
				#dir = avgnormal.cross(forwardDir).normalized().rotated(avgnormal.normalized(), PI/2)
			#if Input.is_action_pressed("MoveLeft"):
				#dir = avgnormal.cross(forwardDir).normalized()
			#if Input.is_action_pressed("MoveRight"):
				#dir = avgnormal.cross(forwardDir).normalized().rotated(avgnormal.normalized(), PI)
			#print("graf",forwardDir)
				## IDEA clamp campivot results to only be on the same plane that you're moving across while sticking to prevent falling off
				dir = Vector3(input.x,-input.y,0).rotated(Vector3(0,1 - test,0),rot).normalized()
		else:
			
			rot = camPivot.rotation.y
			dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, rot).normalized()
		
		
		
		
		#lerp the   for smoother movement and acceleration
		velocity = dir * (speed/stickSlow)
		
		
	else:
		#set the diraction based on the value and the camera rotation
		rot = camPivot.rotation.y
		dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, rot).normalized()
		#lerp the velocity for smoother movement and acceleration
		if sprinting == true:
			
			velocity = lerp(velocity, dir * sprintSpeed, acc * delta)
			

		else:
			
			velocity = lerp(velocity, dir * speed, acc * delta)


	

	#set the vertical velocity to the same as it was

	#rotate in the right direction
	##rotate(-dir.normalized(),rotVal)
	

func _physics_process(delta: float) -> void:
	
	mangoShadow.global_position.x = global_position.x
	mangoShadow.global_position.y = global_position.y - 24.785
	mangoShadow.global_position.z = global_position.z
	
	#eyesNode.global_position.lerp(global_position, 0.5)
	
	eyesNode.global_position.x = lerpf(eyesNode.global_position.x,global_position.x,lerpWeight)
	eyesNode.global_position.y = lerpf(eyesNode.global_position.y,global_position.y,0.65)
	eyesNode.global_position.z = lerpf(eyesNode.global_position.z,global_position.z,lerpWeight)
	
	#eyesNode.global_rotation.lerp(global_rotation, 0.5)
	
	eyesNode.global_rotation.x = lerpf(eyesNode.global_rotation.x,global_rotation.x,lerpWeight)
	eyesNode.global_rotation.y = lerpf(eyesNode.global_rotation.y,global_rotation.y,lerpWeight)
	eyesNode.global_rotation.z = lerpf(eyesNode.global_rotation.z,global_rotation.z,lerpWeight)
	
	if !isSticking:
		match camFOVMode:
			0:
				cam.fov = lerpf(cam.fov, 65.0, 0.25)
			1:
				cam.fov = lerpf(cam.fov, 75.0, 0.25)
			2:
				cam.fov = lerpf(cam.fov, 85.0, 0.25)
	else:
		cam.fov = lerpf(cam.fov, 65.0, 0.25)
	
	
	#call the climb function each frame, we don't have to worry that much about hardware efficiency rn
	_stick()
	



	if faceChecker.get_collision_count() == 0:
		isSticking = false
		squeezedBefore = false
		camFOVMode = 1
	#Because the camera is top level, this allows it to still follow the player without inheriting the rotation
	camPivot.global_position = Vector3(global_position.x,global_position.y + camPivotHeight, global_position.z)
	
	
	
	
	#check for sprinting input, can't sprint while sticking
	#if isSticking == false && stickyMode == false && Input.is_action_pressed("Sprint"):
	if Input.is_action_pressed("Sprint"):
		sprinting = true
		camFOVMode = 2
		if squeezedBeforeAlt == false && is_on_floor():
			squeeze()
			squeezedBeforeAlt = true
	else:
		sprinting = false
		camFOVMode = 1
		squeezedBeforeAlt = false
	_get_move_input(delta)
	#if !isSticking:
	velocity += grav
	#if is not sticking and is on floor, alligns with floor

	for o in faceChecker.get_collision_count():
		if faceChecker.get_collision_normal(o).y >= 0.75 && faceChecker.get_collision_normal(o).y <= 1.25:
			_allign_with_surface(faceChecker.get_collision_normal(o))
	
	if is_on_floor():
		coyoteTimer.stop()
		canJump = true
	
	
	
	#start coyote time if conditions are met
	if !is_on_floor() && coyoteTimer.is_stopped() == true:
		coyoteTimer.start()
	#print(coyoteTimer.time_left)
	
	#print(velocity)
	if Input.is_action_just_pressed("Jump") && isSticking:
		$MangoJumpSound.pitch_scale = randf_range(0.9, 1.1)
		$MangoJumpSound.play()
		velocity += (faceChecker.get_collision_normal(currentSurfaceVal) * jumpVelocity)
		velocity.y += jumpVelocity/2 

	if Input.is_action_just_pressed("Jump")&& !isSticking && (is_on_floor() or canJump):
		$MangoJumpSound.pitch_scale = randf_range(0.9, 1.1)
		$MangoJumpSound.play()
		velocity.y += jumpVelocity + (jumpVelocity/2)












	move_and_slide()
	#allows the movement angles to be more consistent and sets rotation to a set speed for the character
	if velocity.length() > 1.0:
		rotation.y = lerp_angle(rotation.y, camPivot.rotation.y, turnSpeed * delta)


func _process(delta: float) -> void:
	#print(global_position)
	pass
	#move the face checker to check the surface the player is on





#Camera control with mouse, currently researching controller as well. I don't have a controller to test with 
func _unhandled_input(event: InputEvent) -> void:
	
	
	
	if event is InputEventMouseMotion:
		#Move the camera with the mouse in proportion to sensitivity
		camPivot.rotation.x -= event.relative.y * mouseSensitivity * get_process_delta_time()
		#rotate the camera same as before
		camPivot.rotation.y -= event.relative.x * mouseSensitivity * get_process_delta_time()
		#clamp the values so the camera doesn't spin
		camPivot.rotation.x = clampf(camPivot.rotation.x, -tiltLimit, tiltLimit)
		
		





func _stick():
	# set sticky mode to true while button is held, can be changed to toggle if/when we add settings
	if Input.is_action_just_released("StickMode"):
		stickyMode = false
		isSticking = false
		squeezedBefore = false
		camFOVMode = 1
	if Input.is_action_pressed("StickMode"):
		stickyMode = true
	
		#
		#
		#checks which point is closer
		if faceChecker.get_collision_count() >= 1:
			for i in faceChecker.get_collision_count():
				#if theres 2 or more objects
				currentSurface = faceChecker.get_collider(i)
				currentSurfaceVal = i
				if "nonstick" in currentSurface:
					if currentSurface.nonstick == false:
						currentSurfacesTot += faceChecker.get_collision_normal(i)
				else:
					currentSurfacesTot += faceChecker.get_collision_normal(i)
					

			
			if currentSurfacesTot != Vector3.ZERO:
				currentSurfacesAvr = currentSurfacesTot / faceChecker.get_collision_count()
				_allign_with_surface(currentSurfacesAvr)
				
				camFOVMode = 0
				
				if squeezedBefore == false:
					squeeze()
					squeezedBefore = true
				if currentSurfacesAvr.y >= 0.75 && currentSurfacesAvr.y < 1.25:
					grav = Vector3.UP * gravityStr
				else:
					grav = -currentSurfacesAvr
				
				isSticking = true
				currentSurfacesTot = Vector3.ZERO
				currentSurfacesAvr = Vector3.ZERO
				#print(grav)
			else:
				currentSurfacesTot = Vector3.ZERO
				currentSurfacesAvr = Vector3.ZERO
				grav = Vector3.UP * gravityStr

				isSticking = false
				squeezedBefore = false
				camFOVMode = 1
				
				#if there are no objects
		elif faceChecker.get_collision_count() == 0:
				isSticking = false
				squeezedBefore = false
				camFOVMode = 1
				grav = Vector3.UP * gravityStr
	else:
		grav = Vector3.UP * gravityStr

		isSticking = false
		squeezedBefore = false
		camFOVMode = 1


#alligns the player's base with the surface being stuck to
func _allign_with_surface(normal):
	var temptrans = global_transform
	temptrans.basis.y = normal
	temptrans.basis.x = -temptrans.basis.z.cross(normal)
	temptrans.basis = temptrans.basis.orthonormalized()
	global_transform = temptrans


func _on_stick_detection_range_body_entered(body: Node3D) -> void:
	if body != currentBody:
		currentBody = body


func _on_stick_detection_range_body_exited(body: Node3D) -> void:
	if body == currentBody:
		currentBody = null
		isSticking = false
		squeezedBefore = false
		camFOVMode = 1


func _on_coyote_timer_timeout() -> void:
	canJump = false





































## Change Mango's eye sprite
func change_eyes(newEyes: CompressedTexture2D) -> void:
	if newEyes == load("res://Textures/Other/MangoEyes/Open2.png"):
		mangoEyeL.position.x = -0.199
		mangoEyeL.scale.x = -0.482
	else:
		mangoEyeL.position.x = -0.192
		mangoEyeL.scale.x = 0.482
	
	mangoEyeR.get_surface_override_material(0).set_shader_parameter("Texture", newEyes)
	mangoEyeL.get_surface_override_material(0).set_shader_parameter("Texture", newEyes)

## For debug. Testing eyes
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_5):
		change_eyes(load("res://Textures/Other/MangoEyes/Open1.png"))
	
	if Input.is_key_pressed(KEY_6):
		change_eyes(load("res://Textures/Other/MangoEyes/Closed1.png"))
	
	if Input.is_key_pressed(KEY_7):
		change_eyes(load("res://Textures/Other/MangoEyes/Open2.png"))
	
	if Input.is_key_pressed(KEY_8):
		change_eyes(load("res://Textures/Other/MangoEyes/Closed2.png"))
	
	if Input.is_key_pressed(KEY_9):
		change_eyes(load("res://Textures/Other/MangoEyes/Squeeze.png"))

func _ready() -> void:
	mangoShadow = $MangoShadowParent/MangoShadow
	blink()
	
	eyesNode.global_position.x = global_position.x
	eyesNode.global_position.y = global_position.y
	eyesNode.global_position.z = global_position.z
	eyesNode.global_rotation.x = global_rotation.x
	eyesNode.global_rotation.y = global_rotation.y
	eyesNode.global_rotation.z = global_rotation.z

func blink():
	change_eyes(load("res://Textures/Other/MangoEyes/Closed1.png"))
	await get_tree().create_timer(randf_range(0.1, 0.2)).timeout
	change_eyes(load("res://Textures/Other/MangoEyes/Open1.png"))
	await get_tree().create_timer(randf_range(4.0, 8.0)).timeout
	blink()

func squeeze():
	change_eyes(load("res://Textures/Other/MangoEyes/Squeeze.png"))
	await get_tree().create_timer(randf_range(0.2, 0.6)).timeout
	change_eyes(load("res://Textures/Other/MangoEyes/Open1.png"))
