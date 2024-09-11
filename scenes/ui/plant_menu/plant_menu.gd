extends PanelContainer


var till_soil_action: TillSoilAction = null
var selected_seed_packet_instance: SelectedSeedPacket = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
        if event.is_pressed():
            if Player.selected_action == Player.SELECTED_ACTION.TILL_SOIL:
                Player.unset_till_soil_action()
            else:
                destroy_selected_seed_packet()
        if event.is_pressed():
            destroy_selected_seed_packet()

func _on_till_soil_button_button_up() -> void:
    Player.set_till_soil_action()


func destroy_selected_seed_packet() -> void:
    if selected_seed_packet_instance:
        selected_seed_packet_instance.destroy()
        selected_seed_packet_instance = null


var selected_seed_packet_scene := preload("res://scenes/selected_seed_packet.tscn")
func get_selected_seed_packet_instance() -> SelectedSeedPacket:
    if selected_seed_packet_instance:
        return selected_seed_packet_instance
    else:
        selected_seed_packet_instance = selected_seed_packet_scene.instantiate() as SelectedSeedPacket
        # Add the seed packet so that it's parent is a CanvasLayer with no transform.
        # Let it be a child of the UI CanvasLayer.
        get_tree().get_first_node_in_group("ui_canvas_layer").add_child(selected_seed_packet_instance)
        return selected_seed_packet_instance


var wheat_seed_packet_texture := preload("res://assets/items/seeds/wheat_seeds.png")
var beet_seed_packet_texture := preload("res://assets/items/seeds/beet_seeds.png")
var lettuce_seed_packet_texture := preload("res://assets/items/seeds/lettuce_seeds.png")
func ensure_seed_packet_at_mouse_position(crop_type: Global.CROP_TYPE) -> void:
    var selected_seed_packet := get_selected_seed_packet_instance()

    match crop_type:
        Global.CROP_TYPE.WHEAT:
            selected_seed_packet.crop_type = Global.CROP_TYPE.WHEAT
            selected_seed_packet.texture = wheat_seed_packet_texture
            selected_seed_packet.price = Global.settings.coin_cost_wheat
        Global.CROP_TYPE.BEET:
            selected_seed_packet.crop_type = Global.CROP_TYPE.BEET
            selected_seed_packet.texture = beet_seed_packet_texture
            selected_seed_packet.price = Global.settings.coin_cost_beet
        Global.CROP_TYPE.LETTUCE:
            selected_seed_packet.crop_type = Global.CROP_TYPE.LETTUCE
            selected_seed_packet.texture = lettuce_seed_packet_texture
            selected_seed_packet.price = Global.settings.coin_cost_lettuce

    Player.selected_seed_packet = selected_seed_packet
    selected_seed_packet.position = get_viewport().get_mouse_position()
    selected_seed_packet.show()




func _on_wheat_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(Global.CROP_TYPE.WHEAT)


func _on_beet_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(Global.CROP_TYPE.BEET)


func _on_lettuce_button_pressed() -> void:
    ensure_seed_packet_at_mouse_position(Global.CROP_TYPE.LETTUCE)
