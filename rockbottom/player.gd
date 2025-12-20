extends CharacterBody3D


var speed = 8
var acc = 20
var fric = 20

var jump_vel = 6
var mantle_vel = 8
var walljump_mod = 1.0
var walljump_push = 6
var can_walljump = true

var sense = 0.001
@export var head: Node3D
@export var cam: Camera3D




func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sense)
		cam.rotate_x(-event.relative.y * sense)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	#print("looking")
		

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_vel
			print("jump")
		elif $head/mantle_top.is_colliding() == false and $head/mantle_bottom.is_colliding(): # mantle
			velocity.y = mantle_vel
			print("mantle")
		
		elif $head/wall_jump.is_colliding(): # wall jump
			velocity.y = jump_vel * walljump_mod
			velocity += $head/wall_jump.get_collision_normal() * walljump_push
			#velocity + (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()#-head.transform.basis * Vector3.BACK * walljump_push
			print("wall jump")
		else:
			pass
		
	#else: #works for climbing!!!
		#if $head/wall_jump.is_colliding():
			#velocity.y = jump_vel
	
	if Input.is_action_just_pressed("int"):
		if %interact_cast.interactable != null:
			%interact_cast.interactable.interact()
		 
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acc * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acc * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, fric * delta)
		velocity.z = move_toward(velocity.z, 0, fric * delta)
	
	$Control/fps_counter.text = str(Engine.get_frames_per_second())

	move_and_slide()
	
