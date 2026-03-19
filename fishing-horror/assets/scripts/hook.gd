extends Node3D

@export var player:Player
@export var fishing_rod:FishingRod
@export var hook_camera_node:Node3D

var catch_up_speed:float = 5.0
var max_distance:float = 2.0

func _process(delta: float) -> void:
	self.look_at(fishing_rod.tip.global_position)
	if not player.fish_on_hook or (player.fish_on_hook and player.fish_on_hook.recharging):
		var diff_x:float = self.global_position.x - fishing_rod.tip.global_position.x
		self.global_position.x -= diff_x * delta * catch_up_speed
		self.global_position.x = clampf(self.global_position.x, fishing_rod.tip.global_position.x-max_distance, fishing_rod.tip.global_position.x+max_distance)
		var diff_z:float = self.global_position.z - fishing_rod.tip.global_position.z
		self.global_position.z -= diff_z * delta * catch_up_speed
	
	self.hook_camera_node.global_position = self.global_position + Vector3(0,0,-0.35)
