extends Node


signal player_coins_changed(new_coins: int)
func emit_player_coins_changed(new_coins: int) -> void:
    player_coins_changed.emit(new_coins)


signal player_wood_changed(new_wood: int)
func emit_player_wood_changed(new_wood: int) -> void:
    player_wood_changed.emit(new_wood)


signal player_ability_unlocked(ability: Global.ABILITY_TYPE)
func emit_player_ability_unlocked(ability: Global.ABILITY_TYPE) -> void:
    player_ability_unlocked.emit(ability)