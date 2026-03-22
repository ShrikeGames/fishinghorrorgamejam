extends "res://assets/scripts/fish/Species/Species.gd"
class_name PuffTailFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone = null
	var x_pos:float = 0


	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()

		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour

		var radius = max_radius * (1.0 - i * 0.1)

		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, i == 0)
		bone.move_speed = randf_range(200, 350)

		x_pos -= bone.radius
		bone.position.x = x_pos

		bones.add_child(bone)

		# giant tail
		if i == num_bones - 1:
			var fin = fish_bone_object.instantiate()
			fin.init(bone, use_individual_colours, max_distance * 3.5, bone.radius * 9.0, min_turn_angle, turn_speed * 2)
			fin.position.x = x_pos - bone.radius
			fin.position.y = 0
			bones.add_child(fin)

		prev_bone = bone
