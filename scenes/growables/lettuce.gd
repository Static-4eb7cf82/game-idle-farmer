extends Crop


func _ready() -> void:
    growthDurationInSeconds = Global.settings.growth_duration_in_seconds_lettuce
    coin_reward = Global.settings.coin_reward_lettuce
    super()