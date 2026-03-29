extends StaticBody3D
class_name Player

@export var head:Head
var camera:Camera3D
@export var animation_player:AnimationPlayer
@export var animation_tree:AnimationTree
var hair:MeshInstance3D
@export var hair_3p:MeshInstance3D

@export var dialogue_menu:Dialogue

@export var fishing_rod:FishingRod
@export var tablet:Tablet
@export var fish_spot:Node3D
@export var fish_spot_2:Node3D
@export var menu:CanvasLayer
@export var left_travel_point:Node3D
@export var center_travel_point:Node3D
@export var right_travel_point:Node3D
var shop_distance:float = 2.0

@export var camera_3p:Camera3D
@export var head_3p:Node3D
@export var pointers:Pointer

@export var music_main:AudioStreamPlayer
var music_state = "menu"
@export var sfx_main:AudioStreamPlayer
var sfx_state = "silence"
@export var ambient_main:AudioStreamPlayer
var ambient_state = "wind1"

@export var cat_vending_machine:VendingMachine
@export var dog_vending_machine:VendingMachine
@export var left_fish_pile:Node3D
@export var right_fish_pile:Node3D

@export var fish_info_text:RichTextLabel


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
var fish_on_hook:Array[Fish] =[]
var timer:float

var prev_camera_rotation:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_settings()
	# Set up the AudioStreamInteractive resource
	var music = preload("res://assets/sound/audio_stream_interactive.tres")
	music_main.stream = music
	music_main.play()
	var sfx = preload("res://assets/sound/sfx_audio_stream_interactive.tres")
	sfx_main.stream = sfx
	sfx_main.play()
	
	var ambient = preload("res://assets/sound/ambient_audio_stream_interactive.tres")
	ambient_main.stream = ambient
	ambient_main.play()
	
	self.timer = 0
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
	fish_on_hook.append(fish)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	self.global_position.y = sin(timer)*0.05
	
	if Global.game_state["you"]["hunger"] <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://assets/scenes/ending_1.tscn")
		return
	if Global.game_state["you"]["corruption"] >= Global.game_state["you"]["max_corruption"]:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://assets/scenes/ending_2.tscn")
		return
	if Global.game_state["you"]["cat_score"] >= 100:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://assets/scenes/ending_3.tscn")
		return
	if Global.game_state["you"]["dog_score"] >= 100:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://assets/scenes/ending_4.tscn")
		return
	if in_dialogue:
		if target_position.x == self.left_travel_point.global_position.x:
			camera.look_at(cat_vending_machine.global_position)
		elif target_position.x == self.right_travel_point.global_position.x:
			camera.look_at(dog_vending_machine.global_position)
		
	if in_menu:
		fish_info_text.visible = false
		in_dialogue = false
		dialogue_menu.visible = false
		return
	
	if is_zooming:
		zoom_progress = min(zoom_progress + (delta * zoom_speed_scale), 1)
	
	if Input.is_action_just_pressed("escape"):
		menu.visible = true
		in_dialogue = false
		dialogue_menu.visible = false
		in_menu = true
		self.camera = camera_3p
		self.head.rotation_degrees.y = 150
		self.camera.rotation_degrees.x = -13
		update_camera_state()
		switch_music("menu")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.save_settings()
	elif not menu.visible and music_state == "menu":
		switch_music("game")
	
	if Input.is_action_just_pressed("zoom_in"):
		is_zooming = true
		zoom_direction = 1
		zoom_progress = 0
	elif Input.is_action_just_pressed("zoom_out"):
		is_zooming = true
		zoom_direction = -1
		zoom_progress = 0
	
	if Input.is_action_just_pressed("eat") and Global.game_state["you"]["current_fish"] > 0:
		if left_fish_pile.get_child_count() > 0:
			var fish_to_remove:Fish = left_fish_pile.get_child(0)
			if fish_to_remove.fish_stats["id"] == 14:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().change_scene_to_file("res://assets/scenes/ending_6.tscn")
				return
			Global.game_state["you"]["hunger"] += fish_to_remove.fish.species.fish_stats["food"]
			Global.game_state["you"]["corruption"] += fish_to_remove.fish.species.fish_stats["corruption"]
			Global.game_state["you"]["current_fish"] -= 1
			left_fish_pile.remove_child(fish_to_remove)
			fish_to_remove.queue_free()
			
		elif right_fish_pile.get_child_count() > 0:
			var fish_to_remove:Fish = right_fish_pile.get_child(0)
			if fish_to_remove.fish_stats["id"] == 14:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().change_scene_to_file("res://assets/scenes/ending_6.tscn")
				return
			
			Global.game_state["you"]["hunger"] += fish_to_remove.fish.species.fish_stats["food"]
			Global.game_state["you"]["corruption"] += fish_to_remove.fish.species.fish_stats["corruption"]
			Global.game_state["you"]["current_fish"] -= 1
			right_fish_pile.remove_child(fish_to_remove)
			fish_to_remove.queue_free()
			
		
	if Input.is_action_pressed("travel_left"):
		if self.global_position.x < self.left_travel_point.global_position.x - shop_distance:
			target_position.x = self.global_position.x + (boat_speed * delta)
		else:
			target_position.x = self.left_travel_point.global_position.x
	elif Input.is_action_pressed("travel_right"):
		if self.global_position.x > self.right_travel_point.global_position.x + shop_distance:
			target_position.x = self.global_position.x - (boat_speed * delta)
		else:
			target_position.x = self.right_travel_point.global_position.x
	if Input.is_action_just_pressed("activate_tablet"):
		self.tablet.toggle_screen()
	
	if self.global_position.x >= self.left_travel_point.global_position.x - shop_distance:
		self.in_dialogue = true
		self.dialogue_menu.update("cat")
		self.dialogue_menu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	elif self.global_position.x <= self.right_travel_point.global_position.x + shop_distance:
		self.in_dialogue = true
		self.dialogue_menu.update("dog")
		self.dialogue_menu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	else:
		self.in_dialogue = false
		self.dialogue_menu.visible = false
		if not in_menu:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
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
	
	if not in_menu:
		if in_dialogue:
			if self.global_position.x >= self.left_travel_point.global_position.x - shop_distance:
				switch_music("cat")
			elif  self.global_position.x <= self.right_travel_point.global_position.x + shop_distance:
				switch_music("dog")
		elif not fish_on_hook.is_empty():
			switch_music("battle")
		elif not fish_on_hook:
			switch_music("game")
	
	if not fish_on_hook.is_empty() and not fish_on_hook[0].recharging:
		update_camera(Vector2(fishing_rod.tip.global_position.x -fish_on_hook[0].global_position.x + randf_range(-3.5,3.5), fishing_rod.tip.global_position.z - fish_on_hook[0].global_position.z + randf_range(-3.5,3.5)))
	
	if not fish_on_hook.is_empty() and fishing_rod.hook.global_position.y > 0:
		var text:String = "[center]%s\n%s[/center]"%[fish_on_hook[0].fish_stats["name"], fish_on_hook[0].fish_stats["description"]]
		if Global.game_state["cat"]["upgrades"]["unique"]:
			text = "%s\n(%s Corruption)"%[text, fish_on_hook[0].fish_stats["corruption"]]
		if Global.game_state["dog"]["upgrades"]["unique"]:
			text = "%s\n(%s CC / %s DD)"%[text, fish_on_hook[0].fish_stats["cat_coins"], fish_on_hook[0].fish_stats["dog_coins"]]
		fish_info_text.text = text
		fish_info_text.visible = true
	else:
		fish_info_text.visible = false
	
	if self.global_position.x <= self.left_travel_point.global_position.x - shop_distance and self.global_position.x >= self.right_travel_point.global_position.x + shop_distance:
		if fishing_lower:
			fishing_rod.hook.global_position.y -= fishing_lower_speed * delta
			fishing_rod.spinner.rotation.x -= fishing_lower_speed * 10* delta
			play_sfx("reel")
		elif fishing_raise and Global.game_state["you"]["stamina"] >= Global.game_state["you"]["stamina_cost"] * delta:
			if not fish_on_hook.is_empty():
				for fish in fish_on_hook:
					Global.game_state["you"]["stamina"] -= Global.game_state["you"]["stamina_cost"] * delta
					#fish_on_hook.global_rotation_degrees = Vector3(90,0,0)
					fish.speed_modifier = 0.25
			var total_raise_speed:float = fishing_raise_speed
			if not fish_on_hook.is_empty():
				if not fish_on_hook[0].recharging:
					total_raise_speed = 0
				else:
					total_raise_speed *= 0.75
			fishing_rod.hook.global_position.y += total_raise_speed * delta
			if fishing_rod.hook.global_position.y <= 1.14:
				fishing_rod.spinner.rotation.x += total_raise_speed * 10* delta
				play_sfx("reel")
			else:
				if not fish_on_hook.is_empty() and Global.game_state["you"]["current_fish"] < Global.game_state["you"]["max_fish"]:
					for fish in fish_on_hook:
						
						# move the fish to the boat
						fish.caught = false
						fish.on_boat = true
						fish.get_parent().remove_child(fish)
						if int(Global.game_state["you"]["current_fish"]) % 2 == 0:
							fish_spot.add_child(fish)
							fish.position = Vector3(0,fish_spot.get_child_count()*0.1,0)
						else:
							fish_spot_2.add_child(fish)
							fish.position = Vector3(0,fish_spot_2.get_child_count()*0.1,0)
						fish.rotation_degrees = Vector3(0,randf_range(-15, 15),0)
						fish.paused = true
						fish.fish.paused = true
						Global.game_state["you"]["current_fish"] += 1
						# reduce the number of fish on hook count
						Global.game_state["you"]["hooked_fish"] -= 1
						if fish.fish_stats["id"] == 15:
							Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
							get_tree().change_scene_to_file("res://assets/scenes/ending_5.tscn")
							return
						
					fish_on_hook = []
		else:
			if not fish_on_hook.is_empty():
				for fish in fish_on_hook:
					fish.speed_modifier = 1.0
					if not fish.recharging:
						fishing_rod.spinner.rotation.x -= fishing_lower_speed * 10* delta
						play_sfx("reel")
					else:
						play_sfx("silence")
		if not fishing_raise and not fishing_lower:
			if fish_on_hook.is_empty():
				play_sfx("silence")
			else:
				var all_recharging:bool = true
				for fish in fish_on_hook:
					if not fish.recharging:
						all_recharging = false
						break
				if all_recharging:
					play_sfx("silence")
		elif fishing_raise and fishing_rod.hook.global_position.y >= 1.14:
			play_sfx("silence")
		
	if global_position.x > target_position.x:
		global_position.x -= boat_speed * delta
		Global.game_state["you"]["hunger"] -= Global.game_state["you"]["travel_hunger_rate"] * delta
	elif global_position.x < target_position.x:
		global_position.x += boat_speed * delta
		Global.game_state["you"]["hunger"] -= Global.game_state["you"]["travel_hunger_rate"] * delta
	else:
		Global.game_state["you"]["hunger"] -= Global.game_state["you"]["idle_hunger_rate"] * delta
	
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
	
func switch_music(new_music_state:String):
	if music_state != new_music_state:
		if music_state == "game" or music_state == "battle":
			if new_music_state == "cat" or new_music_state == "dog":
				prev_camera_rotation = camera.rotation
		if music_state == "cat" or music_state == "dog":
			if new_music_state == "game":
				camera.rotation = prev_camera_rotation
		
		# print("Switch music from %s to %s"%[music_state, new_music_state])
		var playback = music_main.get_stream_playback() as AudioStreamPlaybackInteractive
		playback.switch_to_clip_by_name(new_music_state)
		music_state = new_music_state
		

func play_sfx(new_sfx_state:String):
	if sfx_state != new_sfx_state:
		# print("Switch sfx from %s to %s"%[sfx_state, new_sfx_state])
		var playback = sfx_main.get_stream_playback() as AudioStreamPlaybackInteractive
		sfx_main.pitch_scale = randf_range(0.9, 1.1)
		playback.switch_to_clip_by_name(new_sfx_state)
		sfx_state = new_sfx_state
	

func _unhandled_input(event : InputEvent):
	if in_menu:
		return
	if event is InputEventMouseButton:
		if event.button_index == 1:
			fishing_lower = event.pressed
		elif event.button_index == 2:
			fishing_raise = event.pressed
		if not event.pressed:
			fishing_lower = false
			fishing_raise = false
	if event is InputEventMouseMotion:
		var mouseInput:Vector2 = event.relative
		update_camera(mouseInput)
	
func update_camera(mouseInput:Vector2):
	if in_menu or in_dialogue:
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
		min_rotation_x = -PI/6
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
	return Input.is_action_pressed("travel_left") or Input.is_action_pressed("travel_right")
