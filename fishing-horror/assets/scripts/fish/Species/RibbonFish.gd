extends "res://assets/scripts/fish/Species/Species.gd"
class_name Ribbonfish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	var x_pos:float = 0
	
	num_bones = randi_range(14, 20)
	max_distance = randi_range(6, 10)
	max_radius = randi_range(6, 10)
	
	var min_turn_angle:float = 0.02
	var turn_speed:float = 10
	
	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()
		
		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour
		
		var has_eyes:bool = (i == 0)
		bone.init(prev_bone, use_individual_colours, max_distance, max_radius, min_turn_angle, turn_speed, has_eyes)
		
		bone.move_speed = randf_range(300, 500)
		
		x_pos -= bone.radius
		bone.position.x = x_pos
		
		bones.add_child(bone)
		prev_bone = bone
