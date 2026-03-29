extends MeshInstance3D
class_name Ripple

@export var player:Player
@export var fishing_rod:FishingRod
@export var min_size:float = 0.0
@export var max_size:float = 1.0
@export var init_speed:float = 3.0
var speed:float = init_speed
@export var max_transparency:float = 0.1
@export var init_size:float = 0.0
@export var auto_restart:bool = true
var alpha:float = 0.0
var material:Material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()
	
func init():
	self.speed = self.init_speed
	self.scale.x = self.min_size
	self.scale.z = self.min_size

func reset():
	if not self.auto_restart:
		self.get_parent().remove_child(self)
		self.queue_free()
		return
	self.scale.x = self.min_size
	self.scale.z = self.min_size
	if self.player:
		self.global_position = self.player.global_position
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var percent:float = (self.scale.x / self.max_size)
	self.material = self.get_active_material(0)
	if self.fishing_rod and self.fishing_rod.hook.global_position.y > 0:
		self.alpha = 0
	else:
		self.alpha = clampf((0.5 - 0.5 * cos(2.0 * PI * percent))*max_transparency, 0.0, max_transparency)
	self.material.albedo_color = Color(1, 1, 1, self.alpha) 
	self.scale.x += (speed * delta)
	self.scale.z += (speed * delta)
	self.scale.x = clampf(self.scale.x, self.min_size, self.max_size)
	self.scale.z = clampf(self.scale.z, self.min_size, self.max_size)
	if self.fishing_rod:
		self.global_position = self.fishing_rod.get_water_point()
	
	if self.scale.x >= self.max_size:
		reset()
