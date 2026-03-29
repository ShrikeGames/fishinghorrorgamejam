extends MeshInstance3D

class_name FishingRod

@export var water_ripple_node:Node3D
@export var base:Node3D
@export var tip:Node3D
@export var hook:Node3D
@export var fishing_line:MeshInstance3D
@export var hook_camera_node:Node3D
@export var spinner:MeshInstance3D

var tip_pos:Vector3
var hook_pos:Vector3 
const line_thickness:float = 0.005
var ripple_resource:Resource = load("res://assets/scenes/water_ripple.tscn")
var time_since_last_ripple:float = 0
var ripple_timer:float = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func draw_fishing_line(point1:Vector3, point2:Vector3):
	fishing_line.mesh.surface_add_vertex(point1)
	fishing_line.mesh.surface_add_vertex(point2)

func _physics_process(delta: float) -> void:
	time_since_last_ripple += delta
	tip_pos = tip.global_position
	hook_pos = hook.global_position
	
	fishing_line.mesh.clear_surfaces()

	fishing_line.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	fishing_line.mesh.surface_set_normal(Vector3(0, 0, 1))
	fishing_line.mesh.surface_set_uv(Vector2(0, 0))
	draw_fishing_line(tip_pos, base.global_position)
	fishing_line.mesh.surface_end()
	
	#if self.hook.global_position.y < 0 and time_since_last_ripple >= ripple_timer:
		#var new_ripple:Ripple = ripple_resource.instantiate()
		#new_ripple.fishing_rod = self
		#self.water_ripple_node.add_child(new_ripple)
		#time_since_last_ripple = 0.0
		

func get_water_point():
	if self.hook.global_position.y >= 0:
		return Vector3(self.hook.global_position.x, 0, self.hook.global_position.z)
	
	var x:float = self.hook.global_position.x + ((-self.hook.global_position.y / (self.tip.global_position.y)) * (self.hook.global_position.x - self.tip.global_position.x))
	var z:float = self.hook.global_position.z + ((-self.hook.global_position.y / (self.tip.global_position.y)) * (self.hook.global_position.z - self.tip.global_position.z))
	return Vector3(x, 0, z)
