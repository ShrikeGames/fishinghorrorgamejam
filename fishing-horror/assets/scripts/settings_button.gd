extends TextureButton

@export var settings_container:Node2D


func _on_button_down() -> void:
	settings_container.visible = not settings_container.visible
