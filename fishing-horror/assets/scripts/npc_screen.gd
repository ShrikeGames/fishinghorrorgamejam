extends MeshInstance3D

class_name NPCScreen

var config:Dictionary = {}
@onready var viewport:SubViewport = self.find_child("SubViewport", false)
@onready var image:Sprite2D = self.find_child("Image", true)

func init(settings_name:String):
	config = Global.game_state[settings_name]["settings"]
	# display default character image
	var default_image:Resource = load(config["default_image"])
	image.texture = default_image


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
