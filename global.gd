extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

# todo: Move to a static constants class
# rename this class to GlobalState
enum crop_type {
    NONE,
    WHEAT,
    BEET,
    LETTUCE,
    CARROT,
}