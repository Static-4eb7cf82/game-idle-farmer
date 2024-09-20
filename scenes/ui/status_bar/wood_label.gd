extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    on_player_wood_changed(Player.wood)
    GlobalSignals.player_wood_changed.connect(on_player_wood_changed)


func on_player_wood_changed(new_wood: int) -> void:
    text = get_label_text(new_wood)


func get_label_text(wood: int) -> String:
    return str(wood)