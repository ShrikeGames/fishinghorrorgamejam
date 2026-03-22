extends Node2D
class_name FishSegment

@export var bones:Node2D
@export var base_colour:String
@export var multi_colour_chance:float = 0.0
var time:float = 0.0
var paused:bool = false
@export var species:Species
var last_valid_draw_points:Array[Vector2]
var last_colour_points:Array[String]

func _ready():
	species.generate(bones, multi_colour_chance, base_colour)
	pass
	
	
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
		# print("invalid polygon detected with ", species.fish_stats["name"])
		# sort the points to try and resolve it
		draw_points = order_points_path(draw_points)
	# check again if it's valid
	if Geometry2D.triangulate_polygon(draw_points).is_empty() and last_valid_draw_points:
		draw_points = last_valid_draw_points
		colour_points = last_colour_points
		
	if not Geometry2D.triangulate_polygon(draw_points).is_empty():
		last_valid_draw_points = draw_points
		last_colour_points = colour_points
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
