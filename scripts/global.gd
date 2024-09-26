extends Node

var debug := false
var settings := Settings.new()
class DebugSettings extends Settings:
    func _init() -> void:
        cat_worker_speed = 50.0
        growth_duration_in_seconds_wheat = 5
        coin_reward_wheat = 20
        growth_duration_in_seconds_beet = 10
        coin_reward_beet = 40
        growth_duration_in_seconds_lettuce = 15
        coin_reward_lettuce = 60
        player_starting_coins = 100
        player_starting_wood = 100
        wood_tree_max_hp = 2
        wood_tree_regen_duration_in_seconds = 15
        till_cost = 5
        ability_axe_cost = 10
        ability_pickaxe_cost = 20

class Settings:
    var cat_worker_speed: float = 25.0
    var cat_worker_water_count: int = 10
    var coin_cost_wheat: int = 1
    var coin_cost_beet: int = 2
    var coin_cost_lettuce: int = 4
    var coin_reward_wheat: int = 6
    var coin_reward_beet: int = 8
    var coin_reward_lettuce: int = 11
    var growth_duration_in_seconds_wheat: int = 60 # 5 coin/minute
    var growth_duration_in_seconds_beet: int = 75 # 4.5 coin/minute
    var growth_duration_in_seconds_lettuce: int = 90 # 4.66 coin/minute
    var till_cost: int = 20
    var watered_soil_duration: int = 60
    var player_starting_coins: int = 100
    var player_starting_wood: int = 0
    var wood_tree_max_hp: int = 10
    var wood_tree_regen_duration_in_seconds: int = 240 # wood drops 4 so 1 wood/minute
    var ability_axe_cost: int = 200
    var ability_pickaxe_cost: int = 400



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if debug:
        print("Debug mode enabled")
        settings = DebugSettings.new()
    else:
        print("Debug mode disabled")
        settings = Settings.new()


# todo: Move to a static constants class
# rename this class to GlobalState
enum CROP_TYPE {
    NONE,
    WHEAT,
    BEET,
    LETTUCE,
    CARROT,
}

const CROP_NAMES = {
    CROP_TYPE.WHEAT: "Wheat",
    CROP_TYPE.BEET: "Beet",
    CROP_TYPE.LETTUCE: "Lettuce",
    CROP_TYPE.CARROT: "Carrot",
}

# todo: Should these be moved to the crop resources?
var CROP_GROWTH_DURATION = {
    CROP_TYPE.WHEAT: settings.growth_duration_in_seconds_wheat,
    CROP_TYPE.BEET: settings.growth_duration_in_seconds_beet,
    CROP_TYPE.LETTUCE: settings.growth_duration_in_seconds_lettuce,
}

var CROP_COST = {
    CROP_TYPE.WHEAT: settings.coin_cost_wheat,
    CROP_TYPE.BEET: settings.coin_cost_beet,
    CROP_TYPE.LETTUCE: settings.coin_cost_lettuce,
}

var CROP_REWARD = {
    CROP_TYPE.WHEAT: settings.coin_reward_wheat,
    CROP_TYPE.BEET: settings.coin_reward_beet,
    CROP_TYPE.LETTUCE: settings.coin_reward_lettuce,
}

const PLAYER_GROUP_NAME = "player"
const UI_GROUP_NAME = "ui_canvas_layer"

enum ABILITY_TYPE {
    AXE,
    PICKAXE,
}