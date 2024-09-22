extends Camera2D

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
        get_viewport().set_input_as_handled();
        if event.is_pressed():
            _previousPosition = event.position;
            _moveCamera = true;
            print("right mouse button pressed");
        else:
            _moveCamera = false;
            print("right mouse button released");
    elif event is InputEventMouseMotion && _moveCamera:
        get_viewport().set_input_as_handled();
        position += (_previousPosition - event.position);
        _previousPosition = event.position;