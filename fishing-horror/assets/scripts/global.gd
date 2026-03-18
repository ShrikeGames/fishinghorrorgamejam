extends Node

class_name GlobalState
signal caught_fish(fish:Fish)
var settings_config_location:String = "user://user_settings.json"

var game_state:Dictionary = {
	"settings": {
		"volume":{
			"master": 80.0,
			"music": 0.0,
			"sfx": 40.0,
			"voices": 80.0
		}
	},
	"you": {
		"run": 0,
		"corruption": 0,
		"max_corruption": 10,
		"hunger": 10,
		"max_hunger": 10,
		"current_fish": 0,
		"stamina": 10,
		"max_stamina": 10,
		"travel_hunger_rate": 0.01,
		"stamina_regen_rate": 0.1,
		"max_fish": 4,
		"current_time": 0,
		"mouse_sensitivity": 0.1,
		"fov": 75.0,
		"boat_speed": 1.0,
		"fishing_lower_speed": 0.5,
		"fishing_raise_speed": 0.3,
		"hooked_fish": 0,
		"max_hooked_fish": 1,
		"target_position": [0,0,0],
		"current_position": [0,0,0],
		"current_location": "center"
	},
	"cat": {
		"settings": {
			"name": "Cat Demon",
			"default_image": "res://assets/art/placeholder.png",
			"conversation_state": [0],
			"conversations":[
				{
					"prompt": "insert character introduction line here",
					"image": "res://assets/art/placeholder.png",
					"responses": [
						"Response 0",
						"Response 1",
						"Response 2"
					],
					"conversations":[
						{
							"prompt": "followup to response 0",
							"image": "res://assets/art/placeholder.png",
							"responses": [
								"Response 0-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 0-0",
									"image": "res://assets/art/placeholder.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 1",
							"image": "res://assets/art/placeholder.png",
							"responses": [
								"Response 1-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 1-0",
									"image": "res://assets/art/placeholder.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 2",
							"responses": [
								"Response 2-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 2-0",
									"image": "res://assets/art/placeholder.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						}
					]
				}
			]
		},
		"corruption": 0,
		"coins": 0,
		"upgrades": {
			"camera_app": false,
			"shop_app": false,
			"bait": false,
			"hook": false,
			"line": false,
			"stamina": false,
			"boat_max_fish": false,
			"unique_1": false # Fish Corruption Detector
		},
		"cosmetics": {
			"clothes_1": false,
			"clothes_2": false,
			"clothes_3": false
		}
		
	},
	"dog": {
		"settings": {
			"name": "Dog Demon",
			"default_image": "res://assets/art/placeholder.png",
			"conversation_state": [0],
			"conversations":[
				{
					"prompt": "insert character introduction line here",
					"image": "res://assets/art/placeholder.png",
					"responses": [
						"Response 0",
						"Response 1",
						"Response 2"
					],
					"conversations":[
						{
							"prompt": "followup to response 0",
							"image": "res://assets/art/placeholder.png",
							"responses": [
								"Response 0-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 0-0",
									"image": "res://assets/art/placeholder.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 1",
							"image": "res://assets/art/placeholder.png",
							"responses": [
								"Response 1-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 1-0",
									"image": "res://assets/art/placeholder.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 2",
							"responses": [
								"Response 2-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 2-0",
									"image": "res://assets/art/placeholder.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						}
					]
				}
			]
		},
		"corruption": 0,
		"coins": 0,
		"upgrades": {
			"camera_app": false,
			"shop_app": false,
			"bait": false,
			"hook": false,
			"line": false,
			"stamina": false,
			"boat_max_fish": false,
			"unique_2": false # Fish Quality Detector
		},
		"cosmetics": {
			"clothes_1": false,
			"clothes_2": false,
			"clothes_3": false
		}
	}
}

func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var json_string = FileAccess.get_file_as_string(path)
	var json_dict = JSON.parse_string(json_string)
	
	return json_dict

func load_settings():
	# check if user has settings at settings_config_location
	if not FileAccess.file_exists(settings_config_location):
		save_settings()
	game_state = read_json(settings_config_location)

func save_settings():
	# save the results
	var json_string := JSON.stringify(game_state)
	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(settings_config_location, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
		
	file_access.store_line(json_string)
	file_access.close()
