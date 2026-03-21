extends TextureButton

@export var scene_to_change_to:String = "res://assets/scenes/game.tscn"
@export var text_label: RichTextLabel
@export var text: String
@export var start_button:bool = false
@export var menu:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if text_label != null:
		text_label.bbcode_enabled = true
		text_label.text = "[center]%s[/center]" % [text]

func _on_button_down() -> void:
	if start_button and menu:
		menu.visible = false
		var player:Player = menu.get_parent().find_child("player")
		print(player)
		player.in_menu = false
		player.update_camera_state()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	
	if scene_to_change_to != null:
		get_tree().paused = false
		get_tree().change_scene_to_file(scene_to_change_to)
