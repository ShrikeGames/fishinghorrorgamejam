extends Node

class_name GlobalState
signal caught_fish(fish:Fish)

var game_state:Dictionary = {
	"you": {
		"run": 0,
		"corruption": 0,
		"max_corruption": 10,
		"hunger": 10,
		"max_hunger": 10,
		"current_fish": 0,
		"stamina": 10,
		"max_stamina": 10,
		"max_fish": 4,
		"current_time": 0,
		"mouse_sensitivity": 0.1,
		"fov": 75.0,
		"fishing_lower_speed": 0.5,
		"fishing_raise_speed": 0.3,
		"hooked_fish": 0,
		"max_hooked_fish": 1
	},
	"cat": {
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
		},
		"conversations":{
			
		}
	},
	"dog": {
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
		},
		"conversations":{
			
		}
	}
}
