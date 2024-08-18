extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    var mouse_position := get_viewport().get_mouse_position()
    var position_offset := Vector2(10, -6)
    position = mouse_position + position_offset
