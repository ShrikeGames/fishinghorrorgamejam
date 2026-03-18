extends MeshInstance3D

class_name ShopScreen

var config:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(settings_name:String):
	config = Global.game_state[settings_name]["settings"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
