extends Control


var is_open := false

var selected_build_menu_option_scene := preload("res://scenes/ui/build_menu/selected_build_menu_option.tscn")
var selected_build_menu_option: FollowMouse = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    close_action_menu()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
        if event.is_pressed():
            destroy_selected_build_option()

func destroy_selected_build_option() -> void:
    if selected_build_menu_option:
        Player.till_soil_selected = false
        selected_build_menu_option.queue_free()
        selected_build_menu_option = null

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


func get_selected_build_menu_option_node() -> SelectedBuildMenuOption:
    if selected_build_menu_option:
        return selected_build_menu_option
    else:
        selected_build_menu_option = selected_build_menu_option_scene.instantiate() as SelectedBuildMenuOption
        # Add the instance so that it's parent is a CanvasLayer with no transform.
        # Let it be a child of the UI CanvasLayer.
        get_parent().add_child(selected_build_menu_option)
        return selected_build_menu_option

# var wheat_seed_packet_texture := preload("res://assets/items/seeds/wheat_seeds.png")
# func ensure_seed_packet_at_mouse_position(type: seed_type) -> void:
#     var selected_seed_packet := get_seed_packet_node()

#     match type:
#         seed_type.WHEAT:
#             selected_seed_packet.crop_type = Global.CROP_TYPE.WHEAT
#             selected_seed_packet.texture = wheat_seed_packet_texture
#             selected_seed_packet.price = 10
#         seed_type.BEET:
#             selected_seed_packet.crop_type = Global.CROP_TYPE.BEET
#             selected_seed_packet.texture = beet_seed_packet_texture
#             selected_seed_packet.price = 20
#         seed_type.LETTUCE:
#             selected_seed_packet.crop_type = Global.CROP_TYPE.LETTUCE
#             selected_seed_packet.texture = lettuce_seed_packet_texture
#             selected_seed_packet.price = 30

#     Player.selected_seed_packet = selected_seed_packet  
#     selected_seed_packet.position = get_viewport().get_mouse_position()
#     selected_seed_packet.show()


func _on_till_soil_button_button_up() -> void:
    var selected_build_menu_option_node := get_selected_build_menu_option_node()
    selected_build_menu_option_node.texture = load("res://assets/items/tools/hoe.png")
    Player.till_soil_selected = true
