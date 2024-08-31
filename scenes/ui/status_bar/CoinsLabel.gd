extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignals.player_coins_changed.connect(on_player_coins_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func on_player_coins_changed(new_coins: int) -> void:
    text = "coins " + str(new_coins)
