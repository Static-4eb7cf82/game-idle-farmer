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

class Settings:
    var cat_worker_speed: float = 25.0
    var growth_duration_in_seconds_wheat: float = 45.0
    var coin_reward_wheat: int = 20
    var growth_duration_in_seconds_beet: float = 75.0
    var coin_reward_beet: int = 40
    var growth_duration_in_seconds_lettuce: float = 120.0
    var coin_reward_lettuce: int = 60



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