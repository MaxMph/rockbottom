extends Node3D

var affecting: Array = []

var thrust_cap = 12
var acc = 1

@export var length = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.shape = $Area3D/CollisionShape3D.shape.duplicate()
	$Area3D/CollisionShape3D.shape.height = length
	$Area3D/CollisionShape3D.position.y = length / 2
	$CPUParticles3D.lifetime *= length / 8
	$CPUParticles3D.amount *= length / 8
	$CPUParticles3D.preprocess = $CPUParticles3D.lifetime
	$CPUParticles3D.restart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for i in affecting:
		if i is RigidBody3D:
			pass
		elif i is CharacterBody3D:
			#if i.velocity.y < thrust_cap:
			var thrust_dir = (global_transform.basis * Vector3.UP).normalized()
			var cur_speed = i.velocity.dot(thrust_dir)
			if cur_speed < thrust_cap:
				i.velocity += thrust_dir * acc #global_transform.basis * (Vector3.UP * acc)


func _on_area_3d_body_entered(body: Node3D) -> void:
	affecting.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	affecting.erase(body)
