extends Control


var is_open := false
var selected_seed_packet_instance: SelectedSeedPacket = null

enum seed_type {
    WHEAT,
    BEET,
    LETTUCE,
    CARROT
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    close_action_menu()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func open_action_menu() -> void:
    is_open = true
    $ActionMenuOpen.show()
    $ActionMenuClosed.hide()

func close_action_menu() -> void:
    is_open = false
    $ActionMenuOpen.hide()
    $ActionMenuClosed.show()

func _on_open_action_menu_button_pressed() -> void:
    open_action_menu()

func _on_close_action_menu_button_pressed() -> void:
    close_action_menu()



func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
        if event.is_pressed():
            destroy_selected_seed_packet()

func destroy_selected_seed_packet() -> void:
    if selected_seed_packet_instance:
        Player.selected_seed_packet = null
        selected_seed_packet_instance.queue_free()
        selected_seed_packet_instance = null

var selected_seed_packet_scene := preload("res://scenes/selected_seed_packet.tscn")
func get_seed_packet_node() -> SelectedSeedPacket:
    if selected_seed_packet_instance:
        return selected_seed_packet_instance
    else:
        selected_seed_packet_instance = selected_seed_packet_scene.instantiate() as SelectedSeedPacket
        # Add the seed packet so that it's parent is a CanvasLayer with no transform.
        # Let it be a child of the UI CanvasLayer.
        get_parent().add_child(selected_seed_packet_instance)
        return selected_seed_packet_instance

var wheat_seed_packet_texture := preload("res://assets/items/seeds/wheat_seeds.png")
var beet_seed_packet_texture := preload("res://assets/items/seeds/beet_seeds.png")
var lettuce_seed_packet_texture := preload("res://assets/items/seeds/lettuce_seeds.png")
func ensure_seed_packet_at_mouse_position(type: seed_type) -> void:
    var selected_seed_packet := get_seed_packet_node()

    match type:
        seed_type.WHEAT:
            selected_seed_packet.crop_type = Global.CROP_TYPE.WHEAT
            selected_seed_packet.texture = wheat_seed_packet_texture
            selected_seed_packet.price = Global.settings.coin_cost_wheat
        seed_type.BEET:
            selected_seed_packet.crop_type = Global.CROP_TYPE.BEET
            selected_seed_packet.texture = beet_seed_packet_texture
            selected_seed_packet.price = Global.settings.coin_cost_beet
        seed_type.LETTUCE:
            selected_seed_packet.crop_type = Global.CROP_TYPE.LETTUCE
            selected_seed_packet.texture = lettuce_seed_packet_texture
            selected_seed_packet.price = Global.settings.coin_cost_lettuce

    Player.selected_seed_packet = selected_seed_packet  
    selected_seed_packet.position = get_viewport().get_mouse_position()
    selected_seed_packet.show()

func _on_wheat_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(seed_type.WHEAT)

func _on_beet_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(seed_type.BEET)

func _on_lettuce_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(seed_type.LETTUCE)

func _on_carrot_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(seed_type.CARROT)
