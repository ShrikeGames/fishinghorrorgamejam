extends "res://assets/scripts/fish/Species/Species.gd"
class_name Goldfish

func generate(bones:Node2D, multi_colour_chance:float, colour:String):
	var prev_bone:Node2D = null
	var x_pos:float = 0
	# tadpole initial values
	num_bones = randi_range(8, 12)
	max_distance = randi_range(10, 15)
	max_radius = randi_range(10, 20)
	
	var min_turn_angle:float = 0.1
	var turn_speed:float = 6
	
	
	for i in range(0, num_bones):
		var bone:FishBone = fish_bone_object.instantiate()
		
		var use_individual_colours = false
		bone.colour = colour
		if randf() < multi_colour_chance:
			use_individual_colours = true
		var radius = max_radius * ((4+abs((num_bones*0.5)-i))/num_bones)
		var has_eyes:bool = (i == 0)
		bone.init(prev_bone, use_individual_colours, max_distance, radius, min_turn_angle, turn_speed, has_eyes)
		bone.move_speed = randf_range(200, 500)
		x_pos -= bone.radius
		var fin:FishBone = null
		if i == 2:
			fin = fish_bone_object.instantiate()
			var fin_radius:float = bone.radius*1.75
			var fin_max_distance:float = max_distance * 1.25
			var fin_min_turn_angle:float = min_turn_angle
			var fin_turn_speed:float = turn_speed * 1.5
			fin.init(bone, use_individual_colours, fin_max_distance, fin_radius, fin_min_turn_angle, fin_turn_speed)
			fin.move_speed = bone.move_speed
			fin.position.x = x_pos - bone.radius
			fin.position.y = -fin_radius
			fin.rotation = 0
		
		bone.position.x = x_pos
		bone.rotation = 0
		
		bones.add_child(bone)
		if fin:
			bones.add_child(fin)
		
		prev_bone = bone
