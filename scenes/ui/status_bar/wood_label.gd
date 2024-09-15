extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignals.player_wood_changed.connect(on_player_wood_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    text = get_label_text(Player.wood)


func on_player_wood_changed(new_wood: int) -> void:
    text = get_label_text(new_wood)


func get_label_text(wood: int) -> String:
    return "wood " + str(wood)