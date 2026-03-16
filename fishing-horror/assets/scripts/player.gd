extends StaticBody3D
class_name Player

@export var head:Head
var camera:Camera3D
@export var animation_player:AnimationPlayer
@export var animation_tree:AnimationTree
var hair:SoftBody3D

var mouseInput:Vector2 = Vector2(0,0)
var initial_fov:float = 75.0
var mouse_sensitivity:float = 0.2
var zoom_fov_modifier:float = 0.5
var is_zooming:bool = false
var zoom_progress:float = 0.0
var zoom_speed_scale:float = 0.5
var zoom_direction:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = head.camera
	hair = head.hair
	initial_fov = Global.game_state["you"]["fov"]
	mouse_sensitivity = Global.game_state["you"]["mouse_sensitivity"]
	is_zooming = false
	zoom_progress = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_zooming:
		zoom_progress = min(zoom_progress + (delta * zoom_speed_scale), 1)
		
	if Input.is_action_just_pressed("zoom_in"):
		is_zooming = true
		zoom_direction = 1
		zoom_progress = 0
		
	elif Input.is_action_just_pressed("zoom_out"):
		is_zooming = true
		zoom_direction = -1
		zoom_progress = 0
	
	if is_zooming:
		if zoom_progress >= 1:
			is_zooming = false
			zoom_progress = 0
		else:
			if zoom_direction > 0:
				camera.fov = lerpf(camera.fov, initial_fov*zoom_fov_modifier, zoom_progress)
			elif zoom_direction < 0:
				camera.fov = lerpf(camera.fov, initial_fov, zoom_progress)
	
	
func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		mouseInput = event.relative
		
		head.rotate(Vector3(0,1,0), -event.relative.x * mouse_sensitivity *0.01)
		var new_rotation_y:float = fmod(head.rotation.y + 2*PI, 2*PI)
		new_rotation_y =  clamp(new_rotation_y, 2.1, 4.4)
		head.rotation.y = new_rotation_y
		#hair.rotation.y = head.rotation.y
		
		#hair.global_rotate(Vector3(0,1,0), event.relative.x * mouse_sensitivity *0.01)
		#hair.global_rotation.y = fmod(hair.global_rotation.y + 2*PI, 2*PI)
		
		
		camera.rotate(Vector3(1,0,0), -event.relative.y * mouse_sensitivity *0.01)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, 0.25)
