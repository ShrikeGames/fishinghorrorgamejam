extends Node

class_name GlobalState
signal caught_fish(fish: Fish)
signal update_conversation()
var settings_config_location: String = "user://user_settings_v0_2026_03_29.json"
var fish_object: Resource = load("res://assets/scenes/fish/FishSegment.tscn")
var fish_rbg_colour_choices: Array[String] = ["00", "11", "22", "33", "44", "55", "66", "77", "88", "99", "AA", "BB", "CC", "DD", "EE", "FF"]

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
		"min_spawn_y": - 20.0,
		"max_spawn_y": - 40.0,
		"min_spawn_x": - 60.0,
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
		"cat_coins": 10.0,
		"dog_coins": 15.0,
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
		"min_spawn_y": - 10.0,
		"max_spawn_y": - 30.0,
		"min_spawn_x": - 50.0,
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
		"max_spawn_y": - 20.0,
		"min_spawn_x": - 80.0,
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
		"max_spawn_y": - 10.0,
		"min_spawn_x": - 20.0,
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
		"min_spawn_y": - 5.0,
		"max_spawn_y": - 30.0,
		"min_spawn_x": - 10.0,
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
		"min_spawn_y": - 15.0,
		"max_spawn_y": - 45.0,
		"min_spawn_x": - 80.0,
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
		"min_spawn_y": - 20.0,
		"max_spawn_y": - 60.0,
		"min_spawn_x": - 80.0,
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
		"min_spawn_y": - 20.0,
		"max_spawn_y": - 30.0,
		"min_spawn_x": - 40.0,
		"max_spawn_x": - 60.0,
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
		"min_spawn_y": - 30.0,
		"max_spawn_y": - 70.0,
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
		"max_spawn_y": - 70.0,
		"min_spawn_x": - 10.0,
		"max_spawn_x": - 60.0,
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
		"min_spawn_y": - 10.0,
		"max_spawn_y": - 50.0,
		"min_spawn_x": - 60.0,
		"max_spawn_x": - 60.0,
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
		"max_spawn_y": - 95.0,
		"min_spawn_x": - 80.0,
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
		"min_spawn_y": - 40.0,
		"max_spawn_y": - 75.0,
		"min_spawn_x": - 80.0,
		"max_spawn_x": - 80.0,
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
		"min_spawn_y": - 15.0,
		"max_spawn_y": - 75.0,
		"min_spawn_x": - 80.0,
		"max_spawn_x": - 80.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": []
	},
	"angelfish": {
		"id": 14,
		"name": "Angel Fish",
		"description": "The Legendary Fish said to grant any wish to those that eat it.",
		"min_corruption": 0.0,
		"max_corruption": 0.0,
		"min_stamina": 10.0,
		"max_stamina": 10.0,
		"stamina": 10.0,
		"stamina_regen": 2.0,
		"stamina_cost": 1.0,
		"min_speed": 2.5,
		"max_speed": 2.5,
		"agility": 14.0,
		"food": 1.0,
		"cat_coins": 9999.0,
		"dog_coins": 9999.0,
		"min_turn_angle": 0.5,
		"turn_speed": 2.0,
		"min_num_bones": 12,
		"max_num_bones": 16,
		"min_bone_distance": 50,
		"max_bone_distance": 50,
		"min_bone_radius": 50,
		"max_bone_radius": 50,
		"min_size_modifier": 5.0,
		"max_size_modifier": 5.0,
		"min_spawn_y": -100.0,
		"max_spawn_y": - 200.0,
		"min_spawn_x": - 50.0,
		"max_spawn_x": 50.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 1.0,
		"specific_colour_choices": ["ffffff"]
	},
	"demonfish": {
		"id": 15,
		"name": "Demon Fish",
		"description": "This abomination from hell curses all who catch it.",
		"min_corruption": 0.0,
		"max_corruption": 0.0,
		"min_stamina": 10.0,
		"max_stamina": 10.0,
		"stamina": 10.0,
		"stamina_regen": 2.0,
		"stamina_cost": 1.0,
		"min_speed": 2.5,
		"max_speed": 2.5,
		"agility": 14.0,
		"food": 1.0,
		"cat_coins": 9999.0,
		"dog_coins": 9999.0,
		"min_turn_angle": 0.5,
		"turn_speed": 2.0,
		"min_num_bones": 16,
		"max_num_bones": 20,
		"min_bone_distance": 30,
		"max_bone_distance": 30,
		"min_bone_radius": 30,
		"max_bone_radius": 30,
		"min_size_modifier": 3.0,
		"max_size_modifier": 3.0,
		"min_spawn_y": -80.0,
		"max_spawn_y": -160.0,
		"min_spawn_x": -70.0,
		"max_spawn_x": 70.0,
		"min_spawn_radius": 4.0,
		"max_target_radius": 2.0,
		"specific_colour_choices": ["BB0000"]
	}
}

var game_state: Dictionary = {
	"settings": {
		"volume": {
			"master": 100.0,
			"music": 10.0,
			"sfx": 40.0,
			"voices": 80.0,
			"ambient": 50.0
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
		"idle_hunger_rate": 0.01,
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
		"target_position": [0, 0, 0],
		"current_position": [0, 0, 0],
		"current_location": "center",
		"cat_score": 1,
		"dog_score": 1,
		"fish_caught": []
	},
	"cat": {
		"name": "Maha",
		"coins": 0,
		"corruption": 0,
		"settings": {
			"default_image": "res://assets/art/characters/maha_amused.png",
			"conversation_state": "default",
			"conversations": {
				"default": "Nyahaha, look what we have here. 
A new soul has come. 
We are [color=green][url=#maha]Maha[/url][/color].
Give Maha [color=green][url=#fish]fish[/url][/color], and Maha give you [color=green][url=#coin]coin[/url][/color]. 

It's a fair [color=green][url=#buy]trade[/url][/color], nyo? 
You like [color=green][url=#talk]talk[/url][/color]? 
Maha can also offer [color=green][url=#advice]advice[/url][/color].",
				
				"#maha": "Maha is mighty. Maha wants many [color=green][url=#fish]fish[/url][/color].
The [color=green][url=#lake]lake[/url][/color] has many [color=green][url=#variety]types of yummy fish[/url][/color].

Trade fish to Maha and [color=green][url=#talk]chat[/url][/color] over lunch.",
		
				"#fish": "Give fish. All fish. [color=green][url=#maha]Maha[/url][/color] not picky unlike [color=green][url=#hama]Hama[/url][/color]",
				
				"#variety": "Surface fish not worth many coin.
[color=green][url=#deep]Deep Fish[/url][/color] difficult but worth more.
Rare fish be special. [color=green][url=#maha]Maha[/url][/color] not picky but like [color=green][url=#special]Special Fish[/url][/color] too.",

				"#deep": "[color=green][url=#maha]Maha[/url][/color] knows of [color=green][url=#whisker]Whisker Fish[/url][/color].
They found deep and far. Maha loves Whisker Fish. Pay many [color=green][url=#coin]Coins[/url][/color] for one.
Even deeper are [color=green][url=#special]special fish[/url][/color].
Maha drool just thinking.
Maha give [color=green][url=#maha]advice[/url][/color] to [color=green][url=#buy]trade[/url][/color] all [color=green][url=#fish]fish[/url][/color] to Maha.",
				
				"#whisker": "Delicious. [color=green][url=#maha]Maha[/url][/color] like very much.
[color=green][url=#buy]Trade[/url][/color] for many [color=green][url=#coin]coin[/url][/color], yes?
Find Whisker Fish deep. Far. Other side of [color=green][url=#lake]lake[/url][/color].",
				
				"#special": "Rarest fish be Angel Fish. Very [color=green][url=#deep]deep[/url][/color] must go to find.
[color=green][url=#maha]Maha[/url][/color] never seen [color=green][url=#angel]Angel Fish[/url][/color]. Desire much.
Bring to Maha and Maha give [color=green][url=#reward]special reward[/url][/color].",

				"#reward": "[color=green][url=#maha]Maha[/url][/color] give very special reward for [color=green][url=#special]very special fish[/url][/color].
No [color=green][url=#fish]fish[/url][/color] no reward.
Maha no say more till you bring.
[color=green][url=#talk]Talk[/url][/color] different topic.",

				"#angel": "Angel Fish be Pure white. [color=green][url=#maha]Maha[/url][/color] knows this much.
Powerful [color=green][url=#fish]Fish[/url][/color].
Live very [color=green][url=#deep]deep[/url][/color] it does.
Promise [color=green][url=#power]great power[/url][/color] when eat Angel fish.",

				"#power": "Eat [color=green][url=#angel]Angel Fish[/url][/color] rule world.
Simple [color=green][url=#maha]Maha[/url][/color] thinks.
Bring to [color=green][url=#maha]Maha[/url][/color] and give [color=green][url=#reward]big reward[/url][/color].

Until then [color=green][url=#talk]talk[/url][/color] and [color=green][url=#food]eat[/url][/color] other [color=green][url=#fish]fish[/url][/color]!",
				
				"#lake": "Small lake. Many [color=green][url=#fish]fish[/url][/color].
Delicous all. [color=green][url=#buy]Trade[/url][/color] to [color=green][url=#maha]Maha[/url][/color] you must.
[color=green][url=#variety]Different fish/url][/color] found different depths.
Looky looky for tasty fishy.",
				
				"#coin": "[color=green][url=#maha]Maha[/url][/color] [color=green][url=#buy]trade[/url][/color] in Cat Coins.
Cat Coins good here. No good if go to [color=green][url=#hama]Hama[/url][/color].
So stay here. [color=green][url=#talk]talk[/url][/color] to Maha and [color=green][url=#food]eat[/url][/color] well together.",
				
				"#buy": "[color=green][url=#maha]Maha[/url][/color] offer many goods.
Good prices. You like.
[color=green][url=#food]Food[/url][/color] free of [color=green][url=#corruption]corruption[/url][/color].
[color=green][url=#stamina]Stamina[/url][/color] potion so never tire.
[color=green][url=#strength]Strength[/url][/color] potion so pull fast.
[color=green][url=#fish]Fish[/url][/color] like bait. Buy bait and fish come from far.
Show support for Maha. Wear [color=green][url=#hat]kawaii hat[/url][/color]. Better than ugly [color=green][url=#hama]Hama[/url][/color] hat.

Or you like [color=green][url=#talk]talk[/url][/color]?
",
				"hat": "[color=green][url=#maha]Maha[/url][/color] has cute ears yes?
You want be like Maha, yes?
[color=green][url=#buy]Buy[/url][/color] Maha hat.
Be Cute.
You need more [color=green][url=#advice]advice[/url][/color]?",
				
				"#stamina": "[color=green][url=#maha]Maha[/url][/color] knows fishing hard work.
Pull. Struggle. Tire. [color=green][url=#fish]Fish[/url][/color] on surface easy.
[color=green][url=#deep]Deep fish[/url][/color] much harder.
[color=green][url=#buy]Buy[/url][/color] this and last longer.
You like.",
				"#strength": "[color=green][url=#maha]Maha[/url][/color] knows [color=green][url=#fish]fish[/url][/color] struggle.
[color=green][url=#deep]Deep fish[/url][/color] even harder.
[color=green][url=#buy]Buy[/url][/color] this and pull fish surface faster. Easier.
You like.",
				"#food": "[color=green][url=#maha]Maha[/url][/color] say careful eat [color=green][url=#fish]fish[/url][/color] . [color=green][url=#buy]Buy[/url][/color] from Maha instead.
Maha food is safe. Cheap. Good.
Maha wise. More [color=green][url=#advice]advice[/url][/color] if need?
",
				
				"#talk": "What talk you like? [color=green][url=#maha]Maha[/url][/color] wiser than dumb [color=green][url=#hama]Hama[/url][/color].
Best ask Maha for [color=green][url=#advice]Advice[/url][/color].
Maha [color=green][url=#buy]sells[/url][/color] many good tools. You like.
[color=green][url=#lake]Lake[/url][/color] full of [color=green][url=#fish]Maha[/url][/color] in [color=green][url=#variety]many kinds[/url][/color].
Or like know about Maha's [color=green][url=#background]background[/url][/color]?",

				"#background": "[color=green][url=#maha]Maha[/url][/color] is great [color=green][url=#leader]leader[/url][/color]
[color=green][url=#buy]Merchant too[/url][/color].
Maha work hard to defeat smelly [color=green][url=#hama]Hama[/url][/color].
Maha wise. More [color=green][url=#advice]advice[/url][/color] if need?
",
				"#leader": "[color=green][url=#maha]Maha[/url][/color] soon rule world.
Maha fights [color=green][url=#corruption]Corruption[/url][/color] and demon [color=green][url=#hama]Hama[/url][/color].
Maha's people wise. Rule justly. Make dity Hama slave.
Maha wise. More [color=green][url=#advice]advice[/url][/color] if need?
",
				"#corruption": "[color=green][url=#maha]Maha[/url][/color] knows much of corruption.
Maha make [color=green][url=#unique]Corruption Detector[/url][/color].
You [color=green][url=#buy]buy[/url][/color] it. Good price.
[color=green][url=#fish]Fish[/url][/color] corrupted. Hama corrupted.
Maha clean. Maha good.
Maha wise. More [color=green][url=#advice]advice[/url][/color] if need?",
				
				"#unique": "[color=green][url=#maha]Maha[/url][/color] [color=green][url=#buy]sells[/url][/color] Corruption Detector.
Good price. Never guess again. 
See corruption in fish.
You buy or just [color=green][url=#talk]talk[/url][/color] talk?",
				
				"#advice": "[color=green][url=#maha]Maha[/url][/color] knows much.
Not trust [color=green][url=#hama]Hama[/url][/color].
When [color=green][url=#fish]fish[/url][/color] struggle pull. Slow fish down.
Rest when [color=green][url=#stamina]stamina[/url][/color] low.
[color=green][url=#buy]Trade[/url][/color] with Maha. Advantage get.
[color=green][url=#deep]Deep fish[/url][/color] found different parts of [color=green][url=#lake]lake[/url][/color].
",
				
				"#hama": "Hama is stupid dog demon. Maha much superior.
Do not [color=green][url=#buy]trade[/url][/color] with Hama, only Maha.
Simple [color=green][url=#advice]advice[/url][/color] Maha give.
Stay here. Not go to other [color=green][url=#lake]lake[/url][/color] side.",
				
				"#unknown": "[color=green][url=#maha]Maha[/url][/color] doesn't know about that.
You should [color=green][url=#buy]trade[/url][/color], nyo? 
Maha also likes [color=green][url=#talk]talk[/url][/color] and giving [color=green][url=#advice]advice[/url][/color]"
				
				
			}
		
		},
		"upgrades": {
			"bait": false,
			"hook": false,
			"line": false,
			"stamina": false,
			"fish": false,
			"strength": false,
			"unique": false,
			"food": false,
			"hat": false
		}
	},
	"dog": {
		"name": "Hama",
		"coins": 0,
		"corruption": 0,
		"settings": {
			"default_image": "res://assets/art/characters/hama_eyes_closed.png",
			"conversation_state": "default",
			"conversations": {
				"default": "Welcome. I am [color=green][url=#hama]Hama[/url][/color].
It is an honour to make your acquaintance.
If you bring me [color=green][url=#special]rare fish[/url][/color], I shall compensate you with [color=green][url=#coin]Dog Coins[/url][/color].

We may [color=green][url=#buy]trade[/url][/color], [color=green][url=#talk]talk[/url][/color], or I can offer modest [color=green][url=#advice]advice[/url][/color].",

				"#hama": "I am Hama, a keeper of calm waters.
I value care, patience, and excellence in the art of angling.
Though our aims differ, I hold [color=green][url=#maha]Maha[/url][/color] in regard; even so, I advise you to keep your dealings here.
If you seek purpose, bring me [color=green][url=#special]rare fish[/url][/color].
Shall we [color=green][url=#buy]trade[/url][/color] or simply [color=green][url=#talk]talk[/url][/color]?",

				"#maha": "[color=green][url=#maha]Maha[/url][/color] is a capable merchant and a spirited leader.
Our domains are distinct, and I wish him an honourable death.
For your own consistency and safety, I recommend you conduct your trade here.
We only deal with [color=green][url=#coin]Dog Dollars[/url][/color], consider a [color=green][url=#buy]purchase[/url][/color], or simply [color=green][url=#talk]talk[/url][/color].",

				"#fish": "I accept all [color=green][url=#fish]fish[/url][/color], of course, but my interest is greatest in [color=green][url=#special]rare specimens[/url][/color].
Common catches will earn modest [color=green][url=#coin]dollars[/url][/color].
Seek the [color=green][url=#deep]deep[/url][/color] for [color=green][url=#special]rarities[/url][/color], then [color=green][url=#buy]trade[/url][/color] as you wish.",

				"#variety": "These waters hold a wide [color=green][url=#variety]variety of fish[/url][/color].
Shallow currents favour the common; venture [color=green][url=#deep]deeper[/url][/color] for creatures of greater distinction.
You should survey the entire [color=green][url=#lake]lake[/url][/color] and then [color=green][url=#buy]trade[/url][/color] when ready.",

				"#deep": "Below the tranquil surface dwell remarkable forms.
Among them, the [color=green][url=#stubby]Stubby Fish[/url][/color] is renowned.
Deeper still, you may find truly [color=green][url=#special]rare fish[/url][/color].
If you bring them to me, I will see you rewarded.
You might begin with the Stubby Fish, or seek the [color=green][url=#special]truly rare[/url][/color] and then [color=green][url=#buy]trade[/url][/color].",

				"#stubby": "The Stubby Fish is admirable—keen and deliberate.
It keeps to the deep and distant reaches of the [color=green][url=#lake]lake[/url][/color].
Present one, and I shall offer generous [color=green][url=#coin]compensation[/url][/color].
Shall we proceed to [color=green][url=#buy]trade[/url][/color], or [color=green][url=#talk]speak[/url][/color] further together?",

				"#special": "Of the rarities, the [color=green][url=#angel]Angel Fish[/url][/color] is spoken of in hushed voices.
If you should find so pure a specimen, know that I will provide a [color=green][url=#reward]special reward[/url][/color].
Pursue the [color=green][url=#deep]deepest[/url][/color] parts of the lake, but [color=green][url=#buy]trade[/url][/color] me whatever you find regardless.",

				"#reward": "For a truly [color=green][url=#special]extraordinary catch[/url][/color], I have set aside a respectful gift.
Bring the fish first; discretion is part of the promise.
We can then [color=green][url=#talk]talk[/url][/color] further.",

				"#angel": "The Angel Fish is said to be white as first light.
Its presence is felt most strongly in the very [color=green][url=#deep]deep[/url][/color].
Approach with patience and care.
When found, consider its [color=green][url=#power]power[/url][/color], then return for your [color=green][url=#reward]reward[/url][/color].

I am of course open to [color=green][url=#talk]discussion[/url][/color] of other matters anytime.",

				"#power": "Power discovered in the depths should be handled with restraint.
Should you obtain an [color=green][url=#angel]Angel Fish[/url][/color], consider its weight—then choose with wisdom.
If entrusted to me, I will honour it properly.
Now then, shall we [color=green][url=#buy]browse my wares[/url][/color], or simply [color=green][url=#talk]talk[/url][/color]?",

				"#lake": "This [color=green][url=#lake]lake[/url][/color] is modest in size yet rich in life.
Different depths host different temperaments.
Travel with intention, and you will learn its quiet patterns.
Now then, shall we [color=green][url=#buy]browse my wares[/url][/color], or simply [color=green][url=#talk]talk[/url][/color]?",

				"#coin": "I trade in [color=green][url=#coin]Dog Dollars[/url][/color].
Cat Coins will not be accepted here, and I would advise against collecting them.
If you wish, we can exchange Dog Dollars for any of my [color=green][url=#buy]fine goods[/url][/color] or would you like more [color=green][url=#advice]advice[/url][/color].",

				"#buy": "I maintain a small counter of goods.
[color=green][url=#food]Provisions[/url][/color], prepared with care and free of [color=green][url=#corruption]corruption[/url][/color], they are worth the cost.
[color=green][url=#stamina]Stamina tonics[/url][/color] for steady endurance.
[color=green][url=#strength]Line strength tonics[/url][/color] for firmer pull.
[color=green][url=#fish]Bait[/url][/color] to entice from afar.
[color=green][url=#unique]Quality Detector[/url][/color] to estimate a catch's value at my counter.
A magnificent and graceful [color=green][url=#hat]hat[/url][/color] should you wish to look the part of a winner.

Or, if you prefer, we may simply [color=green][url=#talk]talk[/url][/color].",

				"#stamina": "Endurance is the quiet ally of every angler.
With this, you may work longer before needing rest.
Use it wisely, not wastefully.
If it would help, you may [color=green][url=#buy]purchase one[/url][/color] or ask of me additional [color=green][url=#advice]advice[/url][/color].",

				"#strength": "When a [color=green][url=#fish]fish[/url][/color] contests your pull, firmness helps.
This will hasten your draw to the surface—within reason.
Would you like to [color=green][url=#buy]procure one[/url][/color], or seek further [color=green][url=#advice]advice[/url][/color]?",

				"#food": "Do not settle for cat food, dine on the best.
I only produce the finest provisions free of [color=green][url=#corruption]corruption[/url][/color].
One serving will surely fill you for days.
Shall I prepare [color=green][url=#buy]provisions[/url][/color], or would you rather [color=green][url=#talk]talk[/url][/color]?",

				"#talk": "What shall we discuss?
I can offer [color=green][url=#advice]advice[/url][/color] for the waters, tell you of of my [color=green][url=#background]background[/url][/color], or direct you to [color=green][url=#buy]supplies[/url][/color].
If you are curious about [color=green][url=#maha]Maha[/url][/color], I will answer respectfully.
I have reasonable knowledge of the [color=green][url=#lake]lake[/url][/color] as well.",

				"#background": "I serve as a steward of these shores, a merchant by necessity and a guardian by choice.
While our waters are contested, I bear no ill will.
I work to keep the currents steady and the trade just.
If you wish, we can reflect on [color=green][url=#leader]leadership[/url][/color] or [color=green][url=#talk]discuss[/url][/color] other matters.",

				"#leader": "Leadership is quiet labour.
I prefer to listen, to act with care, and to keep [color=green][url=#corruption]corruption[/url][/color] at bay where I can.
May our efforts leave the lake under the proper care and attention.
[color=green][url=#maha]Maha[/url][/color] would foolishly devour the [color=green][url=#lake]lake[/url][/color] and waste its potential.
I would see to it that all [color=green][url=#fish]fish[/url][/color] bow to the proper laws and behaviours..",

				"#corruption": "The [color=green][url=#fish]fish[/url][/color] of all [color=green][url=#variety]varieties[/url][/color] suffer from it.
Observe carefully and proceed with caution.
If a catch seems compromised, do not shove it in your gullet.
You should [color=green][url=#buy]sell[/url][/color] them to me to handle with care.
Now, is there something else you'd like to [color=green][url=#talk]discuss[/url][/color]?",

				"#unique": "The [color=green][url=#unique]Quality Detector[/url][/color] is a modest instrument.
It estimates the sale value of your recent catch with me, sparing you guesswork.
Should that aid your judgment, I will extend a fair price.
Would you like to [color=green][url=#buy]acquire one[/url][/color], or seek my [color=green][url=#advice]advice[/url][/color] on another matter?",

				"#advice": "Be patient. 
Reel when the [color=green][url=#fish]fish[/url][/color] yields.
Rest when your [color=green][url=#stamina]stamina[/url][/color] wanes.
The [color=green][url=#deep]deep[/url][/color] harbours distinct species in distinct quarters of the [color=green][url=#lake]lake[/url][/color].
Relocate your fine craft to discover different fish if you grow bored of the currently selection.
If you are ready, we can [color=green][url=#buy]trade[/url][/color] or continue to [color=green][url=#talk]talk[/url][/color].",

				"#unknown": "I do not have knowledge of that, I am afraid.
We may [color=green][url=#buy]trade[/url][/color] if you wish, or simply [color=green][url=#talk]talk[/url][/color] awhile."
			}
		},
		"upgrades": {
			"bait": false,
			"hook": false,
			"line": false,
			"stamina": false,
			"fish": false,
			"strength": false,
			"unique": false,
			"food": false,
			"hat": false
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
