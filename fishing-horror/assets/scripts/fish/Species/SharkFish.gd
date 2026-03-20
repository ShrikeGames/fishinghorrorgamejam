extends "res://assets/scripts/fish/Species/Species.gd"
class_name SharkFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	var x_pos:float = 0
	
	num_bones = randi_range(8, 12)
	max_distance = randi_range(12, 18)
	max_radius = randi_range(14, 22)
	
	var min_turn_angle:float = 0.04
	var turn_speed:float = 7
	
	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()
		
		var scale = 1.0 - (i / float(num_bones))
		var radius = max_radius * (0.5 + scale * 0.5)
		
		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour
		
		var has_eyes:bool = (i == 0)
		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, has_eyes)
		
		bone.move_speed = randf_range(400, 700)
		
		x_pos -= bone.radius
		bone.position.x = x_pos
		
		bones.add_child(bone)
		
		if i == 2:
			var fin = fish_bone_object.instantiate()
			fin.init(bone, use_individual_colours, max_distance, radius * 1.5, min_turn_angle, turn_speed)
			fin.position.y = -radius * 1.5
			bones.add_child(fin)
		
		prev_bone = bone
