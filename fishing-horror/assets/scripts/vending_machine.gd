extends MeshInstance3D

class_name VendingMachine
@export var settings_name:String = "cat"
@export var npc_screen:NPCScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_screen.init(settings_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
