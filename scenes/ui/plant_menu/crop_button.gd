extends PanelContainer

class_name CropButton

@export var crop_resource: CropResource

signal button_pressed(crop_resource: CropResource)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Button/MarginContainer/HBoxContainer/CropTexture.texture = crop_resource.texture
    $Button/MarginContainer/HBoxContainer/HBoxContainer/CropCostLabel.text = str(Global.CROP_COST[crop_resource.type])
    $Button.tooltip_text = Global.CROP_NAMES[crop_resource.type]
    $Button.tooltip_text += "\nTime: " + str(Global.CROP_GROWTH_DURATION[crop_resource.type]) + " seconds"
    var coins_cost_str := " coins" if Global.CROP_COST[crop_resource.type] > 1 else " coin"
    $Button.tooltip_text += "\nCost: " + str(Global.CROP_COST[crop_resource.type]) + coins_cost_str
    $Button.tooltip_text += "\nReward: " + str(Global.CROP_REWARD[crop_resource.type]) + " coins"


func _on_button_pressed() -> void:
    button_pressed.emit(crop_resource)
