extends Control


var is_open := false
var selected_seed_packet_instance: Sprite2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    close_action_menu()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func open_action_menu() -> void:
    is_open = true
    $BuildMenuOpen.show()
    $BuildMenuClosed.hide()

func close_action_menu() -> void:
    is_open = false
    $BuildMenuOpen.hide()
    $BuildMenuClosed.show()

func _on_open_build_menu_button_pressed() -> void:
    open_action_menu()

func _on_close_build_menu_button_pressed() -> void:
    close_action_menu()
