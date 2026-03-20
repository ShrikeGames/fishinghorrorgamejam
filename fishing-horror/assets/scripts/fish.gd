extends Node3D

class_name Fish

@export var player:Player
@export var viewport:SubViewport
@export var billboard:CanvasLayer
@export var plane:MeshInstance3D
@export var direction_node:Node3D

var size_multiplier:float = 1.0
var speed:float = randf_range(0.25,0.5)
var quality:float = 1.0
var corruption:float = 1.0
var food:float = 1.0
var strength:float = 1.0
var target_position:Vector3
var original_position:Vector3
var hook:Node3D
var caught:bool = false
var on_boat:bool = false
var stamina:float = 2.0
var max_stamina:float = 2.0
var stamina_cost:float = 1.2
var stamina_regen:float = 0.4
var recharging:bool = false
var speed_modifier:float = 1.0
var fish:FishSegment
var colour_choices = ["00", "11", "22", "33", "44", "55", "66", "77", "88", "99", "AA", "BB", "CC", "DD", "EE", "FF"]
var timer:float = 0
var paused:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.timer = 0
	self.paused = false
	self.global_position = original_position
	self.size_multiplier = randf_range(0.5, 1.0) + -fmod(self.global_position.y, 25)
	self.size_multiplier = clampf(self.size_multiplier, 0.5, 2.0)
	
	self.scale = self.scale * self.size_multiplier
	self.caught = false
	self.on_boat = false
	fish = Global.fish_object.instantiate()
	fish.position = Vector2(0,0)
	var red: String = colour_choices[randi_range(0, len(colour_choices)-1)]
	var green: String = colour_choices[randi_range(0, len(colour_choices)-1)]
	var blue: String = colour_choices[randi_range(0, len(colour_choices)-1)]
	var species:Species
	var species_id:int = randi_range(1,14)
	
	if species_id == 1:
		species = Worm.new()
	elif species_id == 2:
		species = Goldfish.new()
	elif species_id == 3:
		species = Longfish.new()
	elif species_id == 4:
		species = Eyefish.new()
	elif species_id == 5:
		species = FanTail.new()
	elif species_id == 6:
		species = PufferFish.new()
	elif species_id == 7:
		species = PuffTailFish.new()
	elif species_id == 8:
		species = SpineFish.new()
	elif species_id == 9:
		species = StubbyFish.new()
	elif species_id == 10:
		species = TriangleFish.new()
	elif species_id == 11:
		species = ClusterEyeFish.new()
	elif species_id == 12:
		species = SharkFish.new()
	elif species_id == 13:
		species = WhiskerFish.new()
	elif species_id == 14:
		species = Ribbonfish.new()
	
	fish.species = species
	fish.base_colour = "%s%s%s"%[red, green, blue]
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
		if self.stamina > 0 and not self.recharging:
			self.fish.bones.get_child(0).agility = self.fish.bones.get_child(0).max_agility
			#print("pulling hook.", self.hook.global_position, " Stamina: ", self.stamina, " speed modifer: ",speed_modifier)
			#print(self.global_position, " -> ", self.target_position)
			self.hook.global_position = self.global_position
			self.target_position = self.hook.global_position + Vector3(sin(timer*2.0), -5.0, sin(timer*2.0)*1.0)
			self.stamina -= self.stamina_cost * delta
		if self.stamina <= 0:
			#print("Out of stamina. Stamina: ", self.stamina)
			self.recharging = true
			
		if self.recharging:
			self.fish.bones.get_child(0).agility = self.fish.bones.get_child(0).slow_agility
			self.global_position = self.hook.global_position
			self.stamina += stamina_regen * delta
			#print("Recharging. Stamina: ", self.stamina)
			if self.stamina >= self.max_stamina:
				#print("Done recharging. Stamina: ", self.stamina)
				self.recharging = false
	
	self.stamina = clampf(self.stamina, 0, self.max_stamina)
	if target_position and not self.recharging:
		direction_node.look_at(target_position)
		var direction:Vector3 = -direction_node.global_transform.basis.z.normalized()
		self.global_position += direction * speed * speed_modifier * delta
		if not caught:
			var hooked_fish:int = Global.game_state["you"]["hooked_fish"]
			var max_hooked_fish:int = Global.game_state["you"]["max_hooked_fish"]
			if self.global_position.distance_to(self.hook.global_position) <= 0.1 and hooked_fish < max_hooked_fish:
				# got caught on the hook
				Global.emit_signal("caught_fish", self)
				Global.game_state["you"]["hooked_fish"] += 1
				
				caught = true
			elif self.global_position.distance_to(self.target_position) <= 0.5:
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
