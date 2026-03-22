extends "res://assets/scripts/fish/Species/Species.gd"
class_name PufferFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	
	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()
		
		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour
		
		var has_eyes:bool = (i == 0)
		bone.init(prev_bone, use_individual_colours, max_distance, max_radius, min_turn_angle, turn_speed, has_eyes)
		
		bones.add_child(bone)
		
		# spikes
		for j in range(4):
			var fin:FishBone = fish_bone_object.instantiate()
			var angle = j * PI/2
			
			fin.init(bone, use_individual_colours, max_distance * 0.8, max_radius * 0.8, min_turn_angle, turn_speed)
			fin.position = Vector2(cos(angle), sin(angle)) * max_radius
			bones.add_child(fin)
		
		prev_bone = bone
