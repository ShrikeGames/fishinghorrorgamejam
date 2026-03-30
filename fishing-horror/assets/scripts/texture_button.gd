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
		Global.game_state["you"]["hunger"] = Global.game_state["you"]["max_hunger"]
		Global.game_state["you"]["corruption"] = 0
		Global.game_state["you"]["cat_score"] = 1
		Global.game_state["you"]["dog_score"] = 1
		Global.game_state["cat"]["corruption"] = clampf(Global.game_state["cat"]["corruption"], 0.0, 9.0)
		Global.game_state["dog"]["corruption"] = clampf(Global.game_state["dog"]["corruption"], 0.0, 9.0)
		
		Global.save_settings()
		get_tree().change_scene_to_file(scene_to_change_to)
