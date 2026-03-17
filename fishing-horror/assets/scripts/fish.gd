extends Node3D

class_name Fish


var size_multiplier:float = 1.0
var speed:float = 1.0
var quality:float = 1.0
var corruption:float = 1.0
var food:float = 1.0
var strength:float = 1.0
var target_position:Vector3
var original_position:Vector3
var hook:Node3D
var caught:bool = false
var on_boat:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.global_position = original_position
	self.look_at(target_position)
	self.scale = self.scale * self.size_multiplier
	self.caught = false
	self.on_boat = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_boat:
		return
	
	if caught:
		if self.hook.global_position != self.global_position:
			self.rotation_degrees = Vector3(90,0,0)
			self.global_position = self.hook.global_position
		return
	
	if target_position:
		self.look_at(target_position)
		var direction = -global_transform.basis.z.normalized()
		self.global_position += direction * speed * delta
		var hooked_fish:int = Global.game_state["you"]["hooked_fish"]
		var max_hooked_fish:int = Global.game_state["you"]["max_hooked_fish"]
		
		if self.global_position.distance_to(self.hook.global_position) <= 0.01 and hooked_fish < max_hooked_fish:
			self.speed = 0
			Global.emit_signal("caught_fish", self)
			Global.game_state["you"]["hooked_fish"] += 1
			caught = true
		elif self.global_position.distance_to(self.target_position) <= 0.01:
			self.target_position = self.global_position + (direction.rotated(Vector3.UP, randf_range(-PI/6, PI/6)) * 2.0)
		elif self.hook.global_position.distance_to(self.global_position) >= 10.0:
			self.get_parent().remove_child(self)
		elif self.hook.global_position.distance_to(self.global_position) <= 1.0 and hooked_fish < max_hooked_fish:
			self.target_position = self.hook.global_position
		self.target_position.y = clampf(self.target_position.y, -10000, -1.0)
