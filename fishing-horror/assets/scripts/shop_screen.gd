extends MeshInstance3D

class_name ShopScreen

var config:Dictionary = {}
@onready var promp_text:RichTextLabel = self.find_child("ShopScreenContents", true).find_child("PromptText", true)

@onready var option1_text:RichTextLabel = self.find_child("ShopScreenContents", true).find_child("Text1", true)
@onready var option2_text:RichTextLabel = self.find_child("ShopScreenContents", true).find_child("Text2", true)
@onready var option3_text:RichTextLabel = self.find_child("ShopScreenContents", true).find_child("Text3", true)

var conversation_name:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.update_conversation.connect(update)

func update():
	init(self.conversation_name)

func init(settings_name:String):
	self.conversation_name = settings_name
	config = Global.game_state[self.conversation_name]["settings"]
	var conversation_state:Array = config["conversation_state"]
	print("conversation_state: ", conversation_state)
	var next_conversations:Array = config["conversations"]
	var current_conversation:Dictionary = config
	for conversation_index in conversation_state:
		if len(next_conversations) > 0:
			current_conversation = next_conversations[conversation_index]
			next_conversations  = next_conversations[conversation_index]["conversations"]
	print("current_conversation: ", current_conversation)
	
	promp_text.text = "[center]%s[/center]"%current_conversation["prompt"]
	
	var responses:Array = current_conversation["responses"]
	print("responses: ", responses)
	if len(responses) > 0:
		option1_text.text = " %s"%responses[0]
	else:
		option1_text.text = " "
	if len(responses) > 1:
		option2_text.text = " %s"%responses[1]
	else:
		option2_text.text = " "
	if len(responses) > 2:
		option3_text.text = " %s"%responses[2]
	else:
		option3_text.text = " "
	
