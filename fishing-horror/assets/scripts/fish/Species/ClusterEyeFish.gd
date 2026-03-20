extends "res://assets/scripts/fish/Species/Species.gd"
class_name ClusterEyeFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone = null
	var x_pos:float = 0

	num_bones = randi_range(6, 10)
	max_distance = randi_range(10, 14)
	max_radius = randi_range(12, 20)

	var min_turn_angle:float = 0.15
	var turn_speed:float = 5

	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()

		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour

		var has_eyes = false
		# 👁️ random eye distribution
		if i == 0 or randf() < 0.3:
			has_eyes = true

		var radius = max_radius * (1.0 - i * 0.08)

		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, has_eyes)
		bone.move_speed = randf_range(200, 400)

		x_pos -= bone.radius
		bone.position.x = x_pos

		bones.add_child(bone)
		prev_bone = bone
