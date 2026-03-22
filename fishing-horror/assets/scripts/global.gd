extends Node

class_name GlobalState
signal caught_fish(fish:Fish)
signal update_conversation()
var settings_config_location:String = "user://user_settings_v0_2026_03_22.json"
var fish_object:Resource = load("res://assets/scenes/fish/FishSegment.tscn")
var fish_rbg_colour_choices:Array[String] = ["00", "11", "22", "33", "44", "55", "66", "77", "88", "99", "AA", "BB", "CC", "DD", "EE", "FF"]

var bestiary: Dictionary = {
	"clustereyefish": {
		"id": 0,
		"name": "Cluster Fish",
		"description": "It has multiple sets of eyes rumoured to be able to see into the past and future.",
		"min_corruption": 1.0,
		"max_corruption": 2.0,
		"min_stamina": 1.0,
		"max_stamina": 2.0,
		"stamina": 0.0,
		"stamina_regen": 1.0,
		"stamina_cost": 1.0,
		"min_speed": 0.8,
		"max_speed": 1.4,
		"agility": 6.0,
		"food": 5.0,
		"cat_coins": 3.0,
		"dog_coins": 3.0,
		"min_turn_angle": 0.15,
		"turn_speed": 5.0,
		"min_num_bones": 6,
		"max_num_bones": 10,
		"min_bone_distance": 10,
		"max_bone_distance": 14,
		"min_bone_radius": 12,
		"max_bone_radius": 20,
		"min_size_modifier": 0.75,
		"max_size_modifier": 1.25,
		"min_spawn_y": -20.0,
		"max_spawn_y": -40.0,
		"min_spawn_x": -60.0,
		"max_spawn_x": 60.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": []
	},
	"eyefish": {
		"id": 1,
		"name": "Eye Fish",
		"description": "It is rumoured their numerous eyes are from children they have consumed.",
		"min_corruption": 0.0,
		"max_corruption": 3.0,
		"min_stamina": 3.0,
		"max_stamina": 4.0,
		"stamina": 0.0,
		"stamina_regen": 1.0,
		"stamina_cost": 1.0,
		"min_speed": 1.0,
		"max_speed": 1.2,
		"agility": 4.0,
		"food": 5.0,
		"cat_coins": 1.0,
		"dog_coins": 5.0,
		"min_turn_angle": 0.5,
		"turn_speed": 1.0,
		"min_num_bones": 8,
		"max_num_bones": 12,
		"min_bone_distance": 15,
		"max_bone_distance": 15,
		"min_bone_radius": 20,
		"max_bone_radius": 30,
		"min_size_modifier": 0.75,
		"max_size_modifier": 1.25,
		"min_spawn_y": -10.0,
		"max_spawn_y": -30.0,
		"min_spawn_x": -50.0,
		"max_spawn_x": 50.0,
		"min_spawn_radius": 2.5,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["c28e93", "c2636d", "c2404e", "c22032"]
	},
	"fantail": {
		"id": 2,
		"name": "Fan Tail Fish",
		"description": "Their large fins are capable of crushing a human skull.",
		"min_corruption": 0.0,
		"max_corruption": 1.0,
		"min_stamina": 1.5,
		"max_stamina": 2.5,
		"stamina": 0.0,
		"stamina_regen": 0.5,
		"stamina_cost": 1.0,
		"min_speed": 0.9,
		"max_speed": 1.3,
		"agility": 8.0,
		"food": 1.0,
		"cat_coins": 2.0,
		"dog_coins": 1.0,
		"min_turn_angle": 0.5,
		"turn_speed": 2.0,
		"min_num_bones": 4,
		"max_num_bones": 6,
		"min_bone_distance": 20,
		"max_bone_distance": 20,
		"min_bone_radius": 10,
		"max_bone_radius": 20,
		"min_size_modifier": 0.50,
		"max_size_modifier": 1.25,
		"min_spawn_y": 10.0,
		"max_spawn_y": -20.0,
		"min_spawn_x": -80.0,
		"max_spawn_x": 80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": []
	},
	"goldfish": {
		"id": 3,
		"name": "Fools-Gold Fish",
		"description": "Only a complete baffoon would think these are real gold fish.",
		"min_corruption": 0.0,
		"max_corruption": 1.0,
		"min_stamina": 1.0,
		"max_stamina": 1.5,
		"stamina": 0.0,
		"stamina_regen": 0.25,
		"stamina_cost": 1.0,
		"min_speed": 0.9,
		"max_speed": 1.3,
		"agility": 8.0,
		"food": 0.5,
		"cat_coins": 1.0,
		"dog_coins": 1.0,
		"min_turn_angle": 0.5,
		"turn_speed": 2.0,
		"min_num_bones": 4,
		"max_num_bones": 6,
		"min_bone_distance": 15,
		"max_bone_distance": 15,
		"min_bone_radius": 10,
		"max_bone_radius": 15,
		"min_size_modifier": 1.0,
		"max_size_modifier": 1.50,
		"min_spawn_y": 10.0,
		"max_spawn_y": -10.0,
		"min_spawn_x": -20.0,
		"max_spawn_x": 20.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["c2c020", "c7c64b", "c6c55e", "c8c775"]
	},
	"longfish": {
		"id": 4,
		"name": "Long Fish",
		"description": "Known for their long bodies but offer little in the ways of edible food.",
		"min_corruption": 0.5,
		"max_corruption": 2.0,
		"min_stamina": 2.5,
		"max_stamina": 3.5,
		"stamina": 0.0,
		"stamina_regen": 0.6,
		"stamina_cost": 1.2,
		"min_speed": 1.1,
		"max_speed": 1.5,
		"agility": 8.0,
		"food": 1.0,
		"cat_coins": 3.0,
		"dog_coins": 6.0,
		"min_turn_angle": 0.5,
		"turn_speed": 2.0,
		"min_num_bones": 16,
		"max_num_bones": 20,
		"min_bone_distance": 20,
		"max_bone_distance": 20,
		"min_bone_radius": 10,
		"max_bone_radius": 15,
		"min_size_modifier": 0.50,
		"max_size_modifier": 1.50,
		"min_spawn_y": -5.0,
		"max_spawn_y": -30.0,
		"min_spawn_x": -10.0,
		"max_spawn_x": 80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["79c875", "4ccc46", "2bcb23", "74523c", "70472b", "714120"]
	},
	"pufferfish": {
		"id": 5,
		"name": "Puff Spike Fish",
		"description": "Their spikes are deadily but their inards delicious.",
		"min_corruption": 1.5,
		"max_corruption": 5.0,
		"min_stamina": 2.5,
		"max_stamina": 2.5,
		"stamina": 0.0,
		"stamina_regen": 0.3,
		"stamina_cost": 1.0,
		"min_speed": 1.0,
		"max_speed": 1.3,
		"agility": 5.0,
		"food": 3.0,
		"cat_coins": 5.0,
		"dog_coins": 1.0,
		"min_turn_angle": 0.15,
		"turn_speed": 1.0,
		"min_num_bones": 4,
		"max_num_bones": 6,
		"min_bone_distance": 20,
		"max_bone_distance": 30,
		"min_bone_radius": 18,
		"max_bone_radius": 26,
		"min_size_modifier": 1.00,
		"max_size_modifier": 1.50,
		"min_spawn_y": -15.0,
		"max_spawn_y": -45.0,
		"min_spawn_x": -80.0,
		"max_spawn_x": 10.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["71206a", "711569", "753b70"]
	},
	"pufftailfish": {
		"id": 6,
		"name": "Puff Tail Fish",
		"description": "Their tails are often used in weaponary.",
		"min_corruption": 1.5,
		"max_corruption": 5.0,
		"min_stamina": 2.5,
		"max_stamina": 2.5,
		"stamina": 0.0,
		"stamina_regen": 0.3,
		"stamina_cost": 1.0,
		"min_speed": 1.0,
		"max_speed": 1.3,
		"agility": 5.0,
		"food": 1.0,
		"cat_coins": 5.0,
		"dog_coins": 1.0,
		"min_turn_angle": 0.15,
		"turn_speed": 2.0,
		"min_num_bones": 5,
		"max_num_bones": 8,
		"min_bone_distance": 20,
		"max_bone_distance": 24,
		"min_bone_radius": 10,
		"max_bone_radius": 16,
		"min_size_modifier": 1.00,
		"max_size_modifier": 3.50,
		"min_spawn_y": -20.0,
		"max_spawn_y": -60.0,
		"min_spawn_x": -80.0,
		"max_spawn_x": 80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["79e6dd", "4ae1d5", "22dfcf"]
	},
	"ribbonfish": {
		"id": 7,
		"name": "Ribbon Fish",
		"description": "These paper thin fish are able to give paper cuts.",
		"min_corruption": 1.5,
		"max_corruption": 3.0,
		"min_stamina": 4.0,
		"max_stamina": 5.0,
		"stamina": 0.0,
		"stamina_regen": 0.15,
		"stamina_cost": 1.5,
		"min_speed": 1.5,
		"max_speed": 2.0,
		"agility": 8.0,
		"food": 10.0,
		"cat_coins": 10.0,
		"dog_coins": 30.0,
		"min_turn_angle": 0.02,
		"turn_speed": 10.0,
		"min_num_bones": 14,
		"max_num_bones": 20,
		"min_bone_distance": 6,
		"max_bone_distance": 10,
		"min_bone_radius": 6,
		"max_bone_radius": 8,
		"min_size_modifier": 1.00,
		"max_size_modifier": 1.50,
		"min_spawn_y": -20.0,
		"max_spawn_y": -30.0,
		"min_spawn_x": -40.0,
		"max_spawn_x": -60.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": []
	},
	"sharkfish": {
		"id": 8,
		"name": "Shark Fish",
		"description": "It can smell blood from 3km away, or 9km if underwater.",
		"min_corruption": 0.5,
		"max_corruption": 3.0,
		"min_stamina": 1.0,
		"max_stamina": 1.0,
		"stamina": 0.0,
		"stamina_regen": 0.5,
		"stamina_cost": 0.5,
		"min_speed": 0.5,
		"max_speed": 1.5,
		"agility": 8.0,
		"food": 6.0,
		"cat_coins": 15.0,
		"dog_coins": 15.0,
		"min_turn_angle": 0.04,
		"turn_speed": 7.0,
		"min_num_bones": 8,
		"max_num_bones": 12,
		"min_bone_distance": 12,
		"max_bone_distance": 18,
		"min_bone_radius": 14,
		"max_bone_radius": 22,
		"min_size_modifier": 1.00,
		"max_size_modifier": 2.50,
		"min_spawn_y": -30.0,
		"max_spawn_y": -70.0,
		"min_spawn_x": 10.0,
		"max_spawn_x": 60.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["4b1034", "104b48", "1e4b10", "4b3f10"]
	},
	"spinefish": {
		"id": 9,
		"name": "Spine Fish",
		"description": "Their little jaws can crush through steel.",
		"min_corruption": 0.5,
		"max_corruption": 3.0,
		"min_stamina": 2.0,
		"max_stamina": 2.0,
		"stamina": 0.0,
		"stamina_regen": 0.25,
		"stamina_cost": 0.75,
		"min_speed": 0.75,
		"max_speed": 1.25,
		"agility": 4.0,
		"food": 1.0,
		"cat_coins": 10.0,
		"dog_coins": 10.0,
		"min_turn_angle": 0.2,
		"turn_speed": 6.0,
		"min_num_bones": 8,
		"max_num_bones": 14,
		"min_bone_distance": 10,
		"max_bone_distance": 15,
		"min_bone_radius": 10,
		"max_bone_radius": 18,
		"min_size_modifier": 1.00,
		"max_size_modifier": 1.50,
		"min_spawn_y": 10.0,
		"max_spawn_y": -70.0,
		"min_spawn_x": -10.0,
		"max_spawn_x": -60.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": []
	},
	"stubbyfish": {
		"id": 10,
		"name": "Stubby Fish",
		"description": "Extremely stubby but also just as stubborn.",
		"min_corruption": 0.5,
		"max_corruption": 3.0,
		"min_stamina": 5.0,
		"max_stamina": 5.0,
		"stamina": 0.0,
		"stamina_regen": 0.5,
		"stamina_cost": 0.5,
		"min_speed": 0.5,
		"max_speed": 0.75,
		"agility": 4.0,
		"food": 5.0,
		"cat_coins": 40.0,
		"dog_coins": 40.0,
		"min_turn_angle": 0.3,
		"turn_speed": 8.0,
		"min_num_bones": 4,
		"max_num_bones": 6,
		"min_bone_distance": 8,
		"max_bone_distance": 12,
		"min_bone_radius": 20,
		"max_bone_radius": 30,
		"min_size_modifier": 1.00,
		"max_size_modifier": 3.50,
		"min_spawn_y": -10.0,
		"max_spawn_y": -50.0,
		"min_spawn_x": -60.0,
		"max_spawn_x": -60.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["e73333", "f81e1e", "de1111"]
	},
	"trianglefish": {
		"id": 11,
		"name": "Triangle Fish",
		"description": "Simple little fish that tapper off into a general triangle shape.",
		"min_corruption": 0.0,
		"max_corruption": 1.0,
		"min_stamina": 1.0,
		"max_stamina": 1.5,
		"stamina": 0.0,
		"stamina_regen": 0.3,
		"stamina_cost": 0.6,
		"min_speed": 0.75,
		"max_speed": 1.0,
		"agility": 9.0,
		"food": 1.0,
		"cat_coins": 1.0,
		"dog_coins": 1.0,
		"min_turn_angle": 0.2,
		"turn_speed": 7.0,
		"min_num_bones": 6,
		"max_num_bones": 10,
		"min_bone_distance": 10,
		"max_bone_distance": 14,
		"min_bone_radius": 18,
		"max_bone_radius": 28,
		"min_size_modifier": 1.00,
		"max_size_modifier": 2.00,
		"min_spawn_y": 10.0,
		"max_spawn_y": -95.0,
		"min_spawn_x": -80.0,
		"max_spawn_x": 80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["b3eeba", "d3eeb3", "b3eecf"]
	},
	"whiskerfish": {
		"id": 12,
		"name": "Whisker Fish",
		"description": "Their forward fins resemble whiskers and they can grasp things like little hands.",
		"min_corruption": 1.0,
		"max_corruption": 2.0,
		"min_stamina": 3.0,
		"max_stamina": 3.5,
		"stamina": 0.0,
		"stamina_regen": 0.4,
		"stamina_cost": 0.9,
		"min_speed": 0.75,
		"max_speed": 1.0,
		"agility": 4.0,
		"food": 5.0,
		"cat_coins": 40.0,
		"dog_coins": 10.0,
		"min_turn_angle": 0.15,
		"turn_speed": 5.0,
		"min_num_bones": 6,
		"max_num_bones": 10,
		"min_bone_distance": 12,
		"max_bone_distance": 14,
		"min_bone_radius": 20,
		"max_bone_radius": 25,
		"min_size_modifier": 1.00,
		"max_size_modifier": 2.00,
		"min_spawn_y": -40.0,
		"max_spawn_y": -75.0,
		"min_spawn_x": -80.0,
		"max_spawn_x": -80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["27362e", "363627", "342736"]
	},
	"worm": {
		"id": 13,
		"name": "Worm Fish",
		"description": "Even without eyes they can still detect anything around them.",
		"min_corruption": 3.0,
		"max_corruption": 4.0,
		"min_stamina": 2.0,
		"max_stamina": 2.5,
		"stamina": 0.0,
		"stamina_regen": 0.9,
		"stamina_cost": 0.3,
		"min_speed": 0.5,
		"max_speed": 0.7,
		"agility": 14.0,
		"food": 10.0,
		"cat_coins": 10.0,
		"dog_coins": 10.0,
		"min_turn_angle": 0.12,
		"turn_speed": 3.0,
		"min_num_bones": 8,
		"max_num_bones": 30,
		"min_bone_distance": 10,
		"max_bone_distance": 15,
		"min_bone_radius": 20,
		"max_bone_radius": 30,
		"min_size_modifier": 1.00,
		"max_size_modifier": 2.00,
		"min_spawn_y": -15.0,
		"max_spawn_y": -75.0,
		"min_spawn_x": -80.0,
		"max_spawn_x": -80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": []
	}
}

var game_state:Dictionary = {
	"settings": {
		"volume":{
			"master": 100.0,
			"music": 10.0,
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
		"travel_hunger_rate": 0.1,
		"stamina_regen_rate": 2.0,
		"stamina_cost": 0.5,
		"max_fish": 10,
		"current_time": 0,
		"mouse_sensitivity": 0.1,
		"fov": 75.0,
		"boat_speed": 1.0,
		"fishing_lower_speed": 3.0,
		"fishing_raise_speed": 1.5,
		"hooked_fish": 0,
		"max_hooked_fish": 1,
		"target_position": [0,0,0],
		"current_position": [0,0,0],
		"current_location": "center",
		"fish_caught": []
	},
	"cat": {
		"settings": {
			"name": "Cat Demon",
			"default_image": "res://assets/art/characters/maha_amused.png",
			"conversation_state": [0],
			"conversations":[
				{
					"prompt": "insert character introduction line here",
					"image": "res://assets/art/characters/maha_amused.png",
					"responses": [
						"Response 0",
						"Response 1",
						"Response 2"
					],
					"conversations":[
						{
							"prompt": "followup to response 0",
							"image": "res://assets/art/characters/maha_eyes_closed_cover_mouth.png",
							"responses": [
								"Response 0-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 0-0",
									"image": "res://assets/art/characters/maha_eyes_open.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 1",
							"image": "res://assets/art/characters/maha_eyes_open.png",
							"responses": [
								"Response 1-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 1-0",
									"image": "res://assets/art/characters/maha_eyes_open_cover_mouth.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 2",
							"image": "res://assets/art/characters/maha_amused.png",
							"responses": [
								"Response 2-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 2-0",
									"image": "res://assets/art/characters/maha_eyes_closed_cover_mouth.png",
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
			"default_image": "res://assets/art/characters/hama_eyes_closed.png",
			"conversation_state": [0],
			"conversations":[
				{
					"prompt": "insert character introduction line here",
					"image": "res://assets/art/characters/hama_eyes_closed.png",
					"responses": [
						"Response 0",
						"Response 1",
						"Response 2"
					],
					"conversations":[
						{
							"prompt": "followup to response 0",
							"image": "res://assets/art/characters/hama_eyes_closed_mouth_cover.png",
							"responses": [
								"Response 0-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 0-0",
									"image": "res://assets/art/characters/hama_eyes_open_cover_mouth.png",
									"responses": [
									],
									"conversations":[]
								},
							]
						},
						{
							"prompt": "followup to response 1",
							"image": "/home/shrike/Dropbox/programming/fishinghorrorgamejam/fishing-horror/assets/art/characters/hama_eyes_open.png",
							"responses": [
								"Response 1-0",
							],
							"conversations":[
								{
									"prompt": "followup to response 1-0",
									"image": "/home/shrike/Dropbox/programming/fishinghorrorgamejam/fishing-horror/assets/art/characters/hama_eyes_open_cover_mouth.png",
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
									"image": "/home/shrike/Dropbox/programming/fishinghorrorgamejam/fishing-horror/assets/art/characters/hama_eyes_open_cover_mouth.png",
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
	game_state["you"]["hooked_fish"] = 0
	game_state["you"]["current_fish"] = 0
	

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
