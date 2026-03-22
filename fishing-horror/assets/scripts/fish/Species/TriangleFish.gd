extends "res://assets/scripts/fish/Species/Species.gd"
class_name TriangleFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone = null
	var x_pos:float = 0

	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()

		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour

		var t = i / float(num_bones)
		var radius = max_radius * (1.0 - t * 1.2)

		bone.init(prev_bone, use_individual_colours, max_distance, max(radius, 3), min_turn_angle, turn_speed, i == 0)
		bone.move_speed = randf_range(300, 500)

		x_pos -= bone.radius
		bone.position.x = x_pos

		bones.add_child(bone)
		prev_bone = bone
