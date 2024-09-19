extends PanelContainer

signal button_pressed()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Button/MarginContainer/HBoxContainer/HBoxContainer/CoinCostLabel.text = str(Global.settings.till_cost)
    $Button.tooltip_text = "Till soil"
    var coins_cost_str := " coins" if Global.settings.till_cost > 1 else " coin"
    $Button.tooltip_text += "\nCost: " + str(Global.settings.till_cost) + coins_cost_str


func _on_button_pressed() -> void:
    button_pressed.emit()
