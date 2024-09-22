extends Control

var is_open := false
const opened_position := Vector2(318, 196)
const closed_position := Vector2(624, 196)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    close_side_menu()


func _on_open_close_button_pressed() -> void:
    toggle_open()


func toggle_open() -> void:
    if is_open:
        close_side_menu()
    else:
        open_side_menu()


func open_side_menu() -> void:
    is_open = true
    var tween := get_tree().create_tween()
    tween.tween_property(self, "position", opened_position, 0.3).set_trans(Tween.TRANS_CUBIC)
    ($HBoxContainer/OpenCloseButton as Button).text = ">"


func close_side_menu() -> void:
    is_open = false
    var tween := get_tree().create_tween()
    tween.tween_property(self, "position", closed_position, 0.3).set_trans(Tween.TRANS_CUBIC)
    ($HBoxContainer/OpenCloseButton as Button).text = "<"