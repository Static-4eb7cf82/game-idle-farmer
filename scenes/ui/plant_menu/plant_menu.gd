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
            if Player.selected_action == Player.SELECTED_ACTION.PLANT_CROP:
                Player.unset_plant_crop_action()

func _on_till_soil_button_button_up() -> void:
    Player.set_till_soil_action()


func _on_wheat_button_pressed() -> void:
    Player.set_plant_crop_action(Global.CROP_TYPE.WHEAT)


func _on_beet_button_pressed() -> void:
    Player.set_plant_crop_action(Global.CROP_TYPE.BEET)


func _on_lettuce_button_pressed() -> void:
    Player.set_plant_crop_action(Global.CROP_TYPE.LETTUCE)
