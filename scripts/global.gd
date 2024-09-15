extends Node

var debug := true
var settings := Settings.new()
class DebugSettings extends Settings:
    func _init() -> void:
        cat_worker_speed = 50.0
        growth_duration_in_seconds_wheat = 5.0
        coin_reward_wheat = 20
        growth_duration_in_seconds_beet = 10.0
        coin_reward_beet = 40
        growth_duration_in_seconds_lettuce = 15.0
        coin_reward_lettuce = 60
        player_starting_coins = 100
        player_starting_wood = 100
        wood_tree_max_hp = 2
        wood_tree_regen_duration_in_seconds = 15
        till_cost = 10

class Settings:
    var cat_worker_speed: float = 25.0
    var cat_worker_water_count: int = 5
    var coin_cost_wheat: int = 1
    var coin_cost_beet: int = 3
    var coin_cost_lettuce: int = 6
    var coin_reward_wheat: int = 7
    var coin_reward_beet: int = 12
    var coin_reward_lettuce: int = 18
    var growth_duration_in_seconds_wheat: float = 70.0
    var growth_duration_in_seconds_beet: float = 105.0
    var growth_duration_in_seconds_lettuce: float = 175.0
    var till_cost: int = 35
    var watered_soil_duration: int = 35
    var player_starting_coins: int = 5
    var player_starting_wood: int = 0
    var wood_tree_max_hp: int = 10
    var wood_tree_regen_duration_in_seconds: int = 60



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if debug:
        print("Debug mode enabled")
        settings = DebugSettings.new()
    else:
        print("Debug mode disabled")
        settings = Settings.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

# todo: Move to a static constants class
# rename this class to GlobalState
enum CROP_TYPE {
    NONE,
    WHEAT,
    BEET,
    LETTUCE,
    CARROT,
}

const PLAYER_GROUP_NAME = "player"
const UI_GROUP_NAME = "ui_canvas_layer"