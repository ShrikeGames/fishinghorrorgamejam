extends Node3D

class_name Fish

@export var player:Player
@export var viewport:SubViewport
@export var billboard:CanvasLayer
@export var plane:MeshInstance3D
@export var direction_node:Node3D

var size_multiplier:float = 1.0

var target_position:Vector3
var original_position:Vector3
var hook:Node3D
var caught:bool = false
var on_boat:bool = false

@export var recharging:bool = false
var speed_modifier:float = 1.0

@export var fish:FishSegment

var timer:float = 0
var paused:bool = false
var fish_stats:Dictionary
@export var stamina:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.timer = 0
	self.paused = false
	self.global_position = original_position
	
func init(fish_name:String, fishing_rod:FishingRod):
	fish_stats = Global.bestiary[fish_name]
	fish_stats["corruption"] = randf_range(fish_stats["min_corruption"], fish_stats["max_corruption"])
	var random_flip:Array[int] = [-1,1]
	self.original_position = fishing_rod.hook.global_position
	self.original_position.x += (1.0+randf())*random_flip.pick_random()*fish_stats["min_spawn_radius"]
	self.original_position.z += (1.0+randf())*random_flip.pick_random()*fish_stats["min_spawn_radius"]
	self.original_position.y += (1.0+randf())*random_flip.pick_random()*fish_stats["min_spawn_radius"]
	self.original_position.y = clampf(self.original_position.y, fish_stats["max_spawn_y"], fish_stats["min_spawn_y"])
	self.original_position.x = clampf(self.original_position.x, fish_stats["min_spawn_x"], fish_stats["max_spawn_x"])
	
	self.target_position = fishing_rod.hook.global_position + (Vector3(randf()*random_flip.pick_random(), randf()*random_flip.pick_random(), randf()*random_flip.pick_random()).normalized()*fish_stats["max_target_radius"])
	if fishing_rod.hook.global_position.y > 0:
		self.original_position -= Vector3(0, fishing_rod.hook.global_position.y+0.5, 0)
		self.target_position -= Vector3(0, fishing_rod.hook.global_position.y+0.5, 0)
	self.original_position.y = clampf(self.original_position.y, -10000, 0)
	self.target_position.y = clampf(self.target_position.y, -10000, -1.0)
	
	self.size_multiplier = randf_range(fish_stats["min_size_modifier"], fish_stats["max_size_modifier"])
	self.scale = self.scale * self.size_multiplier
	
	self.stamina = fish_stats["max_stamina"]
	
	var species:Species
	var species_id:int = fish_stats["id"]
	
	if species_id == 0:
		species = ClusterEyeFish.new()
	elif species_id == 1:
		species = Eyefish.new()
	elif species_id == 2:
		species = FanTail.new()
	elif species_id == 3:
		species = Goldfish.new()
	elif species_id == 4:
		species = Longfish.new()
	elif species_id == 5:
		species = PufferFish.new()
	elif species_id == 6:
		species = PuffTailFish.new()
	elif species_id == 7:
		species = Ribbonfish.new()
	elif species_id == 8:
		species = SharkFish.new()
	elif species_id == 9:
		species = SpineFish.new()
	elif species_id == 10:
		species = StubbyFish.new()
	elif species_id == 11:
		species = TriangleFish.new()
	elif species_id == 12:
		species = WhiskerFish.new()
	elif species_id == 13:
		species = Worm.new()
	
	
	species.init(fish_stats)
	self.caught = false
	self.on_boat = false
	
	var specific_colour_choices:Array = fish_stats.get("specific_colour_choices", [])
	
	if specific_colour_choices.is_empty():
		var red: String = Global.fish_rbg_colour_choices[randi_range(0, len(Global.fish_rbg_colour_choices)-1)]
		var green: String = Global.fish_rbg_colour_choices[randi_range(0, len(Global.fish_rbg_colour_choices)-1)]
		var blue: String = Global.fish_rbg_colour_choices[randi_range(0, len(Global.fish_rbg_colour_choices)-1)]
		specific_colour_choices = ["%s%s%s"%[red, green, blue]]
	
	fish = Global.fish_object.instantiate()
	fish.position = Vector2(0,0)
	fish.species = species
	fish.base_colour = specific_colour_choices.pick_random()
	#print(fish.base_colour)
	self.billboard.add_child(fish)
	

func _process(delta: float) -> void:
	timer += delta
	if self.paused:
		return
	#self.look_at(player.global_position)
	self.direction_node.look_at(target_position)
	if caught:
		self.look_at(player.fishing_rod.hook_camera_node.global_position + Vector3(0,-5,-5))
	else:
		self.look_at(target_position)
	
	
	if on_boat or self.global_position.y > 0:
		if caught:
			self.global_position = self.hook.global_position
		return
	
	if caught:
		if self.stamina >= fish_stats["stamina_cost"] * delta and not self.recharging:
			self.fish.bones.get_child(0).agility = self.fish.bones.get_child(0).max_agility
			#print("pulling hook.", self.hook.global_position, " Stamina: ", self.stamina, " speed modifer: ",speed_modifier)
			#print(self.global_position, " -> ", self.target_position)
			self.hook.global_position = self.global_position
			self.target_position = self.hook.global_position + Vector3(sin(timer*2.0) * randf_range(1.0,4.0), randf_range(-1.0, -5.0), sin(timer*2.0) * randf_range(1.0,4.0))
			self.stamina -= fish_stats["stamina_cost"] * delta
		if self.stamina <= fish_stats["stamina_cost"] * delta:
			#print("Out of stamina. Stamina: ", self.stamina)
			self.recharging = true
			
		if self.recharging:
			self.fish.bones.get_child(0).agility = self.fish.bones.get_child(0).slow_agility
			self.global_position = self.hook.global_position
			self.stamina += fish_stats["stamina_regen"] * delta
			#print("Recharging. Stamina: ", self.stamina)
			if self.stamina >= self.fish_stats["max_stamina"]:
				#print("Done recharging. Stamina: ", self.stamina)
				self.recharging = false
	
	self.stamina = clampf(self.stamina, 0, self.fish_stats["max_stamina"])
	if target_position and not self.recharging:
		direction_node.look_at(target_position)
		var direction:Vector3 = -direction_node.global_transform.basis.z.normalized()
		self.global_position += direction * fish.species.speed * speed_modifier * delta
		if not caught:
			var hooked_fish:int = Global.game_state["you"]["hooked_fish"]
			var max_hooked_fish:int = Global.game_state["you"]["max_hooked_fish"]
			if self.global_position.distance_to(self.hook.global_position) <= 0.1 and hooked_fish < max_hooked_fish:
				# got caught on the hook
				Global.emit_signal("caught_fish", self)
				Global.game_state["you"]["hooked_fish"] += 1
				
				caught = true
			elif self.global_position.distance_to(self.target_position) <= 1.0:
				# reached target, pick a new one
				self.target_position = self.global_position + (direction * 5.0)
			elif Vector2(self.hook.global_position.x, self.hook.global_position.z).distance_to(Vector2(self.global_position.x, self.global_position.z)) >= 10.0:
				# too far away, despawn
				self.get_parent().remove_child(self)
				self.queue_free()
			elif self.hook.global_position.distance_to(self.global_position) <= 1.0 and hooked_fish < max_hooked_fish:
				# traget hook when close to is
				self.target_position = self.hook.global_position
			self.target_position.y = clampf(self.target_position.y, -10000, -0.2)
