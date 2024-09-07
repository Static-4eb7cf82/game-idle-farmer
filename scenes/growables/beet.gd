extends Crop


func _ready() -> void:
    growthDurationInSeconds = Global.settings.growth_duration_in_seconds_beet
    coin_reward = Global.settings.coin_reward_beet
    super()