extends CanvasLayer

class_name Dialogue

@export var player:Player
@export var button_bait:Button
@export var button_hook:Button
@export var button_line:Button
@export var button_stamina:Button
@export var button_fish:Button
@export var button_strength:Button
@export var button_unique:Button
@export var button_food:Button
@export var button_hat:Button
@export var button_sell:Button

@export var text_dialogue:RichTextLabel
@export var text_name:RichTextLabel

@export var icon_cat:Sprite2D
@export var coin_cat:RichTextLabel

@export var icon_dog:Sprite2D
@export var coin_dog:RichTextLabel

var info:Dictionary

var character_name:String = "cat"

func update(character_key:String):
	self.character_name = character_key
	self.icon_cat.visible = (self.character_name == "cat")
	self.icon_dog.visible = (self.character_name == "dog")
	
	self.info = Global.game_state[self.character_name]
	self.coin_cat.text = "%s"%Global.game_state["cat"]["coins"]
	self.coin_dog.text = "%s"%Global.game_state["dog"]["coins"]
	
	self.text_name.text = "[center]%s[/center]"%[self.info["name"]]
	var convo_state:String = self.info["settings"]["conversation_state"]
	self.text_dialogue.text = "%s"%[self.info["settings"]["conversations"].get(convo_state, self.info["settings"]["conversations"]["#unknown"])]
	if self.info["upgrades"]["bait"]:
		button_bait.disabled = true
	if self.info["upgrades"]["hook"]:
		button_hook.disabled = true
	if self.info["upgrades"]["line"]:
		button_line.disabled = true
	if self.info["upgrades"]["stamina"]:
		button_stamina.disabled = true
	if self.info["upgrades"]["fish"]:
		button_fish.disabled = true
	if self.info["upgrades"]["strength"]:
		button_strength.disabled = true
	if self.info["upgrades"]["unique"]:
		button_unique.disabled = true
	if self.info["upgrades"]["hat"]:
		button_hat.disabled = true
	
	if self.character_name == "cat":
		button_hat.text = "Cat Hat (10)"
	else:
		button_hat.text = "Dog Hat (10)"
	
	button_sell.text = "Sell (%s)"%[calculate_sell_value()]

func calculate_sell_value() -> float:
	var value:float = 0.0
	if Global.game_state["you"]["current_fish"] > 0:
		for fish in player.left_fish_pile.get_children():
			if self.character_name == "cat":
				value += fish.fish.species.fish_stats["cat_coins"]
			else:
				value += fish.fish.species.fish_stats["dog_coins"]
		for fish in player.right_fish_pile.get_children():
			if self.character_name == "cat":
				value += fish.fish.species.fish_stats["cat_coins"]
			else:
				value += fish.fish.species.fish_stats["dog_coins"]
	return value

func _on_sell_button_down() -> void:
	if Global.game_state["you"]["current_fish"] > 0:
		if self.character_name == "cat":
			Global.game_state["you"]["dog_score"] = 0.75
			Global.game_state["you"]["cat_score"] += 10
		else:
			Global.game_state["you"]["cat_score"] = 0.75
			Global.game_state["you"]["dog_score"] += 10
		
		
		for fish in player.left_fish_pile.get_children():
			if self.character_name == "cat" and fish.fish_stats["id"] == 14:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().change_scene_to_file("res://assets/scenes/ending_3.tscn")
				return
			if self.character_name == "dog" and fish.fish_stats["id"] == 14:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().change_scene_to_file("res://assets/scenes/ending_4.tscn")
				return
			if self.character_name == "cat":
				Global.game_state[character_name]["coins"] += fish.fish.species.fish_stats["cat_coins"]
			else:
				Global.game_state[character_name]["coins"] += fish.fish.species.fish_stats["dog_coins"]
			player.left_fish_pile.remove_child(fish)
			fish.queue_free()
		for fish in player.right_fish_pile.get_children():
			if self.character_name == "cat" and fish.fish_stats["id"] == 14:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().change_scene_to_file("res://assets/scenes/ending_3.tscn")
				return
			if self.character_name == "dog" and fish.fish_stats["id"] == 14:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().change_scene_to_file("res://assets/scenes/ending_4.tscn")
				return
			if self.character_name == "cat":
				Global.game_state[character_name]["coins"] += fish.fish.species.fish_stats["cat_coins"]
			else:
				Global.game_state[character_name]["coins"] += fish.fish.species.fish_stats["dog_coins"]
			player.right_fish_pile.remove_child(fish)
			fish.queue_free()
		
		Global.game_state["you"]["current_fish"] = 0
	self.update(self.character_name)

func _on_character_dialogue_meta_clicked(meta: Variant) -> void:
	print(str(meta))
	self.info["settings"]["conversation_state"] = str(meta)


func _on_bait_button_down() -> void:
	var cost:float = 10.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["bait"]:
		self.info["upgrades"]["bait"] = true
		self.info["coins"] -= cost
		self.update(self.character_name)


func _on_hook_button_down() -> void:
	var cost:float = 10.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["hook"]:
		self.info["upgrades"]["hook"] = true
		self.info["coins"] -= cost
		self.update(self.character_name)

func _on_line_button_down() -> void:
	var cost:float = 10.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["line"]:
		self.info["upgrades"]["line"] = true
		self.info["coins"] -= cost
		self.update(self.character_name)


func _on_stamina_button_down() -> void:
	var cost:float = 20.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["stamina"]:
		self.info["upgrades"]["stamina"] = true
		Global.game_state["you"]["max_stamina"] *= 2.0
		Global.game_state["you"]["stamina_cost"] *= 0.5
		Global.game_state["you"]["stamina_regen_rate"] *= 1.5
		self.info["coins"] -= cost
		self.update(self.character_name)

func _on_fish_button_down() -> void:
	var cost:float = 10.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["fish"]:
		self.info["upgrades"]["fish"] = true
		Global.game_state["you"]["max_fish"] *= 2.0
		self.info["coins"] -= cost
		self.update(self.character_name)

func _on_strength_button_down() -> void:
	var cost:float = 10.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["strength"]:
		self.info["upgrades"]["strength"] = true
		Global.game_state["you"]["fishing_raise_speed"] *= 2.0
		self.info["coins"] -= cost
		self.update(self.character_name)


func _on_unique_button_down() -> void:
	var cost:float = 50.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["unique"]:
		self.info["upgrades"]["unique"] = true
		self.info["coins"] -= cost
		self.update(self.character_name)
	


func _on_food_button_down() -> void:
	var cost:float = 2.0
	if self.info["coins"] >= cost:
		Global.game_state["you"]["hunger"] += 5.0
		Global.game_state["you"]["hunger"] = clampf(Global.game_state["you"]["hunger"], 0.0, Global.game_state["you"]["max_hunger"])
		self.info["coins"] -= cost
		self.update(self.character_name)


func _on_hat_button_down() -> void:
	var cost:float = 10.0
	if self.info["coins"] >= cost and not self.info["upgrades"]["hat"]:
		self.info["upgrades"]["hat"] = true
		self.info["coins"] -= cost
		self.update(self.character_name)
	
