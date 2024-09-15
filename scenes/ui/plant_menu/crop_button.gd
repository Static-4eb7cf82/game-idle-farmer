extends PanelContainer

class_name CropButton

@export var crop_resource: CropResource

signal button_pressed(crop_resource: CropResource)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Button/MarginContainer/HBoxContainer/CropTexture.texture = crop_resource.texture
    $Button/MarginContainer/HBoxContainer/HBoxContainer/CropCostLabel.text = str(Global.CROP_COST[crop_resource.type])


func _on_button_pressed() -> void:
    button_pressed.emit(crop_resource)
