extends CanvasLayer

class_name TabletCanvas

@export var cat_coins_count:RichTextLabel
@export var dog_dollars_count:RichTextLabel
@export var depth_amount:RichTextLabel

@export var stamina:Sprite2D
@export var hunger:Sprite2D
@export var corruption:Sprite2D
@export var fish:Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_coin_counts(Global.game_state["cat"]["coins"], Global.game_state["cat"]["coins"])

func update_coin_counts(cat_coints:int, dog_count:int):
	if cat_coins_count:
		cat_coins_count.text = " %d"%cat_coints
	if dog_dollars_count:
		dog_dollars_count.text = " %d"%dog_count

func update_depth(depth:float):
	if depth_amount:
		depth_amount.text = " %sm"%snappedf(depth, 0.01)

func _process(delta: float) -> void:
	update_ui_bars(delta)
	update_coin_counts(Global.game_state["cat"]["coins"], Global.game_state["dog"]["coins"])
	
func update_ui_bars(_delta):
	if stamina:
		stamina.scale.x = get_percentage(Global.game_state["you"]["stamina"], Global.game_state["you"]["max_stamina"])
	if hunger:
		hunger.scale.x = get_percentage(Global.game_state["you"]["hunger"], Global.game_state["you"]["max_hunger"])
	if corruption:
		corruption.scale.x = get_percentage(Global.game_state["you"]["corruption"], Global.game_state["you"]["max_corruption"])
	if fish:
		fish.scale.x = get_percentage(Global.game_state["you"]["current_fish"], Global.game_state["you"]["max_fish"])

func get_percentage(current_value: float, max_value: float) -> float:
	return current_value / max_value
