extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

signal player_coins_changed(new_coins: int)
func emit_player_coins_changed(new_coins: int) -> void:
    player_coins_changed.emit(new_coins)