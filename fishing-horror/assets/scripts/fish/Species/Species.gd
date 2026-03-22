extends Node
class_name Species

@export var num_bones:int = 30
@export var max_distance:float = 25
@export var max_radius:float = 40
@export var min_turn_angle:float = 0.5
@export var turn_speed:float = 1.0
@export var speed:float = 1.0

var fish_bone_object = load("res://assets/scenes/fish/FishBone.tscn")
var fish_stats:Dictionary = {
	
}
func generate(_bones:Node2D, _multi_colour_chance:float, _colour:String):
	pass

func init(stats:Dictionary):
	self.fish_stats = stats
	self.num_bones = randi_range(fish_stats["min_num_bones"], fish_stats["max_num_bones"])
	self.max_distance = randf_range(fish_stats["min_bone_distance"], fish_stats["max_bone_distance"])
	self.max_radius = randf_range(fish_stats["min_bone_radius"], fish_stats["max_bone_radius"])
	self.min_turn_angle = fish_stats["min_turn_angle"]
	self.turn_speed = fish_stats["turn_speed"]
	self.speed = randf_range(fish_stats["min_speed"], fish_stats["max_speed"])
