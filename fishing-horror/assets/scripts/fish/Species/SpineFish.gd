extends "res://assets/scripts/fish/Species/Species.gd"
class_name SpineFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone = null
	var x_pos:float = 0

	num_bones = randi_range(8, 14)
	max_distance = randi_range(10, 15)
	max_radius = randi_range(10, 18)

	var min_turn_angle:float = 0.2
	var turn_speed:float = 6

	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()

		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour

		var radius = max_radius * (1.0 - i * 0.05)

		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, i == 0)
		bone.move_speed = randf_range(250, 450)

		x_pos -= bone.radius
		bone.position.x = x_pos

		bones.add_child(bone)

		# spikes everywhere
		if i % 2 == 0:
			var fin = fish_bone_object.instantiate()
			fin.init(bone, use_individual_colours, max_distance, bone.radius * 1.5, min_turn_angle, turn_speed * 1.5)
			fin.position.x = x_pos - bone.radius
			fin.position.y = (-1 if i % 4 == 0 else 1) * bone.radius
			bones.add_child(fin)

		prev_bone = bone
