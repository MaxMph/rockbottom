extends RigidBody3D

@onready var floorcast = $floor_cast
@export var head: Node3D
@export var cam: Camera3D


var speed = 120
var jump_force = 10000

var is_on_floor

#float values
var up_force = 120000
var damp = 1800


func _ready() -> void:
	pass
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * Global.sense)
		cam.rotate_x(-event.relative.y * Global.sense)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-75), deg_to_rad(75))


func _physics_process(delta: float) -> void:
	floor_float(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor:
		#if linear_velocity.y < 0:
			#linear_velocity.y = 0
		apply_central_impulse(Vector3.UP * jump_force * delta)

func floor_float(delta):
	if floorcast.is_colliding():
		is_on_floor = true
		#sdtfyjg
		var floor_dist = 1 - floorcast.global_position.distance_to(floorcast.get_collision_point())
		var float_damp = linear_velocity.y * damp
		#print(floor_dist)
		apply_central_force(Vector3.UP * ((up_force * floor_dist) - float_damp) * delta)
		print(Vector3.UP * up_force * floor_dist * delta)
		
		#if abs(linear_velocity.y) < 0.05:
			#linear_velocity.y = 0

	else:
		is_on_floor = false

func move(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#apply_central_force(direction * speed * delta)
		apply_central_impulse(direction * speed * delta)
		#velocity.x = move_toward(velocity.x, direction.x * speed, acc * delta)
		#velocity.z = move_toward(velocity.z, direction.z * speed, acc * delta)
	#else:
		#velocity.x = move_toward(velocity.x, 0, fric * delta)
		#velocity.z = move_toward(velocity.z, 0, fric * delta)
