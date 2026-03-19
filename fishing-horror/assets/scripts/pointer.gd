extends CanvasLayer
class_name Pointer

@export var menu:CanvasLayer
@export var pointer:Sprite2D
@export var fishing:Node2D
@export var tablet:Node2D
@export var travel:Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.visible = not menu.visible

func show_fishing():
	fishing.visible = true
	tablet.visible = false
	travel.visible = false

func show_tablet():
	fishing.visible = false
	tablet.visible = true
	travel.visible = false
	
func show_travel():
	fishing.visible = false
	tablet.visible = false
	travel.visible = true
