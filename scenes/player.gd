extends Node2D
# todo: Change the autoload from a scene to a script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

var selected_seed_type: Global.crop_type = Global.crop_type.NONE

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mouse_event := event as InputEventMouseButton
        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
            print("[Player] Mouse down at: ", get_global_mouse_position())
            # get_viewport().set_input_as_handled()