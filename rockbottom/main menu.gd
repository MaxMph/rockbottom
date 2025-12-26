extends Control

var offset_speed = 10
@export var world = preload("res://world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var goal_offset = Vector2(get_local_mouse_position().x / 200, -get_local_mouse_position().y / 200)
	#$"../Camera3D".h_offset = goal_offset.x #move_toward($"../Camera3D".h_offset, global_position.x, offset_speed * delta)
	#$"../Camera3D".v_offset = goal_offset.y #move_toward($"../Camera3D".v_offset, global_position.y, offset_speed * delta)
	
	$"../Camera3D".h_offset = move_toward($"../Camera3D".h_offset ,goal_offset.x, offset_speed * delta) #move_toward($"../Camera3D".h_offset, global_position.x, offset_speed * delta)
	$"../Camera3D".v_offset = move_toward($"../Camera3D".v_offset ,goal_offset.y, offset_speed * delta) #move_toward($"../Camera3D".v_offset, global_position.y, offset_speed * delta)
	


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(world)


func _on_quit_pressed() -> void:
	get_tree().quit()
