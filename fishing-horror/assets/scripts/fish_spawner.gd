extends Node3D

class_name FishSpawner

@export var player:Player
@export var fish_container:Node3D
@export var fishing_rod:FishingRod
@export var timer:float = 0.0
@export var max_timer:float = 1
@export var num_fish_to_spawn:int = 3

var fish_resource:Resource = load("res://assets/scenes/fish/fish.tscn")


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		spawn_fish()
		timer = max_timer
	pass

func spawn_fish():
	for i in range(0, num_fish_to_spawn):
		var fish:Fish = fish_resource.instantiate()
		var fish_name:String = pick_random_fish_type()
		if fish_name != "":
			fish.init(fish_name, fishing_rod)
			fish.player = player
			fish.hook = fishing_rod.hook
			
			#print("Spawn ", fish_name, " at ", fish.original_position)
			fish_container.add_child(fish)
	
	#print(fish.global_position, " -> ", fish.target_position)

func pick_random_fish_type():
	var valid_fish_types:Array[String] = []
	for fish_type in Global.bestiary.keys():
		var valid_y:bool = fishing_rod.hook.global_position.y <= Global.bestiary[fish_type]["min_spawn_y"] and fishing_rod.hook.global_position.y >= Global.bestiary[fish_type]["max_spawn_y"]
		var valid_x:bool = fishing_rod.hook.global_position.x <= Global.bestiary[fish_type]["max_spawn_x"] and fishing_rod.hook.global_position.x >= Global.bestiary[fish_type]["min_spawn_x"]
		
		if valid_y and valid_x:
			valid_fish_types.append(fish_type)
	if valid_fish_types.is_empty():
		return ""
	return valid_fish_types.pick_random()
