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
	
	var species_id:int = randi_range(1,4)
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
			colour_points.insert(0,bone.colour)
	
	for head_node in fish_bones[0].head_points:
		var x = to_local(head_node.global_position).x
		var y = to_local(head_node.global_position).y
		draw_points.append(Vector2(x,y))
		if multi_colour_chance > 0:
			colour_points.append(fish_bones[0].colour)
	
	for bone in fish_bones:
		draw_points.append(to_local(bone.right.global_position))
		if multi_colour_chance > 0:
			colour_points.append(bone.colour)
	
	if multi_colour_chance > 0:
		draw_polygon(draw_points, colour_points)
	else:
		draw_colored_polygon(draw_points, base_colour)
