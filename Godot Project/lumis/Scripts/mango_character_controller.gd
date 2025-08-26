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
#how much force is applied to stick in one spot
@export var stickStrength:float
#the value that 
@export var stickSlow := 2.0
#the raycast holder
#@export var stickRayHolder:Node3D
#the forward direction
@export var upwards:RayCast3D

#sticky mode toggle
var stickyMode = false
#is actively sticking to something
var isSticking = false
#used later to move along walls or the floor
#checks which of the objects facechecker is colliding with is the one that is best
var currentSurface:Node3D
#which of the surfaces is it
var currentSurfaceVal:int
#the point at which the force is aiming
var stickPoint:Vector3
#the direction to the stick point
var stickPointDir:Vector3








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
	#prevent movement in the vertical based on camera
	#assign a value to each input, should work with controller too
	var input = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
	

	
	var input3 := Vector3(input.x,0,input.y)
	if isSticking:
		
		
		stickRot = faceChecker.get_collision_normal(currentSurfaceVal)
		#stickRot.y = stickRot.x
		#stickRot.z = stickRot.z
		
		
		
		
		
		velocity = Vector3.ZERO
		input = Vector3.ZERO
		input = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
		rot = -(atan2(faceChecker.get_collision_normal(currentSurfaceVal).z, faceChecker.get_collision_normal(currentSurfaceVal).x) - PI/2)
		
		#global_transform.basis.get_euler().y

		#dir = Vector3(input.x, 0, input.y).rotated(faceChecker.get_collision_normal(currentSurfaceVal), rot)
		#dir = transform.basis * input3

		#set the direction based on the values of the wall
		#rot = faceChecker.get_collision_normal(currentSurfaceVal)*90
		
		
		
		
		print(stickRot)
		
		
		
		
		
		#temporary
		if !is_on_floor():
			## IDEA clamp campivot results to only be on the same plane that you're moving across while sticking to prevent falling off
			dir = Vector3(input.x,-input.y,0).rotated(Vector3.UP,rot).normalized()
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
	if !isSticking:
		velocity += get_gravity()
	#if is not sticking and is on floor, alligns with floor
	if is_on_floor():
		#print(faceChecker.get_collision_normal(0))
		for o in faceChecker.get_collision_count():
			if faceChecker.get_collision_normal(o) == Vector3(0,1,0):
				_allign_with_surface(faceChecker.get_collision_normal(o))
		
	print(velocity)
	if Input.is_action_just_pressed("Jump") && is_on_floor() && !isSticking:
		
		velocity.y += jumpVelocity
	if Input.is_action_just_pressed("Jump") && isSticking:
		
		velocity += (faceChecker.get_collision_normal(currentSurfaceVal) * jumpVelocity)
		velocity.y += jumpVelocity/2
		#print(velocity)

	move_and_slide()
	#allows the movement angles to be more consistent and sets rotation to a set speed for the character
	if velocity.length() > 1.0:
		rotation.y = lerp_angle(rotation.y, camPivot.rotation.y, turnSpeed * delta)


func _process(delta: float) -> void:
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
	
	
	
#temporary fix to the sliding problem
	#if Input.is_action_just_pressed("StickMode") && faceChecker.get_collision_count() > 0:
		#velocity = Vector3.ZERO
	
	# set sticky mode to true while button is held, can be changed to toggle if/when we add settings
	if Input.is_action_pressed("StickMode"):
		stickyMode = true
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		#checks which point is closer
		for i in faceChecker.get_collision_count():
			#if theres 2 or more objects
			if faceChecker.get_collision_count() > 1 && i-1 >= 0:
				#if this point is closer than the last point, use its details instead
				if (self.global_position - faceChecker.get_collision_point(i)) < (self.global_position - faceChecker.get_collision_point(i-1)):
					currentSurface = faceChecker.get_collider(i)
					#print(faceChecker.get_collision_point(i))
					currentSurfaceVal = i
					stickPoint = faceChecker.get_collision_point(i)
					isSticking = true
					_allign_with_surface(faceChecker.get_collision_normal(i))
			#if theres exactly one object
			elif faceChecker.get_collision_count() == 1:
				currentSurface = faceChecker.get_collider(i)
				currentSurfaceVal = i
				stickPoint = faceChecker.get_collision_point(i)
				isSticking = true
				_allign_with_surface(faceChecker.get_collision_normal(i))
				#if there are no objects
			if faceChecker.get_collision_count() == 0:
				isSticking = false

	else:
		stickyMode = false
		isSticking = false

#alligns the player's base with the surface being stuck to
func _allign_with_surface(normal):
	var temptrans = global_transform
	temptrans.basis.y = normal
	temptrans.basis.x = -temptrans.basis.z.cross(normal)
	temptrans.basis = temptrans.basis.orthonormalized()
	global_transform = temptrans
