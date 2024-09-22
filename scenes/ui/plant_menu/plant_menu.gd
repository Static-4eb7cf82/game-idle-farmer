extends PanelContainer


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
        if event.is_pressed():
            if Player.selected_action == Player.SELECTED_ACTION.TILL_SOIL:
                Player.unset_till_soil_action()
            if Player.selected_action == Player.SELECTED_ACTION.PLANT_CROP:
                Player.unset_plant_crop_action()


func _on_till_soil_pressed() -> void:
    Player.set_till_soil_action()


func _on_crop_button_pressed(crop_resource: CropResource) -> void:
    Player.set_plant_crop_action(crop_resource.type)
