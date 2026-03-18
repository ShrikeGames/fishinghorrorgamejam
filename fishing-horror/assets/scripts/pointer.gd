extends CanvasLayer
class_name Pointer

@export var menu:CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.visible = not menu.visible
