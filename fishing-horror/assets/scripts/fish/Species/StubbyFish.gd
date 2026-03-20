extends "res://assets/scripts/fish/Species/Species.gd"
class_name StubbyFish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	var x_pos:float = 0

	num_bones = randi_range(4, 6)
	max_distance = randi_range(8, 12)
	max_radius = randi_range(20, 30)

	var min_turn_angle:float = 0.3
	var turn_speed:float = 8

	for i in range(num_bones):
		var bone:FishBone = fish_bone_object.instantiate()

		var use_individual_colours = randf() < multi_colour_chance
		bone.colour = colour

		var radius = max_radius * (1.0 - i * 0.15)
		var has_eyes = (i == 0)

		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, has_eyes)
		bone.move_speed = randf_range(150, 300)

		x_pos -= bone.radius
		bone.position.x = x_pos

		bones.add_child(bone)
		prev_bone = bone
