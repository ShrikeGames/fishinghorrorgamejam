extends TextureButton

@export var scene_to_change_to:String = "res://assets/scenes/game.tscn"
@export var text_label: RichTextLabel
@export var text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if text_label != null:
		text_label.bbcode_enabled = true
		text_label.text = "[center]%s[/center]" % [text]

func _on_button_down() -> void:
	if scene_to_change_to != null:
		get_tree().paused = false
		get_tree().change_scene_to_file(scene_to_change_to)
