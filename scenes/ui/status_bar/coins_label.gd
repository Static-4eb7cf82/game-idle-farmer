extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignals.player_coins_changed.connect(on_player_coins_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    text = get_label_text(Player.coins)


func on_player_coins_changed(new_coins: int) -> void:
    text = get_label_text(new_coins)


func get_label_text(coins: int) -> String:
    return str(coins)