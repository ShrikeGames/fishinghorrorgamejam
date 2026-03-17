extends StaticBody3D
class_name Player

@export var head:Head
var camera:Camera3D
@export var animation_player:AnimationPlayer
@export var animation_tree:AnimationTree
var hair:SoftBody3D
@export var hair_3p:SoftBody3D
@export var fishing_rod:FishingRod
@export var tablet:Tablet
@export var fish_spot:Node3D
@export var fish_spot_2:Node3D
@export var menu:CanvasLayer
var in_menu:bool = true

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

var forward:Vector3
var fish_on_hook:Fish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.camera = head.camera_3p
	self.head.rotation_degrees.y = 150
	self.camera.rotation_degrees.x = -13
	hair = head.hair
	initial_fov = Global.game_state["you"]["fov"]
	mouse_sensitivity = Global.game_state["you"]["mouse_sensitivity"]
	fishing_lower_speed = Global.game_state["you"]["fishing_lower_speed"]
	fishing_raise_speed = Global.game_state["you"]["fishing_raise_speed"]
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
		self.camera = head.camera_3p
		self.head.rotation_degrees.y = 150
		self.camera.rotation_degrees.x = -13
		update_camera_state()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("toggle_camera"):
		update_camera_state()
	
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
	
	if fishing_lower:
		fishing_rod.hook.global_position.y -= fishing_lower_speed * delta
		fishing_rod.spinner.rotation.x -= fishing_lower_speed * 10* delta
	if fishing_raise:
		if fish_on_hook:
			Global.game_state["you"]["stamina"] -= fish_on_hook.size_multiplier * delta
		
		fishing_rod.hook.global_position.y += fishing_raise_speed * delta
		if fishing_rod.hook.global_position.y <= 1.14:
			fishing_rod.spinner.rotation.x += fishing_raise_speed * 10* delta
		else:
			if fish_on_hook and Global.game_state["you"]["current_fish"] < Global.game_state["you"]["max_fish"]:
				# move the fish to the boat
				fish_on_hook.caught = false
				fish_on_hook.on_boat = true
				if Global.game_state["you"]["current_fish"] % 2 == 0:
					fish_on_hook.global_position = fish_spot.global_position
				else:
					fish_on_hook.global_position = fish_spot_2.global_position
				fish_on_hook.rotation_degrees = Vector3(0,randf_range(-15, 15),0)
				Global.game_state["you"]["current_fish"] += 1
				# reduce the number of fish on hook count
				Global.game_state["you"]["hooked_fish"] -= 1
				fish_on_hook = null
		
	fishing_rod.hook.global_position.y = clampf(fishing_rod.hook.global_position.y, -100000, 1.14)
	var stamina_regen:float = 0.1
	Global.game_state["you"]["stamina"] += stamina_regen * delta
	
	Global.game_state["you"]["stamina"] = clampf(Global.game_state["you"]["stamina"], 0, Global.game_state["you"]["max_stamina"])
	Global.game_state["you"]["hunger"] = clampf(Global.game_state["you"]["hunger"], 0, Global.game_state["you"]["max_hunger"])
	Global.game_state["you"]["corruption"] = clampf(Global.game_state["you"]["corruption"], 0, Global.game_state["you"]["max_corruption"])


func _unhandled_input(event : InputEvent):
	if in_menu:
		return
	if event is InputEventMouseMotion:
		var mouseInput:Vector2 = event.relative
		update_camera(mouseInput)
	elif event is InputEventMouseButton and event.button_index in [1,2]:
		
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
				if event.button_index == 1:
					fishing_lower = event.pressed
				elif event.button_index == 2:
					fishing_raise = event.pressed
			elif collider.name == "TabletArea" and event.button_index == 1 and event.pressed:
				tablet.toggle_screen()
			
		if not event.pressed:
			fishing_lower = false
			fishing_raise = false
		

func update_camera(mouseInput:Vector2):
	if in_menu:
		return
	var min_rotation_y:float = 2.3
	var max_rotation_y:float = 3.8
	var min_rotation_x:float = -PI/4
	var max_rotation_x:float = 0.0
	if camera_toggle:
		min_rotation_y=0
		max_rotation_y=2*PI
	
	
	head.rotate(Vector3(0,1,0), -mouseInput.x * mouse_sensitivity *0.01)
	var new_rotation_y:float = fmod(head.rotation.y + 2*PI, 2*PI)
	new_rotation_y =  clamp(new_rotation_y,min_rotation_y, max_rotation_y)
	head.rotation.y = new_rotation_y
	
	camera.rotate(Vector3(1,0,0), -mouseInput.y * mouse_sensitivity *0.01)
	camera.rotation.x = clamp(camera.rotation.x, min_rotation_x, max_rotation_x)
	
func update_camera_state():
	camera_toggle = not camera_toggle
	
	if camera_toggle:
		hair.visible = false
		hair_3p.visible = true
		self.camera = head.camera_3p
	else:
		hair.visible = true
		hair_3p.visible = false
		self.camera = head.camera
	self.camera.make_current()
	update_camera(Vector2(0,0))
