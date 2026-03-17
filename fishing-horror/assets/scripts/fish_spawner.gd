extends Node3D

class_name FishSpawner

@export var fish_container:Node3D
@export var fishing_rod:FishingRod
# Timer for how often to spawn a fish
# A radius in which they cannot spawn
# Each fish needs to be placed outside of that radius and told to go to a random other position
# Determine the type of fish based on depth
# Determine the size, corruption level, quality, how much food it provides

@export var timer:float = 0.0
@export var max_timer:float = 1.5
@export var min_spawn_radius:float = 3.0
@export var max_target_radius:float = 2.0
var fish_resource:Resource = load("res://assets/scenes/fish/fish.tscn")

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0 and fishing_rod.hook.global_position.y <= -0.5 * min_spawn_radius:
		spawn_fish()
		timer = max_timer
	pass

func spawn_fish():
	var fish:Fish = fish_resource.instantiate()
	fish.hook = fishing_rod.hook
	var random_flip:Array[int] = [-1,1]
	fish.size_multiplier = randf_range(0.15, 1.0)
	fish.speed = 2 - fish.size_multiplier
	
	fish.original_position = fishing_rod.hook.global_position + (Vector3((1.0+randf())*random_flip.pick_random(), (0.15*randf())*random_flip.pick_random(), (1.0+randf())*random_flip.pick_random()).normalized()*min_spawn_radius)
	fish.target_position = fishing_rod.hook.global_position + (Vector3(randf()*random_flip.pick_random(), randf()*random_flip.pick_random(), randf()*random_flip.pick_random()).normalized()*max_target_radius)
	fish_container.add_child(fish)
	
	print(fish.global_position, " -> ", fish.target_position)
