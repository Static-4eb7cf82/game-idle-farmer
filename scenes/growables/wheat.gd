extends Crop
# Bug:
# When all the crops referenced Crop.gd as their script, planting a crop other than wheat would be nil
# But when I first implemented this and had the crops share this script, it worked fine

func _ready() -> void:
    super()
    growthDurationInSeconds = Global.settings.growth_duration_in_seconds_wheat
    coin_reward = Global.settings.coin_reward_wheat