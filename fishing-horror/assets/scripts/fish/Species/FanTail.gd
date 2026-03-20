extends "res://assets/scripts/fish/Species/Species.gd"
class_name FanTail

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	var x_pos:float = 0
	
	num_bones = randi_range(6, 10)
	max_distance = randi_range(10, 15)
	max_radius = randi_range(10, 18)
	
	var min_turn_angle:float = 0.08
	var turn_speed:float = 5
	
	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()
		
		var scale = 1.0 - (i / float(num_bones)) * 0.6
		var radius = max_radius * scale
		
		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour
		
		var has_eyes:bool = (i == 0)
		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, has_eyes)
		
		x_pos -= bone.radius
		bone.position.x = x_pos
		bones.add_child(bone)
		
		# big tail fan
		if i == num_bones - 1:
			for j in range(3):
				var fin:FishBone = fish_bone_object.instantiate()
				var angle = (-0.5 + j * 0.5)
				
				fin.init(bone, use_individual_colours, max_distance * 1.5, radius * 2.0, min_turn_angle, turn_speed * 1.5)
				fin.position = Vector2(x_pos, radius * angle * 2)
				bones.add_child(fin)
		
		prev_bone = bone
