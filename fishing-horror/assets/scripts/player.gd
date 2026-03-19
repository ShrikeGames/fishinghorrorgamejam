extends StaticBody3D
class_name Player

@export var head:Head
var camera:Camera3D
@export var animation_player:AnimationPlayer
@export var animation_tree:AnimationTree
var hair:SoftBody3D
@export var hair_3p:MeshInstance3D

@export var fishing_rod:FishingRod
@export var tablet:Tablet
@export var fish_spot:Node3D
@export var fish_spot_2:Node3D
@export var menu:CanvasLayer
@export var left_travel_point:Node3D
@export var center_travel_point:Node3D
@export var right_travel_point:Node3D
@export var camera_3p:Camera3D
@export var head_3p:Node3D
@export var pointers:Pointer

var target_position:Vector3
var current_location:String = "center"

var in_menu:bool = true
var in_dialogue:bool = false

var fish_on_boat_position:Vector3

var initial_fov:float = 75.0
var mouse_sensitivity:float = 0.2
var zoom_fov_modifier:float = 0.5
var is_zooming:bool = false
var zoom_progress:float = 0.0
var zoom_speed_scale:float = 0.5
var zoom_direction:int = 1
var camera_toggle:bool = true
var fishing_lower:bool = false
var fishing_raise:bool = false
var fishing_lower_speed:float
var fishing_raise_speed:float
var boat_speed:float
var forward:Vector3
var fish_on_hook:Fish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_settings()
	self.camera = camera_3p
	self.head.rotation_degrees.y = 150
	self.camera.rotation_degrees.x = -13
	self.in_dialogue = false
	hair = head.hair
	initial_fov = Global.game_state["you"]["fov"]
	boat_speed  = Global.game_state["you"]["boat_speed"]
	mouse_sensitivity = Global.game_state["you"]["mouse_sensitivity"]
	fishing_lower_speed = Global.game_state["you"]["fishing_lower_speed"]
	fishing_raise_speed = Global.game_state["you"]["fishing_raise_speed"]
	self.global_position = Vector3(Global.game_state["you"]["current_position"][0], Global.game_state["you"]["current_position"][1], Global.game_state["you"]["current_position"][2])
	self.current_location = Global.game_state["you"]["current_location"]
	self.target_position = Vector3(Global.game_state["you"]["target_position"][0], Global.game_state["you"]["target_position"][1], Global.game_state["you"]["target_position"][2])
	self.fishing_rod.hook.global_position.x = self.global_position.x
	is_zooming = false
	zoom_progress = 0.0
	fishing_lower = false
	fishing_raise = false
	
	forward = camera.global_transform.basis.z
	
	Global.caught_fish.connect(caught_fish)

func caught_fish(fish:Fish):
	print("Caught fish start minigame", fish)
	fish_on_hook = fish

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_menu:
		return
	
	if is_zooming:
		zoom_progress = min(zoom_progress + (delta * zoom_speed_scale), 1)
	
	if Input.is_action_just_pressed("escape"):
		menu.visible = true
		in_menu = true
		self.camera = camera_3p
		self.head.rotation_degrees.y = 150
		self.camera.rotation_degrees.x = -13
		update_camera_state()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.save_settings()
	
	if Input.is_action_just_pressed("zoom_in"):
		is_zooming = true
		zoom_direction = 1
		zoom_progress = 0
		
	elif Input.is_action_just_pressed("zoom_out"):
		is_zooming = true
		zoom_direction = -1
		zoom_progress = 0
	
	if is_zooming:
		if zoom_progress >= 1:
			is_zooming = false
			zoom_progress = 0
		else:
			if zoom_direction > 0:
				camera.fov = lerpf(camera.fov, initial_fov*zoom_fov_modifier, zoom_progress)
			elif zoom_direction < 0:
				camera.fov = lerpf(camera.fov, initial_fov, zoom_progress)
	
	if Input.is_action_just_pressed("toggle_camera"):
		update_camera_state()
		
	if in_dialogue:
		return
	if fish_on_hook and not fish_on_hook.recharging:
		update_camera(Vector2(fishing_rod.tip.global_position.x -fish_on_hook.global_position.x, fishing_rod.tip.global_position.z - fish_on_hook.global_position.z))
	
	if global_position.x != left_travel_point.global_position.x and global_position.x != right_travel_point.global_position.x:
		fishing_rod.visible = true
		if fishing_lower:
			fishing_rod.hook.global_position.y -= fishing_lower_speed * delta
			fishing_rod.spinner.rotation.x -= fishing_lower_speed * 10* delta
		if fishing_raise and Global.game_state["you"]["stamina"] >= Global.game_state["you"]["stamina_cost"] * delta:
			if fish_on_hook:
				Global.game_state["you"]["stamina"] -= Global.game_state["you"]["stamina_cost"] * delta
				#fish_on_hook.global_rotation_degrees = Vector3(90,0,0)
				fish_on_hook.speed_modifier = 0.25
			var total_raise_speed:float = fishing_raise_speed
			if fish_on_hook:
				if not fish_on_hook.recharging:
					total_raise_speed = 0
				else:
					total_raise_speed *= 0.75
			fishing_rod.hook.global_position.y += total_raise_speed * delta
			if fishing_rod.hook.global_position.y <= 1.14:
				fishing_rod.spinner.rotation.x += total_raise_speed * 10* delta
			else:
				if fish_on_hook and Global.game_state["you"]["current_fish"] < Global.game_state["you"]["max_fish"]:
					# move the fish to the boat
					fish_on_hook.caught = false
					fish_on_hook.on_boat = true
					fish_on_hook.get_parent().remove_child(fish_on_hook)
					if int(Global.game_state["you"]["current_fish"]) % 2 == 0:
						fish_spot.add_child(fish_on_hook)
						fish_on_hook.position = Vector3(0,fish_spot.get_child_count()*0.1,0)
						
					else:
						fish_spot_2.add_child(fish_on_hook)
						fish_on_hook.position = Vector3(0,fish_spot_2.get_child_count()*0.1,0)
					fish_on_hook.rotation_degrees = Vector3(0,randf_range(-15, 15),0)
					fish_on_hook.fish.paused = true
					Global.game_state["you"]["current_fish"] += 1
					# reduce the number of fish on hook count
					Global.game_state["you"]["hooked_fish"] -= 1
					fish_on_hook = null
		else:
			if fish_on_hook:
				fish_on_hook.speed_modifier = 1.0
				if not fish_on_hook.recharging:
					fishing_rod.spinner.rotation.x -= fishing_lower_speed * 10* delta
	else:
		fishing_rod.visible = false
	
	if global_position.x > target_position.x:
		global_position.x -= boat_speed * delta
		Global.game_state["you"]["hunger"] -= Global.game_state["you"]["travel_hunger_rate"] * delta
	elif global_position.x < target_position.x:
		global_position.x += boat_speed * delta
		Global.game_state["you"]["hunger"] -= Global.game_state["you"]["travel_hunger_rate"] * delta
	
	if abs(global_position.x - target_position.x) <= boat_speed * delta and abs(global_position.x - target_position.x)>0:
		global_position = target_position
	if global_position.x == left_travel_point.global_position.x:
		in_dialogue = true
	elif global_position.x == right_travel_point.global_position.x:
		in_dialogue = true
	
	global_position.x = clampf(global_position.x, right_travel_point.global_position.x,  left_travel_point.global_position.x)
	fishing_rod.hook.global_position.y = clampf(fishing_rod.hook.global_position.y, -100000, 1.14)
	var stamina_regen:float = Global.game_state["you"]["stamina_regen_rate"]
	if not fishing_raise:
		Global.game_state["you"]["stamina"] += stamina_regen * delta
	
	Global.game_state["you"]["stamina"] = clampf(Global.game_state["you"]["stamina"], 0, Global.game_state["you"]["max_stamina"])
	Global.game_state["you"]["hunger"] = clampf(Global.game_state["you"]["hunger"], 0, Global.game_state["you"]["max_hunger"])
	Global.game_state["you"]["corruption"] = clampf(Global.game_state["you"]["corruption"], 0, Global.game_state["you"]["max_corruption"])
	
	Global.game_state["you"]["current_location"] = self.current_location
	
	Global.game_state["you"]["target_position"][0] = self.target_position.x
	Global.game_state["you"]["target_position"][1] = self.target_position.y
	Global.game_state["you"]["target_position"][2] = self.target_position.z
	
	Global.game_state["you"]["current_position"][0] = self.global_position.x
	Global.game_state["you"]["current_position"][1] = self.global_position.y
	Global.game_state["you"]["current_position"][2] = self.global_position.z
	

func _unhandled_input(event : InputEvent):
	if in_menu:
		return
	if event is InputEventMouseButton and event.button_index in [1,2]:
		
		var from:Vector3 = camera.project_ray_origin(event.position)
		const RAY_LENGTH:float = 10.0
		var to:Vector3 = from + camera.project_ray_normal(event.position) * RAY_LENGTH
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.collision_mask = 2
		var result = space_state.intersect_ray(query)
		var collider:Area3D = result.get("collider", null)
		
		if collider:
			print(collider.name)
			if collider.name == "FishingArea":
				target_position = self.global_position
				current_location = "center"
				if event.button_index == 1:
					fishing_lower = event.pressed
				elif event.button_index == 2:
					fishing_raise = event.pressed
			elif collider.name == "TabletArea":
				if event.button_index == 1 and event.pressed:
					tablet.toggle_screen()
			elif collider.name == "LeftTravelArea":
				if event.button_index == 1 and event.pressed:
					if current_location == "center":
						target_position = self.left_travel_point.global_position
						current_location = "left"
						in_dialogue = false
					elif current_location == "right":
						target_position = self.center_travel_point.global_position
						current_location = "center"
						in_dialogue = false
			elif collider.name == "RightTravelArea":
				if event.button_index == 1 and event.pressed:
					if current_location == "center":
						target_position = self.right_travel_point.global_position
						current_location = "right"
						in_dialogue = false
					elif current_location == "left":
						target_position = self.center_travel_point.global_position
						current_location = "center"
						in_dialogue = false
			else:
				if event.button_index == 1 and event.pressed:
					var vending_machine:VendingMachine = collider.get_parent()
					var option_picked:int = int(collider.name.replace("ShopOption", ""))-1
					Global.game_state[vending_machine.shop_screen.conversation_name]["settings"]["conversation_state"].append(option_picked)
					Global.update_conversation.emit()
		if not event.pressed:
			fishing_lower = false
			fishing_raise = false
	if event is InputEventMouseMotion:
		var mouseInput:Vector2 = event.relative
		update_camera(mouseInput)
		var from:Vector3 = camera.project_ray_origin(event.position)
		const RAY_LENGTH:float = 10.0
		var to:Vector3 = from + camera.project_ray_normal(event.position) * RAY_LENGTH
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.collision_mask = 2
		var result = space_state.intersect_ray(query)
		var collider:Area3D = result.get("collider", null)
		if collider:
			if collider.name == "FishingArea":
				pointers.show_fishing()
			elif collider.name == "TabletArea":
				pointers.show_tablet()
			elif collider.name == "LeftTravelArea":
				pointers.show_travel()
			elif collider.name == "RightTravelArea":
				pointers.show_travel()

func update_camera(mouseInput:Vector2):
	if in_menu:
		return
	
	# how far right
	var min_rotation_y:float = 1.8
	# how far left
	var max_rotation_y:float = 4.1
	var min_rotation_x:float = -PI/3
	var max_rotation_x:float = PI/6
	var animation_x:float = convert_to_range(head.rotation.y, min_rotation_y, max_rotation_y, -1.0, 1.0)
	var animation_y:float = convert_to_range(camera.rotation.x, min_rotation_x, max_rotation_x, -1.0, 1.0)
	
	#print(animation_x, ", ", animation_y)
	var new_rotation_y:float = 0
	if camera_toggle:
		min_rotation_y=0
		max_rotation_y=2*PI
		min_rotation_x = 0
		max_rotation_y = 2*PI
		animation_x=0
		animation_y=0
		head_3p.rotate(Vector3(0,1,0), -mouseInput.x * mouse_sensitivity *0.01)
		new_rotation_y = fmod(head_3p.rotation.y + 2*PI, 2*PI)
		new_rotation_y =  clamp(new_rotation_y,min_rotation_y, max_rotation_y)
		head_3p.rotation.y = new_rotation_y
		camera.rotate(Vector3(1,0,0), -mouseInput.y * mouse_sensitivity *0.01)
		camera.rotation.x = clamp(camera.rotation.x, min_rotation_x, max_rotation_x)
	else:
		head.rotate(Vector3(0,1,0), -mouseInput.x * mouse_sensitivity *0.01)
		new_rotation_y = fmod(head.rotation.y + 2*PI, 2*PI)
		new_rotation_y =  clamp(new_rotation_y,min_rotation_y, max_rotation_y)
		head.rotation.y = new_rotation_y
		animation_tree.set("parameters/LookMachine/BlendSpace2D/blend_position", Vector2(-animation_x, animation_y))
	
		camera.rotate(Vector3(1,0,0), mouseInput.y * mouse_sensitivity *0.01)
		camera.rotation.x = clamp(camera.rotation.x, min_rotation_x, max_rotation_x)
	#print(camera.global_position)
	
	
func convert_to_range(value:float,min_value:float, max_value:float, new_min_value:float, new_max_value:float):
	return ((value - min_value) * (new_max_value - new_min_value) / (max_value - min_value)) + new_min_value
	
	
func update_camera_state():
	camera_toggle = not camera_toggle
	
	if camera_toggle:
		hair.visible = false
		hair_3p.visible = true
		self.camera = camera_3p
	else:
		hair.visible = true#make true to enable first person hair
		hair_3p.visible = false
		self.camera = head.camera
	self.camera.make_current()
	update_camera(Vector2(0,0))

func is_in_dialogue():
	return in_dialogue

func is_moving():
	return global_position.x != target_position.x
