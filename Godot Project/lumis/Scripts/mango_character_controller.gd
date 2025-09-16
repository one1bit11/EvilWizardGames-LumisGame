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

##gravity
var grav := Vector3(0,-2,0)
##average normals of the surfaces nearby
var avgnormal := Vector3.ZERO


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
	#the vector 3 rot for rotating
	var stickRot:Vector3
	#save velocity.y
	var vy = velocity.y
	#assign a value to each input, should work with controller too
	var input = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
	var input3 := Vector3(input.x,0,input.y)
	if isSticking:
		stickRot = faceChecker.get_collision_normal(currentSurfaceVal)
		
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
		velocity = lerp(velocity, dir * speed, acc * delta)
	

	#set the vertical velocity to the same as it was

	#rotate in the right direction
	##rotate(-dir.normalized(),rotVal)
	

func _physics_process(delta: float) -> void:
	
	#call the climb function each frame, we don't have to worry that much about hardware efficiency rn
	_stick()
	



	if faceChecker.get_collision_count() == 0:
		isSticking = false
	#Because the camera is top level, this allows it to still follow the player without inheriting the rotation
	camPivot.global_position = Vector3(global_position.x,global_position.y + camPivotHeight, global_position.z)
	_get_move_input(delta)
	#if !isSticking:
	velocity += grav
	#if is not sticking and is on floor, alligns with floor
	if is_on_floor():
		
		for o in faceChecker.get_collision_count():
			
			#print("angle" , faceChecker.get_collision_normal(o))
			if faceChecker.get_collision_normal(o).y >= 0.75 && faceChecker.get_collision_normal(o).y <= 1.25:
				_allign_with_surface(faceChecker.get_collision_normal(o))
		
	#print(velocity)
	if Input.is_action_just_pressed("Jump") && isSticking:
		$MangoJumpSound.pitch_scale = randf_range(0.9, 1.1)
		$MangoJumpSound.play()
		velocity += (faceChecker.get_collision_normal(currentSurfaceVal) * jumpVelocity)

		velocity.y += jumpVelocity/2 
	if Input.is_action_just_pressed("Jump") && is_on_floor() && !isSticking:
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
	#check raycasts
	#grav = Vector3.ZERO
	#var raysColliding := 0
	#if stickyMode:
		#for ray in $RayHolder.get_children():
			#if ray.is_colliding():
				#raysColliding += 1
				#avgnormal += ray.get_collision_normal()
			#if raysColliding:
				#isSticking = true
				#avgnormal /= raysColliding
				#avgnormal = avgnormal.normalized()
				#grav = avgnormal * gravityStr
			#else:
				#isSticking = false
				#avgnormal = Vector3.UP
				#grav = avgnormal * gravityStr
	#else:
		#avgnormal = Vector3.UP
		#grav = avgnormal * gravityStr
	 
	
#temporary fix to the sliding problem
	#if Input.is_action_just_pressed("StickMode") && faceChecker.get_collision_count() > 0:
		#velocity = Vector3.ZERO
	
	# set sticky mode to true while button is held, can be changed to toggle if/when we add settings
	if Input.is_action_pressed("StickMode"):
		stickyMode = true
		#
#
		#
		#
		print(get_gravity())
		#
		#
		#
		#
		#
		#
		#
		#
		#
		#
		#
		#
		#
		#checks which point is closer
		if faceChecker.get_collision_count() >= 1:
			for i in faceChecker.get_collision_count():
				#if theres 2 or more objects
				#if faceChecker.get_collision_count() > 1 && i-1 >= 0:
					#if this point is closer than the last point, use its details instead
					#if (self.global_position - faceChecker.get_collision_point(i)) < (self.global_position - faceChecker.get_collision_point(i-1)):
						#currentSurface = faceChecker.get_collider(i)
						#currentSurfaceVal = i
						#if "nonstick" in currentSurface:
							#if currentSurface.nonstick == false:
								#stickPoint = faceChecker.get_collision_point(i)
								#isSticking = true
								#
								#_allign_with_surface(faceChecker.get_collision_normal(i))
								#grav = Vector3.ZERO
							#else:
								#isSticking = false
						
				#if theres exactly one object
				if faceChecker.get_collision_count() == 1:
					currentSurface = faceChecker.get_collider(i)
					currentSurfaceVal = i
					if "nonstick" in currentSurface:
						if currentSurface.nonstick == false:
							stickPoint = faceChecker.get_collision_point(i)
							isSticking = true
							_allign_with_surface(faceChecker.get_collision_normal(i))
							grav = Vector3.ZERO
				#if there are no objects
		elif faceChecker.get_collision_count() == 0:
				isSticking = false
				grav = Vector3.UP * gravityStr
	else:
		grav = Vector3.UP * gravityStr
		stickyMode = false
		isSticking = false


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
