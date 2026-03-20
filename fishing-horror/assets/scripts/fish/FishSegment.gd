extends Node2D
class_name FishSegment

@export var bones:Node2D
@export var base_colour:String
@export var multi_colour_chance:float = 1.0
var colour_choices = ["00", "11", "22", "33", "44", "55", "66", "77", "88", "99", "AA", "BB", "CC", "DD", "EE", "FF"]
var time:float = 0.0
var paused:bool = false
func _ready():
	var red: String = colour_choices[randi_range(0, len(colour_choices)-1)]
	var green: String = colour_choices[randi_range(0, len(colour_choices)-1)]
	var blue: String = colour_choices[randi_range(0, len(colour_choices)-1)]
	
	var species_id:int = randi_range(1,12)
	if species_id == 1:
		var worm:Worm = Worm.new()
		base_colour = "%s%s%s"%[red, green, blue]
		worm.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 2:
		var tadpole:Goldfish = Goldfish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		tadpole.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 3:
		var longfish:Longfish = Longfish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		longfish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 4:
		var eyefish:Eyefish = Eyefish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 5:
		var eyefish:FanTail = FanTail.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 6:
		var eyefish:PufferFish = PufferFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 7:
		var eyefish:PuffTailFish = PuffTailFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 8:
		var eyefish:SpineFish = SpineFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 9:
		var eyefish:StubbyFish = StubbyFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 10:
		var eyefish:TriangleFish = TriangleFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 11:
		var eyefish:ClusterEyeFish = ClusterEyeFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	elif species_id == 12:
		var eyefish:SharkFish = SharkFish.new()
		base_colour = "%s%s%s"%[red, green, blue]
		eyefish.generate(bones, multi_colour_chance, base_colour)
	
	
func _process(delta):
	time += delta
	if not paused:
		for bone:FishBone in bones.get_children():
			bone.update(delta)
	queue_redraw()

func _on_draw():
	var draw_points:Array[Vector2] = []
	var colour_points:Array[String] = []

	var fish_bones = bones.get_children()
	if fish_bones.is_empty():
		return

	for bone in fish_bones:
		draw_points.insert(0, to_local(bone.left.global_position))
		if multi_colour_chance > 0:
			colour_points.insert(0, bone.colour)

	for head_node in fish_bones[0].head_points:
		var p = to_local(head_node.global_position)
		draw_points.append(p)
		if multi_colour_chance > 0:
			colour_points.append(fish_bones[0].colour)

	for bone in fish_bones:
		draw_points.append(to_local(bone.right.global_position))
		if multi_colour_chance > 0:
			colour_points.append(bone.colour)

	draw_points = _sanitize_polygon(draw_points, colour_points)

	if draw_points.size() < 3:
		return
		
	# if there are issues with the polygon intersecting itself
	if Geometry2D.triangulate_polygon(draw_points).is_empty():
		# sort the points to try and resolve it
		draw_points = order_points_path(draw_points)
	# check again if it's valid
	if not Geometry2D.triangulate_polygon(draw_points).is_empty():
		if multi_colour_chance > 0:
			draw_polygon(draw_points, colour_points)
		else:
			draw_colored_polygon(draw_points, base_colour)

func order_points_path(points: Array[Vector2]) -> Array[Vector2]:
	var remaining:Array[Vector2] = points.duplicate()
	var result:Array[Vector2] = []

	var current = remaining.pop_front()
	result.append(current)

	while remaining.size() > 0:
		var closest_index = 0
		var closest_dist = current.distance_to(remaining[0])

		for i in range(1, remaining.size()):
			var dist = current.distance_to(remaining[i])
			if dist < closest_dist:
				closest_dist = dist
				closest_index = i

		current = remaining[closest_index]
		result.append(current)
		remaining.remove_at(closest_index)

	return result

func _sanitize_polygon(points:Array, colours:Array) -> Array:
	var cleaned_points:Array[Vector2] = []
	var cleaned_colours:Array = []

	const MIN_DIST:float = 1.0

	for i in range(points.size()):
		var p = points[i]

		if not is_finite(p.x) or not is_finite(p.y):
			continue

		if cleaned_points.size() > 0:
			if cleaned_points[-1].distance_to(p) < MIN_DIST:
				continue

		cleaned_points.append(p)
		if colours.size() == points.size():
			cleaned_colours.append(colours[i])

	if cleaned_points.size() > 2:
		if cleaned_points[0].distance_to(cleaned_points[-1]) < MIN_DIST:
			cleaned_points.pop_back()
			if cleaned_colours.size() > 0:
				cleaned_colours.pop_back()

	points.clear()
	points.append_array(cleaned_points)

	if colours.size() > 0:
		colours.clear()
		colours.append_array(cleaned_colours)

	return points
