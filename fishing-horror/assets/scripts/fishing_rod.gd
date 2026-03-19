extends MeshInstance3D

class_name FishingRod

@export var base:Node3D
@export var tip:Node3D
@export var hook:Node3D
@export var fishing_line:MeshInstance3D
@export var hook_camera_node:Node3D
@export var spinner:MeshInstance3D

var tip_pos:Vector3
var hook_pos:Vector3 
const line_thickness:float = 0.005

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func draw_fishing_line(point1:Vector3, point2:Vector3):
	fishing_line.mesh.surface_add_vertex(point1)
	fishing_line.mesh.surface_add_vertex(point2)

func _physics_process(_delta: float) -> void:
	tip_pos = tip.global_position
	hook_pos = hook.global_position
	
	fishing_line.mesh.clear_surfaces()

	fishing_line.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	fishing_line.mesh.surface_set_normal(Vector3(0, 0, 1))
	fishing_line.mesh.surface_set_uv(Vector2(0, 0))
	draw_fishing_line(tip_pos, base.global_position)
	fishing_line.mesh.surface_end()
