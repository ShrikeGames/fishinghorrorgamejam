extends Node3D

@export var player:Player
@export var fishing_rod:FishingRod
@export var hook_camera_node:Node3D

var catch_up_speed:float = 5.0
var max_distance:float = 2.0

func _process(delta: float) -> void:
	self.look_at(fishing_rod.tip.global_position)
	var diff_x:float = self.global_position.x - fishing_rod.tip.global_position.x
	self.global_position.x -= diff_x * delta * catch_up_speed
	self.global_position.x = clampf(self.global_position.x, fishing_rod.tip.global_position.x-max_distance, fishing_rod.tip.global_position.x+max_distance)
	self.hook_camera_node.global_position = self.global_position + Vector3(0,0,-0.35)
