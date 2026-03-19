extends Node3D

class_name FishSpawner

@export var player:Player
@export var fish_container:Node3D
@export var fishing_rod:FishingRod
@export var timer:float = 0.0
@export var max_timer:float = 0.5
@export var min_spawn_radius:float = 5.0
@export var max_target_radius:float = 2.0
var fish_resource:Resource = load("res://assets/scenes/fish/fish.tscn")


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		spawn_fish()
		timer = max_timer
	pass

func spawn_fish():
	var fish:Fish = fish_resource.instantiate()
	fish.player = player
	fish.hook = fishing_rod.hook
	var random_flip:Array[int] = [-1,1]
	fish.speed = randf_range(0.3, 1.0) * (1.0-fish.size_multiplier)
	fish.speed = 2 - fish.size_multiplier
	
	fish.original_position = fishing_rod.hook.global_position
	fish.original_position.x += (1.0+randf())*random_flip.pick_random()*min_spawn_radius
	fish.original_position.z += (1.0+randf())*random_flip.pick_random()*min_spawn_radius
	fish.original_position.y = randf_range(fishing_rod.hook.global_position.y-2.0, 0)
	
	fish.target_position = fishing_rod.hook.global_position + (Vector3(randf()*random_flip.pick_random(), randf()*random_flip.pick_random(), randf()*random_flip.pick_random()).normalized()*max_target_radius)
	if fishing_rod.hook.global_position.y > 0:
		fish.original_position -= Vector3(0, fishing_rod.hook.global_position.y+0.5, 0)
		fish.target_position -= Vector3(0, fishing_rod.hook.global_position.y+0.5, 0)
	fish.original_position.y = clampf(fish.original_position.y, -10000, 0)
	fish.target_position.y = clampf(fish.target_position.y, -10000, 0)
	#print("spawn fish at: ", fish.original_position)
	fish_container.add_child(fish)
	
	#print(fish.global_position, " -> ", fish.target_position)
