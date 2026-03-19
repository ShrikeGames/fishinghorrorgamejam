extends Node3D

class_name Fish

@export var player:Player
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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.global_position = original_position
	#self.look_at(target_position)
	self.size_multiplier = 1.0 + (-fmod(self.global_position.y, 10))
	self.scale = self.scale * self.size_multiplier
	self.caught = false
	self.on_boat = false
	fish = Global.fish_object.instantiate()
	fish.position = Vector2(0,0)
	self.billboard.add_child(fish)

func _process(delta: float) -> void:
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
			#print("pulling hook.", self.hook.global_position, " Stamina: ", self.stamina, " speed modifer: ",speed_modifier)
			#print(self.global_position, " -> ", self.target_position)
			self.hook.global_position = self.global_position
			self.stamina -= self.stamina_cost * delta
		if self.stamina <= 0:
			#print("Out of stamina. Stamina: ", self.stamina)
			self.recharging = true
			
		if self.recharging:
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
			if self.global_position.distance_to(self.hook.global_position) <= 0.05 and hooked_fish < max_hooked_fish:
				# got caught on the hook
				Global.emit_signal("caught_fish", self)
				Global.game_state["you"]["hooked_fish"] += 1
				self.target_position = self.hook.global_position + Vector3(randf_range(-5.0,5.0), -5.0, randf_range(-5.0,5.0))
				caught = true
			elif self.global_position.distance_to(self.target_position) <= 0.1:
				# reached target, pick a new one
				self.target_position = self.global_position + (direction * 5.0)
			elif self.hook.global_position.distance_to(self.global_position) >= 10.0:
				# too far away, despawn
				self.get_parent().remove_child(self)
			elif self.hook.global_position.distance_to(self.global_position) <= 1.0 and hooked_fish < max_hooked_fish:
				# traget hook when close to is
				self.target_position = self.hook.global_position
			self.target_position.y = clampf(self.target_position.y, -10000, -0.5)
