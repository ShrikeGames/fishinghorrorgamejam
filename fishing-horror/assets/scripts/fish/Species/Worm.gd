extends "res://assets/scripts/fish/Species/Species.gd"
class_name Worm

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	var x_pos:float = 0
	# worm initial values
	num_bones = randi_range(8, 30)
	max_distance = randi_range(10, 15)
	max_radius = randi_range(20, 30)
	
	var scaling_max:float = min(num_bones, 12)
	var min_turn_angle:float = (scaling_max * 0.01)
	var turn_speed:float = 6-(scaling_max * 0.45)
	
	
	for i in range(0, num_bones):
		var bone:FishBone = fish_bone_object.instantiate()
		var scale_factor:float = 1-(i*(0.75/num_bones))
		var use_individual_colours = false
		bone.colour = colour
		if randf() < multi_colour_chance:
			use_individual_colours = true
		
		if i > 0:
			bone.init(prev_bone, use_individual_colours, max_distance, max_radius*scale_factor, min_turn_angle*scale_factor, turn_speed)
		else:
			bone.init(prev_bone, use_individual_colours, max_distance, max_radius, min_turn_angle, turn_speed)
			bone.move_speed = randf_range(200, 800)
		x_pos -= bone.radius
		bone.position.x = x_pos
		bone.rotation = 0
		
		bones.add_child(bone)
		prev_bone = bone
