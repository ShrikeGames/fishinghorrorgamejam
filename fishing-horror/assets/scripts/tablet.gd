extends MeshInstance3D
class_name Tablet

var env_above_water:Environment = load("res://assets/env/above_water.tres")
var env_under_water:Environment = load("res://assets/env/underwater_env.tres")


@export var viewport:SubViewport
@export var canvas:TabletCanvas
@export var fishing_rod:FishingRod
@export var hook_camera:Camera3D

var screens:Array = []
var current_screen:int = 0

func _ready() -> void:
	screens = [canvas, hook_camera]
	screens[1].current = screens[1].visible
	

func _process(_delta: float) -> void:
	hook_camera.global_position = fishing_rod.hook_camera_node.global_position
	hook_camera.look_at(fishing_rod.hook.global_position)
	canvas.update_depth(fishing_rod.hook.global_position.y)
	
	if fishing_rod.hook.global_position.y >= 0:
		hook_camera.environment = env_above_water
	else:
		hook_camera.environment = env_under_water

func toggle_screen():
	var max_screen:int = len(screens)
	screens[current_screen].visible = false
	current_screen = wrapi(current_screen+1, 0, max_screen)
	screens[current_screen].visible = true
	screens[1].current = screens[1].visible
