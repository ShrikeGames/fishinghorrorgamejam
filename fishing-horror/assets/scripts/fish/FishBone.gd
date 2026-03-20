extends Node2D
class_name FishBone

@export var left:Node2D
@export var right:Node2D
@export var prev_bone:FishBone
@export var max_distance:float = 1
@export var radius:float = 1
@export var move_speed:float = 400
@export var line:Line2D
@export var flexibility:float = 0.2
@export var agility:float = 6
@export var mouse_control:bool = true
@export var mouse_chase_distance:float = 300
@export var debug:bool = false
@export var look_ahead_distance:float = 100

@export var use_individual_colours:bool = false
var colour_choices = ["00", "11", "22", "33", "44", "55", "66", "77", "88", "99", "AA", "BB", "CC", "DD", "EE", "FF"]
var colour:String = "fff"

var head_points:Array[Node2D] = []
var eye_colour:String = "000"
var has_eyes:bool = false
var timer:float = 0

func init(bone:FishBone, multicolour:bool, distance:float = 1, body_radius:float = 1, min_turn_angle:float = 0.4, turn_speed:float = 12, eyes:bool = false):
	self.timer = 0
	self.prev_bone = bone
	self.use_individual_colours = multicolour
	self.max_distance = max(distance, radius * 0.5)
	self.radius = max(2.0, body_radius)
	self.left.translate(Vector2(0, -radius))
	self.right.translate(Vector2(0, radius))
	self.flexibility = min_turn_angle
	self.agility = turn_speed
	self.has_eyes = eyes
	# add head points if it's the front
	if not prev_bone:
		var angle:float = -PI/4
		while angle <= PI/4:
			var node:Node2D = Node2D.new()
			var x = position.x + radius * cos(angle)
			var y = position.y + radius * sin(angle)
			node.position = Vector2(x, y)
			head_points.append(node)
			add_child(node)
			angle += PI/8
		line.add_point(Vector2(0,0))
		line.add_point(Vector2(0,0))
		line.visible = false
		
	if self.use_individual_colours:
		if self.prev_bone:
			var prev_colour:Color = Color(prev_bone.colour)
			var variance:float = 0.1
			var random_pick:int = randi_range(0, 3)
			var r:float = prev_colour.r
			var g:float = prev_colour.g
			var b:float = prev_colour.b
			if random_pick == 0:
				r = max(min(prev_colour.r + randf_range(-variance, variance), 1.0), 0)
			elif random_pick == 1:
				g = max(min(prev_colour.g + randf_range(-variance, variance), 1.0), 0)
			else:
				b = max(min(prev_colour.b + randf_range(-variance, variance), 1.0), 0)
			colour = Color(r,g,b).to_html()
			eye_colour = Color(r*0.1,g*0.1,b*0.1).to_html()
		else:
			var red: String = colour_choices[randi_range(0, len(colour_choices)-1)]
			var green: String = colour_choices[randi_range(0, len(colour_choices)-1)]
			var blue: String = colour_choices[randi_range(0, len(colour_choices)-1)]
			colour = "%s%s%s"%[red, green, blue]
			var c:Color = Color(colour)
			eye_colour = Color(c.r*0.5, c.g*0.5, c.b*0.5).to_html()

func update(delta):
	var target_pos:Vector2
	timer += delta
	
	if prev_bone:
		target_pos = prev_bone.global_position
	else:
		target_pos = Vector2(514,512 + (sin(timer*agility))) 
		global_position = Vector2(512,512)
	
	var distance:float = global_position.distance_to(target_pos)
	
	if distance != max_distance:
		var angle_diff:float = get_angle_to(target_pos)
		if angle_diff > flexibility:
			rotation += agility * delta
		elif angle_diff < -flexibility:
			rotation -= agility * delta
		else:
			look_at(target_pos)
		if not prev_bone and debug:
			line.points[1] = to_local(target_pos)
		
		if prev_bone:
			# body parts must remain at correct distance from bone they're attached to
			global_position = prev_bone.global_position - (prev_bone.transform.x.normalized() * prev_bone.max_distance)
		else:
			# move forward since it's the head
			position += move_speed * transform.x * delta
	

func _on_draw():
	if has_eyes:
		draw_circle(left.position*0.55, radius*0.25, eye_colour)
		draw_circle(right.position*0.55, radius*0.25, eye_colour)
	if debug:
		draw_circle(Vector2(0,0), radius, "fff")
		draw_circle(left.position, 2, "ff0000")
		draw_circle(right.position, 2, "00ff00")
		for head_node in head_points:
			draw_circle(head_node.position, 2, "fff")
