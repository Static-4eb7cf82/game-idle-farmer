extends Node2D

class_name FollowMouse

@export
var position_offset: Vector2 = Vector2(12, -6)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    var mouse_position := get_viewport().get_mouse_position()
    position = mouse_position + position_offset